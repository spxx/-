//
//  PlaceholderCenterTextField.m
//  Wallet
//
//  Created by 陈荣雄 on 16/5/16.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "PlaceholderCenterTextField.h"

@implementation PlaceholderCenterTextField

- (void) drawPlaceholderInRect:(CGRect)rect
{
    [[UIColor blueColor] setFill];
    
    UIFont *font = [UIFont systemFontOfSize:15];
    
    CGRect placeholderRect = CGRectMake(rect.origin.x, (rect.size.height-font.pointSize-5)/2, rect.size.width, font.pointSize+5);
    
    /// Make a copy of the default paragraph style
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    /// Set line break mode
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    /// Set text alignment
    //paragraphStyle.alignment = NSTextAlignmentRight;
    
    NSDictionary *attributes = @{ NSFontAttributeName: font,
                                  NSParagraphStyleAttributeName: paragraphStyle,
                                  NSForegroundColorAttributeName: [UIColor string2Color:@"#b0bec5"]};
    
    [[self placeholder] drawInRect:placeholderRect withAttributes:attributes];
}

@end
