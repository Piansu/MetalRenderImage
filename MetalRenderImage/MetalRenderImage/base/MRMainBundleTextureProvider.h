
#import <UIKit/UIKit.h>
#import "MRTextureProvider.h"

@class MRMetalContext;

@interface MRMainBundleTextureProvider : NSObject<MRTextureProvider>

+ (instancetype)textureProviderWithImageNamed:(NSString *)imageName context:(MRMetalContext *)context;

@end
