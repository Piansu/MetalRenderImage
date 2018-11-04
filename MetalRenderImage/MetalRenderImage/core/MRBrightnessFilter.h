//
//  MRBrightnessFilter.h
//  ImageProcessing
//
//  Created by suruochang on 2018/10/15.
//  Copyright © 2018年 Su Ruochang. All rights reserved.
//

#import "MRImageFilter.h"

@interface MRBrightnessFilter : MRImageFilter

@property (nonatomic, assign) float brightnessFactor;

+ (instancetype)filterWithBrightnessFactor:(float)contrast context:(MRMetalContext *)context;

@end
