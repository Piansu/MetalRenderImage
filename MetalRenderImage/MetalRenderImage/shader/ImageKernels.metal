
#include <metal_stdlib>
#include "../base/MRInputParameterTypes.h"

using namespace metal;

kernel void adjust_saturation(texture2d<float, access::write> outTexture [[texture(MRTextureIndexTypeOutput)]],
                              texture2d<float, access::read> inTexture [[texture(MRTextureIndexTypeInputOne)]],
                              constant MROneInputParameterUniforms &uniforms [[buffer(0)]],
                              uint2 gid [[thread_position_in_grid]])
{
    float4 inColor = inTexture.read(gid);
    float value = dot(inColor.rgb, float3(0.299, 0.587, 0.114));
    float4 grayColor(value, value, value, 1.0);
    float4 outColor = mix(grayColor, inColor, uniforms.one);
    outTexture.write(outColor, gid);
}

kernel void gaussian_blur_2d(texture2d<float, access::write> outTexture [[texture(MRTextureIndexTypeOutput)]],
                             texture2d<float, access::read> inTexture [[texture(MRTextureIndexTypeInputOne)]],
                             texture2d<float, access::read> weights [[texture(MRTextureIndexTypeInputTwo)]],
                             uint2 gid [[thread_position_in_grid]])
{
    int size = weights.get_width();
    int radius = size / 2;
    
    float4 accumColor(0, 0, 0, 0);
    for (int j = 0; j < size; ++j)
    {
        for (int i = 0; i < size; ++i)
        {
            uint2 kernelIndex(i, j);
            uint2 textureIndex(gid.x + (i - radius), gid.y + (j - radius));
            float4 color = inTexture.read(textureIndex).rgba;
            float4 weight = weights.read(kernelIndex).rrrr;
            accumColor += weight * color;
        }
    }

    outTexture.write(float4(accumColor.rgb, 1), gid);
}





kernel void adjust_contrast(texture2d<float, access::write> outTexture [[texture(MRTextureIndexTypeOutput)]],
                            texture2d<float, access::read> inTexture [[texture(MRTextureIndexTypeInputOne)]],
                            constant MROneInputParameterUniforms &uniforms [[buffer(0)]],
                            uint2 gid [[thread_position_in_grid]])
{
    float4 inColor = inTexture.read(gid);
    
    float4 outColor = float4( (inColor.rgb - float3(0.5)) * uniforms.one + float3(0.5), inColor.a );
    outTexture.write(outColor, gid);
}

kernel void adjust_brightness(texture2d<float, access::write> outTexture [[texture(MRTextureIndexTypeOutput)]],
                              texture2d<float, access::read> inTexture [[texture(MRTextureIndexTypeInputOne)]],
                              constant MROneInputParameterUniforms &uniforms [[buffer(0)]],
                              uint2 gid [[thread_position_in_grid]])
{
    float4 inColor = inTexture.read(gid);
    float bright = uniforms.one;
    float4 outColor = float4( (inColor.rgb + float3(bright)), inColor.a );
    outTexture.write(outColor, gid);
}

kernel void adjust_exposure(texture2d<float, access::write> outTexture [[texture(MRTextureIndexTypeOutput)]],
                            texture2d<float, access::read> inTexture [[texture(MRTextureIndexTypeInputOne)]],
                            constant MROneInputParameterUniforms &uniforms [[buffer(0)]],
                            uint2 gid [[thread_position_in_grid]])
{
    float4 inColor = inTexture.read(gid);
    float exposure = uniforms.one;
    float4 outColor = float4( (inColor.rgb * pow(2, exposure)), inColor.a );
    outTexture.write(outColor, gid);
}



struct AdjustRGBUniforms
{
    float redFactor;
    float greenFactor;
    float blueFactor;
};

kernel void adjust_RGB(texture2d<float, access::write> outTexture [[texture(MRTextureIndexTypeOutput)]],
                       texture2d<float, access::read> inTexture [[texture(MRTextureIndexTypeInputOne)]],
                       constant AdjustRGBUniforms &uniforms [[buffer(0)]],
                       uint2 gid [[thread_position_in_grid]])
{
    float4 inColor = inTexture.read(gid);
    
    float redAdjustment = uniforms.redFactor;
    float greenAdjustment = uniforms.greenFactor;
    float blueAdjustment = uniforms.blueFactor;
    
    float4 outColor = float4(inColor.r * redAdjustment,
                            inColor.g * greenAdjustment,
                            inColor.b * blueAdjustment,
                            inColor.a );
    outTexture.write(outColor, gid);
}

constant float3 W = float3(0.2125, 0.7154, 0.0721);

kernel void adjust_grayscale(texture2d<float, access::write> outTexture [[texture(MRTextureIndexTypeOutput)]],
                             texture2d<float, access::read> inTexture [[texture(MRTextureIndexTypeInputOne)]],
                             uint2 gid [[thread_position_in_grid]])
{
    float4 inColor = inTexture.read(gid);
    float luminance = dot(inColor.rgb, W);
    
    float4 outColor = float4(float3(luminance), inColor.a);
    
    outTexture.write(outColor, gid);
}


constant float4  kRGBToYPrime = float4 (0.299, 0.587, 0.114, 0.0);
constant float4  kRGBToI     = float4 (0.595716, -0.274453, -0.321263, 0.0);
constant float4  kRGBToQ     = float4 (0.211456, -0.522591, 0.31135, 0.0);

constant float4  kYIQToR   = float4 (1.0, 0.9563, 0.6210, 0.0);
constant float4  kYIQToG   = float4 (1.0, -0.2721, -0.6474, 0.0);
constant float4  kYIQToB   = float4 (1.0, -1.1070, 1.7046, 0.0);

kernel void adjust_hue(texture2d<float, access::write> outTexture [[texture(MRTextureIndexTypeOutput)]],
                       texture2d<float, access::read> inTexture [[texture(MRTextureIndexTypeInputOne)]],
                       constant MROneInputParameterUniforms &uniforms [[buffer(0)]],
                       uint2 gid [[thread_position_in_grid]])
{
    float4 color = inTexture.read(gid);
    
    // Convert to YIQ
    float   YPrime  = dot (color, kRGBToYPrime);
    float   I      = dot (color, kRGBToI);
    float   Q      = dot (color, kRGBToQ);
    
    // Calculate the hue and chroma
    float   hue     = atan2 (Q, I); 
    float   chroma  = sqrt (I * I + Q * Q);
    
    // Make the user's adjustments
    hue += (-uniforms.one); //why negative rotation?
    
    // Convert back to YIQ
    Q = chroma * sin (hue);
    I = chroma * cos (hue);
    
    // Convert back to RGB
    float4    yIQ   = float4 (YPrime, I, Q, 0.0);
    color.r = dot (yIQ, kYIQToR);
    color.g = dot (yIQ, kYIQToG);
    color.b = dot (yIQ, kYIQToB);

    outTexture.write(color, gid);
}


kernel void adjust_gamma(texture2d<float, access::write> outTexture [[texture(MRTextureIndexTypeOutput)]],
                         texture2d<float, access::read> inTexture [[texture(MRTextureIndexTypeInputOne)]],
                         constant MROneInputParameterUniforms &uniforms [[buffer(0)]],
                         uint2 gid [[thread_position_in_grid]])
{
    float4 inColor = inTexture.read(gid);
    float4 outColor = float4( pow(inColor.rgb, float3(uniforms.one)), inColor.a );
    outTexture.write(outColor, gid);
}


kernel void adjust_color_invert(texture2d<float, access::write> outTexture [[texture(MRTextureIndexTypeOutput)]],
                                texture2d<float, access::read> inTexture [[texture(MRTextureIndexTypeInputOne)]],
                                uint2 gid [[thread_position_in_grid]])
{
    float4 inColor = inTexture.read(gid);
    float4 outColor = float4( 1.0 - inColor.rgb, inColor.a );
    outTexture.write(outColor, gid);
}




