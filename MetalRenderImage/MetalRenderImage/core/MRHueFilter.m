//
//  MRHueFilter.m
//  ImageProcessing
//
//  Created by suruochang on 2018/10/15.
//  Copyright © 2018年 Su Ruochang. All rights reserved.
//

#import "MRHueFilter.h"
#import "MRMetalContext.h"
#import "MRInputParameterTypes.h"

@implementation MRHueFilter

+ (instancetype)filterWithHueFactor:(float)hue context:(MRMetalContext *)context;
{
    return [[self alloc] initWithHueFactor:hue context:context];
}

- (instancetype)initWithHueFactor:(float)hue context:(MRMetalContext *)context;
{
    self = [super initWithFunctionName:@"adjust_hue" context:context];
    if (self) {
        _hueFactor = hue;
    }
    
    return self;
}

- (void)setHueFactor:(float)hueFactor
{
    self.dirty = YES;
    _hueFactor = fmodf(hueFactor, 360.0) * M_PI/180;
}

- (void)configureBufferParametersWithCommandEncoder:(id<MTLComputeCommandEncoder>)commandEncoder
{
    struct MROneInputParameterUniforms uniforms;
    uniforms.one = self.hueFactor;
    
    if (!self.uniformBuffer)
    {
        self.uniformBuffer = [self.context.device newBufferWithLength:sizeof(uniforms)
                                                              options:MTLResourceOptionCPUCacheModeDefault];
    }
    
    memcpy([self.uniformBuffer contents], &uniforms, sizeof(uniforms));
    
    [commandEncoder setBuffer:self.uniformBuffer offset:0 atIndex:0];
    
}


@end
