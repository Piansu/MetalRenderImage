//
//  MRTwoInputImageFilter.m
//  MetalRenderImage
//
//  Created by suruochang on 2018/10/30.
//  Copyright © 2018年 Su Ruochang. All rights reserved.
//

#import "MRImageTwoInputFilter.h"
#import "MRMetalContext.h"

@implementation MRImageTwoInputFilter

- (void)configureArgumentTableWithCommandEncoder:(id<MTLComputeCommandEncoder>)commandEncoder
{
    id<MTLTexture> secondTexture = self.secondProvider.texture;
    [commandEncoder setTexture:secondTexture atIndex:2];
    
    [self configureTwoInputArgumentTableWithCommandEncoder:commandEncoder];
}

- (void)configureTwoInputArgumentTableWithCommandEncoder:(id<MTLComputeCommandEncoder>)commandEncoder
{
}

@end
