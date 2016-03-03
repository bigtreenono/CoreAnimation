//
//  ViewController.m
//  CALayer
//
//  Created by FNNishipu on 6/28/15.
//  Copyright (c) 2015 FNNishipu. All rights reserved.
//

#import "ViewController.h"
#import "KCView.h"

#define WIDTH 50
#define PHOTO_HEIGHT 150

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self drawMyLayer];
//    [self layer2];
//    [self layer3];
    
    KCView *view=[[KCView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor=[UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1];
    
    
    [self.view addSubview:view];
}

- (void)layer3
{
    CGPoint position= CGPointMake(160, 200);
    CGRect bounds=CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT);
    CGFloat cornerRadius=PHOTO_HEIGHT/2;
    CGFloat borderWidth=2;
    
    //阴影图层
    CALayer *layerShadow=[[CALayer alloc]init];
    layerShadow.bounds=bounds;
    layerShadow.position=position;
    layerShadow.cornerRadius=cornerRadius;
    layerShadow.shadowColor=[UIColor grayColor].CGColor;
    layerShadow.shadowOffset=CGSizeMake(2, 1);
    layerShadow.shadowOpacity=1;
    layerShadow.borderColor=[UIColor whiteColor].CGColor;
    layerShadow.borderWidth=borderWidth;
    [self.view.layer addSublayer:layerShadow];
    
    //容器图层
    CALayer *layer=[[CALayer alloc]init];
    layer.bounds=bounds;
    layer.position=position;
    layer.backgroundColor=[UIColor redColor].CGColor;
    layer.cornerRadius=cornerRadius;
    layer.masksToBounds=YES;
    layer.borderColor=[UIColor whiteColor].CGColor;
    layer.borderWidth=borderWidth;
    
    //设置图层代理
//    layer.delegate=self;
    
    //设置内容（注意这里一定要转换为CGImage）
    UIImage *image=[UIImage imageNamed:@"photo"];
    layer.contents=(id)image.CGImage;

    
    /* 
     用这个属性则不必在代理方法中对图层的图形上下文进行反转利用图层形变解决图像倒立问题
     */
//    layer.transform = CATransform3DMakeRotation(M_PI, 1, 0, 0);
    [layer setValue:@M_PI forKeyPath:@"transform.rotation.x"];

    
    //添加图层到根图层
    [self.view.layer addSublayer:layer];
    
    //调用图层setNeedDisplay,否则代理方法不会被调用
//    [layer setNeedsDisplay];
}

- (void)layer2
{
    //自定义图层
    CALayer *layer=[[CALayer alloc]init];
    layer.bounds=CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT);
    layer.position=CGPointMake(160, 200);
    layer.backgroundColor=[UIColor redColor].CGColor;
    layer.cornerRadius=PHOTO_HEIGHT/2;
    //注意仅仅设置圆角，对于图形而言可以正常显示，但是对于图层中绘制的图片无法正确显示
    //如果想要正确显示则必须设置masksToBounds=YES，剪切子图层
    /*
     需要注意的是上面代码中绘制图片圆形裁切效果时如果不设置masksToBounds是无法显示圆形，但是对于其他图形却没有这个限制。原因就是当绘制一张图片到图层上的时候会重新创建一个图层添加到当前图层，这样一来如果设置了圆角之后虽然底图层有圆角效果，但是子图层还是矩形，只有设置了masksToBounds为YES让子图层按底图层剪切才能显示圆角效果。同样的，有些朋友经常在网上提问说为什么使用UIImageView的layer设置圆角后图片无法显示圆角，只有设置masksToBounds才能出现效果，也是类似的问题。
     */
    layer.masksToBounds=YES;
    //阴影效果无法和masksToBounds同时使用，因为masksToBounds的目的就是剪切外边框，
    //而阴影效果刚好在外边框
    //    layer.shadowColor=[UIColor grayColor].CGColor;
    //    layer.shadowOffset=CGSizeMake(2, 2);
    //    layer.shadowOpacity=1;
    //设置边框
    layer.borderColor=[UIColor whiteColor].CGColor;
    layer.borderWidth=2;
    
    //设置图层代理
    layer.delegate=self;
    
    //添加图层到根图层
    [self.view.layer addSublayer:layer];
    
    //调用图层setNeedDisplay,否则代理方法不会被调用
    [layer setNeedsDisplay];
}

#pragma mark 绘制图形、图像到图层，注意参数中的ctx是图层的图形上下文，其中绘图位置也是相对图层而言的
-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    //    NSLog(@"%@",layer);//这个图层正是上面定义的图层
    CGContextSaveGState(ctx);
    
    //图形上下文形变，解决图片倒立的问题
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -PHOTO_HEIGHT);
    
    UIImage *image=[UIImage imageNamed:@"photo.png"];
    //注意这个位置是相对于图层而言的不是屏幕
    CGContextDrawImage(ctx, CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT), image.CGImage);
    
    //    CGContextFillRect(ctx, CGRectMake(0, 0, 100, 100));
    //    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    CGContextRestoreGState(ctx);
}


#pragma mark 绘制图层
- (void)drawMyLayer
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    //获得根图层
    CALayer *layer=[[CALayer alloc]init];
    //设置背景颜色,由于QuartzCore是跨平台框架，无法直接使用UIColor
    layer.backgroundColor=[UIColor colorWithRed:0 green:146/255.0 blue:1.0 alpha:1.0].CGColor;
    //设置中心点
    layer.position=CGPointMake(size.width/2, size.height/2);
    //设置大小
    layer.bounds=CGRectMake(0, 0, WIDTH,WIDTH);
    //设置圆角,当圆角半径等于矩形的一半时看起来就是一个圆形
    layer.cornerRadius=WIDTH/2;
    //设置阴影
    layer.shadowColor=[UIColor grayColor].CGColor;
    layer.shadowOffset=CGSizeMake(2, 2);
    layer.shadowOpacity=.9;
    //设置边框
    //    layer.borderColor=[UIColor whiteColor].CGColor;
    //    layer.borderWidth=1;
    
    //设置锚点
    //    layer.anchorPoint=CGPointZero;

    [self.view.layer addSublayer:layer];
}

#pragma mark 点击放大
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch=[touches anyObject];
//    CALayer *layer=self.view.layer.sublayers[2];
//    
//    CGFloat width=layer.bounds.size.width;
//    if (width==WIDTH) {
//        width=WIDTH*4;
//    }else{
//        width=WIDTH;
//    }
//    layer.bounds=CGRectMake(0, 0, width, width);
//    layer.position=[touch locationInView:self.view];
//    layer.cornerRadius=width/2;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
