//
//  MRMonochromeFilter.m
//  MetalRenderImage
//
//  Created by suruochang on 2018/10/30.
//  Copyright © 2018年 Su Ruochang. All rights reserved.
//

#import "MRMonochromeFilter.h"
#import "MRMetalContext.h"

struct AdjustMonochromeUniforms
{
    MRColor color;
    float intensity;
};

@implementation MRMonochromeFilter

- (instancetype)initWithContext:(MRMetalContext *)context
{
    return [self initWithFunctionName:@"adjust_monochrome" context:context];
}

- (void)configureBufferParametersWithCommandEncoder:(id<MTLComputeCommandEncoder>)commandEncoder
{
    struct AdjustMonochromeUniforms uniforms;
    uniforms.intensity = self.intensity;
    uniforms.color = self.color;
    
    if (!self.uniformBuffer)
    {
        self.uniformBuffer = [self.context.device newBufferWithLength:sizeof(uniforms)
                                                              options:MTLResourceOptionCPUCacheModeDefault];
    }
    
    memcpy([self.uniformBuffer contents], &uniforms, sizeof(uniforms));
    
    [commandEncoder setBuffer:self.uniformBuffer offset:0 atIndex:0];
    
}

@end
