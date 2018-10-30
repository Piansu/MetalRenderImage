
#import "MRImageView.h"
#import <simd/simd.h>

@interface MRImageView ()

@property (nonatomic, strong) id<MTLRenderPipelineState> pipelineState;
@property (nonatomic, strong) id<MTLBuffer> vertexBuffer;

@end

@implementation MRImageView

+ (id)layerClass {
    return [CAMetalLayer class];
}

- (instancetype)initWithFrame:(CGRect)frameRect context:(MRMetalContext *)metalContext {
    if ((self = [super initWithFrame:frameRect])) {
        _metalContext = metalContext;
        [self configureDefaults];
        [self makeVertexBuffer];
        [self makeRenderPipelineState];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if ((self = [super initWithCoder:coder])) {
        _metalContext = [MRMetalContext defaultContext];
        [self configureDefaults];
        [self makeVertexBuffer];
        [self makeRenderPipelineState];
    }
    return self;
}

- (CAMetalLayer *)metalLayer {
    return (CAMetalLayer *)self.layer;
}

- (void)setTexture:(id)texture {
    _texture = texture;
    [self setNeedsDisplay];
    [self drawRect:CGRectZero];
}

- (void)setScalingMode:(MRImageScalingMode)scalingMode {
    _scalingMode = scalingMode;
    [self setNeedsDisplay];
    [self drawRect:CGRectZero];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setNeedsDisplay];
    [self drawRect:CGRectZero];
}

- (void)configureDefaults {
    self.metalLayer.device = _metalContext.device;
    self.metalLayer.pixelFormat = MTLPixelFormatBGRA8Unorm;
}

- (void)makeVertexBuffer {
    // Vertex list for a full-screen quad described as a triangle strip.
    // Each vertex has two clip-space coordinates, followed by two texture coordinates.
    float vertices[] = {
        -1, -1, 0, 1,    // lower left
        -1,  1, 0, 0,    // upper left
         1, -1, 1, 1,    // lower right
         1,  1, 1, 0,    // upper right
    };

    _vertexBuffer = [_metalContext.device newBufferWithBytes:&vertices[0]
                                                      length:sizeof(vertices)
                                                     options:MTLResourceOptionCPUCacheModeDefault];
}

- (void)makeRenderPipelineState {
    MTLVertexDescriptor *vertexDescriptor = [MTLVertexDescriptor vertexDescriptor];
    vertexDescriptor.attributes[0].format = MTLVertexFormatFloat2; // position
    vertexDescriptor.attributes[0].offset = 0;
    vertexDescriptor.attributes[0].bufferIndex = 0;
    vertexDescriptor.attributes[1].format = MTLVertexFormatFloat2; // texCoords
    vertexDescriptor.attributes[1].offset = 2 * sizeof(float);
    vertexDescriptor.attributes[1].bufferIndex = 0;
    vertexDescriptor.layouts[0].stepRate = 1;
    vertexDescriptor.layouts[0].stepFunction = MTLVertexStepFunctionPerVertex;
    vertexDescriptor.layouts[0].stride = 4 * sizeof(float);

//    id <MTLLibrary> library = [_metalContext.device newDefaultLibrary];
    id <MTLLibrary> library = [_metalContext library];
    id <MTLFunction> vertexFunction = [library newFunctionWithName:@"vertex_reshape"];
    id <MTLFunction> fragmentFunction = [library newFunctionWithName:@"fragment_texture"];

    MTLRenderPipelineDescriptor *pipelineDescriptor = [MTLRenderPipelineDescriptor new];
    pipelineDescriptor.vertexFunction = vertexFunction;
    pipelineDescriptor.fragmentFunction = fragmentFunction;
    pipelineDescriptor.vertexDescriptor = vertexDescriptor;
    pipelineDescriptor.colorAttachments[0].pixelFormat = self.metalLayer.pixelFormat;

    NSError *error = nil;
    _pipelineState = [_metalContext.device newRenderPipelineStateWithDescriptor:pipelineDescriptor error:&error];
    if (!_pipelineState) {
        NSLog(@"Error occurred when making render pipeline state: %@", [error localizedDescription]);
    }
}

- (matrix_float2x2)scaleMatrixForScalingMode:(MRImageScalingMode)scalingMode
                                 textureSize:(CGSize)textureSize
                                    viewSize:(CGSize)viewSize
{
    float imageAspect = textureSize.width / textureSize.height;
    float viewAspect = viewSize.width / viewSize.height;
    matrix_float2x2 matrix = matrix_identity_float2x2;

    switch (scalingMode) {
        case MRImageScalingModeScaleToFill:
        {
            return matrix;
        }
        case MRImageScalingModeAspectFit:
        {
            if (imageAspect < viewAspect) {
                matrix.columns[0][0] = (imageAspect / viewAspect);
            } else {
                matrix.columns[1][1] = (viewAspect / imageAspect);
            }
            return matrix;
        }
        case MRImageScalingModeAspectFill:
        {
            if (imageAspect > viewAspect) {
                matrix.columns[0][0] = (imageAspect / viewAspect);
            } else {
                matrix.columns[1][1] = (viewAspect / imageAspect);
            }
            return matrix;
        }
        case MRImageScalingModeDontResize:
        {
            matrix.columns[0][0] = (textureSize.width / viewSize.width);
            matrix.columns[1][1] = (textureSize.height / viewSize.height);
            return matrix;
        }
    }
}

- (void)drawRect:(CGRect)rect {
    id<CAMetalDrawable> drawable = [self.metalLayer nextDrawable];

    if (drawable != nil && self.texture != nil) {
        MTLRenderPassDescriptor *passDescriptor = [MTLRenderPassDescriptor new];
        passDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(1, 1, 1, 1);
        passDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
        passDescriptor.colorAttachments[0].storeAction = MTLStoreActionStore;
        passDescriptor.colorAttachments[0].texture = [drawable texture];

        id<MTLCommandBuffer> commandBuffer = [self.metalContext.commandQueue commandBuffer];

        id<MTLRenderCommandEncoder> commandEncoder = [commandBuffer renderCommandEncoderWithDescriptor:passDescriptor];
        if (self.texture != nil) {
            [commandEncoder setRenderPipelineState:self.pipelineState];
            [commandEncoder setVertexBuffer:self.vertexBuffer offset:0 atIndex:0];
            CGSize textureSize = CGSizeMake([self.texture width], [self.texture height]);
            matrix_float2x2 scaleMatrix = [self scaleMatrixForScalingMode:self.scalingMode
                                                              textureSize:textureSize
                                                                 viewSize:self.metalLayer.drawableSize];
            [commandEncoder setVertexBytes:&scaleMatrix length:sizeof(scaleMatrix) atIndex:1];
            [commandEncoder setFragmentTexture:self.texture atIndex:0];
            [commandEncoder drawPrimitives:MTLPrimitiveTypeTriangleStrip vertexStart:0 vertexCount:4];
        }
        [commandEncoder endEncoding];

        [commandBuffer presentDrawable:drawable];

        [commandBuffer commit];
    }
}

@end
