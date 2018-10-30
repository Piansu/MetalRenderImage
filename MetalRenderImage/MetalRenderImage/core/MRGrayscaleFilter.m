//
//  MRGrayscaleFilter.m
//  ImageProcessing
//
//  Created by suruochang on 2018/10/15.
//  Copyright © 2018年 Su Ruochang. All rights reserved.
//

#import "MRGrayscaleFilter.h"

@implementation MRGrayscaleFilter

- (instancetype)initWithContext:(MRMetalContext *)context;
{
    return [self initWithFunctionName:@"adjust_grayscale" context:context];
}

@end
