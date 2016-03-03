//
//  ViewController.m
//  CAShapeLayer_maskLayer
//
//  Created by Jeff on 1/10/16.
//  Copyright © 2016 FNNishipu. All rights reserved.
//

#import "ViewController.h"
#import "CAShapeLayer+ViewMask.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 50, 180, 100)];
    imageView.image = [UIImage imageNamed:@"0.jpg"];
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(40, 50, 80, 100)];
//    view.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:imageView];
    
    CAShapeLayer *layer = [CAShapeLayer createMaskLayerWithView:imageView];
    imageView.layer.mask = layer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
