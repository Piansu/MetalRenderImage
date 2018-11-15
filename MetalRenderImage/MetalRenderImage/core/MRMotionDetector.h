//
//  MRMotionDetector.h
//  MetalRenderImage
//
//  Created by suruochang on 2018/11/16.
//  Copyright © 2018年 Su Ruochang. All rights reserved.
//

#import "MRImageTwoInputFilter.h"

@interface MRMotionDetector : MRImageTwoInputFilter

@property (nonatomic, assign) float lowPassStrength;

@end
