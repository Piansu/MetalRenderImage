//
//  LuminanceThreshold.metal
//  MetalRenderImage
//
//  Created by suruochang on 2018/11/16.
//  Copyright © 2018年 Su Ruochang. All rights reserved.
//

#include <metal_stdlib>
#include "../base/MRInputParameterTypes.h"

using namespace metal;

constant float3 luminanceWeighting = float3(0.2125, 0.7154, 0.0721);

kernel void adjust_luminance_threshold(texture2d<float, access::write> outTexture [[texture(MRTextureIndexTypeOutput)]],
                             texture2d<float, access::read> inTexture [[texture(MRTextureIndexTypeInputOne)]],
                             constant MROneInputParameterUniforms &uniforms [[buffer(0)]],
                             uint2 gid [[thread_position_in_grid]])
{
    float threshold = uniforms.one;
    float4 inColor = inTexture.read(gid);
    float luminance = dot(inColor.rgb, luminanceWeighting);
    float thresholdResult = step(threshold, luminance);
    
    float4 outColor = float4(float3(thresholdResult), inColor.a);
    
    outTexture.write(outColor, gid);
}
