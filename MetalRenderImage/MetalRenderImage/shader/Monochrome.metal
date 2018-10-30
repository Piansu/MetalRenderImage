//
//  Monochrome.metal
//  MetalRenderImage
//
//  Created by suruochang on 2018/10/30.
//  Copyright © 2018年 Su Ruochang. All rights reserved.
//

#include <metal_stdlib>

using namespace metal;

constant float3 luminanceWeighting = float3(0.2125, 0.7154, 0.0721);

struct AdjustComochromeUniforms {
    float4 color;
    float intensity;
};

kernel void adjust_monochrome(texture2d<float, access::read> inTexture [[texture(0)]],
                         texture2d<float, access::write> outTexture [[texture(1)]],
                         constant AdjustComochromeUniforms &uniforms [[buffer(0)]],
                         uint2 gid [[thread_position_in_grid]])
{
    float4 inColor = inTexture.read(gid);
    
    float luminance = dot(inColor.rgb, luminanceWeighting);
    
    float4 desat = float4(float3(luminance), 1.0);
    
    float3 filterColor = uniforms.color.rgb;
    float intensity = uniforms.intensity;
    //overlay
    float4 outputColor = float4(
                            (desat.r < 0.5 ? (2.0 * desat.r * filterColor.r) : (1.0 - 2.0 * (1.0 - desat.r) * (1.0 - filterColor.r))),
                            (desat.g < 0.5 ? (2.0 * desat.g * filterColor.g) : (1.0 - 2.0 * (1.0 - desat.g) * (1.0 - filterColor.g))),
                            (desat.b < 0.5 ? (2.0 * desat.b * filterColor.b) : (1.0 - 2.0 * (1.0 - desat.b) * (1.0 - filterColor.b))),
                            1.0
                            );
    
    //which is better, or are they equal?
    float4 outColor = float4( mix(inColor.rgb, outputColor.rgb, intensity), inColor.a);
    
    outTexture.write(outColor, gid);
}
