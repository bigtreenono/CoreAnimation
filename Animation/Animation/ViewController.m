//
//  ViewController.m
//  Animation
//
//  Created by FNNishipu on 6/28/15.
//  Copyright (c) 2015 FNNishipu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    CALayer *_layer;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //设置背景(注意这个图片其实在根图层)
    UIImage *backgroundImage=[UIImage imageNamed:@"push"];
    self.view.backgroundColor=[UIColor colorWithPatternImage:backgroundImage];
    
    //自定义一个图层
    _layer = [[CALayer alloc] init];
    _layer.bounds = CGRectMake(0, 0, 100, 200);
    _layer.position = CGPointMake(50, 150);
    _layer.anchorPoint = CGPointMake(0.5, 0.6);//设置锚点
    _layer.contents = (id)[UIImage imageNamed:@"Rock"].CGImage;
    [self.view.layer addSublayer:_layer];

    
    //创建动画
//    [self translationAnimation];
    
    //创建动画
    [self groupAnimation];

    /*
    UIImage *image=[UIImage imageNamed:@"Gem Blue.png"];
    UIImageView *imageView=[[UIImageView alloc]init];
    imageView.image=image;
    imageView.frame=CGRectMake(120, 140, 80, 80);
    [self.view addSubview:imageView];
    
    //两秒后开始一个持续一分钟的动画
    [UIView animateWithDuration:1 delay:2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        imageView.frame=CGRectMake(80, 100, 160, 160);
    } completion:nil];
     */
}

#pragma mark 创建动画组
- (void)groupAnimation
{
    //1.创建动画组
    CAAnimationGroup *animationGroup=[CAAnimationGroup animation];
    
    //2.设置组中的动画和其他属性
    CABasicAnimation *basicAnimation=[self rotationAnimation];
    CAKeyframeAnimation *keyframeAnimation=[self translationAnimation];
    animationGroup.animations=@[basicAnimation,keyframeAnimation];
    
    animationGroup.delegate=self;
    animationGroup.duration=10.0; // 设置动画时间，如果动画组中动画已经设置过动画属性则不再生效
//    animationGroup.beginTime=CACurrentMediaTime()+5;//延迟五秒执行
    
    //3.给图层添加动画
    [_layer addAnimation:animationGroup forKey:nil];
}

#pragma mark 基础旋转动画
- (CABasicAnimation *)rotationAnimation
{
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    CGFloat toValue=M_PI_2*3;
    basicAnimation.toValue = [NSNumber numberWithFloat:M_PI_2*3];
    
    //    basicAnimation.duration=6.0;
    basicAnimation.autoreverses=true;
    basicAnimation.repeatCount=HUGE_VALF;
    basicAnimation.removedOnCompletion=NO;
    
    [basicAnimation setValue:[NSNumber numberWithFloat:toValue] forKey:@"KCBasicAnimationProperty_ToValue"];
    
    return basicAnimation;
}

#pragma mark 关键帧移动动画
- (CAKeyframeAnimation *)translationAnimation
{
    CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    CGPoint endPoint = CGPointMake(55, 400);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, _layer.position.x, _layer.position.y);
    CGPathAddCurveToPoint(path, NULL, 160, 280, -30, 300, endPoint.x, endPoint.y);
    
    keyframeAnimation.path=path;
    CGPathRelease(path);
    
    [keyframeAnimation setValue:[NSValue valueWithCGPoint:endPoint] forKey:@"KCKeyframeAnimationProperty_EndPosition"];
    
    return keyframeAnimation;
}

#pragma mark 移动动画
- (void)translatonAnimation:(CGPoint)location
{
    //1.创建动画并指定动画属性
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    
    //2.设置动画属性初始值和结束值
    //    basicAnimation.fromValue=[NSNumber numberWithInteger:50];//可以不设置，默认为图层初始状态
    basicAnimation.toValue = [NSValue valueWithCGPoint:location];
    
    //设置其他动画属性
    basicAnimation.duration = 5.0;//动画时间5秒
//    basicAnimation.repeatCount = HUGE_VALF; // 设置重复次数,HUGE_VALF可看做无穷大，起到循环动画的效果
    basicAnimation.removedOnCompletion = NO; // 运行一次是否移除动画
    
    basicAnimation.delegate = self;
    // 存储当前位置在动画结束后使用
    [basicAnimation setValue:[NSValue valueWithCGPoint:location] forKey:@"KCBasicAnimationLocation"];
    
    //3.添加动画到图层，注意key相当于给动画进行命名，以后获得该动画时可以使用此名称获取
    [_layer addAnimation:basicAnimation forKey:@"KCBasicAnimation_Translation"];
}

#pragma mark 旋转动画
//- (void)rotationAnimation
//{
//    //1.创建动画并指定动画属性
//    CABasicAnimation *basicAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    
//    //2.设置动画属性初始值、结束值
//    //    basicAnimation.fromValue=[NSNumber numberWithInt:M_PI_2];
//    basicAnimation.toValue=[NSNumber numberWithFloat:M_PI_2*3];
//    
//    //设置其他动画属性
//    basicAnimation.duration=6.0;
//    basicAnimation.autoreverses=true;//旋转后再旋转到原来的位置
//    basicAnimation.repeatCount = HUGE_VALF;//设置无限循环
//    basicAnimation.removedOnCompletion=NO;
//    
//    //4.添加动画到图层，注意key相当于给动画进行命名，以后获得该动画时可以使用此名称获取
//    [_layer addAnimation:basicAnimation forKey:@"KCBasicAnimation_Rotation"];
//}
//
//#pragma mark 关键帧动画
//- (void)translationAnimation
//{
//    //1.创建关键帧动画并设置动画属性
//    CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//    
////    //2.设置关键帧,这里有四个关键帧
////    NSValue *key1 = [NSValue valueWithCGPoint:_layer.position];//对于关键帧动画初始值不能省略
////    NSValue *key2 = [NSValue valueWithCGPoint:CGPointMake(80, 220)];
////    NSValue *key3 = [NSValue valueWithCGPoint:CGPointMake(45, 300)];
////    NSValue *key4 = [NSValue valueWithCGPoint:CGPointMake(55, 400)];
////    NSArray *values = @[key1,key2,key3,key4];
////    keyframeAnimation.values = values;
//
//    //2.设置路径
//    //绘制贝塞尔曲线
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathMoveToPoint(path, NULL, _layer.position.x, _layer.position.y);//移动到起始点
//    CGPathAddCurveToPoint(path, NULL, 160, 280, -30, 300, 55, 400);//绘制二次贝塞尔曲线
//    
//    keyframeAnimation.path=path;//设置path属性
//    CGPathRelease(path);//释放路径对象
//
//    
//    //设置其他属性
//    keyframeAnimation.duration = 8.0;
//    keyframeAnimation.beginTime = CACurrentMediaTime()+2;//设置延迟2秒执行
//    
//    
//    //3.添加动画到图层，添加动画后就会执行动画
//    [_layer addAnimation:keyframeAnimation forKey:@"KCKeyframeAnimation_Position"];
//}

#pragma mark - 动画代理方法
#pragma mark 动画开始
- (void)animationDidStart:(CAAnimation *)anim
{
    NSLog(@"animation(%@) start.\r_layer.frame=%@",anim,NSStringFromCGRect(_layer.frame));
    NSLog(@"%@",[_layer animationForKey:@"KCBasicAnimation_Translation"]);//通过前面的设置的key获得动画
}

#pragma mark 动画结束
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    CAAnimationGroup *animationGroup=(CAAnimationGroup *)anim;
    CABasicAnimation *basicAnimation=animationGroup.animations[0];
    CAKeyframeAnimation *keyframeAnimation=animationGroup.animations[1];
    CGFloat toValue=[[basicAnimation valueForKey:@"KCBasicAnimationProperty_ToValue"] floatValue];
    CGPoint endPoint=[[keyframeAnimation valueForKey:@"KCKeyframeAnimationProperty_EndPosition"] CGPointValue];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    //设置动画最终状态
    _layer.position=endPoint;
    _layer.transform=CATransform3DMakeRotation(toValue, 0, 0, 1);
    
    [CATransaction commit];

//    NSLog(@"animation(%@) stop.\r_layer.frame=%@",anim,NSStringFromCGRect(_layer.frame));
//    // 开启事务
//    [CATransaction begin];
//    // 禁用隐式动画
//    [CATransaction setDisableActions:YES];
//    
//    _layer.position=[[anim valueForKey:@"KCBasicAnimationLocation"] CGPointValue];
//    
//    // 提交事务
//    [CATransaction commit];
//    
//    // 暂停动画
//    [self animationPause];
}

#pragma mark 点击事件
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    CGPoint location = [touch locationInView:self.view];
    //判断是否已经常见过动画，如果已经创建则不再创建动画
    CAAnimation *animation = [_layer animationForKey:@"KCBasicAnimation_Translation"];
    if(animation)
    {
        if (_layer.speed == 0)
        {
            [self animationResume];
        }
        else
        {
            [self animationPause];
        }
    }
    else
    {
        //创建并开始动画
        [self translatonAnimation:location];
        
        [self rotationAnimation];
    }
}

#pragma mark 动画暂停
-(void)animationPause
{
    // 取得指定图层动画的媒体时间，后面参数用于指定子图层，这里不需要
    CFTimeInterval interval = [_layer convertTime:CACurrentMediaTime() fromLayer:nil];
    NSLog(@"current1 = %f, interval1 = %f", CACurrentMediaTime(), interval);
    // 设置时间偏移量，保证暂停时停留在旋转的位置
    [_layer setTimeOffset:interval];
    // 速度设置为0，暂停动画
    _layer.speed = 0;
}

#pragma mark 动画恢复
- (void)animationResume
{
    //获得暂停的时间
    CFTimeInterval beginTime = CACurrentMediaTime() - _layer.timeOffset;
    
    NSLog(@"current2 = %f, timeOffset = %f", CACurrentMediaTime(), _layer.timeOffset);

    //设置偏移量
    _layer.timeOffset=0;
    //设置开始时间
    _layer.beginTime=beginTime;
    //设置动画速度，开始运动
    _layer.speed=1.0;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
