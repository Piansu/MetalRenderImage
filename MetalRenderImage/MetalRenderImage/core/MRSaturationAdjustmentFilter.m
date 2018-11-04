
#import "MRSaturationAdjustmentFilter.h"
#import <Metal/Metal.h>
#import "MRInputParameterTypes.h"

@implementation MRSaturationAdjustmentFilter

+ (instancetype)filterWithSaturationFactor:(float)saturation context:(MRMetalContext *)context
{
    return [[self alloc] initWithSaturationFactor:saturation context:context];
}

- (instancetype)initWithSaturationFactor:(float)saturation context:(MRMetalContext *)context
{
    if ((self = [super initWithFunctionName:@"adjust_saturation" context:context]))
    {
        _saturationFactor = saturation;
    }
    return self;
}

- (void)setSaturationFactor:(float)saturationFactor
{
    self.dirty = YES;
    _saturationFactor = saturationFactor;
}

- (void)configureBufferParametersWithCommandEncoder:(id<MTLComputeCommandEncoder>)commandEncoder
{
    struct MROneInputParameterUniforms uniforms;
    uniforms.one = self.saturationFactor;

    if (!self.uniformBuffer)
    {
        self.uniformBuffer = [self.context.device newBufferWithLength:sizeof(uniforms)
                                                              options:MTLResourceOptionCPUCacheModeDefault];
    }

    memcpy([self.uniformBuffer contents], &uniforms, sizeof(uniforms));
    
    [commandEncoder setBuffer:self.uniformBuffer offset:0 atIndex:0];
}

@end
