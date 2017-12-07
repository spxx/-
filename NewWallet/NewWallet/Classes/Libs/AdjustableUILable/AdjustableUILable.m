//
//  AdjustableUILable.m
//  NewWallet
//
//  Created by mac on 14-11-4.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "AdjustableUILable.h"

@implementation AdjustableUILable

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


- (void)drawTextInRect:(CGRect)rect
{
    if (_characterSpacing)
    {
        // Drawing code
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGFloat size = self.font.pointSize;
        
        CGContextSelectFont (context, [self.font.fontName UTF8String], size, kCGEncodingMacRoman);
        CGContextSetCharacterSpacing (context, _characterSpacing);
        CGContextSetTextDrawingMode (context, kCGTextFill);
        
        // Rotate text to not be upside down
        CGAffineTransform xform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);
        CGContextSetTextMatrix(context, xform);
        if (self.text.length > 0) {
            const char *cStr = [self.text UTF8String];
            CGContextShowTextAtPoint (context, rect.origin.x + 3, rect.origin.y + size, cStr, strlen(cStr));
        }
        
        
        
//        CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
//        float lengths[] = {size, 3};
//        CGContextSetLineDash(context, 0, lengths, 2);  //画虚线
//        CGContextMoveToPoint(context, 0, rect.size.height - 2);    //开始画线
//        CGContextAddLineToPoint(context, rect.size.width, rect.size.height - 2);
//        CGContextStrokePath(context);

    }
    else
    {
        // no character spacing provided so do normal drawing
        [super drawTextInRect:rect];
    }
}

@end
