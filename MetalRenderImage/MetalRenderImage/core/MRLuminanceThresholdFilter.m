//
//  MRLuminanceThresholdFilter.m
//  MetalRenderImage
//
//  Created by suruochang on 2018/11/16.
//  Copyright © 2018年 Su Ruochang. All rights reserved.
//

#import "MRLuminanceThresholdFilter.h"
#import "MRMetalContext.h"
#import "MRInputParameterTypes.h"

@implementation MRLuminanceThresholdFilter

- (instancetype)initWithContext:(MRMetalContext *)context
{
    return [self initWithFunctionName:@"adjust_luminance_threshold" context:context];
}

- (void)configureBufferParametersWithCommandEncoder:(id<MTLComputeCommandEncoder>)commandEncoder
{
    struct MROneInputParameterUniforms uniforms;
    uniforms.one = self.threshold;
    
    if (!self.uniformBuffer)
    {
        self.uniformBuffer = [self.context.device newBufferWithLength:sizeof(uniforms)
                                                              options:MTLResourceOptionCPUCacheModeDefault];
    }
    
    memcpy([self.uniformBuffer contents], &uniforms, sizeof(uniforms));
    
    [commandEncoder setBuffer:self.uniformBuffer offset:0 atIndex:0];
    
}

@end
