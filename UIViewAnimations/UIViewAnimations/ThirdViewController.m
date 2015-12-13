//
//  ThirdViewController.m
//  UIViewAnimations
//
//  Created by FNNishipu on 6/26/15.
//  Copyright (c) 2015 FNNishipu. All rights reserved.
//

#import "ThirdViewController.h"

@interface ThirdViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *plane;

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGPoint originalCenter = _plane.center;
    
    [UIView animateKeyframesWithDuration:1.5 delay:0 options:UIViewKeyframeAnimationOptionRepeat animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.25 animations:^{
            CGPoint center = _plane.center;
            center.x += 80;
            center.y -= 10;
            _plane.center = center;
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.1 relativeDuration:0.4 animations:^{
            _plane.transform = CGAffineTransformMakeRotation(-M_PI_4 / 2);
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.25 relativeDuration:0.25 animations:^{
            CGPoint center = _plane.center;
            center.x += 100;
            center.y -= 50;
            _plane.center = center;
            _plane.alpha = 0;
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.51 relativeDuration:0.01 animations:^{
            _plane.transform = CGAffineTransformIdentity;
            CGPoint center = CGPointMake(0, originalCenter.y);
            _plane.center = center;
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.55 relativeDuration:0.45 animations:^{
            _plane.alpha = 1;
            _plane.center = originalCenter;
        }];
        
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)repeat1
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
