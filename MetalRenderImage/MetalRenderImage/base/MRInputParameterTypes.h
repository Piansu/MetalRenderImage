//
//  MRInputParameterTypes.h
//  MetalRenderImage
//
//  Created by suruochang on 2018/11/1.
//  Copyright © 2018年 Su Ruochang. All rights reserved.
//

#ifndef MRInputParameterTypes_h
#define MRInputParameterTypes_h

typedef enum {
    MRTextureIndexTypeOutput,
    MRTextureIndexTypeInputOne,
    MRTextureIndexTypeInputTwo,
    MRTextureIndexTypeInputThree,
    MRTextureIndexTypeInputFour,
} MRTextureIndexType;


struct MROneInputParameterUniforms {
    float one;
};

struct MRTwoInputParameterUniforms {
    float one;
    float two;
};

struct MRThreeInputParameterUniforms {
    float one;
    float two;
    float three;
};

#endif /* MRInputParameterTypes_h */
