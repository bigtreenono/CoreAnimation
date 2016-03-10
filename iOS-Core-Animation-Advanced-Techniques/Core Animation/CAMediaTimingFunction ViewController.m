//
//  CAMediaTimingFunction ViewController.m
//  Core Animation
//
//  Created by Jeff on 3/8/16.
//  Copyright © 2016 FNNishipu. All rights reserved.
//

#import "CAMediaTimingFunction ViewController.h"

@interface CAMediaTimingFunction_ViewController ()
@property (nonatomic, strong) CALayer *colorLayer;
@property (nonatomic, strong) UIView *colorView;
@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, strong) UIImageView *ballView;

@end

@implementation CAMediaTimingFunction_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     kCAMediaTimingFunctionEaseIn常量创建了一个慢慢加速然后突然停止的方法。对于之前提到的自由落体的例子来说很适合，或者比如对准一个目标的导弹的发射。
     
     kCAMediaTimingFunctionEaseOut则恰恰相反，它以一个全速开始，然后慢慢减速停止。它有一个削弱的效果，应用的场景比如一扇门慢慢地关上，而不是砰地一声。
     
     kCAMediaTimingFunctionEaseInEaseOut创建了一个慢慢加速然后再慢慢减速的过程。这是现实世界大多数物体移动的方式，也是大多数动画来说最好的选择。如果只可以用一种缓冲函数的话，那就必须是它了。那么你会疑惑为什么这不是默认的选择，实际上当使用UIView的动画方法时，他的确是默认的，但当创建CAAnimation的时候，就需要手动设置它了。
     
     */

    //add ball image view
    UIImage *ballImage = [UIImage imageNamed:@"Heart"];
    self.ballView = [[UIImageView alloc] initWithImage:ballImage];
    [self.containerView addSubview:self.ballView];
    //animate
    [self animate];

    //create timing function
//    CAMediaTimingFunction *function = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
//    //get control points
//    CGPoint controlPoint1, controlPoint2;
//    [function getControlPointAtIndex:1 values:(float *)&controlPoint1];
//    [function getControlPointAtIndex:2 values:(float *)&controlPoint2];
//    //create curve
//    UIBezierPath *path = [[UIBezierPath alloc] init];
//    [path moveToPoint:CGPointZero];
//    [path addCurveToPoint:CGPointMake(1, 1)
//            controlPoint1:controlPoint1 controlPoint2:controlPoint2];
//    //scale the path up to a reasonable size for display
//    [path applyTransform:CGAffineTransformMakeScale(200, 200)];
//    //create shape layer
//    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//    shapeLayer.strokeColor = [UIColor redColor].CGColor;
//    shapeLayer.fillColor = [UIColor clearColor].CGColor;
//    shapeLayer.lineWidth = 4.0f;
//    shapeLayer.path = path.CGPath;
//    [self.view.layer addSublayer:shapeLayer];
//    //flip geometry so that 0,0 is in the bottom-left
//    self.view.layer.geometryFlipped = YES;

//    self.colorLayer = [CALayer layer];
//    self.colorLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
//    self.colorLayer.backgroundColor = [UIColor blueColor].CGColor;
//    //add it to our view
//    [self.view.layer addSublayer:self.colorLayer];

//    self.colorView = [[UIView alloc] init];
//    self.colorView.bounds = CGRectMake(0, 0, 100, 100);
//    self.colorView.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
//    self.colorView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:self.colorView];

}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //replay animation on tap
    [self animate];
}

- (void)animate
{
    //reset ball to top of screen
    self.ballView.center = CGPointMake(150, 32);
    //create keyframe animation
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 1.0;
    animation.delegate = self;
    animation.values = @[
                         [NSValue valueWithCGPoint:CGPointMake(150, 32)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 268)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 140)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 268)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 220)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 268)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 250)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 268)]
                         ];
    
    animation.timingFunctions = @[
                                  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn],
                                  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut],
                                  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn],
                                  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut],
                                  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn],
                                  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut],
                                  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn]
                                  ];
    
    animation.keyTimes = @[@0.0, @0.3, @0.5, @0.7, @0.8, @0.9, @0.95, @1.0];
    //apply animation
    self.ballView.layer.position = CGPointMake(150, 268);
    [self.ballView.layer addAnimation:animation forKey:nil];
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
////    //configure the transaction
////    [CATransaction begin];
////    [CATransaction setAnimationDuration:1.0];
////    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
////    //set the position
////    self.colorLayer.position = [[touches anyObject] locationInView:self.view];
////    //commit transaction
////    [CATransaction commit];
//
//    //perform the animation
//    [UIView animateWithDuration:1.0 delay:0.0
//                        options:0
//                     animations:^{
//                         //set the position
//                         self.colorView.center = [[touches anyObject] locationInView:self.view];
//                     }
//                     completion:NULL];
//
//}


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
