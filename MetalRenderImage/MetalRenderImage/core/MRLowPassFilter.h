//
//  MRLowPassFilter.h
//  MetalRenderImage
//
//  Created by suruochang on 2018/11/14.
//  Copyright © 2018年 Su Ruochang. All rights reserved.
//

#import "MRImageTwoInputFilter.h"

@interface MRLowPassFilter : MRImageTwoInputFilter

@property (nonatomic, assign) float mix;

@end
