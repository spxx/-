//
//  BNEnterBKView.m
//  Wallet
//
//  Created by mac1 on 15/3/31.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNEnterBKView.h"

@implementation BNEnterBKView


- (void)drawRect:(CGRect)rect
{
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(currentContext);
    
    [UIColor_GrayLine setStroke];
    
    CGContextSetLineWidth(currentContext, 0.5);
    
    CGContextSetShouldAntialias(currentContext, NO );
    
    int countLine = (rect.size.height / ((45 * BILI_WIDTH) - 1));
    
    for (int i = 0; i < countLine - 1; i++) {
        CGContextMoveToPoint(currentContext, 20, 45 * BILI_WIDTH * (i + 1));
        CGContextAddLineToPoint(currentContext, rect.size.width, 45 * BILI_WIDTH * (i + 1));
    }
    
    CGContextStrokePath(currentContext);
    
    CGContextRestoreGState(currentContext);
}
@end
