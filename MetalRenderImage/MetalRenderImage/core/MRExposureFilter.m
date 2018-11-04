//
//  MRExposureFilter.m
//  ImageProcessing
//
//  Created by suruochang on 2018/10/15.
//  Copyright © 2018年 Su Ruochang. All rights reserved.
//

#import "MRExposureFilter.h"
#import "MRMetalContext.h"
#import "MRInputParameterTypes.h"

@implementation MRExposureFilter

+ (instancetype)filterWithExposureFactor:(float)exposure context:(MRMetalContext *)context;
{
    return [[self alloc] initWithExposureFactor:exposure context:context];
}

- (instancetype)initWithExposureFactor:(float)exposure context:(MRMetalContext *)context;
{
    self = [super initWithFunctionName:@"adjust_exposure" context:context];
    if (self) {
        _exposureFactor = exposure;
    }
    return self;
}

- (void)setExposureFactor:(float)exposureFactor
{
    self.dirty = YES;
    _exposureFactor = exposureFactor;
}

- (void)configureBufferParametersWithCommandEncoder:(id<MTLComputeCommandEncoder>)commandEncoder
{
    struct MROneInputParameterUniforms uniforms;
    uniforms.one = self.exposureFactor;
    
    if (!self.uniformBuffer)
    {
        self.uniformBuffer = [self.context.device newBufferWithLength:sizeof(uniforms)
                                                              options:MTLResourceOptionCPUCacheModeDefault];
    }
    
    memcpy([self.uniformBuffer contents], &uniforms, sizeof(uniforms));
    
    [commandEncoder setBuffer:self.uniformBuffer offset:0 atIndex:0];
    
}


@end
