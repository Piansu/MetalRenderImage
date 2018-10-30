
#import <Foundation/Foundation.h>
#import "MRTextureProvider.h"
#import "MRTextureConsumer.h"

@protocol MTLTexture, MTLBuffer, MTLComputeCommandEncoder, MTLComputePipelineState;
@class MRMetalContext;

@interface MRImageFilter : NSObject <MRTextureProvider, MRTextureConsumer>

@property (nonatomic, strong) MRMetalContext *context;
@property (nonatomic, strong) id<MTLBuffer> uniformBuffer;
@property (nonatomic, strong) id<MTLComputePipelineState> pipeline;
@property (nonatomic, strong) id<MTLTexture> internalTexture;
@property (nonatomic, assign, getter=isDirty) BOOL dirty;

- (instancetype)initWithFunctionName:(NSString *)functionName context:(MRMetalContext *)context;

- (void)configureArgumentTableWithCommandEncoder:(id<MTLComputeCommandEncoder>)commandEncoder;

@end

