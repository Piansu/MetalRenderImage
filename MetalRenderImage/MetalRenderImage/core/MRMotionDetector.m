//
//  MRMotionDetector.m
//  MetalRenderImage
//
//  Created by suruochang on 2018/11/16.
//  Copyright © 2018年 Su Ruochang. All rights reserved.
//

#import "MRMotionDetector.h"
#import "MRLowPassFilter.h"
#import "MRMetalContext.h"

@interface MRMotionDetector ()

@property (nonatomic, strong) MRLowPassFilter *lowPassFilter;

@end

@implementation MRMotionDetector

- (instancetype)initWithContext:(MRMetalContext *)context
{
    self = [super initWithFunctionName:@"adjust_comparison" context:context];
    
    if (self) {
        
        _lowPassFilter = [[MRLowPassFilter alloc] initWithContext:context];
        _lowPassFilter.mix = 0.5;
    }
    
    return self;
}

- (void)configureBufferParametersWithCommandEncoder:(id<MTLComputeCommandEncoder>)commandEncoder
{
    struct MROneInputParameterUniforms uniforms;
    uniforms.one = self.lowPassStrength;
    
    if (!self.uniformBuffer)
    {
        self.uniformBuffer = [self.context.device newBufferWithLength:sizeof(uniforms)
                                                              options:MTLResourceOptionCPUCacheModeDefault];
    }
    
    memcpy([self.uniformBuffer contents], &uniforms, sizeof(uniforms));
    
    [commandEncoder setBuffer:self.uniformBuffer offset:0 atIndex:0];
    
}


- (void)setProvider:(id<MRTextureProvider>)provider
{
    [super setProvider:provider];
    
    _lowPassFilter.provider = provider;
    self.secondProvider = _lowPassFilter;
}

- (void)setLowPassStrength:(float)lowPassStrength
{
    _lowPassStrength = lowPassStrength;
    _lowPassFilter.mix = lowPassStrength;
}

@end
