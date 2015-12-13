//
//  ViewController.m
//  UIViewAnimations
//
//  Created by FNNishipu on 6/26/15.
//  Copyright (c) 2015 FNNishipu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    // http://www.jianshu.com/p/bd7bf438b288
    
    
    _view2.alpha = 0;
    _view3.alpha = 0;
    
    [UIView animateWithDuration:5 delay:0.5 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionRepeat animations:^{
        CGPoint center = _view1.center;
        center.y += 100;
        _view1.center = center;
    } completion:^(BOOL finished) {
        NSLog(@"1111111111111111111111111111111111111111111111111111111111111111");
    }];
    
    [UIView animateWithDuration:5 delay:0.5 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionRepeat animations:^{
        _view2.alpha = 1;
    } completion:^(BOOL finished) {
        NSLog(@"22222222222222222222222222222222222222222222222222222222222222");
    }];
    
    [UIView animateWithDuration:5 delay:0.5 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionRepeat animations:^{
        _view3.alpha = 1;
        
        CGPoint center = _view3.center;
        center.y -= 100;
        _view3.center = center;

    } completion:^(BOOL finished) {
        NSLog(@"3333333333333333333333333333333333333333333333333333333333333333333333333333333333");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
