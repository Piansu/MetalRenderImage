//
//  TableViewController.m
//  MetalRenderImageExamples
//
//  Created by suruochang on 2018/10/30.
//  Copyright © 2018年 Su Ruochang. All rights reserved.
//

#import "TableViewController.h"
#import "FilterViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.tableFooterView = [UIView new];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return METAL_RENDER_NUMFILTERS;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify = @"table";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellIdentify];
    }
    
    NSString *title = nil;
    
    NSInteger index = indexPath.row;
    switch (index) {
        case METALRENDER_GAUSSIAN:
            title = @"Gaussian Blur";
            break;
        
        case METALRENDER_GRAYSCALE:
            title = @"Grayscale";
            break;
            
        case METALRENDER_HUE:
            title = @"Hue";
            break;
            
        case METALRENDER_RGB:
            title = @"RGB";
            break;
            
        case METALRENDER_SATURATION:
            title = @"Saturtion";
            break;
            
        case METALRENDER_BRIGHTNESS:
            title = @"Brightness";
            break;
            
        case METALRENDER_COLORINVERT:
            title = @"Color Invert";
            break;
            
        case METALRENDER_CONTRAST:
            title = @"Contrast";
            break;
            
        case METALRENDER_EXPOSURE:
            title = @"Exposure";
            break;
            
        case METALRENDER_GAMMA:
            title = @"Gamma";
            break;
    
        case METALRENDER_WHITEBALANCE:
            title = @"White Balance";
            break;
        
        case METALRENDER_MONOCHROME:
            title = @"Monochrome";
            break;
        
        case METALRENDER_SHARPENESS:
            title = @"Sharpen";
            break;
        
        default:
            break;
    }
    
    cell.textLabel.text = title;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    MetalRenderImageFilterType filterType = (MetalRenderImageFilterType)indexPath.row;
    FilterViewController *vc = [[FilterViewController alloc] initWithFliterType:filterType];
    vc.title = title;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
