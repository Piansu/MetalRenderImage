//
//  MRWhiteBalanceFilter.m
//  MetalRenderImage
//
//  Created by suruochang on 2018/10/30.
//  Copyright © 2018年 Su Ruochang. All rights reserved.
//

#import "MRWhiteBalanceFilter.h"
#import "MRMetalContext.h"

struct AdjustWhiteBalanceUniforms
{
    float temperature;
    float tint;
};

@implementation MRWhiteBalanceFilter

- (instancetype)initWithContext:(MRMetalContext *)context
{
    self = [super initWithFunctionName:@"adjust_white_balance" context:context];
    if (self) {
        self.temperature = 5000.0;
        self.tint = 0.0;
    }
    return self;
}

- (void)configureBufferParametersWithCommandEncoder:(id<MTLComputeCommandEncoder>)commandEncoder
{
    struct AdjustWhiteBalanceUniforms uniforms;
    
    float adjustTemp = _temperature < 5000 ? 0.0004 * (_temperature-5000.0) : 0.00006 * (_temperature-5000.0);
    float adjustTint =  _tint / 100.0;
    
    uniforms.temperature = adjustTemp;
    uniforms.tint = adjustTint;
    
    if (!self.uniformBuffer)
    {
        self.uniformBuffer = [self.context.device newBufferWithLength:sizeof(uniforms)
                                                              options:MTLResourceOptionCPUCacheModeDefault];
    }
    
    memcpy([self.uniformBuffer contents], &uniforms, sizeof(uniforms));
    
    [commandEncoder setBuffer:self.uniformBuffer offset:0 atIndex:0];
}

@end
