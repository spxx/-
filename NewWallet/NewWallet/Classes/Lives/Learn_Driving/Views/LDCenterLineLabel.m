//
//  LDMainViewController.h
//  Wallet
//
//  Created by mac1 on 16/5/30.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "LDCenterLineLabel.h"

@interface LDCenterLineLabel ()

@property (nonatomic, assign) CGFloat startX;
@property (nonatomic, assign) CGFloat width;

@end

@implementation LDCenterLineLabel


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, BNColorRGB(155, 174, 183).CGColor);
    CGFloat halfHeightValue = CGRectGetHeight(self.frame) * 0.5;
    CGContextMoveToPoint(context, _startX, halfHeightValue);
    CGContextAddLineToPoint(context, _startX + _width, halfHeightValue);
    CGContextSetLineWidth(context, 1);
    CGContextStrokePath(context);
   
    
    //可以直接画矩形框
//    UIRectFill(CGRectMake(0, rect.size.height * 0.5, rect.size.width, 1));

}


//设置需要划线的x（相对于lable） 和 宽度。
- (void)setCenterLineStartX:(CGFloat)startX width:(CGFloat)width
{
    self.startX = startX;
    self.width = width;
    [self setNeedsDisplay];
}

@end
