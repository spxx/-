//
//  UIView+Appearance.h
//  AutoGang
//
//  Created by luoxu on 14/11/12.
//  Copyright (c) 2014年 com.qcb008.QiCheApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView(Appearance)

- (void)roundCorner:(CGFloat)raduis;

- (void)border:(UIColor *)color width:(CGFloat)width;

- (void)topBorder:(UIColor *)color width:(CGFloat)width;

- (void)bottomBorder:(UIColor *)color width:(CGFloat)width;

- (void)leftBorder:(UIColor *)color width:(CGFloat)width;

- (void)rightBorder:(UIColor *)color width:(CGFloat)width;

@end
