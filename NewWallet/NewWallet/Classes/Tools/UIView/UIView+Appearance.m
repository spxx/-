//
//  UIView+Appearance.m
//  AutoGang
//
//  Created by luoxu on 14/11/12.
//  Copyright (c) 2014年 com.qcb008.QiCheApp. All rights reserved.
//

#import "UIView+Appearance.h"

@implementation UIView(Appearance)

- (void)roundCorner:(CGFloat)raduis
{
    self.layer.cornerRadius = raduis;
    self.layer.masksToBounds = YES;
}

- (void)border:(UIColor *)color width:(CGFloat)width
{
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
    self.layer.masksToBounds = YES;
}

- (void)topBorder:(UIColor *)color width:(CGFloat)width
{
  CALayer * topBorder = [CALayer new];
  topBorder.frame = CGRectMake(0, 0, self.viewWidth, width);
  topBorder.backgroundColor = color.CGColor;
  [self.layer addSublayer:topBorder];
}

- (void)bottomBorder:(UIColor *)color width:(CGFloat)width
{
  CALayer * topBorder = [CALayer new];
  topBorder.frame = CGRectMake(0, self.viewHeight - width, self.viewWidth, width);
  topBorder.backgroundColor = color.CGColor;
  [self.layer addSublayer:topBorder];
}

- (void)leftBorder:(UIColor *)color width:(CGFloat)width
{
  CALayer * topBorder = [CALayer new];
  topBorder.frame = CGRectMake(0, 0, width, self.viewHeight);
  topBorder.backgroundColor = color.CGColor;
  [self.layer addSublayer:topBorder];
}

- (void)rightBorder:(UIColor *)color width:(CGFloat)width
{
  CALayer * topBorder = [CALayer new];
  topBorder.frame = CGRectMake(self.viewWidth - width, 0, width, self.viewHeight);
  topBorder.backgroundColor = color.CGColor;
  [self.layer addSublayer:topBorder];
}

@end
