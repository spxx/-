//
//  BNHandleImageTool.m
//  Wallet
//
//  Created by mac1 on 15/5/18.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNHandleImageTool.h"

@implementation BNHandleImageTool

+ (UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        UIGraphicsBeginImageContext(asize);
        [image drawInRect:CGRectMake(0, 0, asize.width, asize.height)];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}


+ (UIImage *)createUploadDefaultBackGroundImage
{
    UIGraphicsBeginImageContext(CGSizeMake(90, 90));   //开始画线
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(currentContext);
    CGContextSetLineCap(currentContext, kCGLineCapRound);  //设置线条终点形状
    CGFloat lengths[2] = {8,4};
    CGContextSetLineDash(currentContext, 0, lengths, 2);
    CGContextSetLineWidth(currentContext, 1);
    [UIColorFromRGB(0xc5c5c5) setStroke];
    [UIColorFromRGB(0xe7e7e7) setFill];
    CGContextAddRect(currentContext, CGRectMake(1, 1, 90-2, 90-2));
    CGContextDrawPath(currentContext, kCGPathFillStroke);
    CGContextRestoreGState(currentContext);
    
    CGContextSaveGState(currentContext);
    CGContextAddRect(currentContext, CGRectMake((90 - 6)/2.0, 20, 6, 90 - 20 * 2));
    CGContextAddRect(currentContext, CGRectMake(20, (90 - 6)/2.0, 90 - 20 * 2, 6));
    [[UIColor whiteColor] setFill];
    CGContextFillPath(currentContext);
    
    CGContextRestoreGState(currentContext);
    
    UIImage *uploadBKImg = UIGraphicsGetImageFromCurrentImageContext();
    
    return uploadBKImg;
}


@end
