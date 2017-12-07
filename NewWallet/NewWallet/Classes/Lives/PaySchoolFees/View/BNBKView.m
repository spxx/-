//
//  BNBKView.m
//  Wallet
//
//  Created by mac1 on 15/3/18.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNBKView.h"

@implementation BNBKView

- (void)drawRect:(CGRect)rect
{
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGPoint point[] = {CGPointMake(rect.origin.x + kArrowWidth, 1),
        CGPointMake(kArrowWidth, (rect.size.height - kArrowHeight - kBKSubViewHeight)/2),
        CGPointMake(1,  (rect.size.height - kBKSubViewHeight)/2),
        CGPointMake(kArrowWidth, (rect.size.height - kBKSubViewHeight)/2 + kArrowHeight/2),
        CGPointMake(kArrowWidth, rect.size.height - 1),
        CGPointMake(rect.size.width - 1, rect.size.height-1),
        CGPointMake(rect.size.width - 1, 1)};
    
    
    CGContextAddLines(currentContext, point, 7);
    
    CGContextClosePath(currentContext);
    
    [UIColor_GrayLine setStroke];
    
    [[UIColor whiteColor] setFill];
    
    CGContextSetLineWidth(currentContext, 1);
    
    CGContextDrawPath(currentContext, kCGPathFillStroke);
    
    [[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0] setFill];
    
    CGContextAddRect(currentContext, CGRectMake(rect.origin.x + kArrowWidth + 1, rect.size.height - 1 - kBKSubViewHeight, rect.size.width - kArrowWidth - 3, kBKSubViewHeight-1));
    
    CGContextDrawPath(currentContext, kCGPathFill);
}

@end
