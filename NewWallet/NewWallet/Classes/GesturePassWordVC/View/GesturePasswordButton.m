//
//  GesturePasswordButton.m
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//

#import "GesturePasswordButton.h"

#define bounds self.bounds

@implementation GesturePasswordButton
@synthesize selected;
@synthesize success;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        success=YES;
        self.layer.cornerRadius = frame.size.width/2;
        self.layer.masksToBounds = YES;
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat roundBili = 2*M_PI/360;

    if (!selected) {
        CGContextSetRGBStrokeColor(context, 205/255.f, 210/255.f, 229/255.f,0.5);//线条颜色
        CGContextAddArc(context, bounds.origin.x+bounds.size.width/2, bounds.origin.y+bounds.size.height/2, 54/2, 0*roundBili,360*roundBili, 0);
        CGContextSetLineWidth(context, 1.5); //线宽
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextStrokePath(context);
    }

//    CGContextFillPath(context);
    
    if (selected) {
        if (success) {
            CGContextSetRGBStrokeColor(context, 190/255.f, 198/255.f, 226/255.f,1);//线条颜色
            CGContextSetRGBFillColor(context, 255/255.f, 255/255.f, 255/255.f,0.5);//圆点颜色
        }
        else {
            CGContextSetRGBStrokeColor(context, 255/255.f, 109/255.f, 106/255.f,1);//线条颜色
            CGContextSetRGBFillColor(context, 194/255.f, 21/255.f, 31/255.f,1);//圆点颜色
        }
        //中间圆点尺寸
//        CGRect frame = CGRectMake(bounds.size.width/2-20/2, bounds.size.height/2-20/2, 20, 20);
//        CGContextAddEllipseInRect(context,frame);
//        CGContextFillPath(context);
        
    }
    else{
        CGContextSetRGBStrokeColor(context, 1,1,1,0.0);//线条颜色
        CGContextSetRGBFillColor(context, 255/255.f, 255/255.f, 255/255.f,0.5);//圆点颜色
        //中间圆点尺寸
//        CGRect frame = CGRectMake(bounds.size.width/2-20/2, bounds.size.height/2-20/2, 20, 20);
//        CGContextAddEllipseInRect(context,frame);
//        CGContextFillPath(context);

    }
    
    CGContextSetLineWidth(context,1.5);
    CGRect frame = CGRectMake(1.5, 1.5, bounds.size.width-3, bounds.size.height-3);
    CGContextAddEllipseInRect(context,frame);
    CGContextStrokePath(context);
    
    //画里面的圆弧
    CGContextAddArc(context, bounds.origin.x+bounds.size.width/2, bounds.origin.y+bounds.size.height/2, 20, -52*roundBili,112*roundBili, 0);
    CGContextSetLineWidth(context, 1); //线宽
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextStrokePath(context);

    CGContextAddArc(context, bounds.origin.x+bounds.size.width/2, bounds.origin.y+bounds.size.height/2, 20, 128*roundBili,-68*roundBili, 0);
    CGContextSetLineWidth(context, 1); //线宽
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextStrokePath(context);

    CGContextAddArc(context, bounds.origin.x+bounds.size.width/2, bounds.origin.y+bounds.size.height/2, 13, -110*roundBili,220*roundBili, 0);
    CGContextSetLineWidth(context, 1); //线宽
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextStrokePath(context);

    CGContextAddArc(context, bounds.origin.x+bounds.size.width/2, bounds.origin.y+bounds.size.height/2, 6, 0*roundBili,360*roundBili, 0);
    CGContextSetLineWidth(context, 1); //线宽
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextStrokePath(context);
    
//    if (success) {
//        //按钮内半透明填充色
//        CGContextSetRGBFillColor(context,30/255.f, 175/255.f, 235/255.f,0.3);
//    }
//    else {
//        //按钮内半透明填充色
//        CGContextSetRGBFillColor(context,208/255.f, 36/255.f, 36/255.f,0.3);
//    }
//    CGContextAddEllipseInRect(context,frame);
//    if (selected) {
//        CGContextFillPath(context);
//    }
    
}


@end
