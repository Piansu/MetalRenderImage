//
//  MRDissolveBlendFilter.m
//  MetalRenderImage
//
//  Created by suruochang on 2018/11/1.
//  Copyright © 2018年 Su Ruochang. All rights reserved.
//

#import "MRDissolveBlendFilter.h"
#import "MRMetalContext.h"

@implementation MRDissolveBlendFilter

- (instancetype)initWithContext:(MRMetalContext *)context
{
    return [self initWithFunctionName:@"dissolve_blend" context:context];
}

- (void)configureBufferParametersWithCommandEncoder:(id<MTLComputeCommandEncoder>)commandEncoder
{
    struct MROneInputParameterUniforms uniforms;
    uniforms.one = self.mix;
    
    if (!self.uniformBuffer)
    {
        self.uniformBuffer = [self.context.device newBufferWithLength:sizeof(uniforms)
                                                              options:MTLResourceOptionCPUCacheModeDefault];
    }
    
    memcpy([self.uniformBuffer contents], &uniforms, sizeof(uniforms));
    
    [commandEncoder setBuffer:self.uniformBuffer offset:0 atIndex:0];
    
}

@end
