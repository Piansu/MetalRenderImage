//
//  MRRGBFilter.m
//  ImageProcessing
//
//  Created by suruochang on 2018/10/15.
//  Copyright © 2018年 Su Ruochang. All rights reserved.
//

#import "MRRGBFilter.h"
#import "MRMetalContext.h"

struct AdjustRGBUniforms
{
    float redFactor;
    float greenFactor;
    float blueFactor;
};

@implementation MRRGBFilter

+ (instancetype)filterWithContext:(MRMetalContext *)context;
{
    return [[self alloc] initWithContext:context];
}

- (instancetype)initWithContext:(MRMetalContext *)context;
{
    self = [super initWithFunctionName:@"adjust_RGB" context:context];
    if (self) {
        _redFactor = 1.0;
        _greenFactor = 1.0;
        _blueFactor = 1.0;
    }
    return self;
}

- (void)setRedFactor:(float)redFactor;
{
    _redFactor = redFactor;
}

- (void)setGreenFactor:(float)greenFactor
{
    _greenFactor = greenFactor;
}

- (void)setBlueFactor:(float)blueFactor
{
    _blueFactor = blueFactor;
}

- (void)configureBufferParametersWithCommandEncoder:(id<MTLComputeCommandEncoder>)commandEncoder
{
    struct AdjustRGBUniforms uniforms;
    uniforms.redFactor = self.redFactor;
    uniforms.greenFactor = self.greenFactor;
    uniforms.blueFactor = self.blueFactor;
    
    if (!self.uniformBuffer)
    {
        self.uniformBuffer = [self.context.device newBufferWithLength:sizeof(uniforms)
                                                              options:MTLResourceOptionCPUCacheModeDefault];
    }
    
    memcpy([self.uniformBuffer contents], &uniforms, sizeof(uniforms));
    
    [commandEncoder setBuffer:self.uniformBuffer offset:0 atIndex:0];
    
}

@end
