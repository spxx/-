//
//  MaskView.m
//  DBCamera
//
//  Created by 陈荣雄 on 15/6/25.
//  Copyright © 2015年 PSSD - Daniele Bogo. All rights reserved.
//

#import "MaskView.h"

@interface MaskView ()

@property (assign, nonatomic) CGFloat frameLeftX;
@property (assign, nonatomic) CGFloat frameRightX;
@property (assign, nonatomic) CGFloat frameTopY;
@property (assign, nonatomic) CGFloat frameBottomY;
@property (assign, nonatomic) CGSize frameSize;
@property (strong, nonatomic) UIColor *frameColor;

@end

@implementation MaskView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frameLeftX = 0;
        self.frameRightX = frame.size.width;
        self.frameTopY = (self.bounds.size.height-320)/2;
        self.frameBottomY = self.frameTopY+frame.size.width;
        self.frameSize = CGSizeMake(frame.size.width, frame.size.width);
        self.frameColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1.0];
        
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.5;
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, nil, CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT));
        CGPathAddRect(path, nil, CGRectMake((SCREEN_WIDTH-250)/2, (SCREEN_HEIGHT-250)/2, 250, 250));
        [maskLayer setPath:path];
        maskLayer.fillRule = kCAFillRuleEvenOdd;
        CGPathRelease(path);
        self.layer.mask = maskLayer;
        self.userInteractionEnabled = NO;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, (SCREEN_HEIGHT-260)/2+260+10, SCREEN_WIDTH, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:15];
        label.text = @"将二维码放入框内，即可自动扫描";
        [self addSubview:label];
        
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, (SCREEN_HEIGHT-200)/2, 200, 5)];
//        line.backgroundColor = [UIColor greenColor];
//        [self addSubview:line];
//        
//        CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
//        animation.fromValue = @(0);
//        animation.toValue = @(200-5);
//        animation.duration = 2;
//        animation.repeatCount = INFINITY;
//        animation.removedOnCompletion = NO;
//        animation.fillMode = kCAFillModeForwards;
//        
//        [line.layer addAnimation:animation forKey:nil];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//    //获得处理的上下文
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    //设置线条样式
//    CGContextSetLineCap(context, kCGLineCapSquare);
//    //设置线条粗细宽度
//    CGContextSetLineWidth(context, 1.0);
//    
//    //设置颜色
//    CGFloat red, green, blue, alpha;
//    [self.frameColor getRed:&red green:&green blue:&blue alpha:&alpha];
//    CGContextSetRGBStrokeColor(context, red, green, blue, alpha);
//    //开始一个起始路径
//    CGContextBeginPath(context);
//    //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
//    /*CGContextMoveToPoint(context, 0, self.frameTopY);
//    CGContextAddLineToPoint(context, self.frameRightX, self.frameTopY);
//    CGContextMoveToPoint(context, 0, self.frameBottomY);
//    CGContextAddLineToPoint(context, self.frameRightX, self.frameBottomY);*/
//    CGContextAddRect(context, CGRectMake(0, self.frameTopY, self.frameSize.width, self.frameSize.height));
//    //连接上面定义的坐标点
//    CGContextStrokePath(context);
//}

@end
