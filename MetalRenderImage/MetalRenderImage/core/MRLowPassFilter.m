//
//  MRLowPassFilter.m
//  MetalRenderImage
//
//  Created by suruochang on 2018/11/14.
//  Copyright © 2018年 Su Ruochang. All rights reserved.
//

#import "MRLowPassFilter.h"
#import "MRMetalContext.h"

@interface MRLowPassFilter ()

@property (nonatomic, strong) id<MTLTexture> tmpTexture;

@end

@implementation MRLowPassFilter

- (instancetype)initWithContext:(MRMetalContext *)context
{
    return [self initWithFunctionName:@"dissolve_blend" context:context];
}

- (void)configureTextureParametersWithCommandEncoder:(id<MTLComputeCommandEncoder>)commandEncoder
{
    id<MTLTexture> secondTexture = self.tmpTexture;
    [commandEncoder setTexture:secondTexture atIndex:MRTextureIndexTypeInputTwo];
}

- (void)configureBufferParametersWithCommandEncoder:(id<MTLComputeCommandEncoder>)commandEncoder
{
    struct MROneInputParameterUniforms uniforms;
    uniforms.one = self.mix;
    
    if (!self.uniformBuffer)
    {
        self.uniformBuffer = [self.context.device newBufferWithLength:sizeof(uniforms)
                                                              options:MTLResourceOptionCPUCacheModeDefault];
    }
    
    memcpy([self.uniformBuffer contents], &uniforms, sizeof(uniforms));
    
    [commandEncoder setBuffer:self.uniformBuffer offset:0 atIndex:0];
    
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
    
    if (self.tmpTexture == nil) {
        
        MTLTextureDescriptor *textureDescriptor = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:[inputTexture pixelFormat]
                                                                                                     width:[inputTexture width]
                                                                                                    height:[inputTexture height]
                                                                                                 mipmapped:NO];
        textureDescriptor.usage = MTLTextureUsageShaderWrite | MTLTextureUsageShaderRead;
        
        self.tmpTexture = [self.context.device newTextureWithDescriptor:textureDescriptor];
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
    
    self.tmpTexture = self.internalTexture;
    
    return self.internalTexture;
}


@end
