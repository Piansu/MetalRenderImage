//
//  FilterViewController.m
//  MetalRenderImageExamples
//
//  Created by suruochang on 2018/10/30.
//  Copyright © 2018年 Su Ruochang. All rights reserved.
//

#import "FilterViewController.h"
#import "TableViewController.h"

#import <MetalRenderImage.h>


@interface FilterViewController ()

@property (weak, nonatomic) IBOutlet MRImageView *imageView;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@property (nonatomic, strong) MRMetalContext *context;
@property (nonatomic, strong) id<MRTextureProvider> imageProvider;
@property (nonatomic, strong) MRImageFilter *filter;

@property (nonatomic, assign) MetalRenderImageFilterType filterType;

@property (nonatomic, assign) CGFloat minimumValue;
@property (nonatomic, assign) CGFloat maximumValue;
@property (nonatomic, assign) CGFloat value;

@end

@implementation FilterViewController

- (instancetype)initWithFliterType:(MetalRenderImageFilterType)type;
{
    self = [super initWithNibName:NSStringFromClass(self.class) bundle:nil];
    if (self) {
        _filterType = type;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.context = [MRMetalContext defaultContext];
    
    self.imageView.metalContext = self.context;
    
    [self setupFilter];
    [self update];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupFilter
{
    self.slider.userInteractionEnabled = YES;
    
    self.imageProvider = [MRMainBundleTextureProvider textureProviderWithImageNamed:@"mandrill" context:self.context];
    
    _filter = nil;
    switch (_filterType) {
        case METALRENDER_GAUSSIAN:
        {
            self.minimumValue = 0;
            self.maximumValue = 8;
            self.value = 2;
            
            _filter = [MRGaussianBlurFilter filterWithRadius:self.value context:self.context];
        }
            break;
         
        case METALRENDER_GRAYSCALE:
        {
            _filter = [[MRGrayscaleFilter alloc] initWithContext:self.context];
            self.slider.userInteractionEnabled = NO;
        }
            break;
            
        case METALRENDER_HUE:
        {
            self.minimumValue = 0;
            self.maximumValue = 360;
            self.value = 90;
            _filter = [MRHueFilter filterWithHueFactor:self.value context:self.context];
        }
            break;
            
        case METALRENDER_RGB:
        {
            self.minimumValue = 0;
            self.maximumValue = 2;
            self.value = 1;
            
            MRRGBFilter *filter = [[MRRGBFilter alloc] initWithContext:self.context];
            
            _filter = filter;
            
            //            filter.redFactor =
            //            filter.greenFactor =
            //              filter.greenFactor =
        }
            break;
            
        case METALRENDER_SATURATION:
        {
            self.minimumValue = 0;
            self.maximumValue = 2;
            self.value = 1;
            
            _filter = [MRSaturationAdjustmentFilter filterWithSaturationFactor:self.value context:self.context];
            
        }
            break;
            
        case METALRENDER_BRIGHTNESS:
        {
            self.minimumValue = -1;
            self.maximumValue = 1;
            self.value = 0;
            _filter = [MRBrightnessFilter filterWithBrightnessFactor:self.value context:self.context];
            
        }
            break;
            
        case METALRENDER_COLORINVERT:
        {
            _filter = [[MRColorInvertFilter alloc] initWithContext:self.context];
            
            self.slider.userInteractionEnabled = NO;
        }
            break;
            
        case METALRENDER_CONTRAST:
        {
            self.minimumValue = 0;
            self.maximumValue = 4;
            self.value = 1;
            
            _filter = [MRContrastFilter filterWithContrastFactor:self.value context:self.context];
        }
            break;
            
        case METALRENDER_EXPOSURE:
        {
            self.minimumValue = -4;
            self.maximumValue = 4;
            self.value = 0;
            
            _filter = [MRExposureFilter filterWithExposureFactor:self.value context:self.context];
        }
            break;
            
        case METALRENDER_GAMMA:
        {
            self.minimumValue = 0;
            self.maximumValue = 3;
            self.value = 1;
            
            _filter = [MRGammaFilter filterWithGammaFactor:self.value context:self.context];
        }
            break;
        case METALRENDER_WHITEBALANCE:
        {
            self.minimumValue = 2500;
            self.maximumValue = 7500;
            self.value = 5000;
            
            _filter = [[MRWhiteBalanceFilter alloc] initWithContext:self.context];
        }
            break;
        case METALRENDER_MONOCHROME:
        {
            self.minimumValue = 0;
            self.maximumValue = 1;
            self.value = 0;
            
            MRMonochromeFilter *filter = [[MRMonochromeFilter alloc] initWithContext:self.context];
            filter.color = (MRColor){1.0f, 0.0f, 0.0f, 1.f};
            filter.intensity = 1.0;
            
            _filter = filter;
        }
            break;
        
        case METALRENDER_SHARPENESS:
        {
            self.minimumValue = -1;
            self.maximumValue = 4;
            self.value = 0;
            
            _filter = [[MRCharpenFilter alloc] initWithContext:self.context];
        }
            break;
        
        default:
        {
            _filter = nil;
#if DEBUG
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"setup filter not complete" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
#endif
        }
            break;
    }
    
    if (self.filter) {
        self.filter.provider = self.imageProvider;
    }
}

- (void)update
{
    if (self.filter == nil) {
        return;
    }
    
    float factor = self.slider.value;
    
    switch (_filterType) {
        case METALRENDER_GAUSSIAN:
        {
            MRGaussianBlurFilter *filter = (MRGaussianBlurFilter *)self.filter;
            filter.radius = factor;
        }
            break;
            
        case METALRENDER_GRAYSCALE:
            break;
            
        case METALRENDER_HUE:
        {
            [(MRHueFilter *)_filter setHueFactor:factor];
        }
            break;
            
        case METALRENDER_RGB:
        {
            [(MRRGBFilter *)_filter setRedFactor:factor];
        }
            break;
            
        case METALRENDER_SATURATION:
        {
            [(MRSaturationAdjustmentFilter *)_filter setSaturationFactor:factor];
        }
            break;
            
        case METALRENDER_BRIGHTNESS:
        {
            [(MRBrightnessFilter *)_filter setBrightnessFactor:factor];
        }
            break;
            
        case METALRENDER_COLORINVERT:
            break;
            
        case METALRENDER_CONTRAST:
        {
            [(MRContrastFilter *)_filter setContrastFactor:factor];
        }
            break;
            
        case METALRENDER_EXPOSURE:
        {
            [(MRExposureFilter *)_filter setExposureFactor:factor];
        }
            break;
            
        case METALRENDER_GAMMA:
        {
            [(MRGammaFilter *)_filter setGammaFactor:factor];
        }
            break;
        case METALRENDER_WHITEBALANCE:
        {
            [(MRWhiteBalanceFilter *)_filter setTemperature:factor];
        }
            break;
        
        case METALRENDER_MONOCHROME:
        {
            [(MRMonochromeFilter *)_filter setIntensity:factor];
        }
            break;
        
        case METALRENDER_SHARPENESS:
        {
            [(MRCharpenFilter *)_filter setSharpness:factor];
        }
            break;
        
        default:
            break;
    }
    
    
    id <MTLTexture> texture = self.filter.texture;
    
    self.imageView.texture = texture;
}


- (IBAction)sliderDidChange:(UISlider *)sender
{
    [self update];
}

#pragma mark override
- (void)setMaximumValue:(CGFloat)maximumValue
{
    _maximumValue = maximumValue;
    self.slider.maximumValue = maximumValue;
}

- (void)setMinimumValue:(CGFloat)minimumValue
{
    _minimumValue = minimumValue;
    self.slider.minimumValue = minimumValue;
}

- (void)setValue:(CGFloat)value
{
    _value = value;
    self.slider.value = value;
}

@end
