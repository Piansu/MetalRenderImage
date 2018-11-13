//
//  SobelFilter.metal
//  MetalRenderImage
//
//  Created by suruochang on 2018/11/13.
//  Copyright © 2018年 Su Ruochang. All rights reserved.
//

#include <metal_stdlib>
#include "../base/MRInputParameterTypes.h"

using namespace metal;

constant half sobelStep = 2.0;
constant float3 kRec709Luma = float3(0.2126, 0.7152, 0.0722); // 把rgba转成亮度值

kernel void adjust_sobel(texture2d<float, access::write> outTexture [[texture(MRTextureIndexTypeOutput)]],
                         texture2d<float, access::read> inTexture [[texture(MRTextureIndexTypeInputOne)]],
                         uint2 gid [[thread_position_in_grid]])
{
    /*
     
     行数     9个像素          位置
     上     | * * * |      | 左 中 右 |
     中     | * * * |      | 左 中 右 |
     下     | * * * |      | 左 中 右 |
     
     */
    float4 topLeft = inTexture.read(uint2(gid.x - sobelStep, gid.y - sobelStep)); // 左上
    float4 top = inTexture.read(uint2(gid.x, gid.y - sobelStep)); // 上
    float4 topRight = inTexture.read(uint2(gid.x + sobelStep, gid.y - sobelStep)); // 右上
    float4 centerLeft = inTexture.read(uint2(gid.x - sobelStep, gid.y)); // 中左
    float4 centerRight = inTexture.read(uint2(gid.x + sobelStep, gid.y)); // 中右
    float4 bottomLeft = inTexture.read(uint2(gid.x - sobelStep, gid.y + sobelStep)); // 下左
    float4 bottom = inTexture.read(uint2(gid.x, gid.y + sobelStep)); // 下中
    float4 bottomRight = inTexture.read(uint2(gid.x + sobelStep, gid.y + sobelStep)); // 下右
    
    float4 h = -topLeft - 2.0 * top - topRight + bottomLeft + 2.0 * bottom + bottomRight; // 横方向差别
    float4 v = -bottom - 2.0 * centerLeft - topLeft + bottomRight + 2.0 * centerRight + topRight; // 竖方向差别
    
    float  grayH  = dot(h.rgb, kRec709Luma); // 转换成亮度
    float  grayV  = dot(v.rgb, kRec709Luma); // 转换成亮度
    
    // sqrt(h^2 + v^2)，相当于求点到(h, v)的距离，所以可以用length
    half color = length(float2(grayH, grayV));
    
    outTexture.write(float4(color, color, color, 1.0), gid); // 写回对应纹理
}



