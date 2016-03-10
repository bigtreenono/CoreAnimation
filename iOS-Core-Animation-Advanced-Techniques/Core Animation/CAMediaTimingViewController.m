//
//  CAMediaTimingViewController.m
//  Core Animation
//
//  Created by Jeff on 3/8/16.
//  Copyright © 2016 FNNishipu. All rights reserved.
//

#import "CAMediaTimingViewController.h"

@interface CAMediaTimingViewController ()
@property (nonatomic, strong) CALayer *doorLayer;

@end

@implementation CAMediaTimingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     创建重复动画的另一种方式是使用repeatDuration属性，它让动画重复一个指定的时间，而不是指定次数。你甚至设置一个叫做autoreverses的属性（BOOL类型）在每次间隔交替循环过程中自动回放。这对于播放一段连续非循环的动画很有用，例如打开一扇门，然后关上它（图9.2）。
     
     beginTime指定了动画开始之前的的延迟时间。这里的延迟从动画添加到可见图层的那一刻开始测量，默认是0（就是说动画会立刻执行）。
     
     speed是一个时间的倍数，默认1.0，减少它会减慢图层/动画的时间，增加它会加快速度。如果2.0的速度，那么对于一个duration为1的动画，实际上在0.5秒的时候就已经完成了。
     
     timeOffset和beginTime类似，但是和增加beginTime导致的延迟动画不同，增加timeOffset只是让动画快进到某一点，例如，对于一个持续1秒的动画来说，设置timeOffset为0.5意味着动画将从一半的地方开始。
     
     和beginTime不同的是，timeOffset并不受speed的影响。所以如果你把speed设为2.0，把timeOffset设置为0.5，那么你的动画将从动画最后结束的地方开始，因为1秒的动画实际上被缩短到了0.5秒。然而即使使用了timeOffset让动画从结束的地方开始，它仍然播放了一个完整的时长，这个动画仅仅是循环了一圈，然后从头开始播放。
     

     */
    //add the door
    CALayer *doorLayer = [CALayer layer];
    doorLayer.frame = CGRectMake(0, 0, 128, 256);
    doorLayer.position = CGPointMake(150 - 64, 150);
    doorLayer.anchorPoint = CGPointMake(0, 0.5);
    doorLayer.contents = (__bridge id)[UIImage imageNamed: @"Rock"].CGImage;
    [self.view.layer addSublayer:doorLayer];
    self.doorLayer = doorLayer;
    //apply perspective transform
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0 / 500.0;
    self.view.layer.sublayerTransform = perspective;
    
    //add pan gesture recognizer to handle swipes
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] init];
    [pan addTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
    //pause all layer animations
    self.doorLayer.speed = 0.0;

    //apply swinging animation
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation.y";
    animation.toValue = @(-M_PI_2);
    animation.duration = 1.0;
//    animation.repeatDuration = INFINITY;
//    animation.autoreverses = YES;
    [doorLayer addAnimation:animation forKey:nil];

}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    //get horizontal component of pan gesture
    CGFloat x = [pan translationInView:self.view].x;
    //convert from points to animation duration //using a reasonable scale factor
    x /= 200.0f;
    //update timeOffset and clamp result
    CFTimeInterval timeOffset = self.doorLayer.timeOffset;
    timeOffset = MIN(0.999, MAX(0.0, timeOffset - x));
    self.doorLayer.timeOffset = timeOffset;
    //reset pan gesture
    [pan setTranslation:CGPointZero inView:self.view];
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
