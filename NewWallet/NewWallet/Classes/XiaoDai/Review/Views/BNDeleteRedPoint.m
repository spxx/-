//
//  BNDeleteRedPoint.m
//  Wallet
//
//  Created by mac1 on 15/4/27.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNDeleteRedPoint.h"

@interface BNDeleteRedPoint ()

@property (strong, nonatomic) DeleteImgAction deleteBlock;

@property (weak,   nonatomic) UIImageView *uploadImgView;
@end

@implementation BNDeleteRedPoint

- (id)initWithFrame:(CGRect)frame relateImgView:(UIImageView *)imgView deleteBlock:(DeleteImgAction)delBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.uploadImgView = imgView;
        
        self.userInteractionEnabled = YES;
        
        _deleteBlock = [delBlock copy];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteImgAction:)];
        
        [self addGestureRecognizer:tap];
        
        
        
    }
    return self;
}

- (void)deleteImgAction:(UITapGestureRecognizer *)tap
{
    _deleteBlock(self.uploadImgView);
    self.hidden = YES;
}
- (void)drawRect:(CGRect)rect
{

    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(currentContext);
    
    CGContextAddEllipseInRect(currentContext, CGRectMake(1, 1, CGRectGetWidth(rect) -2, CGRectGetHeight(rect)- 2));
    [UIColorFromRGB(0xfb000c) setFill];
    CGContextFillPath(currentContext);

    CGContextRestoreGState(currentContext);
    
    
    CGContextSaveGState(currentContext);
    
    CGContextAddRect(currentContext, CGRectMake(3.0, (rect.size.height - 4.0)/2.0, rect.size.width - 6.0, 4.0));
    [[UIColor whiteColor] setFill];
    CGContextFillPath(currentContext);
    
    CGContextRestoreGState(currentContext);
}
@end
