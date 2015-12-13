//
//  SecondViewController.m
//  UIViewAnimations
//
//  Created by FNNishipu on 6/26/15.
//  Copyright (c) 2015 FNNishipu. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@property (nonatomic, strong) UIImageView *status;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NSArray *messages;
@property (nonatomic, assign) CGPoint statusPosition;


//let status = UIImageView(image: UIImage(named: "banner"))
//let label = UILabel()
//let messages = ["Connecting ...", "Authorizing ...", "Sending credentials ...", "Failed"]
//var statusPosition = CGPoint.zeroPoint

@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _status = [[UIImageView alloc] initWithFrame:CGRectMake(50, 100, 233, 49)];
    _status.image = [UIImage imageNamed:@"banner"];
    _status.hidden = YES;
    [self.view addSubview:_status];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _status.bounds.size.width, _status.bounds.size.height)];
    _label.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    _label.textColor = [UIColor colorWithRed:0.89 green:0.38 blue:0 alpha:1];
    _label.textAlignment = NSTextAlignmentCenter;
    [_status addSubview:_label];
    
    _statusPosition = _status.center;

    _messages = @[@"Connecting ...", @"Authorizing ...", @"Sending credentials ...", @"Failed"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showMessage:0];
    });
}

- (void)showMessage:(int)index
{
    _label.text = _messages[index];
    
    [UIView transitionWithView:_status duration:0.33 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionTransitionCurlDown animations:^{
        _status.hidden = NO;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (index < _messages.count - 1)
            {
                [self removeMessage:index];
            }            
        });
    }];
}

- (void)removeMessage:(int)index
{
    [UIView animateWithDuration:0.33 animations:^{
        CGPoint center = _status.center;
        center.x += self.view.frame.size.width;
        _status.center = center;
    } completion:^(BOOL finished) {
        _status.hidden = YES;
        _status.center = _statusPosition;
        [self showMessage:index + 1];
    }];
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
