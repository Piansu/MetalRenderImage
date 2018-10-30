//
//  MRColorInvertFilter.m
//  ImageProcessing
//
//  Created by suruochang on 2018/10/15.
//  Copyright © 2018年 Su Ruochang. All rights reserved.
//

#import "MRColorInvertFilter.h"

@implementation MRColorInvertFilter

- (instancetype)initWithContext:(MRMetalContext *)context;
{
    return [self initWithFunctionName:@"adjust_color_invert" context:context];
    
}

@end
