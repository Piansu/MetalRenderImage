//
//  MRContrastFilter.h
//  ImageProcessing
//
//  Created by suruochang on 2018/10/15.
//  Copyright © 2018年 Su Ruochang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRImageFilter.h"

@interface MRContrastFilter : MRImageFilter

@property (nonatomic, assign) float contrastFactor;

+ (instancetype)filterWithContrastFactor:(float)contrast context:(MRMetalContext *)context;

@end
