
#import <Foundation/Foundation.h>
#import "MRImageFilter.h"

@interface MRGaussianBlurFilter : MRImageFilter

@property (nonatomic, assign) float radius;
@property (nonatomic, assign) float sigma;

+ (instancetype)filterWithRadius:(float)radius context:(MRMetalContext *)context;

@end

