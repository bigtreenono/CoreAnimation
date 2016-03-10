//
//  GraphicsIOViewController.m
//  Core Animation
//
//  Created by Jeff on 3/9/16.
//  Copyright © 2016 FNNishipu. All rights reserved.
//

#import "GraphicsIOViewController.h"

@interface GraphicsIOViewController ()

@end

@implementation GraphicsIOViewController

#if 0
绘图实际消耗的时间通常并不是影响性能的因素。图片消耗很大一部分内存，而且不太可能把需要显示的图片都保留在内存中，所以需要在应用运行的时候周期性地加载和卸载图片。

图片文件的加载速度同时受到CPU及IO（输入/输出）延迟的影响。iOS设备中的闪存已经比传统硬盘快很多了，但仍然比RAM慢将近200倍左右，这就需要谨慎地管理加载，以避免延迟。

// 延迟解压
用于加载的CPU时间相对于解码来说根据图片格式而不同。对于PNG图片来说，加载会比JPEG更长，因为文件可能更大，但是解码会相对较快，而且Xcode会把PNG图片进行解码优化之后引入工程。JPEG图片更小，加载更快，但是解压的步骤要消耗更长的时间，因为JPEG解压算法比基于zip的PNG算法更加复杂。

当加载图片的时候，iOS通常会延迟解压图片的时间，直到加载到内存之后。这就会在准备绘制图片的时候影响性能，因为需要在绘制之前进行解压（通常是消耗时间的问题所在）。

最简单的方法就是使用UIImage的+imageNamed:方法避免延时加载。不像+imageWithContentsOfFile:（和其他别的UIImage加载方法），这个方法会在加载图片之后立刻进行解压（就和本章之前我们谈到的好处一样）。问题在于+imageNamed:只对从应用资源束中的图片有效，所以对用户生成的图片内容或者是下载的图片就没法使用了。

另一种立刻加载图片的方法就是把它设置成图层内容，或者是UIImageView的image属性。不幸的是，这又需要在主线程执行，所以不会对性能有所提升。

第三种方式就是绕过UIKit，像下面这样使用ImageIO框架：
NSInteger index = indexPath.row;
NSURL *imageURL = [NSURL fileURLWithPath:self.imagePaths[index]];
NSDictionary *options = @{(__bridge id)kCGImageSourceShouldCache: @YES};
CGImageSourceRef source = CGImageSourceCreateWithURL((__bridge CFURLRef)imageURL, NULL);
CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, 0,(__bridge CFDictionaryRef)options);
UIImage *image = [UIImage imageWithCGImage:imageRef];
CGImageRelease(imageRef);
CFRelease(source);

这样就可以使用kCGImageSourceShouldCache来创建图片，强制图片立刻解压，然后在图片的生命周期保留解压后的版本。

最后一种方式就是使用UIKit加载图片，但是需要立刻将它绘制到CGContext中去。图片必须要在绘制之前解压，所以就要立即强制解压。这样的好处在于绘制图片可以在后台线程（例如加载本身）中执行，而不会阻塞UI。

有两种方式可以为强制解压提前渲染图片：

将图片的一个像素绘制成一个像素大小的CGContext。这样仍然会解压整张图片，但是绘制本身并没有消耗任何时间。这样的好处在于加载的图片并不会在特定的设备上为绘制做优化，所以可以在任何时间点绘制出来。同样iOS也就可以丢弃解压后的图片来节省内存了。

将整张图片绘制到CGContext中，丢弃原始的图片，并且用一个从上下文内容中新的图片来代替。这样比绘制单一像素那样需要更加复杂的计算，但是因此产生的图片将会为绘制做优化，而且由于原始压缩图片被抛弃了，iOS就不能够随时丢弃任何解压后的图片来节省内存了。

需要注意的是苹果特别推荐了不要使用这些诡计来绕过标准图片解压逻辑（所以也是他们选择用默认处理方式的原因），但是如果你使用很多大图来构建应用，那如果想提升性能，就只能和系统博弈了。

如果不使用+imageNamed:，那么把整张图片绘制到CGContext可能是最佳的方式了。尽管你可能认为多余的绘制相较别的解压技术而言性能不是很高，但是新创建的图片（在特定的设备上做过优化）可能比原始图片绘制的更快。

同样，如果想显示图片到比原始尺寸小的容器中，那么一次性在后台线程重新绘制到正确的尺寸会比每次显示的时候都做缩放会更有效（尽管在这个例子中我们加载的图片呈现正确的尺寸，所以不需要多余的优化）。

如果修改了-collectionView:cellForItemAtIndexPath:方法来重绘图片（清单14.3），你会发现滑动更加平滑。

清单14.3 强制图片解压显示

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
￼{
    //dequeue cell
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    ...
    //switch to background thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        //load image
        NSInteger index = indexPath.row;
        NSString *imagePath = self.imagePaths[index];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        //redraw image using device context
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, YES, 0);
        [image drawInRect:imageView.bounds];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //set image on main thread, but only if index still matches up
        dispatch_async(dispatch_get_main_queue(), ^{
            if (index == cell.tag) {
                imageView.image = image;
            }
        });
    });
    return cell;
}

// CATiledLayer
如第6章“专用图层”中的例子所示，CATiledLayer可以用来异步加载和显示大型图片，而不阻塞用户输入。但是我们同样可以使用CATiledLayer在UICollectionView中为每个表格创建分离的CATiledLayer实例加载传动器图片，每个表格仅使用一个图层。

这样使用CATiledLayer有几个潜在的弊端：

CATiledLayer的队列和缓存算法没有暴露出来，所以我们只能祈祷它能匹配我们的需求

CATiledLayer需要我们每次重绘图片到CGContext中，即使它已经解压缩，而且和我们单元格尺寸一样（因此可以直接用作图层内容，而不需要重绘）。

需要解释几点：

CATiledLayer的tileSize属性单位是像素，而不是点，所以为了保证瓦片和表格尺寸一致，需要乘以屏幕比例因子。

在-drawLayer:inContext:方法中，我们需要知道图层属于哪一个indexPath以加载正确的图片。这里我们利用了CALayer的KVC来存储和检索任意的值，将图层和索引打标签。

结果CATiledLayer工作的很好，性能问题解决了，而且和用GCD实现的代码量差不多。仅有一个问题在于图片加载到屏幕上后有一个明显的淡入（图14.4）。

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //dequeue cell
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    //add the tiled layer
    CATiledLayer *tileLayer = [cell.contentView.layer.sublayers lastObject];
    if (!tileLayer) {
        tileLayer = [CATiledLayer layer];
        tileLayer.frame = cell.bounds;
        tileLayer.contentsScale = [UIScreen mainScreen].scale;
        tileLayer.tileSize = CGSizeMake(cell.bounds.size.width * [UIScreen mainScreen].scale, cell.bounds.size.height * [UIScreen mainScreen].scale);
        tileLayer.delegate = self;
        [tileLayer setValue:@(indexPath.row) forKey:@"index"];
        [cell.contentView.layer addSublayer:tileLayer];
    }
    //tag the layer with the correct index and reload
    tileLayer.contents = nil;
    [tileLayer setValue:@(indexPath.row) forKey:@"index"];
    [tileLayer setNeedsDisplay];
    return cell;
}

- (void)drawLayer:(CATiledLayer *)layer inContext:(CGContextRef)ctx
{
    //get image index
    NSInteger index = [[layer valueForKey:@"index"] integerValue];
    //load tile image
    NSString *imagePath = self.imagePaths[index];
    UIImage *tileImage = [UIImage imageWithContentsOfFile:imagePath];
    //calculate image rect
    CGFloat aspectRatio = tileImage.size.height / tileImage.size.width;
    CGRect imageRect = CGRectZero;
    imageRect.size.width = layer.bounds.size.width;
    imageRect.size.height = layer.bounds.size.height * aspectRatio;
    imageRect.origin.y = (layer.bounds.size.height - imageRect.size.height)/2;
    //draw tile
    UIGraphicsPushContext(ctx);
    [tileImage drawInRect:imageRect];
    UIGraphicsPopContext();
}

// 缓存
+imageNamed:方法

之前我们提到使用[UIImage imageNamed:]加载图片有个好处在于可以立刻解压图片而不用等到绘制的时候。但是[UIImage imageNamed:]方法有另一个非常显著的好处：它在内存中自动缓存了解压后的图片，即使你自己没有保留对它的任何引用。

对于iOS应用那些主要的图片（例如图标，按钮和背景图片），使用[UIImage imageNamed:]加载图片是最简单最有效的方式。在nib文件中引用的图片同样也是这个机制，所以你很多时候都在隐式的使用它。

但是[UIImage imageNamed:]并不适用任何情况。它为用户界面做了优化，但是并不是对应用程序需要显示的所有类型的图片都适用。有些时候你还是要实现自己的缓存机制，原因如下：

[UIImage imageNamed:]方法仅仅适用于在应用程序资源束目录下的图片，但是大多数应用的许多图片都要从网络或者是用户的相机中获取，所以[UIImage imageNamed:]就没法用了。

[UIImage imageNamed:]缓存用来存储应用界面的图片（按钮，背景等等）。如果对照片这种大图也用这种缓存，那么iOS系统就很可能会移除这些图片来节省内存。那么在切换页面时性能就会下降，因为这些图片都需要重新加载。对传送器的图片使用一个单独的缓存机制就可以把它和应用图片的生命周期解耦。

[UIImage imageNamed:]缓存机制并不是公开的，所以你不能很好地控制它。例如，你没法做到检测图片是否在加载之前就做了缓存，不能够设置缓存大小，当图片没用的时候也不能把它从缓存中移除。

自定义缓存




#endif

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
