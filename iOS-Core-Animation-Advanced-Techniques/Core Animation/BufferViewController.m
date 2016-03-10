//
//  BufferViewController.m
//  Core Animation
//
//  Created by Jeff on 3/9/16.
//  Copyright © 2016 FNNishipu. All rights reserved.
//

#import "BufferViewController.h"

@interface BufferViewController ()

@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, strong) UIImageView *ballView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) CADisplayLink *displayLinkTimer;
@property (nonatomic, assign) CFTimeInterval lastStep;
@property (nonatomic, assign) CFTimeInterval duration;
@property (nonatomic, assign) CFTimeInterval timeOffset;

//@property (nonatomic, assign) NSTimeInterval duration;
//@property (nonatomic, assign) NSTimeInterval timeOffset;
@property (nonatomic, strong) id fromValue;
@property (nonatomic, strong) id toValue;

@end

@implementation BufferViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*
     CADisplayLink
     CADisplayLink是CoreAnimation提供的另一个类似于NSTimer的类，它总是在屏幕完成一次更新之前启动，它的接口设计的和NSTimer很类似，所以它实际上就是一个内置实现的替代，但是和timeInterval以秒为单位不同，CADisplayLink有一个整型的frameInterval属性，指定了间隔多少帧之后才执行。默认值是1，意味着每次屏幕更新之前都会执行一次。但是如果动画的代码执行起来超过了六十分之一秒，你可以指定frameInterval为2，就是说动画每隔一帧执行一次（一秒钟30帧）或者3，也就是一秒钟20次，等等。
     

     */
    //add ball image view
    UIImage *ballImage = [UIImage imageNamed:@"Gem Orange"];
    self.ballView = [[UIImageView alloc] initWithImage:ballImage];
    [self.containerView addSubview:self.ballView];
    //animate
    [self animate];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //replay animation on tap
    [self animate];
}

float interpolate(float from, float to, float time)
{
    return (to - from) * time + from;
}

- (id)interpolateFromValue:(id)fromValue toValue:(id)toValue time:(float)time
{
    if ([fromValue isKindOfClass:[NSValue class]]) {
        //get type
        const char *type = [(NSValue *)fromValue objCType];
        if (strcmp(type, @encode(CGPoint)) == 0) {
            CGPoint from = [fromValue CGPointValue];
            CGPoint to = [toValue CGPointValue];
            CGPoint result = CGPointMake(interpolate(from.x, to.x, time), interpolate(from.y, to.y, time));
            return [NSValue valueWithCGPoint:result];
        }
    }
    //provide safe default implementation
    return (time < 0.5)? fromValue: toValue;
}

float bounceEaseOut(float t)
{
    if (t < 4/11.0) {
        return (121 * t * t)/16.0;
    } else if (t < 8/11.0) {
        return (363/40.0 * t * t) - (99/10.0 * t) + 17/5.0;
    } else if (t < 9/10.0) {
        return (4356/361.0 * t * t) - (35442/1805.0 * t) + 16061/1805.0;
    }
    return (54/5.0 * t * t) - (513/25.0 * t) + 268/25.0;
}

- (void)animate
{
    //reset ball to top of screen
    self.ballView.center = CGPointMake(150, 32);
    //configure the animation
    self.duration = 1.0;
    self.timeOffset = 0.0;
    self.fromValue = [NSValue valueWithCGPoint:CGPointMake(150, 32)];
    self.toValue = [NSValue valueWithCGPoint:CGPointMake(150, 268)];
    //stop the timer if it's already running
//    [self.timer invalidate];
//    //start the timer
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1/60.0
//                                                  target:self
//                                                selector:@selector(step:)
//                                                userInfo:nil
//                                                 repeats:YES];

    [self.displayLinkTimer invalidate];
    //start the timer
    self.lastStep = CACurrentMediaTime();
    self.displayLinkTimer = [CADisplayLink displayLinkWithTarget:self
                                             selector:@selector(step:)];
    [self.displayLinkTimer addToRunLoop:[NSRunLoop mainRunLoop]
                     forMode:NSDefaultRunLoopMode];
}

- (void)step:(NSTimer *)step
{
    //calculate time delta
    CFTimeInterval thisStep = CACurrentMediaTime();
    CFTimeInterval stepDuration = thisStep - self.lastStep;
    self.lastStep = thisStep;
    //update time offset
    self.timeOffset = MIN(self.timeOffset + stepDuration, self.duration);
    //get normalized time offset (in range 0 - 1)
    float time = self.timeOffset / self.duration;
    //apply easing
    time = bounceEaseOut(time);
    //interpolate position
    id position = [self interpolateFromValue:self.fromValue toValue:self.toValue
                                        time:time];
    //move ball view to new position
    self.ballView.center = [position CGPointValue];
    //stop the timer if we've reached the end of the animation
    if (self.timeOffset >= self.duration) {
        [self.displayLinkTimer invalidate];
        self.displayLinkTimer = nil;
    }

//    //update time offset
//    self.timeOffset = MIN(self.timeOffset + 1/60.0, self.duration);
//    //get normalized time offset (in range 0 - 1)
//    float time = self.timeOffset / self.duration;
//    //apply easing
//    time = bounceEaseOut(time);
//    //interpolate position
//    id position = [self interpolateFromValue:self.fromValue
//                                     toValue:self.toValue
//                                        time:time];
//    //move ball view to new position
//    self.ballView.center = [position CGPointValue];
//    //stop the timer if we've reached the end of the animation
//    if (self.timeOffset >= self.duration) {
//        [self.timer invalidate];
//        self.timer = nil;
//    }
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
