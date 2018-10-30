
#import "MRMetalContext.h"

@implementation MRMetalContext

+ (instancetype)defaultContext {
    static dispatch_once_t onceToken;
    static MRMetalContext *instance = nil;
    dispatch_once(&onceToken, ^{
        id<MTLDevice> device = MTLCreateSystemDefaultDevice();
        instance = [[MRMetalContext alloc] initWithDevice:device];
    });

    return instance;
}

- (instancetype)initWithDevice:(id<MTLDevice>)device {
    if ((self = [super init])) {
        _device = device;
        NSBundle *bundle = [NSBundle mainBundle];
        
        NSString *path = [bundle pathForResource:@"default" ofType:@"metallib" inDirectory:@"Frameworks/MetalRenderImage.framework"];
        NSError *error;
        _library = [_device newLibraryWithFile:path error:&error];
        _commandQueue = [_device newCommandQueue];
    }

    return self;
}

@end
