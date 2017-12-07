//
//  UIColor+HexTransform.h
//  成长轨迹
//
//  Created by Leo Tang on 14/12/17.
//  Copyright (c) 2014年 Leo Tang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIColor (HexTransform)

/**
 *  十六进制获取UIColor
 *
 *  @param hexValue
 *  @param alphaValue
 *
 *  @return
 */
+ (UIColor*)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;

/**
 *  十六进制获取UIColor
 *
 *  @param hexValue
 *
 *  @return
 */
+ (UIColor*)colorWithHex:(NSInteger)hexValue;

/**
 *  UIColor的十六进制编码
 *
 *  @param color
 *
 *  @return
 */
+ (NSString *)hexFromUIColor: (UIColor*) color;

@end