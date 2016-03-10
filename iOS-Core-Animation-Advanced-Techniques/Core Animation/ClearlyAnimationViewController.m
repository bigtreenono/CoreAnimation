//
//  ClearlyAnimationViewController.m
//  Core Animation
//
//  Created by Jeff on 3/7/16.
//  Copyright © 2016 FNNishipu. All rights reserved.
//

#import "ClearlyAnimationViewController.h"

@interface ClearlyAnimationViewController ()
@property (nonatomic, weak) IBOutlet UIView *layerView;
@property (nonatomic, strong) IBOutlet CALayer *colorLayer;
@property (nonatomic, copy) NSArray *images;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@end

@implementation ClearlyAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     1. 属性动画 : CAPropertyAnimation : CAAnimation(基础和关键帧)
        1.1 基础动画 : CABasicAnimation
     CABasicAnimation继承于CAPropertyAnimation，并添加了如下属性：
     
     id fromValue
     id toValue
     id byValue
     
     1.2 关键帧动画 : CAKeyframeAnimation
    和CABasicAnimation不一样的是，它不限制于设置一个起始和结束的值，而是可以根据一连串随意的值来做动画。
     
     2. 动画组
CABasicAnimation和CAKeyframeAnimation仅仅作用于单独的属性，而CAAnimationGroup可以把这些动画组合在一起。CAAnimationGroup是另一个继承于CAAnimation的子类，它添加了一个animations数组的属性，用来组合别的动画

     3. 过渡
     
     */

    self.images = @[[UIImage imageNamed:@"Character Boy"],
                    [UIImage imageNamed:@"Gem Orange"],
                    [UIImage imageNamed:@"Character Pink Girl"],
                    [UIImage imageNamed:@"Gem Blue"]];

   

}


- (IBAction)switchImage
{
    //preserve the current view snapshot
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *coverImage = UIGraphicsGetImageFromCurrentImageContext();
    //insert snapshot view in front of this one
    UIView *coverView = [[UIImageView alloc] initWithImage:coverImage];
    coverView.frame = self.view.bounds;
    [self.view addSubview:coverView];
    //update the view (we'll simply randomize the layer background color)
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    self.view.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    //perform animation (anything you like)
    [UIView animateWithDuration:1.0 animations:^{
        //scale, rotate and fade the view
        CGAffineTransform transform = CGAffineTransformMakeScale(0.01, 0.01);
        transform = CGAffineTransformRotate(transform, M_PI_2);
        coverView.transform = transform;
        coverView.alpha = 0.0;
    } completion:^(BOOL finished) {
        //remove the cover view now we're finished with it
        [coverView removeFromSuperview];
    }];

//    [UIView transitionWithView:self.imageView duration:1.0
//                       options:UIViewAnimationOptionTransitionFlipFromLeft
//                    animations:^{
//                        //cycle to next image
//                        UIImage *currentImage = self.imageView.image;
//                        NSUInteger index = [self.images indexOfObject:currentImage];
//                        index = (index + 1) % [self.images count];
//                        self.imageView.image = self.images[index];
//                    }
//                    completion:NULL];

    //set up crossfade transition
//    CATransition *transition = [CATransition animation];
//    transition.type = kCATransitionFade;
//    //apply transition to imageview backing layer
//    [self.imageView.layer addAnimation:transition forKey:nil];
//    //cycle to next image
//    UIImage *currentImage = self.imageView.image;
//    NSUInteger index = [self.images indexOfObject:currentImage];
//    index = (index + 1) % [self.images count];
//    self.imageView.image = self.images[index];
}


- (void)group
{
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    [bezierPath moveToPoint:CGPointMake(0, 150)];
    [bezierPath addCurveToPoint:CGPointMake(300, 150) controlPoint1:CGPointMake(75, 0) controlPoint2:CGPointMake(225, 300)];
    //draw the path using a CAShapeLayer
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = bezierPath.CGPath;
    pathLayer.fillColor = [UIColor clearColor].CGColor;
    pathLayer.strokeColor = [UIColor redColor].CGColor;
    pathLayer.lineWidth = 3.0f;
    [self.view.layer addSublayer:pathLayer];
    //add a colored layer
    CALayer *colorLayer = [CALayer layer];
    colorLayer.frame = CGRectMake(0, 0, 64, 64);
    colorLayer.position = CGPointMake(0, 150);
    colorLayer.backgroundColor = [UIColor greenColor].CGColor;
    [self.view.layer addSublayer:colorLayer];
    //create the position animation
    CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animation];
    animation1.keyPath = @"position";
    animation1.path = bezierPath.CGPath;
    animation1.rotationMode = kCAAnimationRotateAuto;
    //create the color animation
    CABasicAnimation *animation2 = [CABasicAnimation animation];
    animation2.keyPath = @"backgroundColor";
    animation2.toValue = (__bridge id)[UIColor redColor].CGColor;
    //create group animation
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[animation1, animation2];
    groupAnimation.duration = 4.0;
    //add the animation to the color layer
    [colorLayer addAnimation:groupAnimation forKey:nil];
}

- (void)test
{
//    self.colorLayer = [CALayer layer];
//    self.colorLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
//    self.colorLayer.backgroundColor = [UIColor blueColor].CGColor;
//    //add it to our view
//    [self.layerView.layer addSublayer:self.colorLayer];

    //create a path
//    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
//    [bezierPath moveToPoint:CGPointMake(0, 150)];
//    [bezierPath addCurveToPoint:CGPointMake(300, 150) controlPoint1:CGPointMake(75, 0) controlPoint2:CGPointMake(225, 300)];
//    //draw the path using a CAShapeLayer
//    CAShapeLayer *pathLayer = [CAShapeLayer layer];
//    pathLayer.path = bezierPath.CGPath;
//    pathLayer.fillColor = [UIColor clearColor].CGColor;
//    pathLayer.strokeColor = [UIColor redColor].CGColor;
//    pathLayer.lineWidth = 3.0f;
//    [self.view.layer addSublayer:pathLayer];
    //add the ship
    CALayer *shipLayer = [CALayer layer];
    shipLayer.frame = CGRectMake(0, 0, 64, 64);
    shipLayer.position = CGPointMake(0, 150);
    shipLayer.contents = (__bridge id)[UIImage imageNamed: @"Key"].CGImage;
    [self.layerView.layer addSublayer:shipLayer];
    //create the keyframe animation
//    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
//    animation.keyPath = @"position";
//    animation.duration = 4.0;
//    animation.path = bezierPath.CGPath;
//    animation.rotationMode = kCAAnimationRotateAuto;
//
//    [shipLayer addAnimation:animation forKey:nil];

    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation";
    animation.duration = 2.0;
    animation.byValue = @(M_PI * 2);
    [shipLayer addAnimation:animation forKey:nil];
}

- (IBAction)changeColor
{
    //create a keyframe animation
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"backgroundColor";
    animation.duration = 2.0;
    animation.values = @[
                         (__bridge id)[UIColor blueColor].CGColor,
                         (__bridge id)[UIColor redColor].CGColor,
                         (__bridge id)[UIColor greenColor].CGColor,
                         (__bridge id)[UIColor blueColor].CGColor ];
    //apply animation to layer
    [self.colorLayer addAnimation:animation forKey:nil];

//    //create a new random color
//    CGFloat red = arc4random() / (CGFloat)INT_MAX;
//    CGFloat green = arc4random() / (CGFloat)INT_MAX;
//    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
//    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
//    //create a basic animation
//    CABasicAnimation *animation = [CABasicAnimation animation];
//    animation.keyPath = @"backgroundColor";
////    animation.toValue = (__bridge id)color.CGColor;
////    animation.fromValue = (__bridge id)self.colorLayer.backgroundColor;
////    self.colorLayer.backgroundColor = color.CGColor;
//
//    CALayer *layer = self.colorLayer.presentationLayer ?: self.colorLayer;
//    animation.fromValue = (__bridge id)layer.backgroundColor;
//    [CATransaction begin];
//    [CATransaction setDisableActions:YES];
//    self.colorLayer.backgroundColor = color.CGColor;
//    [CATransaction commit];
//
//    //apply animation to layer
//    [self.colorLayer addAnimation:animation forKey:nil];
    
    //create a new random color
//    CGFloat red = arc4random() / (CGFloat)INT_MAX;
//    CGFloat green = arc4random() / (CGFloat)INT_MAX;
//    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
//    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
//    //create a basic animation
//    CABasicAnimation *animation = [CABasicAnimation animation];
//    animation.keyPath = @"backgroundColor";
//    animation.toValue = (__bridge id)color.CGColor;
//    
//    animation.delegate = self;
//    //apply animation without snap-back
////    [self applyBasicAnimation:animation toLayer:self.colorLayer];
//    [self.colorLayer addAnimation:animation forKey:nil];
}


- (void)animationDidStop:(CABasicAnimation *)anim finished:(BOOL)flag
{
    //set the backgroundColor property to match animation toValue
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.colorLayer.backgroundColor = (__bridge CGColorRef)anim.toValue;
    [CATransaction commit];
}

- (void)applyBasicAnimation:(CABasicAnimation *)animation toLayer:(CALayer *)layer
{
    //set the from value (using presentation layer if available)
    animation.fromValue = [layer.presentationLayer ?: layer valueForKeyPath:animation.keyPath];
    //update the property in advance
    //note: this approach will only work if toValue != nil
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [layer setValue:animation.toValue forKeyPath:animation.keyPath];
    [CATransaction commit];
    //apply animation to layer
    [layer addAnimation:animation forKey:nil];
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
