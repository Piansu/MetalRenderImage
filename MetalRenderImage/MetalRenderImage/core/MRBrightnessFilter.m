//
//  MRBrightnessFilter.m
//  ImageProcessing
//
//  Created by suruochang on 2018/10/15.
//  Copyright © 2018年 Su Ruochang. All rights reserved.
//

#import "MRBrightnessFilter.h"
#import "MRMetalContext.h"

struct AdjustBrightnessUniforms
{
    float brightnessFactor;
};

@implementation MRBrightnessFilter

+ (instancetype)filterWithBrightnessFactor:(float)brightness context:(MRMetalContext *)context;
{
    return [[self alloc] initWithBrightnessFactor:brightness context:context];
}

- (instancetype)initWithBrightnessFactor:(float)brightness context:(MRMetalContext *)context;
{
    self = [super initWithFunctionName:@"adjust_brightness" context:context];
    if (self) {
        _brightnessFactor = brightness;
    }
    
    return self;
}

- (void)setBrightnessFactor:(float)brightnessFactor
{
    self.dirty = YES;
    _brightnessFactor = brightnessFactor;
}

- (void)configureArgumentTableWithCommandEncoder:(id<MTLComputeCommandEncoder>)commandEncoder
{
    struct AdjustBrightnessUniforms uniforms;
    uniforms.brightnessFactor = self.brightnessFactor;
    
    if (!self.uniformBuffer)
    {
        self.uniformBuffer = [self.context.device newBufferWithLength:sizeof(uniforms)
                                                              options:MTLResourceOptionCPUCacheModeDefault];
    }
    
    memcpy([self.uniformBuffer contents], &uniforms, sizeof(uniforms));
    
    [commandEncoder setBuffer:self.uniformBuffer offset:0 atIndex:0];
}

@end
