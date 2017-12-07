//
//  BNUploadAvatarProgressView.m
//  Wallet
//
//  Created by mac1 on 16/7/14.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "BNUploadAvatarProgressView.h"

@interface BNUploadAvatarProgressView ()

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, assign) CGFloat changeRadius;

@property (nonatomic, assign) CGFloat theRadius;

@property (nonatomic, assign) CGFloat centerPointX;
@property (nonatomic, assign) CGFloat centerPointY;

@end

@implementation BNUploadAvatarProgressView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.theRadius = frame.size.width * 0.5;
        self.changeRadius = 0;
        self.centerPointX = frame.size.width/2.0;
        self.centerPointY = frame.size.height/2.0;
    }
    return self;
}


- (void)startAnimation
{
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAcion)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopAnimation
{
     _changeRadius = _theRadius;
    [_displayLink invalidate];
    _displayLink = nil;
    [self removeFromSuperview];
}

- (void)displayLinkAcion
{
    if (_changeRadius < _theRadius) {
        _changeRadius += _theRadius/60 ;
    }else{
        [self stopAnimation];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
    });
}


- (void)drawRect:(CGRect)rect {
  
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSaveGState(currentContext);
    CGContextAddArc(currentContext, _centerPointX, _centerPointY, _theRadius, 0, 2 * M_PI, YES);
    CGContextAddEllipseInRect(currentContext, CGRectMake(_centerPointX - _changeRadius, _centerPointY - _changeRadius, 2 * _changeRadius, 2 * _changeRadius));
    [[[UIColor blackColor] colorWithAlphaComponent:0.8] setFill];
    CGContextEOFillPath(currentContext);
    CGContextRestoreGState(currentContext);
}


@end
