//
//  MRGammaFilter.h
//  ImageProcessing
//
//  Created by suruochang on 2018/10/15.
//  Copyright © 2018年 Su Ruochang. All rights reserved.
//

#import "MRImageFilter.h"

@interface MRGammaFilter : MRImageFilter

@property (nonatomic, assign) float gammaFactor;

+ (instancetype)filterWithGammaFactor:(float)gamma context:(MRMetalContext *)context;

@end
