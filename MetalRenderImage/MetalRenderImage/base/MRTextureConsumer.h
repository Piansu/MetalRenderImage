
#import <Foundation/Foundation.h>

@protocol MRTextureProvider;

@protocol MRTextureConsumer <NSObject>

@property (nonatomic, strong) id<MRTextureProvider> provider;

@end
