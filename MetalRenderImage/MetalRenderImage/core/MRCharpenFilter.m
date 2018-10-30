//
//  MRCharpenFilter.m
//  MetalRenderImage
//
//  Created by suruochang on 2018/10/30.
//  Copyright © 2018年 Su Ruochang. All rights reserved.
//

#import "MRCharpenFilter.h"
#import "MRMetalContext.h"

@implementation MRCharpenFilter

struct AdjustSharpenUniforms {
    
    float sharpness;
    
//    float widthStep;
//    float heightStep;
};

- (instancetype)initWithContext:(MRMetalContext *)context
{
    return [self initWithFunctionName:@"adjust_charpeness" context:context];
}

- (void)configureArgumentTableWithCommandEncoder:(id<MTLComputeCommandEncoder>)commandEncoder
{
    struct AdjustSharpenUniforms uniforms;
    uniforms.sharpness = self.sharpness;
    
    if (!self.uniformBuffer)
    {
        self.uniformBuffer = [self.context.device newBufferWithLength:sizeof(uniforms)
                                                              options:MTLResourceOptionCPUCacheModeDefault];
    }
    
    memcpy([self.uniformBuffer contents], &uniforms, sizeof(uniforms));
    
    [commandEncoder setBuffer:self.uniformBuffer offset:0 atIndex:0];
    
}


@end
