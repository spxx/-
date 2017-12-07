//
//  NSObject+Helper.h
//  DaYiMa
//
//  Created by doorxp on 14/10/29.
//  Copyright (c) 2014年 KickAss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Helper)

/**
 *  调用对象的sel,可带参数,以nil结尾
 *
 *  @param  sel 方法
 *  @param  ... 参数,以nil结尾
 *  @return void
 */
- (void)call:(SEL)sel,... NS_REQUIRES_NIL_TERMINATION;

/**
 *  交换对象的两个方法
 *
 *  @param  originSelector 原始方法
 *  @param  selector 用于交换的方法
 *  @return void
 */
- (void)swizzleSelector:(SEL)originSelector withSelector:(SEL)selector;

/**
 *  交换类的两个方法
 *
 *  @param  originSelector 原始方法
 *  @param  selector 用于交换的方法
 *  @return void
 */
+ (void)swizzleSelector:(SEL)originSelector withSelector:(SEL)selector;
@end
