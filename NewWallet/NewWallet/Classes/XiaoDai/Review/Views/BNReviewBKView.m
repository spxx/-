//
//  BNReviewBKView.m
//  Wallet
//
//  Created by mac1 on 15/4/23.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNReviewBKView.h"

#define kHeadStartHeight 24.0

#define kWaterHalfWidth 12.0

#define kWaterHeight    24.0

@interface BNReviewBKView ()

@property (assign, nonatomic) CGFloat headAdd;

@property (assign, nonatomic) CGFloat waterHalfWidth;

@property (assign, nonatomic) CGFloat waterHeight;

@property (assign, nonatomic) CGFloat centerLineHeight;
@end

@implementation BNReviewBKView

- (id)initWithFrame:(CGRect)frame reviewStep:(BNReviewStepType)step
{
    self = [super initWithFrame:frame];
    if (self) {
        _reviewStepType = step;
        
        if (_reviewStepType == BNReviewStepTypeOne) {
            self.headAdd        = .0;
            self.waterHalfWidth = .0;
            self.waterHeight    = .0;
            self.centerLineHeight = .0;
        }else{
            self.headAdd        = kHeadStartHeight;
            self.waterHalfWidth = kWaterHalfWidth;
            self.waterHeight    = kWaterHeight;
            switch (_reviewStepType) {
                case BNReviewStepTypeTwo:
                {
                    self.centerLineHeight = kReviewRowHeight - kHeadStartHeight - kWaterHeight + 4;
                }
                    break;
                    
                case BNReviewStepTypeThree:
                {
                    self.centerLineHeight = kReviewRowHeight * 2 - kHeadStartHeight - kWaterHeight + 4;
                }
                    break;
                    
                case BNReviewStepTypeFour:
                {
                    self.centerLineHeight = kReviewRowHeight * 3 - kHeadStartHeight - kWaterHeight + 4;
                }
                    break;
                    
                case BNReviewStepTypeFive:
                {
                    self.centerLineHeight = kReviewRowHeight * 4 - kHeadStartHeight - kWaterHeight + 4;
                }
                case BNReviewStepTypeSix:
                {
                    self.centerLineHeight = kReviewRowHeight * 5 - kHeadStartHeight - kWaterHeight + 4;
                }
                default:
                    break;
            }
            
        }
    }
    return self;
}

#pragma mark - water animition
- (void)startDisplayLink
{
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                           forMode:NSDefaultRunLoopMode];
    [self sendNotification];
}

- (void)sendNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_Updat_Review_Step object:nil];
}
- (void)handleDisplayLink:(CADisplayLink *)displayLink
{
    [self setNeedsDisplay];
    
    if (self.headAdd < kHeadStartHeight) {
        self.headAdd = self.headAdd + kHeadStartHeight/30.0;
    }else{
        switch (_reviewStepType) {
            case BNReviewStepTypeOne:
            {
                if (self.waterHalfWidth < kWaterHalfWidth) {
                    self.waterHalfWidth = self.waterHalfWidth + kWaterHalfWidth / 20.0;
                    self.waterHeight    = self.waterHeight + kWaterHeight / 20.0;
                    self.centerLineHeight = self.centerLineHeight + (kReviewRowHeight - kHeadStartHeight - kWaterHeight+ 4)/20.0;
                }else{
                    [self stopDisplayLink];
                }
                
            }
                break;
                
            case BNReviewStepTypeTwo:
            {
                if (self.centerLineHeight < (kReviewRowHeight*2 - kHeadStartHeight - kWaterHeight + 4)) {
                    self.centerLineHeight = self.centerLineHeight + (kReviewRowHeight - kHeadStartHeight - kWaterHeight+ 4)/10.0;
                }else{
                    [self stopDisplayLink];
                }
                
            }
                break;
                
            case BNReviewStepTypeThree:
            {
                if (self.centerLineHeight < (kReviewRowHeight*3 - kHeadStartHeight - kWaterHeight + 4)) {
                    self.centerLineHeight = self.centerLineHeight + (kReviewRowHeight - kHeadStartHeight - kWaterHeight+ 4)/10.0;
                }else{
                    [self stopDisplayLink];
                }
                
            }
                break;
                
            case BNReviewStepTypeFour:
            {
                if (self.centerLineHeight < (kReviewRowHeight*4 - kHeadStartHeight - kWaterHeight + 4)) {
                    self.centerLineHeight = self.centerLineHeight + (kReviewRowHeight - kHeadStartHeight - kWaterHeight + 4)/10.0;
                }else{
                    [self stopDisplayLink];
                }
                
            }
                break;
                
            case BNReviewStepTypeFive:
            {
                if (self.centerLineHeight < (kReviewRowHeight*5 - kHeadStartHeight - kWaterHeight + 4)) {
                    self.centerLineHeight = self.centerLineHeight + (kReviewRowHeight - kHeadStartHeight - kWaterHeight + 4)/10.0;
                }else{
                    [self stopDisplayLink];
                }
                
            }
                break;
            case BNReviewStepTypeSix:
            {
                if (self.centerLineHeight < (kReviewRowHeight*6.5 - kHeadStartHeight)) {
                    self.centerLineHeight = self.centerLineHeight + (kReviewRowHeight - kHeadStartHeight)/10.0;
                }else{
                    [self stopDisplayLink];
                }
                
            }
                break;
                
            default:
                break;
        }
        
        
    }
}

- (void)stopDisplayLink
{
    [self.displayLink invalidate];
    self.displayLink = nil;
    
    if (_reviewStepType == BNReviewStepTypeSix) {
        [self sendNotification];
    }
}


- (void)drawRect:(CGRect)rect {
    
    // Drawing code
    
    //灰色线
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    
    CGContextSaveGState(currentContext);
    
    CGContextMoveToPoint(currentContext, kTimeLineOriginX - 1, 0);
    
    CGPoint point[4] = {CGPointMake(kTimeLineOriginX - 1, 0),
        CGPointMake(kTimeLineOriginX - 1, rect.size.height),
        CGPointMake(kTimeLineOriginX + 1, rect.size.height),
        CGPointMake(kTimeLineOriginX + 1, 0)};
    
    CGContextAddLines(currentContext, point, 4);
    CGContextClosePath(currentContext);
    [UIColorFromRGB(0xe8e8e8) setFill];
    CGContextFillPath(currentContext);
    CGContextRestoreGState(currentContext);
    
    //话圆点
    CGContextSaveGState(currentContext);
    
    for (int i = 1; i < 6; i++) {
        CGContextAddEllipseInRect(currentContext, CGRectMake(kTimeLineOriginX - 5, kReviewHeadHeight + kReviewRowHeight * i - 5, 10, 10));
    }
    
    [UIColorFromRGB(0xe8e8e8) setFill];
    
    CGContextFillPath(currentContext);
    
    CGContextRestoreGState(currentContext);
    
    
    //头部
    CGContextSaveGState(currentContext);
    
    CGContextMoveToPoint(currentContext, 0, 0);
    
    CGContextAddLineToPoint(currentContext, 0, kReviewHeadHeight);
    
    CGContextAddLineToPoint(currentContext, kTimeLineOriginX - 30, kReviewHeadHeight);
    
    CGContextAddQuadCurveToPoint(currentContext, kTimeLineOriginX, kReviewHeadHeight, kTimeLineOriginX - 1 , kReviewHeadHeight + _headAdd);
    CGContextAddLineToPoint(currentContext, kTimeLineOriginX + 1, kReviewHeadHeight + _headAdd);
    
    CGContextAddQuadCurveToPoint(currentContext, kTimeLineOriginX, kReviewHeadHeight, kTimeLineOriginX + 30, kReviewHeadHeight);
    
    CGContextAddLineToPoint(currentContext, rect.size.width, kReviewHeadHeight);
    
    CGContextAddLineToPoint(currentContext, rect.size.width, 0);
    
    CGContextAddLineToPoint(currentContext, 0, 0);
    
    [UIColorFromRGB(0xe25258) setFill];
    
    CGContextClosePath(currentContext);
    
    CGContextFillPath(currentContext);
    
    CGContextRestoreGState(currentContext);
    
    
    if (_headAdd >= 24.0) {
        
        switch (_reviewStepType) {
            case BNReviewStepTypeOne:
            {
                
                
            }
                break;
                
            case BNReviewStepTypeTwo:
            {
                CGContextSaveGState(currentContext);
                
                CGContextAddEllipseInRect(currentContext, CGRectMake(kTimeLineOriginX - 5, kReviewHeadHeight + kReviewRowHeight * 1 - 5, 10, 10));
                
                
                [UIColorFromRGB(0xe25258) setFill];
                
                CGContextFillPath(currentContext);
                
                CGContextRestoreGState(currentContext);
            }
                break;
                
            case BNReviewStepTypeThree:
            {
                CGContextSaveGState(currentContext);
                
                for (int i = 1; i < 3; i++) {
                    CGContextAddEllipseInRect(currentContext, CGRectMake(kTimeLineOriginX - 5, kReviewHeadHeight + kReviewRowHeight * i - 5, 10, 10));
                }
                
                [UIColorFromRGB(0xe25258) setFill];
                
                CGContextFillPath(currentContext);
                
                CGContextRestoreGState(currentContext);
            }
                break;
                
            case BNReviewStepTypeFour:
            {
                CGContextSaveGState(currentContext);
                
                for (int i = 1; i < 4; i++) {
                    CGContextAddEllipseInRect(currentContext, CGRectMake(kTimeLineOriginX - 5, kReviewHeadHeight + kReviewRowHeight * i - 5, 10, 10));
                }
                
                [UIColorFromRGB(0xe25258) setFill];
                
                CGContextFillPath(currentContext);
                
                CGContextRestoreGState(currentContext);
            }
                break;
                
            case BNReviewStepTypeFive:
            {
                CGContextSaveGState(currentContext);
                
                for (int i = 1; i < 5; i++) {
                    CGContextAddEllipseInRect(currentContext, CGRectMake(kTimeLineOriginX - 5, kReviewHeadHeight + kReviewRowHeight * i - 5, 10, 10));
                }
                
                [UIColorFromRGB(0xe25258) setFill];
                
                CGContextFillPath(currentContext);
                
                CGContextRestoreGState(currentContext);
            }
                break;
            case BNReviewStepTypeSix:
            {
                CGContextSaveGState(currentContext);
                
                for (int i = 1; i < 6; i++) {
                    CGContextAddEllipseInRect(currentContext, CGRectMake(kTimeLineOriginX - 5, kReviewHeadHeight + kReviewRowHeight * i - 5, 10, 10));
                }
                
                [UIColorFromRGB(0xe25258) setFill];
                
                CGContextFillPath(currentContext);
                
                CGContextRestoreGState(currentContext);
            }
                break;
                
            default:
                break;
        }
        
        CGContextSaveGState(currentContext);
        CGContextMoveToPoint(currentContext, kTimeLineOriginX - 1 , kReviewHeadHeight + _headAdd);
        CGPoint point[4] = {CGPointMake(kTimeLineOriginX - 1 , kReviewHeadHeight + _headAdd),
            CGPointMake(kTimeLineOriginX - 1, kReviewHeadHeight + _headAdd +_centerLineHeight),
            CGPointMake(kTimeLineOriginX + 1, kReviewHeadHeight + _headAdd +_centerLineHeight),
            CGPointMake(kTimeLineOriginX + 1, kReviewHeadHeight + _headAdd)};
        
        CGContextAddLines(currentContext, point, 4);
        [UIColorFromRGB(0xe25258) setFill];
        CGContextClosePath(currentContext);
        CGContextFillPath(currentContext);
        CGContextRestoreGState(currentContext);
        
        //水滴
        CGFloat fristCotrl = kReviewHeadHeight + _headAdd +_centerLineHeight + _waterHeight/2.0;
        CGFloat secondCotrl = kReviewHeadHeight + _headAdd +_centerLineHeight + 3 * _waterHeight/4.0;
        CGFloat height = kReviewHeadHeight + _headAdd +_centerLineHeight + _waterHeight;
        
        CGContextSaveGState(currentContext);
        CGContextMoveToPoint(currentContext, kTimeLineOriginX - 1 , kReviewHeadHeight + _headAdd +_centerLineHeight - 1);
        CGContextAddCurveToPoint(currentContext, kTimeLineOriginX, fristCotrl, kTimeLineOriginX - 4.0*_waterHalfWidth/5.0, secondCotrl, kTimeLineOriginX - 1, height);
        CGContextAddQuadCurveToPoint(currentContext, kTimeLineOriginX, height, kTimeLineOriginX + 1, height);
        CGContextAddCurveToPoint(currentContext, kTimeLineOriginX + 4.0*_waterHalfWidth/5.0, secondCotrl, kTimeLineOriginX, fristCotrl, kTimeLineOriginX + 1, kReviewHeadHeight + _headAdd +_centerLineHeight - 1);
        [UIColorFromRGB(0xe25258) setFill];
        CGContextClosePath(currentContext);
        CGContextFillPath(currentContext);
        CGContextRestoreGState(currentContext);
        
        
        CGContextSaveGState(currentContext);
        CGContextSetLineCap(currentContext, kCGLineCapRound);
        CGContextSetLineWidth(currentContext, 2.0);
        CGContextMoveToPoint(currentContext, kTimeLineOriginX-2, secondCotrl);
        CGContextAddQuadCurveToPoint(currentContext, kTimeLineOriginX - 2, kReviewHeadHeight + _headAdd + _centerLineHeight +4*_waterHeight/5.0, kTimeLineOriginX, kReviewHeadHeight + _headAdd + _centerLineHeight + 5*_waterHeight/6.0);
        [[UIColor whiteColor] setStroke];
        CGContextStrokePath(currentContext);
        CGContextRestoreGState(currentContext);
        
        
        
        
//        //水滴上半部分
//        CGFloat upHalfHeight = kReviewHeadHeight + _headAdd +_centerLineHeight - 2 + _waterHeight/2.0;
//        
//        CGContextSaveGState(currentContext);
//        CGContextMoveToPoint(currentContext, kTimeLineOriginX - 1 , kReviewHeadHeight + _headAdd +_centerLineHeight - 2);
//        CGContextAddQuadCurveToPoint(currentContext, kTimeLineOriginX, upHalfHeight, kTimeLineOriginX - _waterHalfWidth, upHalfHeight);
//        CGContextAddLineToPoint(currentContext, kTimeLineOriginX + _waterHalfWidth, upHalfHeight);
//        CGContextAddQuadCurveToPoint(currentContext, kTimeLineOriginX, upHalfHeight, kTimeLineOriginX + 1, kReviewHeadHeight + _headAdd +_centerLineHeight - 2);
//        [UIColorFromRGB(0xe25258) setFill];
//        CGContextClosePath(currentContext);
//        CGContextFillPath(currentContext);
//        CGContextRestoreGState(currentContext);
//        
//        //水滴下半部分
//        CGContextSaveGState(currentContext);
//        CGContextMoveToPoint(currentContext, kTimeLineOriginX - _waterHalfWidth , upHalfHeight);
//        CGContextAddCurveToPoint(currentContext, kTimeLineOriginX - _waterHalfWidth, kReviewHeadHeight + _headAdd + _waterHeight + _centerLineHeight, kTimeLineOriginX + _waterHalfWidth, kReviewHeadHeight + _headAdd + _waterHeight + _centerLineHeight, kTimeLineOriginX +_waterHalfWidth, upHalfHeight);
//        [UIColorFromRGB(0xe25258) setFill];
//        
//        CGContextClosePath(currentContext);
//        
//        CGContextFillPath(currentContext);
//        CGContextRestoreGState(currentContext);
    }
    
}


@end
