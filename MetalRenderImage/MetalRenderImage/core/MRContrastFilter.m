//
//  MRContrastFilter.m
//  ImageProcessing
//
//  Created by suruochang on 2018/10/15.
//  Copyright © 2018年 Su Ruochang. All rights reserved.
//

#import <Metal/Metal.h>
#import "MRContrastFilter.h"
#import "MRMetalContext.h"
#import "MRInputParameterTypes.h"

@implementation MRContrastFilter

+ (instancetype)filterWithContrastFactor:(float)contrast context:(MRMetalContext *)context;
{
    return [[self alloc] initWithContrastFactor:contrast context:context];
}


- (instancetype)initWithContrastFactor:(float)contrast context:(MRMetalContext *)context;
{
    self = [super initWithFunctionName:@"adjust_contrast" context:context];
    if (self) {
        _contrastFactor = contrast;
    }
    return self;
}

- (void)setContrastFactor:(float)contrastFactor
{
    self.dirty = YES;
    _contrastFactor = contrastFactor;
}

- (void)configureBufferParametersWithCommandEncoder:(id<MTLComputeCommandEncoder>)commandEncoder
{
    struct MROneInputParameterUniforms uniforms;
    uniforms.one = self.contrastFactor;
    
    if (!self.uniformBuffer)
    {
        self.uniformBuffer = [self.context.device newBufferWithLength:sizeof(uniforms)
                                                              options:MTLResourceOptionCPUCacheModeDefault];
    }
    
    memcpy([self.uniformBuffer contents], &uniforms, sizeof(uniforms));
    
    [commandEncoder setBuffer:self.uniformBuffer offset:0 atIndex:0];
}

@end
