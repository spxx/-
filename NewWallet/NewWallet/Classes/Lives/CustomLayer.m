//
//  CustomLayer.m
//  Wallet
//
//  Created by mac1 on 15/8/7.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//


#import "CustomLayer.h"

@implementation CustomLayer

- (id)initWithLayer:(id)layer
{
    self = [super initWithLayer:layer];
    if (self)
    {
        if ([layer isKindOfClass:[CustomLayer class]])
        {
            CustomLayer *other = layer;
            self.total = other.total;
            self.completed = other.completed;
            
            self.radius = other.radius;
            self.innerRadius = other.innerRadius;
            
            self.startAngle = other.startAngle;
            self.endAngle = other.endAngle;
            self.contentsGravity = kCAGravityCenter;
        }
    }
    
    return self;
}


+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([key isEqualToString:@"completed"])
    {
        return YES;
    }
    return [super needsDisplayForKey:key];
}


- (void)drawInContext:(CGContextRef)ctx
{
    CGContextRef contextRef = ctx;
    CGFloat colorR = (39.0 - 17.0)/_total;
    CGFloat colorG = (231.0 - 116.0)/_total;
    CGFloat colorB = (169.0 - 235.0)/_total;
    CGFloat totalAngle = _endAngle - _startAngle;
    
    CGRect theRect = self.bounds;
    
    CGFloat x0 = (theRect.size.width - 2*_radius)/2.0 + _radius;
    CGFloat y0 = (theRect.size.height - 2*_radius)/2.0 + _radius;
    
    CGContextSetAllowsAntialiasing(contextRef, YES);
    CGContextSetShouldAntialias(contextRef, YES);
    CGContextSetInterpolationQuality(contextRef, kCGInterpolationHigh);
    
    //改变layer的背景
    CGContextSetFillColorWithColor(contextRef, [UIColor whiteColor].CGColor);
    CGContextAddRect(contextRef, theRect);
    CGContextFillPath(contextRef);
    
    //画灰色默认线条
    CGContextSetLineWidth(contextRef,4.0);     //设置线条宽度
    for (int i = 0; i < _total; i++) {
        CGContextMoveToPoint(contextRef, x0, y0);
        
        CGFloat x = x0 + cosf(_startAngle + totalAngle*i/_total)*_radius;
        CGFloat y = y0 + sinf(_startAngle + totalAngle*i/_total)*_radius;
        
        CGContextAddLineToPoint(contextRef, x, y);
        CGContextSetStrokeColorWithColor(contextRef, [UIColor colorWithRed:197/255.0 green:208/255.0 blue:212/255.0 alpha:1.0f].CGColor);   //设置颜色
        CGContextDrawPath(contextRef, kCGPathFillStroke);
    }
    
    
    //白色的内圆
    UIBezierPath *defaultBezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(x0, y0) radius:_innerRadius startAngle:0 endAngle:2*M_PI clockwise:NO];
    CGContextSetFillColorWithColor(contextRef, [UIColor whiteColor].CGColor);
    CGContextAddPath(contextRef, defaultBezierPath.CGPath);
    CGContextDrawPath(contextRef, kCGPathFill);
    
    
    if (_completed == 0) {
       //内圆中的内圆
        CGContextAddArc(contextRef, x0, y0, 47 * BILI_WIDTH, 0, 2 * M_PI, NO);
        CGContextSetFillColorWithColor(contextRef, [UIColor colorWithRed:197/255.0 green:208/255.0 blue:212/255.0 alpha:1.0f].CGColor);
        CGContextDrawPath(contextRef, kCGPathFill);
    }
    
    
    for (int i = 0; i < _completed; i++) {
        
        //线条动画
        CGContextMoveToPoint(contextRef, x0, y0);
        CGFloat x = x0 + cosf(_startAngle + totalAngle*i/_total)*_radius;
        CGFloat y = y0+ sinf(_startAngle + totalAngle*i/_total)*_radius;
        CGContextSetLineWidth(contextRef, 4.0);
        CGContextAddLineToPoint(contextRef, x, y);
        CGContextSetStrokeColorWithColor(contextRef, [UIColor colorWithRed:(17 + colorR * i)/255.0 green:(116 + colorG * i)/255.0 blue:(235 + colorB * i)/255.0 alpha:1.0].CGColor);
        CGContextDrawPath(contextRef, kCGPathStroke);
        
        
        //白色的内圆
        UIBezierPath *defaultBezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(x0, y0) radius:_innerRadius startAngle:0 endAngle:2*M_PI clockwise:NO];
        CGContextSetFillColorWithColor(contextRef, [UIColor whiteColor].CGColor);
        CGContextAddPath(contextRef, defaultBezierPath.CGPath);
        CGContextDrawPath(contextRef, kCGPathFill);
        
        //内圆中的内圆动画
        CGContextAddArc(contextRef, x0, y0, 47 * BILI_WIDTH, 0, 2*M_PI, 0);
        CGContextSetFillColorWithColor(contextRef, [UIColor colorWithRed:(17 + colorR * i)/255.0 green:(116 + colorG * i)/255.0 blue:(235 + colorB * i)/255.0 alpha:1.0].CGColor);
        CGContextSetStrokeColorWithColor(contextRef, [UIColor whiteColor].CGColor);     //设置内圆画笔白色
        CGContextDrawPath(contextRef, kCGPathFill);
    }
    
    
}



@end
