//
//  MRVideoCaptureDevice.m
//  LearnOpenGLES
//
//  Created by suruochang on 2018/9/29.
//  Copyright © 2018年 Mac OS X. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRVideoCaptureDevice.h"
#import <AssetsLibrary/ALAssetsLibrary.h>

@interface MRVideoCaptureDevice ()

@property (nonatomic, strong) AVCaptureSession *mCaptureSession; //负责输入和输出设备之间的数据传递
@property (nonatomic, strong) AVCaptureDeviceInput *mCaptureDeviceInput;//负责从AVCaptureDevice获得输入数据
@property (nonatomic, strong) AVCaptureVideoDataOutput *mCaptureDeviceOutput; //output

@property (nonatomic, strong) dispatch_queue_t mProcessQueue;

@property (nonatomic, weak) MRMetalContext *context;

@property (nonatomic, assign) CVMetalTextureCacheRef textureCache; //output

@property (nonatomic, strong) id <MTLTexture>texture;

@end

@implementation MRVideoCaptureDevice

- (instancetype)initDeviceWithContext:(MRMetalContext *)context;
{
    NSAssert(context, @"context must not be null");
    self = [super init];
    if (self) {
        _context = context;
    }
    
    return self;
}

- (void)setupDevice
{
    self.mProcessQueue = dispatch_queue_create("com.MRMetalRenderImage.videoProcessQueue", DISPATCH_QUEUE_SERIAL);

    CVReturn textCachRes = CVMetalTextureCacheCreate(kCFAllocatorDefault, NULL, self.context.device, NULL, &_textureCache);
    if(textCachRes)
    {
        NSLog(@"ERROR: Can not create a video texture cache!!! ");
        assert(0);
    }
    
    self.mCaptureSession = [[AVCaptureSession alloc] init];
    self.mCaptureSession.sessionPreset = AVCaptureSessionPreset1920x1080;
    
    AVCaptureDevice *inputCamera = nil;
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == AVCaptureDevicePositionBack)
        {
            inputCamera = device;
        }
    }
    
    NSError *error = nil;
    self.mCaptureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:inputCamera error:&error];
    if (error) {
        NSLog(@"取得视频设备输入对象时出错");
        return;
    }

    if ([self.mCaptureSession canAddInput:self.mCaptureDeviceInput]) {
        [self.mCaptureSession addInput:self.mCaptureDeviceInput];
    }
    
    self.mCaptureDeviceOutput = [[AVCaptureVideoDataOutput alloc] init];
    [self.mCaptureDeviceOutput setAlwaysDiscardsLateVideoFrames:NO];
    
    [self.mCaptureDeviceOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
    [self.mCaptureDeviceOutput setSampleBufferDelegate:(id<AVCaptureVideoDataOutputSampleBufferDelegate>)self queue:_mProcessQueue];
    if ([self.mCaptureSession canAddOutput:self.mCaptureDeviceOutput]) {
        [self.mCaptureSession addOutput:self.mCaptureDeviceOutput];
    }
    
    AVCaptureConnection *connection = [self.mCaptureDeviceOutput connectionWithMediaType:AVMediaTypeVideo];
    [connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}

//- (void)deviceOrientationChange
//{
//    AVCaptureConnection *connection = [self.mCaptureDeviceOutput connectionWithMediaType:AVMediaTypeVideo];
//    [connection setVideoOrientation:(AVCaptureVideoOrientation)[UIDevice currentDevice].orientation];
//}

- (void)startRunning;
{
    [self.mCaptureSession startRunning];
}

- (void)stopRunning;
{
    [self.mCaptureSession stopRunning];
}


#pragma mark AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection;
{
    CFRetain(sampleBuffer);
    dispatch_async(dispatch_get_main_queue(), ^{
//        CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        if (self.delegate && [self.delegate respondsToSelector:@selector(captureDevice:didOutputSampleBuffer:)])
        {
            [self.delegate captureDevice:self didOutputSampleBuffer:sampleBuffer];
        }
        
        id<MTLTexture> texture = [self converTextureFromSampleBuffer:sampleBuffer];
        self.texture = texture;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(captureDevice:didOutputTexture:)])
        {
            
            [self.delegate captureDevice:self didOutputTexture:texture];
        }
        
        CFRelease(sampleBuffer);
    });
}

- (id <MTLTexture>)converTextureFromSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    if (self.context == nil) {
        return nil;
    }
//    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
//    CVPixelBufferLockBaseAddress(imageBuffer, 0);
//    size_t bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer, 0);
//    size_t width = CVPixelBufferGetWidthOfPlane(imageBuffer, 0);
//    size_t height = CVPixelBufferGetHeightOfPlane(imageBuffer, 0);
//
//    void *lumaAddress = CVPixelBufferGetBaseAddress(imageBuffer);
//
//    MTLTextureDescriptor *textureDescriptor = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:MTLPixelFormatRGBA8Unorm
//                                                                                                 width:width
//                                                                                                height:height
//                                                                                             mipmapped:NO];
//    id<MTLTexture> texture = [self.context.device newTextureWithDescriptor:textureDescriptor];
//
//    MTLRegion region = MTLRegionMake2D(0, 0, width, height);
//    [texture replaceRegion:region mipmapLevel:0 withBytes:lumaAddress bytesPerRow:bytesPerRow];
//
//    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    
    CVReturn error;
    
    CVImageBufferRef sourceImageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    size_t width = CVPixelBufferGetWidth(sourceImageBuffer);
    size_t height = CVPixelBufferGetHeight(sourceImageBuffer);
    
    CVMetalTextureRef textureRef;
    error = CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault, self.textureCache, sourceImageBuffer, NULL, MTLPixelFormatBGRA8Unorm, width, height, 0, &textureRef);
    
    if (error)
    {
        NSLog(@">> ERROR: Couldnt create texture from image");
        assert(0);
    }
    
    id<MTLTexture> texture = CVMetalTextureGetTexture(textureRef);
//    CMTime currentTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
    
    if (!texture)
    {
        NSLog(@">> ERROR: Couldn't get texture from texture ref");
        assert(0);
    }
    
    CVBufferRelease(textureRef);
    
    return texture;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
}

@end
