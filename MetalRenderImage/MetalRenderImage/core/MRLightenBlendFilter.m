//
//  MRLightenBlendFilter.m
//  MetalRenderImage
//
//  Created by suruochang on 2018/11/1.
//  Copyright © 2018年 Su Ruochang. All rights reserved.
//

#import "MRLightenBlendFilter.h"

@implementation MRLightenBlendFilter

- (instancetype)initWithContext:(MRMetalContext *)context
{
    return [self initWithFunctionName:@"lighten_blend" context:context];
}

@end
