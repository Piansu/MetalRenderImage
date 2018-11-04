//
//  MRRGBFilter.h
//  ImageProcessing
//
//  Created by suruochang on 2018/10/15.
//  Copyright © 2018年 Su Ruochang. All rights reserved.
//

#import "MRImageFilter.h"

@interface MRRGBFilter : MRImageFilter

@property (readwrite, nonatomic) float redFactor;
@property (readwrite, nonatomic) float greenFactor;
@property (readwrite, nonatomic) float blueFactor;

@end
