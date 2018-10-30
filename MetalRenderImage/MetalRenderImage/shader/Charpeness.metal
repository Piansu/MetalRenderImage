//
//  Charpeness.metal
//  MetalRenderImage
//
//  Created by suruochang on 2018/10/30.
//  Copyright © 2018年 Su Ruochang. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct AdjustSharpenUniforms {
    
    float sharpeness;
    
//    float widthStep;
//    float heightStep;
};

kernel void adjust_charpeness(texture2d<float, access::read> inTexture [[texture(0)]],
                              texture2d<float, access::write> outTexture [[texture(1)]],
                              constant AdjustSharpenUniforms &uniforms [[buffer(0)]],
                              uint2 gid [[thread_position_in_grid]])
{
    float sharpness = uniforms.sharpeness;
    
    float centerMultiplier = 1.0 + 4.0 * sharpness;
    
    float4 textureColor = inTexture.read(gid);
    
    float3 leftTextureColor = inTexture.read(gid - uint2(1, 0)).rgb;
    
    float3 rightTextureColor = inTexture.read(gid + uint2(1, 0)).rgb;
    
    float3 topTextureColor = inTexture.read(gid + uint2(0, 1)).rgb;
    
    float3 bottomTextureColor = inTexture.read(gid - uint2(0, 1)).rgb;;
    
    float4 outColor = float4((textureColor.rgb * centerMultiplier - (leftTextureColor * sharpness + rightTextureColor * sharpness + topTextureColor * sharpness + bottomTextureColor * sharpness)), textureColor.a);
    
    outTexture.write(outColor, gid);
}
