//
//  DrawingView.m
//  Core Animation
//
//  Created by Jeff on 3/9/16.
//  Copyright © 2016 FNNishipu. All rights reserved.
//

#import "DrawingView.h"

#define BRUSH_SIZE 32

@interface DrawingView ()

@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) NSMutableArray *strokes;

@end

@implementation DrawingView

//+ (Class)layerClass
//{
//    //this makes our view create a CAShapeLayer
//    //instead of a CALayer for its backing layer
//    return [CAShapeLayer class];
//}

- (void)awakeFromNib
{
    self.strokes = [NSMutableArray array];

//    //create a mutable path
//    self.path = [[UIBezierPath alloc] init];
//    
//    //configure the layer
//    CAShapeLayer *shapeLayer = (CAShapeLayer *)self.layer;
//    shapeLayer.strokeColor = [UIColor redColor].CGColor;
//    shapeLayer.fillColor = [UIColor clearColor].CGColor;
//    shapeLayer.lineJoin = kCALineJoinRound;
//    shapeLayer.lineCap = kCALineCapRound;
//    shapeLayer.lineWidth = 5;
    
//    //create a mutable path
//    self.path = [[UIBezierPath alloc] init];
//    self.path.lineJoinStyle = kCGLineJoinRound;
//    self.path.lineCapStyle = kCGLineCapRound;
//    self.path.lineWidth = 5;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //get the starting point
    CGPoint point = [[touches anyObject] locationInView:self];
    
    [self addBrushStrokeAtPoint:point];

    //move the path drawing cursor to the starting point
//    [self.path moveToPoint:point];
}

- (void)addBrushStrokeAtPoint:(CGPoint)point
{
    //add brush stroke to array
    [self.strokes addObject:[NSValue valueWithCGPoint:point]];
    
    //needs redraw
    [self setNeedsDisplay];
}

- (CGRect)brushRectForPoint:(CGPoint)point
{
    return CGRectMake(point.x - BRUSH_SIZE/2, point.y - BRUSH_SIZE/2, BRUSH_SIZE, BRUSH_SIZE);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //get the current point
    CGPoint point = [[touches anyObject] locationInView:self];

    [self addBrushStrokeAtPoint:point];

//    //add a new line segment to our path
//    [self.path addLineToPoint:point];
//  
//    ((CAShapeLayer *)self.layer).path = self.path.CGPath;

    //redraw the view
//    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    //redraw strokes
    for (NSValue *value in self.strokes) {
        //get point
        CGPoint point = [value CGPointValue];
        
        //get brush rect
        CGRect brushRect = [self brushRectForPoint:point];

        //only draw brush stroke if it intersects dirty rect
        if (CGRectIntersectsRect(rect, brushRect)) {
            //draw brush stroke
            [[UIImage imageNamed:@"Heart"] drawInRect:brushRect];
        }
    }
    
//    //draw path
//    [[UIColor clearColor] setFill];
//    [[UIColor redColor] setStroke];
//    [self.path stroke];
}

@end
