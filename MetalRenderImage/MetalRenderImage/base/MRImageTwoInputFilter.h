//
//  MRTwoInputImageFilter.h
//  MetalRenderImage
//
//  Created by suruochang on 2018/10/30.
//  Copyright © 2018年 Su Ruochang. All rights reserved.
//

#import "MRImageFilter.h"
#import "MRInputParameterTypes.h"

@interface MRImageTwoInputFilter : MRImageFilter

@property (nonatomic, strong) id<MRTextureProvider> secondProvider;


@end
