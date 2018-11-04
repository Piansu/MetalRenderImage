//
//  MRWhiteBalanceFilter.h
//  MetalRenderImage
//
//  Created by suruochang on 2018/10/30.
//  Copyright © 2018年 Su Ruochang. All rights reserved.
//

#import "MRImageFilter.h"

@interface MRWhiteBalanceFilter : MRImageFilter

@property(nonatomic, assign) float temperature;

@property(nonatomic, assign) float tint;


@end
