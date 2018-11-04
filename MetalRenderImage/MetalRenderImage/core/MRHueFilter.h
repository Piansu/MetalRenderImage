//
//  MRHueFilter.h
//  ImageProcessing
//
//  Created by suruochang on 2018/10/15.
//  Copyright © 2018年 Su Ruochang. All rights reserved.
//

#import "MRImageFilter.h"

@interface MRHueFilter : MRImageFilter

@property (nonatomic, assign) float hueFactor;

+ (instancetype)filterWithHueFactor:(float)hue context:(MRMetalContext *)context;

@end
