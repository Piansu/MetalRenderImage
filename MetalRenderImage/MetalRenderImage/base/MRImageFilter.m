
#import <Metal/Metal.h>
#import "MRImageFilter.h"
#import "MRMetalContext.h"
#import "MRInputParameterTypes.h"

@interface MRImageFilter ()

@property (nonatomic, strong) id<MTLFunction> kernelFunction;
@property (nonatomic, strong) id<MTLTexture> texture;

@end

@implementation MRImageFilter

@synthesize initialized=_initialized;
@synthesize provider=_provider;

- (instancetype)initWithContext:(MRMetalContext *)context;
{
    NSAssert(0, @"functionName must input!");
    return nil;
}

- (instancetype)initWithFunctionName:(NSString *)functionName context:(MRMetalContext *)context;
{
    if ((self = [super init]))
    {
        NSError *error = nil;
        _context = context;
        _kernelFunction = [_context.library newFunctionWithName:functionName];
        _pipeline = [_context.device newComputePipelineStateWithFunction:_kernelFunction error:&error];
        if (!_pipeline)
        {
            NSLog(@"Error occurred when building compute pipeline for function %@", functionName);
            return nil;
        }
        _initialized = YES;
    }
    
    return self;
}


- (void)configureBufferParametersWithCommandEncoder:(id<MTLComputeCommandEncoder>)commandEncoder;
{
}

- (void)configureTextureParametersWithCommandEncoder:(id<MTLComputeCommandEncoder>)commandEncoder;
{
}

- (void)applyFilter
{
    id<MTLTexture> inputTexture = self.provider.texture;
    
    if (inputTexture == nil)
    {
        return;
    }
    
    if (!self.internalTexture ||
        [self.internalTexture width] != [inputTexture width] ||
        [self.internalTexture height] != [inputTexture height])
    {
        MTLTextureDescriptor *textureDescriptor = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:[inputTexture pixelFormat]
                                                                                                     width:[inputTexture width]
                                                                                                    height:[inputTexture height]
                                                                                                 mipmapped:NO];
        //否则会出现奔溃
        textureDescriptor.usage = MTLTextureUsageShaderWrite | MTLTextureUsageShaderRead;
        
        self.internalTexture = [self.context.device newTextureWithDescriptor:textureDescriptor];
    }
    
    MTLSize threadgroupCounts = MTLSizeMake(8, 8, 1);
    MTLSize threadgroups = MTLSizeMake([inputTexture width] / threadgroupCounts.width,
                                       [inputTexture height] / threadgroupCounts.height,
                                       1);
    
    id<MTLCommandBuffer> commandBuffer = [self.context.commandQueue commandBuffer];
    
    id<MTLComputeCommandEncoder> commandEncoder = [commandBuffer computeCommandEncoder];
    [commandEncoder setComputePipelineState:self.pipeline];
    
    [commandEncoder setTexture:self.internalTexture atIndex:MRTextureIndexTypeOutput];
    [commandEncoder setTexture:inputTexture atIndex:MRTextureIndexTypeInputOne];

    [self configureTextureParametersWithCommandEncoder:commandEncoder];

    [self configureBufferParametersWithCommandEncoder:commandEncoder];
    
    [commandEncoder dispatchThreadgroups:threadgroups threadsPerThreadgroup:threadgroupCounts];
    [commandEncoder endEncoding];
    
    [commandBuffer commit];
    [commandBuffer waitUntilCompleted];
}

- (id<MTLTexture>)texture
{
    if (self.isInitialized)
    {
        [self applyFilter];
    }
    
    return self.internalTexture;
}

@end
