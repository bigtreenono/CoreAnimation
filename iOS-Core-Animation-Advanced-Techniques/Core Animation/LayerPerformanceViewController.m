//
//  LayerPerformanceViewController.m
//  Core Animation
//
//  Created by Jeff on 3/11/16.
//  Copyright © 2016 FNNishipu. All rights reserved.
//

#import "LayerPerformanceViewController.h"

@interface LayerPerformanceViewController ()
@property (nonatomic, weak) IBOutlet UIView *layerView;

@end

@implementation LayerPerformanceViewController

#if 0
// 离屏渲染
当图层属性的混合体被指定为在未预合成之前不能直接在屏幕中绘制时，屏幕外渲染就被唤起了。屏幕外渲染并不意味着软件绘制，但是它意味着图层必须在被显示之前在一个屏幕外上下文中被渲染（不论CPU还是GPU）。图层的以下属性将会触发屏幕外绘制：

圆角（当和maskToBounds一起使用时）
图层蒙板
阴影
屏幕外渲染和我们启用光栅化时相似，除了它并没有像光栅化图层那么消耗大，子图层并没有被影响到，而且结果也没有被缓存，所以不会有长期的内存占用。但是，如果太多图层在屏幕外渲染依然会影响到性能。

有时候我们可以把那些需要屏幕外绘制的图层开启光栅化以作为一个优化方式，前提是这些图层并不会被频繁地重绘。

对于那些需要动画而且要在屏幕外渲染的图层来说，你可以用CAShapeLayer，contentsCenter或者shadowPath来获得同样的表现而且较少地影响到性能。

// 混合和过度绘制
在第12章有提到，GPU每一帧可以绘制的像素有一个最大限制（就是所谓的fill rate），这个情况下可以轻易地绘制整个屏幕的所有像素。但是如果由于重叠图层的关系需要不停地重绘同一区域的话，掉帧就可能发生了。

GPU会放弃绘制那些完全被其他图层遮挡的像素，但是要计算出一个图层是否被遮挡也是相当复杂并且会消耗处理器资源。同样，合并不同图层的透明重叠像素（即混合）消耗的资源也是相当客观的。所以为了加速处理进程，不到必须时刻不要使用透明图层。任何情况下，你应该这样做：

给视图的backgroundColor属性设置一个固定的，不透明的颜色
设置opaque属性为YES

这样做减少了混合行为（因为编译器知道在图层之后的东西都不会对最终的像素颜色产生影响）并且计算得到了加速，避免了过度绘制行为因为Core Animation可以舍弃所有被完全遮盖住的图层，而不用每个像素都去计算一遍。

如果用到了图像，尽量避免透明除非非常必要。如果图像要显示在一个固定的背景颜色或是固定的背景图之前，你没必要相对前景移动，你只需要预填充背景图片就可以避免运行时混色了。

如果是文本的话，一个白色背景的UILabel（或者其他颜色）会比透明背景要更高效。

最后，明智地使用shouldRasterize属性，可以将一个固定的图层体系折叠成单张图片，这样就不需要每一帧重新合成了，也就不会有因为子图层之间的混合和过度绘制的性能问题了。



#endif

- (void)viewDidLoad {
    [super viewDidLoad];
    //create shape layer
    CAShapeLayer *blueLayer = [CAShapeLayer layer];
    blueLayer.frame = CGRectMake(50, 50, 100, 100);
    blueLayer.fillColor = [UIColor blueColor].CGColor;
    blueLayer.path = [UIBezierPath bezierPathWithRoundedRect:
                      CGRectMake(0, 0, 100, 100) cornerRadius:20].CGPath;

    //add it to our view
    [self.layerView.layer addSublayer:blueLayer];

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
