#import <UIKit/UIKit.h>
#import <Metal/Metal.h>
#import "MRMetalContext.h"

typedef enum {
    MRImageScalingModeAspectFit,
    MRImageScalingModeAspectFill,
    MRImageScalingModeScaleToFill,
    MRImageScalingModeDontResize,
} MRImageScalingMode;

@interface MRImageView : UIView

@property (nonatomic, strong) id<MTLTexture> texture;
@property (nonatomic, assign) MRImageScalingMode scalingMode;
@property (nonatomic, strong) MRMetalContext *metalContext;

@end
