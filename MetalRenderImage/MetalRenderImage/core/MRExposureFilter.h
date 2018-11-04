//
//  MRExposureFilter.h
//  ImageProcessing
//
//  Created by suruochang on 2018/10/15.
//  Copyright © 2018年 Su Ruochang. All rights reserved.
//

#import "MRImageFilter.h"

@interface MRExposureFilter : MRImageFilter

@property (nonatomic, assign) float exposureFactor;

+ (instancetype)filterWithExposureFactor:(float)exposure context:(MRMetalContext *)context;

@end
