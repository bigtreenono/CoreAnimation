//
//  ImplicitAnimationViewController.m
//  Core Animation
//
//  Created by Jeff on 3/7/16.
//  Copyright © 2016 FNNishipu. All rights reserved.
//

#import "ImplicitAnimationViewController.h"

@interface ImplicitAnimationViewController ()

@property (nonatomic, weak) IBOutlet UIView *layerView;
@property (nonatomic, strong) IBOutlet CALayer *colorLayer;

@end

@implementation ImplicitAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /*
     我们把改变属性时CALayer自动应用的动画称作行为，当CALayer的属性被修改时候，它会调用-actionForKey:方法，传递属性的名称。剩下的操作都在CALayer的头文件中有详细的说明，实质上是如下几步：
     
     图层首先检测它是否有委托，并且是否实现CALayerDelegate协议指定的-actionForLayer:forKey方法。如果有，直接调用并返回结果。
     如果没有委托，或者委托没有实现-actionForLayer:forKey方法，图层接着检查包含属性名称对应行为映射的actions字典。
     如果actions字典没有包含对应的属性，那么图层接着在它的style字典接着搜索属性名。
     最后，如果在style里面也找不到对应的行为，那么图层将会直接调用定义了每个属性的标准行为的-defaultActionForKey:方法。
     所以一轮完整的搜索结束之后，-actionForKey:要么返回空（这种情况下将不会有动画发生），要么是CAAction协议对应的对象，最后CALayer拿这个结果去对先前和当前的值做动画。
     
     于是这就解释了UIKit是如何禁用隐式动画的：每个UIView对它关联的图层都扮演了一个委托，并且提供了-actionForLayer:forKey的实现方法。当不在一个动画块的实现中，UIView对所有图层行为返回nil，但是在动画block范围之内，它就返回了一个非空值。我们可以用一个demo做个简单的实验（清单7.5）
     
     总结一下，我们知道了如下几点
     
     UIView关联的图层禁用了隐式动画，对这种图层做动画的唯一办法就是使用UIView的动画函数（而不是依赖CATransaction），或者继承UIView，并覆盖-actionForLayer:forKey:方法，或者直接创建一个显式动画（具体细节见第八章）。
     对于单独存在的图层，我们可以通过实现图层的-actionForLayer:forKey:委托方法，或者提供一个actions字典来控制隐式动画。

     // 呈现与模型
     每个图层属性的显示值都被存储在一个叫做呈现图层的独立图层当中，他可以通过-presentationLayer方法来访问。这个呈现图层实际上是模型图层的复制，但是它的属性值代表了在任何指定时刻当前外观效果。换句话说，你可以通过呈现图层的值来获取当前屏幕上真正显示出来的值（图7.4）。
     
     我们在第一章中提到除了图层树，另外还有呈现树。呈现树通过图层树中所有图层的呈现图层所形成。注意呈现图层仅仅当图层首次被提交（就是首次第一次在屏幕上显示）的时候创建，所以在那之前调用-presentationLayer将会返回nil。
     
     你可能注意到有一个叫做–modelLayer的方法。在呈现图层上调用–modelLayer将会返回它正在呈现所依赖的CALayer。通常在一个图层上调用-modelLayer会返回–self（实际上我们已经创建的原始图层就是一种数据模型）。
     

     */
    
    /*
    //test layer action when outside of animation block
    NSLog(@"Outside: %@", [self.layerView actionForLayer:self.layerView.layer forKey:@"backgroundColor"]);
    //begin animation block
    [UIView beginAnimations:nil context:nil];
    //test layer action when inside of animation block
    NSLog(@"Inside: %@", [self.layerView actionForLayer:self.layerView.layer forKey:@"backgroundColor"]);
    //end animation block
    [UIView commitAnimations];
     */
    
    //create sublayer
//    self.colorLayer = [CALayer layer];
//    self.colorLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
//    self.colorLayer.backgroundColor = [UIColor blueColor].CGColor;
//    
//    //add a custom action
//    CATransition *transition = [CATransition animation];
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromLeft;
//    self.colorLayer.actions = @{@"backgroundColor": transition};
//
//    //add it to our view
//    [self.layerView.layer addSublayer:self.colorLayer];

    self.colorLayer = [CALayer layer];
    self.colorLayer.frame = CGRectMake(0, 0, 100, 100);
    self.colorLayer.position = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
    self.colorLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:self.colorLayer];

}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //get the touch point
    CGPoint point = [[touches anyObject] locationInView:self.view];
    //check if we've tapped the moving layer
    if ([self.colorLayer.presentationLayer hitTest:point]) {
        //randomize the layer background color
        CGFloat red = arc4random() / (CGFloat)INT_MAX;
        CGFloat green = arc4random() / (CGFloat)INT_MAX;
        CGFloat blue = arc4random() / (CGFloat)INT_MAX;
        self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    } else {
        //otherwise (slowly) move the layer to new position
        [CATransaction begin];
        [CATransaction setAnimationDuration:4.0];
        self.colorLayer.position = point;
        [CATransaction commit];
    }
}

- (IBAction)changeColor
{
    //randomize the layer background color
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;

    /*
    [CATransaction begin];
    //set the animation duration to 1 second
    [CATransaction setAnimationDuration:1.0];
    
    [CATransaction setCompletionBlock:^{
        //rotate the layer 90 degrees
        CGAffineTransform transform = self.colorLayer.affineTransform;
        transform = CGAffineTransformRotate(transform, M_PI_2);
        self.colorLayer.affineTransform = transform;
    }];

    //randomize the layer background color
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    [CATransaction commit];
     */
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
