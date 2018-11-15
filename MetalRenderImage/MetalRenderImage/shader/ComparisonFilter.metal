//
//  ComparisonFilter.metal
//  MetalRenderImage
//
//  Created by suruochang on 2018/11/16.
//  Copyright © 2018年 Su Ruochang. All rights reserved.
//

#include <metal_stdlib>
#include "../base/MRInputParameterTypes.h"

using namespace metal;

kernel void adjust_comparison(texture2d<float, access::write> outTexture [[texture(MRTextureIndexTypeOutput)]],
                         texture2d<float, access::read> inTexture [[texture(MRTextureIndexTypeInputOne)]],
                          texture2d<float, access::read> inTexture2 [[texture(MRTextureIndexTypeInputTwo)]],
                         uint2 gid [[thread_position_in_grid]])
{
    float3 oneColor = inTexture.read(gid).rgb;
    
    uint2 gid2;
    gid2.x = gid.x * inTexture2.get_width() / inTexture.get_width();
    gid2.y = gid.y * inTexture2.get_height() / inTexture.get_height();
    
    float3 twoColor = inTexture2.read(gid2).rgb;
    
    float colorDistance = distance(oneColor, twoColor);
    float movementThreshold = step(0.2, colorDistance);
    
//    float4 outColor = movementThreshold * float4(1.0, 1.0, 1.0, 1.0);
    float4 color = movementThreshold * float4(float(gid.x) / float(inTexture.get_width()),
                                              float(gid.y) / float(inTexture.get_height()),
                                              1.0,
                                              1.0);
    outTexture.write(color, gid);
}
