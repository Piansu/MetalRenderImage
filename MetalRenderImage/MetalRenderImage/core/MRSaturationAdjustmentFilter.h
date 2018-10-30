
#import <Foundation/Foundation.h>
#import "MRMetalContext.h"
#import "MRImageFilter.h"

@interface MRSaturationAdjustmentFilter : MRImageFilter

@property (nonatomic, assign) float saturationFactor;

+ (instancetype)filterWithSaturationFactor:(float)saturation context:(MRMetalContext *)context;

@end

