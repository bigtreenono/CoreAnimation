//
//  CAShapeLayer+ViewMask.h
//  CAShapeLayer_maskLayer
//
//  Created by Jeff on 1/10/16.
//  Copyright © 2016 FNNishipu. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CAShapeLayer (ViewMask)

+ (instancetype)createMaskLayerWithView:(UIView *)view;

@end
