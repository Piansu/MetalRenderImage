//
//  MRVideoCaptureDevice.h
//  LearnOpenGLES
//
//  Created by suruochang on 2018/9/29.
//  Copyright © 2018年 Mac OS X. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "MRMetalContext.h"
#import "MRTextureProvider.h"

@class MRVideoCaptureDevice;

@protocol MRVideoCaptureDeviceDelegate <NSObject>

- (void)captureDevice:(MRVideoCaptureDevice *)device didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer;

- (void)captureDevice:(MRVideoCaptureDevice *)device didOutputTexture:(id<MTLTexture>)texture;

@end

@interface MRVideoCaptureDevice : NSObject <MRTextureProvider>

- (instancetype)initDeviceWithContext:(MRMetalContext *)context;

@property (nonatomic, weak) id<MRVideoCaptureDeviceDelegate> delegate;

- (void)setupDevice;

- (void)startRunning;

- (void)stopRunning;

@end
