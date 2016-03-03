//
//  CAShapeLayer+ViewMask.m
//  CAShapeLayer_maskLayer
//
//  Created by Jeff on 1/10/16.
//  Copyright © 2016 FNNishipu. All rights reserved.
//

#import "CAShapeLayer+ViewMask.h"

@implementation CAShapeLayer (ViewMask)

// http://blog.csdn.net/yixiangboy/article/details/50485250?hmsr=toutiao.io&utm_medium=toutiao.io&utm_source=toutiao.io
+ (instancetype)createMaskLayerWithView:(UIView *)view
{
    CGFloat viewWidth = CGRectGetWidth(view.frame);
    CGFloat viewHeight = CGRectGetHeight(view.frame);
    
    CGFloat rightSpace = 10.;
    CGFloat topSpace = 15.;
    
    CGPoint point1 = CGPointMake(0, 0);
    CGPoint point2 = CGPointMake(viewWidth-rightSpace, 0);
    CGPoint point3 = CGPointMake(viewWidth-rightSpace, topSpace);
    CGPoint point4 = CGPointMake(viewWidth, topSpace);
    CGPoint point5 = CGPointMake(viewWidth-rightSpace, topSpace+10.);
    CGPoint point6 = CGPointMake(viewWidth-rightSpace, viewHeight);
    CGPoint point7 = CGPointMake(0, viewHeight);
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:point1];
    [path addLineToPoint:point2];
    [path addLineToPoint:point3];
    [path addLineToPoint:point4];
    [path addLineToPoint:point5];
    [path addLineToPoint:point6];
    [path addLineToPoint:point7];
    [path closePath];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    
    return layer;
}

@end
