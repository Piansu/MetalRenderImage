//
//  TableViewController.h
//  MetalRenderImageExamples
//
//  Created by suruochang on 2018/10/30.
//  Copyright © 2018年 Su Ruochang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    METALRENDER_GAUSSIAN,
    METALRENDER_GRAYSCALE,
    METALRENDER_HUE,
    METALRENDER_RGB,
    METALRENDER_SATURATION,
    METALRENDER_BRIGHTNESS,
    METALRENDER_COLORINVERT,
    METALRENDER_CONTRAST,
    METALRENDER_EXPOSURE,
    METALRENDER_GAMMA,
    METALRENDER_WHITEBALANCE,
    METALRENDER_MONOCHROME,
    METALRENDER_SHARPENESS,
    
    METAL_RENDER_NUMFILTERS
} MetalRenderImageFilterType;

@interface TableViewController : UITableViewController


@end

