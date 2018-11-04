//
//  DissolveBlendFilter.metal
//  MetalRenderImage
//
//  Created by suruochang on 2018/11/1.
//  Copyright © 2018年 Su Ruochang. All rights reserved.
//

#include <metal_stdlib>
//#include <simd/simd.h>
#include "../base/MRInputParameterTypes.h"

using namespace metal;

kernel void dissolve_blend(texture2d<float, access::write> outTexture [[texture(MRTextureIndexTypeOutput)]],
                           texture2d<float, access::read> inTexture [[texture(MRTextureIndexTypeInputOne)]],
                           texture2d<float, access::read> inTexture2 [[texture(MRTextureIndexTypeInputTwo)]],
                           constant MROneInputParameterUniforms &uniforms [[buffer(0)]],
                                uint2 gid [[thread_position_in_grid]])
{
    float percent = uniforms.one;
    
    float4 oneColor = inTexture.read(gid);
    
    uint2 gid2;
    gid2.x = gid.x * inTexture2.get_width() / inTexture.get_width();
    gid2.y = gid.y * inTexture2.get_height() / inTexture.get_height();
    
    float4 twoColor = inTexture2.read(gid2);
    
    float4 outColor = mix(oneColor, twoColor, percent);
    
    outTexture.write(outColor, gid);
}


kernel void lighten_blend(texture2d<float, access::write> outTexture [[texture(MRTextureIndexTypeOutput)]],
                           texture2d<float, access::read> inTexture [[texture(MRTextureIndexTypeInputOne)]],
                           texture2d<float, access::read> inTexture2 [[texture(MRTextureIndexTypeInputTwo)]],
                           uint2 gid [[thread_position_in_grid]])
{
    
    float4 oneColor = inTexture.read(gid);
    
    uint2 gid2;
    gid2.x = gid.x * inTexture2.get_width() / inTexture.get_width();
    gid2.y = gid.y * inTexture2.get_height() / inTexture.get_height();
    float4 twoColor = inTexture2.read(gid2);
    
    float4 outColor = max(oneColor, twoColor);
    
    outTexture.write(outColor, gid);
}


kernel void soft_light_blend(texture2d<float, access::write> outTexture [[texture(MRTextureIndexTypeOutput)]],
                          texture2d<float, access::read> inTexture [[texture(MRTextureIndexTypeInputOne)]],
                          texture2d<float, access::read> inTexture2 [[texture(MRTextureIndexTypeInputTwo)]],
                          uint2 gid [[thread_position_in_grid]])
{
    
    float4 base = inTexture.read(gid);
    
    uint2 gid2;
    gid2.x = gid.x * inTexture2.get_width() / inTexture.get_width();
    gid2.y = gid.y * inTexture2.get_height() / inTexture.get_height();
    float4 overlay = inTexture2.read(gid2);
    
    float alphaDivisor = base.a + step(base.a, 0.0); // Protect against a divide-by-zero blacking out things in the output
    float4 outColor = base * (overlay.a * (base / alphaDivisor) + (2.0 * overlay * (1.0 - (base / alphaDivisor)))) + overlay * (1.0 - base.a) + base * (1.0 - overlay.a);
    
    outTexture.write(outColor, gid);
}
