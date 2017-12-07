//
//  BNUploadProgressView.m
//  Wallet
//
//  Created by mac1 on 15/4/28.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNUploadProgressView.h"

@interface BNUploadProgressView ()

@property (assign, nonatomic) long long dataTotalSize;

@property (assign, nonatomic) long long dataChangeSize;

@property (strong, nonatomic) CADisplayLink *displayLink;

@property (assign, nonatomic) CGFloat dismissRadius;

@property (assign, nonatomic) CGPoint centerPoint;

@property (strong, nonatomic) NSString *progressStr;

@end

@implementation BNUploadProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _dismissRadius = 5.0;
        _centerPoint = CGPointMake(CGRectGetWidth(frame)/2.0, CGRectGetHeight(frame)/2.0);
        _progressStr = @"0.0%";
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadImageTips:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)uploadImageTips:(UITapGestureRecognizer *)tap
{
    [SVProgressHUD showErrorWithStatus:@"照片上传中，请稍等片刻"];
}
- (void)changeProgressWithDataSize:(long long)changeSize  amountSize:(long long) amountSize
{
    
    _dataChangeSize = changeSize;
    _dataTotalSize  = amountSize;
    CGFloat prog = changeSize/(CGFloat)amountSize;
    _progressStr = [NSString stringWithFormat:@"%f", prog * 100.0];
     NSRange pointRange = [_progressStr rangeOfString:@"."];
    if (pointRange.length == 1) {
        _progressStr = [NSString stringWithFormat:@"%@%%",[_progressStr substringWithRange:NSMakeRange(0, pointRange.location)]];
    }else{
        if (_progressStr.length > 2) {
            _progressStr = [NSString stringWithFormat:@"%@%%",[_progressStr substringWithRange:NSMakeRange(0, 2)]];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
    });
        
    if (changeSize == amountSize) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:)];
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                               forMode:NSDefaultRunLoopMode];
    }
    
    
}

- (void)handleDisplayLink:(CADisplayLink *)displayLink
{
    if (_dismissRadius > 2 * CGRectGetWidth(self.frame)) {
        [self.displayLink invalidate];
        self.displayLink = nil;
        [self removeFromSuperview];
    }else{
        _dismissRadius = _dismissRadius + CGRectGetWidth(self.frame)/60.0;
        [self setNeedsDisplay];
    }
    
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    if (_dataChangeSize < _dataTotalSize) {
    
        CGContextSaveGState(currentContext);
        CGContextAddRect(currentContext, rect);
        [[UIColor colorWithRed:.0 green:.0 blue:.0 alpha:0.6] setFill];
        CGContextFillPath(currentContext);
        CGContextRestoreGState(currentContext);
        
        CGContextSaveGState(currentContext);
        CGContextTranslateCTM(currentContext, _centerPoint.x, _centerPoint.y);
        CGContextRotateCTM(currentContext, -M_PI/2.0);
        CGContextSetLineWidth(currentContext, [BNTools sizeFit:13 six:15 sixPlus:18]);
        CGContextAddArc(currentContext, 0, 0, [BNTools sizeFit:26 six:30 sixPlus:36], 0, 2*M_PI*(_dataChangeSize/(CGFloat)_dataTotalSize), 0);
        [[UIColor colorWithRed:0.0 green:72.0/255.0 blue:1.0 alpha:0.6] setStroke];
        CGContextStrokePath(currentContext);
        CGContextRestoreGState(currentContext);
        
        CGFloat width = [BNTools sizeFit:25 six:30 sixPlus:36];
        CGContextSaveGState(currentContext);
        CGContextAddArc(currentContext, CGRectGetWidth(rect)/2.0, CGRectGetHeight(rect)/2.0, width, .0, 2.0 * M_PI, 0);
        CGContextClosePath(currentContext);
        [[UIColor colorWithRed:0.0 green:72.0/255.0 blue:1.0 alpha:1] setFill];
        CGContextFillPath(currentContext);
        CGContextRestoreGState(currentContext);
        
        CGContextSaveGState(currentContext);
        
        [[UIColor whiteColor] setFill];
        [_progressStr drawInRect:CGRectMake(CGRectGetWidth(rect)/2.0 - width, (rect.size.height - 22.0)/2.0, width * 2, 22.0) withFont:[UIFont systemFontOfSize:15] lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
        CGContextRestoreGState(currentContext);
    }else{
        CGContextSaveGState(currentContext);
        CGContextAddRect(currentContext, rect);
        CGContextAddEllipseInRect(currentContext, CGRectMake(_centerPoint.x - _dismissRadius, _centerPoint.y - _dismissRadius, 2 * _dismissRadius, 2 * _dismissRadius));
        [UIColor colorWithRed:.0 green:.0 blue:.0 alpha:0.6];
        CGContextEOFillPath(currentContext);
        CGContextRestoreGState(currentContext);
    }

}
@end
