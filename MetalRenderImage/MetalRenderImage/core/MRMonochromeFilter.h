//
//  MRMonochromeFilter.h
//  MetalRenderImage
//
//  Created by suruochang on 2018/10/30.
//  Copyright © 2018年 Su Ruochang. All rights reserved.
//

#import "MRImageFilter.h"

typedef struct MRColor {
    float red;
    float green;
    float blue;
    float alpha;
} MRColor;

@interface MRMonochromeFilter : MRImageFilter

@property(nonatomic, assign) MRColor color;

@property(nonatomic, assign) float intensity;

@end
