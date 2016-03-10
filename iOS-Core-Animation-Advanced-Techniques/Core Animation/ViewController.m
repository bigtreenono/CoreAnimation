//
//  ViewController.m
//  Core Animation
//
//  Created by Jeff on 1/24/16.
//  Copyright © 2016 FNNishipu. All rights reserved.
//

#import "ViewController.h"
#import <CoreText/CoreText.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *layerView;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIImageView *hourHand;
@property (weak, nonatomic) IBOutlet UIImageView *minuteHand;
@property (weak, nonatomic) IBOutlet UIImageView *secondHand;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, strong) CALayer *blueLayer;
@property (nonatomic, weak) IBOutlet UIView *layerView1;
@property (nonatomic, weak) IBOutlet UIView *layerView2;
@property (nonatomic, weak) IBOutlet UIView *shadowView;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // https://github.com/AttackOnDobby/iOS-Core-Animation-Advanced-Techniques
}

- (void)chapter6_AVPlayerLayer // 专有图层
{
    /*
     最后一个图层类型是AVPlayerLayer。尽管它不是Core Animation框架的一部分（AV前缀看上去像），AVPlayerLayer是有别的框架（AVFoundation）提供的，它和Core Animation紧密地结合在一起，提供了一个CALayer子类来显示自定义的内容类型。
     
     AVPlayerLayer是用来在iOS上播放视频的。他是高级接口例如MPMoivePlayer的底层实现，提供了显示视频的底层控制。AVPlayerLayer的使用相当简单：你可以用+playerLayerWithPlayer:方法创建一个已经绑定了视频播放器的图层，或者你可以先创建一个图层，然后用player属性绑定一个AVPlayer实例。
     */
    //get video URL
    NSURL *URL = [[NSBundle mainBundle] URLForResource:@"Ship" withExtension:@"mp4"];
    
    //create player and player layer
    AVPlayer *player = [AVPlayer playerWithURL:URL];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    
    //set player layer frame and attach it to our view
    playerLayer.frame = self.layerView.bounds;
    [self.layerView.layer addSublayer:playerLayer];
    
    //play the video
    [player play];
}

- (void)chapter6_CAEAGLLayer // 专有图层
{
    /*
     当iOS要处理高性能图形绘制，必要时就是OpenGL。应该说它应该是最后的杀手锏，至少对于非游戏的应用来说是的。因为相比Core Animation和UIkit框架，它不可思议地复杂。
     
     OpenGL提供了Core Animation的基础，它是底层的C接口，直接和iPhone，iPad的硬件通信，极少地抽象出来的方法。OpenGL没有对象或是图层的继承概念。它只是简单地处理三角形。OpenGL中所有东西都是3D空间中有颜色和纹理的三角形。用起来非常复杂和强大，但是用OpenGL绘制iOS用户界面就需要很多很多的工作了。
     
     为了能够以高性能使用Core Animation，你需要判断你需要绘制哪种内容（矢量图形，例子，文本，等等），但后选择合适的图层去呈现这些内容，Core Animation中只有一些类型的内容是被高度优化的；所以如果你想绘制的东西并不能找到标准的图层类，想要得到高性能就比较费事情了。
     
     因为OpenGL根本不会对你的内容进行假设，它能够绘制得相当快。利用OpenGL，你可以绘制任何你知道必要的集合信息和形状逻辑的内容。所以很多游戏都喜欢用OpenGL（这些情况下，Core Animation的限制就明显了：它优化过的内容类型并不一定能满足需求），但是这样依赖，方便的高度抽象接口就没了。
     
     在iOS 5中，苹果引入了一个新的框架叫做GLKit，它去掉了一些设置OpenGL的复杂性，提供了一个叫做CLKView的UIView的子类，帮你处理大部分的设置和绘制工作。前提是各种各样的OpenGL绘图缓冲的底层可配置项仍然需要你用CAEAGLLayer完成，它是CALayer的一个子类，用来显示任意的OpenGL图形。
     
     大部分情况下你都不需要手动设置CAEAGLLayer（假设用GLKView），过去的日子就不要再提了。特别的，我们将设置一个OpenGL ES 2.0的上下文，它是现代的iOS设备的标准做法。
     
     尽管不需要GLKit也可以做到这一切，但是GLKit囊括了很多额外的工作，比如设置顶点和片段着色器，这些都以类C语言叫做GLSL自包含在程序中，同时在运行时载入到图形硬件中。编写GLSL代码和设置EAGLayer没有什么关系，所以我们将用GLKBaseEffect类将着色逻辑抽象出来。其他的事情，我们还是会有以往的方式。
     
     在开始之前，你需要将GLKit和OpenGLES框架加入到你的项目中，然后就可以实现清单6.14中的代码，里面是设置一个GAEAGLLayer的最少工作，它使用了OpenGL ES 2.0 的绘图上下文，并渲染了一个有色三角（见图6.15）.
     */
}

- (void)chapter6_CAEmitterLayer // 专有图层
{
    /*
     CAEMitterCell的属性基本上可以分为三种：
     
     这种粒子的某一属性的初始值。比如，color属性指定了一个可以混合图片内容颜色的混合色。在示例中，我们将它设置为桔色。
     粒子某一属性的变化范围。比如emissionRange属性的值是2π，这意味着粒子可以从360度任意位置反射出来。如果指定一个小一些的值，就可以创造出一个圆锥形。
     指定值在时间线上的变化。比如，在示例中，我们将alphaSpeed设置为-0.4，就是说粒子的透明度每过一秒就是减少0.4，这样就有发射出去之后逐渐消失的效果。
     CAEmitterLayer的属性它自己控制着整个粒子系统的位置和形状。一些属性比如birthRate，lifetime和celocity，这些属性在CAEmitterCell中也有。这些属性会以相乘的方式作用在一起，这样你就可以用一个值来加速或者扩大整个粒子系统。其他值得提到的属性有以下这些：
     
     preservesDepth，是否将3D粒子系统平面化到一个图层（默认值）或者可以在3D空间中混合其他的图层。
     renderMode，控制着在视觉上粒子图片是如何混合的。你可能已经注意到了示例中我们把它设置为kCAEmitterLayerAdditive，它实现了这样一个效果：合并粒子重叠部分的亮度使得看上去更亮。如果我们把它设置为默认的kCAEmitterLayerUnordered，效果就没那么好看了（见图6.14）。
     */
    //create particle emitter layer
    CAEmitterLayer *emitter = [CAEmitterLayer layer];
    emitter.frame = self.view.bounds;
    [self.view.layer addSublayer:emitter];
    
    //configure emitter
    emitter.renderMode = kCAEmitterLayerAdditive;
    emitter.emitterPosition = CGPointMake(emitter.frame.size.width / 2.0, emitter.frame.size.height / 2.0);
    
    //create a particle template
    CAEmitterCell *cell = [[CAEmitterCell alloc] init];
    cell.contents = (__bridge id)[UIImage imageNamed:@"Character Boy"].CGImage;
    cell.birthRate = 150;
    cell.lifetime = 5.0;
    cell.color = [UIColor colorWithRed:1 green:0.5 blue:0.1 alpha:1.0].CGColor;
    cell.alphaSpeed = -0.4;
    cell.velocity = 50;
    cell.velocityRange = 50;
    cell.emissionRange = M_PI * 2.0;
    
    //add particle template to emitter
    emitter.emitterCells = @[cell];
}

- (void)chapter6_CATiledLayer // 专有图层
{
    // CATiledLayer为载入大图造成的性能问题提供了一个解决方案：将大图分解成小片然后将他们单独按需载入。让我们用实验来证明一下。
    //add the tiled layer
    CATiledLayer *tileLayer = [CATiledLayer layer];
    tileLayer.frame = CGRectMake(0, 0, 2048, 2048);
    tileLayer.delegate = self;
//    [self.scrollView.layer addSublayer:tileLayer];
    
    //configure the scroll view
//    self.scrollView.contentSize = tileLayer.frame.size;
    
    //draw layer
    [tileLayer setNeedsDisplay];
}

#if 0 // CATiledLayer
- (void)drawLayer:(CATiledLayer *)layer inContext:(CGContextRef)ctx
{
    //determine tile coordinate
    CGRect bounds = CGContextGetClipBoundingBox(ctx);
    NSInteger x = floor(bounds.origin.x / layer.tileSize.width);
    NSInteger y = floor(bounds.origin.y / layer.tileSize.height);
    
    //load tile image
    NSString *imageName = [NSString stringWithFormat: @"Snowman_%02i_%02i", x, y];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"jpg"];
    UIImage *tileImage = [UIImage imageWithContentsOfFile:imagePath];
    
    //draw tile
    UIGraphicsPushContext(ctx);
    [tileImage drawInRect:bounds];
    UIGraphicsPopContext();
}
#endif

- (void)chapter6_CAScrollLayer // 专有图层
{
    /*
     CAScrollLayer有一个潜在的有用特性。如果你查看CAScrollLayer的头文件，你就会注意到有一个扩展分类实现了一些方法和属性：
     
     - (void)scrollPoint:(CGPoint)p;
     - (void)scrollRectToVisible:(CGRect)r;
     @property(readonly) CGRect visibleRect;
     看到这些方法和属性名，你也许会以为这些方法给每个CALayer实例增加了滑动功能。但是事实上他们只是放置在CAScrollLayer中的图层的实用方法。scrollPoint:方法从图层树中查找并找到第一个可用的CAScrollLayer，然后滑动它使得指定点成为可视的。scrollRectToVisible:方法实现了同样的事情只不过是作用在一个矩形上的。visibleRect属性决定图层（如果存在的话）的哪部分是当前的可视区域。如果你自己实现这些方法就会相对容易明白一点，但是CAScrollLayer帮你省了这些麻烦，所以当涉及到实现图层滑动的时候就可以用上了。
     */
}

- (void)chapter6_CAReplicatorLayer // 专有图层
{
    /*
     开源代码ReflectionView完成了一个自适应的渐变淡出效果（用CAGradientLayer和图层蒙板实现），代码见 https://github.com/nicklockwood/ReflectionView
     */
    //create a replicator layer and add it to our view
    CAReplicatorLayer *replicator = [CAReplicatorLayer layer];
    replicator.frame = self.layerView.bounds;
    [self.layerView.layer addSublayer:replicator];
    
    //configure the replicator
    replicator.instanceCount = 10;
    
    //apply a transform for each instance
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, 0, 200, 0);
    transform = CATransform3DRotate(transform, M_PI / 5.0, 0, 0, 1);
    transform = CATransform3DTranslate(transform, 0, -200, 0);
    replicator.instanceTransform = transform;
    
    //apply a color shift for each instance
    replicator.instanceBlueOffset = -0.1;
    replicator.instanceGreenOffset = -0.1;
    
    //create a sublayer and place it inside the replicator
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(100.0f, 100.0f, 100.0f, 100.0f);
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    [replicator addSublayer:layer];

}

- (void)chapter6_CAGradientLayer // 专有图层
{
    /*
     CAGradientLayer是用来生成两种或更多颜色平滑渐变的。用Core Graphics复制一个CAGradientLayer并将内容绘制到一个普通图层的寄宿图也是有可能的，但是CAGradientLayer的真正好处在于绘制使用了硬件加速。
     */
    //create gradient layer and add it to our container view
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.layerView.bounds;
    [self.layerView.layer addSublayer:gradientLayer];
    
    //set gradient colors
//    gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor, (__bridge id)[UIColor blueColor].CGColor];
    
    //set gradient colors
    gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor, (__bridge id) [UIColor yellowColor].CGColor, (__bridge id)[UIColor greenColor].CGColor];
    
    //set locations
    gradientLayer.locations = @[@0.0, @0.25, @0.5];

    
    //set gradient start and end points
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);

}

- (void)chapter6_CATransformLayer // 专有图层
{
    // CATransformLayer
    //set up the perspective transform
    CATransform3D pt = CATransform3DIdentity;
    pt.m34 = -1.0 / 500.0;
    self.view.layer.sublayerTransform = pt;
    
    //set up the transform for cube 1 and add it
    CATransform3D c1t = CATransform3DIdentity;
    c1t = CATransform3DTranslate(c1t, -100, 0, 0);
    CALayer *cube1 = [self cubeWithTransform:c1t];
    [self.view.layer addSublayer:cube1];
    
    //set up the transform for cube 2 and add it
    CATransform3D c2t = CATransform3DIdentity;
    c2t = CATransform3DTranslate(c2t, 100, 0, 0);
    c2t = CATransform3DRotate(c2t, -M_PI_4, 1, 0, 0);
    c2t = CATransform3DRotate(c2t, -M_PI_4, 0, 1, 0);
    CALayer *cube2 = [self cubeWithTransform:c2t];
    [self.view.layer addSublayer:cube2];

}

- (void)chapter6 // 专有图层
{
    // CAShapeLayer
    /*
     使用CAShapeLayer有以下一些优点：
     
     渲染快速。CAShapeLayer使用了硬件加速，绘制同一图形会比用Core Graphics快很多。
     高效使用内存。一个CAShapeLayer不需要像普通CALayer一样创建一个寄宿图形，所以无论有多大，都不会占用太多的内存。
     不会被图层边界剪裁掉。一个CAShapeLayer可以在边界之外绘制。你的图层路径不会像在使用Core Graphics的普通CALayer一样被剪裁掉（如我们在第二章所见）。
     不会出现像素化。当你给CAShapeLayer做3D变换时，它不像一个有寄宿图的普通图层一样变得像素化。
     */
    
    /*
    //create path
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(175, 100)];

    [path addArcWithCenter:CGPointMake(150, 100) radius:25 startAngle:0 endAngle:2*M_PI clockwise:YES];
    [path moveToPoint:CGPointMake(150, 125)];
    [path addLineToPoint:CGPointMake(150, 175)];
    [path addLineToPoint:CGPointMake(125, 225)];
    [path moveToPoint:CGPointMake(150, 175)];
    [path addLineToPoint:CGPointMake(175, 225)];
    [path moveToPoint:CGPointMake(100, 150)];
    [path addLineToPoint:CGPointMake(200, 150)];
    
    //create shape layer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 5;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.path = path.CGPath;
    //add it to our view
    [self.view.layer addSublayer:shapeLayer];
     */
    
    // CATextLayer
    /*
    //create a text layer
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = self.layerView.bounds;
    [self.layerView.layer addSublayer:textLayer];
    
    //set text attributes
    textLayer.foregroundColor = [UIColor blackColor].CGColor;
    textLayer.alignmentMode = kCAAlignmentJustified;
    textLayer.wrapped = YES;
    
    //choose a font
    UIFont *font = [UIFont systemFontOfSize:15];
    
    //set layer font
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    textLayer.font = fontRef;
    textLayer.fontSize = font.pointSize;
    CGFontRelease(fontRef);
    
    //choose some text
    NSString *text = @"Lorem ipsum dolor sit amet, consectetur adipiscing \ elit. Quisque massa arcu, eleifend vel varius in, facilisis pulvinar \ leo. Nunc quis nunc at mauris pharetra condimentum ut ac neque. Nunc elementum, libero ut porttitor dictum, diam odio congue lacus, vel \ fringilla sapien diam at purus. Etiam suscipit pretium nunc sit amet \ lobortis";
    
    //set layer text
    textLayer.string = text;
textLayer.contentsScale = [UIScreen mainScreen].scale;
    */
    
    //create a text layer
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = self.layerView.bounds;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.layerView.layer addSublayer:textLayer];
    
    //set text attributes
    textLayer.alignmentMode = kCAAlignmentJustified;
    textLayer.wrapped = YES;
    
    //choose a font
    UIFont *font = [UIFont systemFontOfSize:15];
    
    //choose some text
    NSString *text = @"Lorem ipsum dolor sit amet, consectetur adipiscing \ elit. Quisque massa arcu, eleifend vel varius in, facilisis pulvinar \ leo. Nunc quis nunc at mauris pharetra condimentum ut ac neque. Nunc \ elementum, libero ut porttitor dictum, diam odio congue lacus, vel \ fringilla sapien diam at purus. Etiam suscipit pretium nunc sit amet \ lobortis";

    //create attributed string
    NSMutableAttributedString *string = nil;
    string = [[NSMutableAttributedString alloc] initWithString:text];
    
    //convert UIFont to a CTFont
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFloat fontSize = font.pointSize;
    CTFontRef fontRef = CTFontCreateWithName(fontName, fontSize, NULL);
    
    //set text attributes
    NSDictionary *attribs = @{
                              (__bridge id)kCTForegroundColorAttributeName:(__bridge id)[UIColor blackColor].CGColor,
                              (__bridge id)kCTFontAttributeName: (__bridge id)fontRef
                              };
    
    [string setAttributes:attribs range:NSMakeRange(0, [text length])];
    attribs = @{
                (__bridge id)kCTForegroundColorAttributeName: (__bridge id)[UIColor redColor].CGColor,
                (__bridge id)kCTUnderlineStyleAttributeName: @(kCTUnderlineStyleSingle),
                (__bridge id)kCTFontAttributeName: (__bridge id)fontRef
                };
    [string setAttributes:attribs range:NSMakeRange(6, 5)];
    
    //release the CTFont we created earlier
    CFRelease(fontRef);
    
    //set layer text
    textLayer.string = string;

    /*
     行距和字距
     
     有必要提一下的是，由于绘制的实现机制不同（Core Text和WebKit），用CATextLayer渲染和用UILabel渲染出的文本行距和字距也不是不尽相同的。
     
     二者的差异程度（由使用的字体和字符决定）总的来说挺小，但是如果你想正确的显示普通便签和CATextLayer就一定要记住这一点。
     */
}

- (void)chapter5 // 变换
{
    /*
     CALayer同样也有一个transform属性，但它的类型是CATransform3D，而不是CGAffineTransform，本章后续将会详细解释。CALayer对应于UIView的transform属性叫做affineTransform，清单5.1的例子就是使用affineTransform对图层做了45度顺时针旋转。
     

     #define RADIANS_TO_DEGREES(x) ((x)/M_PI*180.0)
     #define DEGREES_TO_RADIANS(x) ((x)/180.0*M_PI)
     
     CGAffineTransform transform = CGAffineTransformIdentity; //create a new transform
     transform = CGAffineTransformScale(transform, 0.5, 0.5); //scale by 50%
     transform = CGAffineTransformRotate(transform, M_PI / 180.0 * 30.0); //rotate by 30 degrees
     transform = CGAffineTransformTranslate(transform, 200, 0); //translate by 200 points
     //apply transform to layer
     self.layerView.layer.affineTransform = transform;
     
     图5.4中有些需要注意的地方：图片向右边发生了平移，但并没有指定距离那么远（200像素），另外它还有点向下发生了平移。原因在于当你按顺序做了变换，上一个变换的结果将会影响之后的变换，所以200像素的向右平移同样也被旋转了30度，缩小了50%，所以它实际上是斜向移动了100像素。
     
     这意味着变换的顺序会影响最终的结果，也就是说旋转之后的平移和平移之后的旋转结果可能不同。
     
     // 实现一个斜切变换
     CGAffineTransform CGAffineTransformMakeShear(CGFloat x, CGFloat y)
     {
     CGAffineTransform transform = CGAffineTransformIdentity;
     transform.c = -x;
     transform.b = y;
     return transform;
     }

     
     CATransform3DMakeRotation(CGFloat angle, CGFloat x, CGFloat y, CGFloat z)
     CATransform3DMakeScale(CGFloat sx, CGFloat sy, CGFloat sz)
     CATransform3DMakeTranslation(Gloat tx, CGFloat ty, CGFloat tz)

     m34的默认值是0，我们可以通过设置m34为-1.0 / d来应用透视效果，d代表了想象中视角相机和屏幕之间的距离，以像素为单位，那应该如何计算这个距离呢？实际上并不需要，大概估算一个就好了。
     
     CATransform3D transform = CATransform3DIdentity;
     //apply perspective
     transform.m34 = - 1.0 / 500.0;
     //rotate by 45 degrees along the Y axis
     transform = CATransform3DRotate(transform, M_PI_4, 0, 1, 0);
     //apply to layer
     self.layerView.layer.transform = transform;
     */
    
    /*
     sublayerTransform属性
     
     CALayer有一个属性叫做sublayerTransform。它也是CATransform3D类型，但和对一个图层的变换不同，它影响到所有的子图层。这意味着你可以一次性对包含这些图层的容器做变换，于是所有的子图层都自动继承了这个变换方法。
     
     //apply perspective transform to container
     CATransform3D perspective = CATransform3DIdentity;
     perspective.m34 = - 1.0 / 500.0;
     self.containerView.layer.sublayerTransform = perspective;
     //rotate layerView1 by 45 degrees along the Y axis
     CATransform3D transform1 = CATransform3DMakeRotation(M_PI_4, 0, 1, 0);
     self.layerView1.layer.transform = transform1;
     //rotate layerView2 by 45 degrees along the Y axis
     CATransform3D transform2 = CATransform3DMakeRotation(-M_PI_4, 0, 1, 0);
     self.layerView2.layer.transform = transform2;
     */
    
    /*
     背面
     如你所见，图层是双面绘制的，反面显示的是正面的一个镜像图片。
     CALayer有一个叫做doubleSided的属性来控制图层的背面是否要被绘制。这是一个BOOL类型，默认为YES，如果设置为NO，那么当图层正面从相机视角消失的时候，它将不会被绘制。
     */
    
    /*
     扁平化图层
     这是由于尽管Core Animation图层存在于3D空间之内，但它们并不都存在同一个3D空间。每个图层的3D场景其实是扁平化的，当你从正面观察一个图层，看到的实际上由子图层创建的想象出来的3D场景，但当你倾斜这个图层，你会发现实际上这个3D场景仅仅是被绘制在图层的表面。
     
     这使得用Core Animation创建非常复杂的3D场景变得十分困难。你不能够使用图层树去创建一个3D结构的层级关系--在相同场景下的任何3D表面必须和同样的图层保持一致，这是因为每个的父视图都把它的子视图扁平化了。
     
     至少当你用正常的CALayer的时候是这样，CALayer有一个叫做CATransformLayer的子类来解决这个问题。具体在第六章“特殊的图层”中将会具体讨论。
     */
    
    /*
     固体对象
     
     - (void)addFace:(NSInteger)index withTransform:(CATransform3D)transform
     {
     //get the face view and add it to the container
     UIView *face = self.faces[index];
     [self.containerView addSubview:face];
     //center the face view within the container
     CGSize containerSize = self.containerView.bounds.size;
     face.center = CGPointMake(containerSize.width / 2.0, containerSize.height / 2.0);
     // apply the transform
     face.layer.transform = transform;
     }
     
     - (void)viewDidLoad
     {
     [super viewDidLoad];
     //set up the container sublayer transform
     CATransform3D perspective = CATransform3DIdentity;
     perspective.m34 = -1.0 / 500.0;
     self.containerView.layer.sublayerTransform = perspective;
     //add cube face 1
     CATransform3D transform = CATransform3DMakeTranslation(0, 0, 100);
     [self addFace:0 withTransform:transform];
     //add cube face 2
     transform = CATransform3DMakeTranslation(100, 0, 0);
     transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
     [self addFace:1 withTransform:transform];
     //add cube face 3
     transform = CATransform3DMakeTranslation(0, -100, 0);
     transform = CATransform3DRotate(transform, M_PI_2, 1, 0, 0);
     [self addFace:2 withTransform:transform];
     //add cube face 4
     transform = CATransform3DMakeTranslation(0, 100, 0);
     transform = CATransform3DRotate(transform, -M_PI_2, 1, 0, 0);
     [self addFace:3 withTransform:transform];
     //add cube face 5
     transform = CATransform3DMakeTranslation(-100, 0, 0);
     transform = CATransform3DRotate(transform, -M_PI_2, 0, 1, 0);
     [self addFace:4 withTransform:transform];
     //add cube face 6
     transform = CATransform3DMakeTranslation(0, 0, -100);
     transform = CATransform3DRotate(transform, M_PI, 0, 1, 0);
     [self addFace:5 withTransform:transform];
     }

     perspective = CATransform3DRotate(perspective, -M_PI_4, 1, 0, 0);
     perspective = CATransform3DRotate(perspective, -M_PI_4, 0, 1, 0);
     */
    
    /*
     光亮和阴影
     清单5.10实现了这样一个结果，我们用GLKit框架来做向量的计算（你需要引入GLKit库来运行代码），每个面的CATransform3D都被转换成GLKMatrix4，然后通过GLKMatrix4GetMatrix3函数得出一个3×3的旋转矩阵。这个旋转矩阵指定了图层的方向，然后可以用它来得到正太向量的值。
     */
    
    /*
     点击事件
     */
}

- (UIButton *)customButton
{
    //create button
    CGRect frame = CGRectMake(0, 0, 150, 50);
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.backgroundColor = [UIColor whiteColor];
    button.layer.cornerRadius = 10;
    
    //add label
    frame = CGRectMake(20, 10, 110, 30);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
//    label.backgroundColor = [UIColor clearColor];
    label.text = @"Hello World";
    label.textAlignment = NSTextAlignmentCenter;
    [button addSubview:label];
    return button;
}

- (void)chapter4
{
    //create mask layer
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = self.imageView.bounds;
    UIImage *maskImage = [UIImage imageNamed:@"Key"];
    maskLayer.contents = (__bridge id)maskImage.CGImage;
    
    //apply mask to image layer￼
    self.imageView.layer.mask = maskLayer;
    
    
    
    //create opaque button
    UIButton *button1 = [self customButton];
    button1.center = CGPointMake(80, 150);
    [self.view addSubview:button1];
    
    //create translucent button
    UIButton *button2 = [self customButton];
    button2.center = CGPointMake(250, 150);
    button2.alpha = 0.5;
    [self.view addSubview:button2];
    //enable rasterization for the translucent button
    button2.layer.shouldRasterize = YES;
    button2.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)chapter3
{
    //set the corner radius on our layers
    self.layerView1.layer.cornerRadius = 20.0f;
    self.layerView2.layer.cornerRadius = 20.0f;
    
    self.layerView1.layer.borderWidth = 5.0f;
    self.layerView2.layer.borderWidth = 5.0f;
    
    //add a shadow to layerView1
    self.layerView1.layer.shadowOpacity = 0.5f;
    self.layerView1.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    self.layerView1.layer.shadowRadius = 5.0f;
    
    //add same shadow to shadowView (not layerView2)
    self.shadowView.layer.shadowOpacity = 0.5f;
    self.shadowView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    self.shadowView.layer.shadowRadius = 5.0f;
    
    //enable clipping on the second layer
    self.layerView2.layer.masksToBounds = YES;
    
    //create a square shadow
    CGMutablePathRef squarePath = CGPathCreateMutable();
    CGPathAddRect(squarePath, NULL, self.layerView1.bounds);
    self.layerView1.layer.shadowPath = squarePath;
    CGPathRelease(squarePath);
    
    //create a circular shadow
    CGMutablePathRef circlePath = CGPathCreateMutable();
    CGPathAddEllipseInRect(circlePath, NULL, self.layerView2.bounds);
    self.layerView2.layer.shadowPath = circlePath; CGPathRelease(circlePath);
}

#if 0
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //get touch position relative to main view
    CGPoint point = [[touches anyObject] locationInView:self.view];
    
    //get touched layer
    CALayer *layer = [self.layerView.layer hitTest:point];
    //get layer using hitTest
    if (layer == self.blueLayer) {
        [[[UIAlertView alloc] initWithTitle:@"Inside Blue Layer"
                                    message:nil
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    } else if (layer == self.layerView.layer) {
        [[[UIAlertView alloc] initWithTitle:@"Inside White Layer"
                                    message:nil
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }

//    //convert point to the white layer's coordinates
//    point = [self.layerView.layer convertPoint:point fromLayer:self.view.layer];
//    //get layer using containsPoint:
//    if ([self.layerView.layer containsPoint:point]) {
//        //convert point to blueLayer’s coordinates
//        point = [self.blueLayer convertPoint:point fromLayer:self.layerView.layer];
//        if ([self.blueLayer containsPoint:point]) {
//            [[[UIAlertView alloc] initWithTitle:@"Inside Blue Layer"
//                                        message:nil
//                                       delegate:nil
//                              cancelButtonTitle:@"OK"
//                              otherButtonTitles:nil] show];
//        } else {
//            [[[UIAlertView alloc] initWithTitle:@"Inside White Layer"
//                                        message:nil
//                                       delegate:nil
//                              cancelButtonTitle:@"OK"
//                              otherButtonTitles:nil] show];
//        }
//    }
}
#endif

- (void)chapters31
{
    //create sublayer
    self.blueLayer = [CALayer layer];
    self.blueLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
    self.blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    //add it to our view
    [self.layerView.layer addSublayer:self.blueLayer];
}

- (void)chapters3ticktock
{
    self.secondHand.layer.anchorPoint = CGPointMake(0.5f, 0.9f);
    self.minuteHand.layer.anchorPoint = CGPointMake(0.5f, 0.9f);
    self.hourHand.layer.anchorPoint = CGPointMake(0.5f, 0.9f);
    
    //start timer
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    //set initial hand positions
    [self tick];
}

- (void)tick
{
    //convert time to hours, minutes and seconds
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger units = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [calendar components:units fromDate:[NSDate date]];
    CGFloat hoursAngle = (components.hour / 12.0) * M_PI * 2.0;
    //calculate hour hand angle //calculate minute hand angle
    CGFloat minsAngle = (components.minute / 60.0) * M_PI * 2.0;
    //calculate second hand angle
    CGFloat secsAngle = (components.second / 60.0) * M_PI * 2.0;
    //rotate hands
    self.hourHand.transform = CGAffineTransformMakeRotation(hoursAngle);
    self.minuteHand.transform = CGAffineTransformMakeRotation(minsAngle);
    self.secondHand.transform = CGAffineTransformMakeRotation(secsAngle);
}

- (void)chapters12
{
    self.view.backgroundColor = [UIColor lightGrayColor];
    
//    CALayer *blueLayer = [CALayer layer];
//    blueLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
//    blueLayer.backgroundColor = [UIColor blueColor].CGColor;
//    [self.layerView.layer addSublayer:blueLayer];
    
//    UIImage *image = [UIImage imageNamed:@"8.jpeg"];
    
    //add it directly to our view's layer
//    self.layerView.layer.contents = (__bridge id)image.CGImage;
//    self.layerView.layer.contentsGravity = kCAGravityCenter;
//    self.layerView.layer.contentsGravity = kCAGravityResizeAspect;
//    self.layerView.layer.contentsScale = image.scale;
//    self.layerView.layer.contentsScale = 1.5;
//    self.layerView.layer.contentsScale = [UIScreen mainScreen].scale;
    
//    self.layerView.layer.masksToBounds = YES;
//    self.layerView.clipsToBounds = YES;

    
//    [self addSpriteImage:image withContentRect:CGRectMake(0, 0, 0.5, 0.5) toLayer:self.view1.layer];
//    //set cone sprite
//    [self addSpriteImage:image withContentRect:CGRectMake(0.5, 0, 0.5, 0.5) toLayer:self.view2.layer];
//    //set anchor sprite
//    [self addSpriteImage:image withContentRect:CGRectMake(0, 0.5, 0.5, 0.5) toLayer:self.view3.layer];
//    //set spaceship sprite
//    [self addSpriteImage:image withContentRect:CGRectMake(0, 0, 1, 1) toLayer:self.view4.layer];
//
//    image = [UIImage imageNamed:@"push"];
//    //set button 1
//    [self addStretchableImage:image withContentCenter:CGRectMake(0.25, 0.25, 0.5, 0.5) toLayer:self.view1.layer];
//    
//    //set button 2
//    [self addStretchableImage:image withContentCenter:CGRectMake(0.25, 0.25, 0.5, 0.5) toLayer:self.view2.layer];

    
    //create sublayer
    CALayer *blueLayer = [CALayer layer];
    blueLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
    blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    
    //set controller as layer delegate
    blueLayer.delegate = self;
    
    //ensure that layer backing image uses correct scale
    blueLayer.contentsScale = [UIScreen mainScreen].scale; //add layer to our view
    [self.layerView.layer addSublayer:blueLayer];
    
    //force layer to redraw
    [blueLayer display];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    //draw a thick red circle
    CGContextSetLineWidth(ctx, 10.0f);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextStrokeEllipseInRect(ctx, layer.bounds);
}

- (void)addStretchableImage:(UIImage *)image withContentCenter:(CGRect)rect toLayer:(CALayer *)layer
{
    //set image
    layer.contents = (__bridge id)image.CGImage;
    
    //set contentsCenter
    layer.contentsCenter = rect;
}

- (void)addSpriteImage:(UIImage *)image withContentRect:(CGRect)rect toLayer:(CALayer *)layer //set image
{
    layer.contents = (__bridge id)image.CGImage;
    
    //scale contents to fit
    layer.contentsGravity = kCAGravityResizeAspect;
    
    //set contentsRect
    layer.contentsRect = rect;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CALayer *)faceWithTransform:(CATransform3D)transform
{
    //create cube face layer
    CALayer *face = [CALayer layer];
    face.frame = CGRectMake(-50, -50, 100, 100);
    
    //apply a random color
    CGFloat red = (rand() / (double)INT_MAX);
    CGFloat green = (rand() / (double)INT_MAX);
    CGFloat blue = (rand() / (double)INT_MAX);
    face.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    
    face.transform = transform;
    return face;
}

- (CALayer *)cubeWithTransform:(CATransform3D)transform
{
    //create cube layer
    CATransformLayer *cube = [CATransformLayer layer];
    
    //add cube face 1
    CATransform3D ct = CATransform3DMakeTranslation(0, 0, 50);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    //add cube face 2
    ct = CATransform3DMakeTranslation(50, 0, 0);
    ct = CATransform3DRotate(ct, M_PI_2, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    //add cube face 3
    ct = CATransform3DMakeTranslation(0, -50, 0);
    ct = CATransform3DRotate(ct, M_PI_2, 1, 0, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    //add cube face 4
    ct = CATransform3DMakeTranslation(0, 50, 0);
    ct = CATransform3DRotate(ct, -M_PI_2, 1, 0, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    //add cube face 5
    ct = CATransform3DMakeTranslation(-50, 0, 0);
    ct = CATransform3DRotate(ct, -M_PI_2, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    //add cube face 6
    ct = CATransform3DMakeTranslation(0, 0, -50);
    ct = CATransform3DRotate(ct, M_PI, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    //center the cube layer within the container
    CGSize containerSize = self.view.bounds.size;
    cube.position = CGPointMake(containerSize.width / 2.0, containerSize.height / 2.0);
    
    //apply the transform and return
    cube.transform = transform;
    return cube;
}

@end
























