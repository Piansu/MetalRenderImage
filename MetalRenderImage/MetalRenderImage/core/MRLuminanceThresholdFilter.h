//
//  MRLuminanceThresholdFilter.h
//  MetalRenderImage
//
//  Created by suruochang on 2018/11/16.
//  Copyright © 2018年 Su Ruochang. All rights reserved.
//

#import "MRImageFilter.h"

@interface MRLuminanceThresholdFilter : MRImageFilter

//threshold:[0, 1]
@property (nonatomic, assign) float threshold;

@end
