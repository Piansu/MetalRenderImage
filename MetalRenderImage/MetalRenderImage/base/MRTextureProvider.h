
#import <Foundation/Foundation.h>

@protocol MTLTexture;

@protocol MRTextureProvider <NSObject>

@property (nonatomic, readonly) id<MTLTexture> texture;

@end
