//
//  MRSobelFilter.m
//  MetalRenderImage
//
//  Created by suruochang on 2018/11/13.
//  Copyright © 2018年 Su Ruochang. All rights reserved.
//

#import "MRSobelFilter.h"

@implementation MRSobelFilter

- (instancetype)initWithContext:(MRMetalContext *)context
{
    return [self initWithFunctionName:@"adjust_sobel" context:context];
}

@end
