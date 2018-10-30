//
//  MRGammaFilter.m
//  ImageProcessing
//
//  Created by suruochang on 2018/10/15.
//  Copyright © 2018年 Su Ruochang. All rights reserved.
//

#import "MRGammaFilter.h"
#import "MRMetalContext.h"

struct AdjustGammaUniforms
{
    float gammaFactor;
};

@implementation MRGammaFilter

+ (instancetype)filterWithGammaFactor:(float)gamma context:(MRMetalContext *)context;
{
    return [[self alloc] initWithGammaFactor:gamma context:context];
}

- (instancetype)initWithGammaFactor:(float)gamma context:(MRMetalContext *)context;
{
    self = [super initWithFunctionName:@"adjust_gamma" context:context];
    if (self) {
        _gammaFactor = gamma;
    }
    
    return self;
}

- (void)setGammaFactor:(float)gammaFactor
{
    self.dirty = YES;
    _gammaFactor = gammaFactor;
}

- (void)configureArgumentTableWithCommandEncoder:(id<MTLComputeCommandEncoder>)commandEncoder
{
    struct AdjustGammaUniforms uniforms;
    uniforms.gammaFactor = self.gammaFactor;
    
    if (!self.uniformBuffer)
    {
        self.uniformBuffer = [self.context.device newBufferWithLength:sizeof(uniforms)
                                                              options:MTLResourceOptionCPUCacheModeDefault];
    }
    
    memcpy([self.uniformBuffer contents], &uniforms, sizeof(uniforms));
    
    [commandEncoder setBuffer:self.uniformBuffer offset:0 atIndex:0];
    
}

@end
