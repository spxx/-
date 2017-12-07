//
//  NSObject+Helper.m
//  DaYiMa
//
//  Created by doorxp on 14/10/29.
//  Copyright (c) 2014年 KickAss. All rights reserved.
//

#import "NSObject+Helper.h"
#import <objc/runtime.h>

@implementation NSObject (Helper)

/**
 *  调用对象的sel,可带参数,以nil结尾
 *
 *  @param  sel 方法
 *  @param  ... 参数,以nil结尾
 *  @return void
 */
- (void)call:(SEL)sel,...
{
    NSMethodSignature *signature =
    [self methodSignatureForSelector:sel];
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self];
    
    va_list ap;
    va_start(ap, sel);
    id obj = va_arg(ap, id);
    
    NSInteger i = 0;
    while (obj)
    {
        //设置传给方法的第i个参数
        [invocation setArgument:(__bridge void *)(obj) atIndex:i];
        i ++;
        obj = va_arg(ap, id);
    }
    
    va_end(ap);
    
    
}

/**
 *  交换指定对象的两个方法
 *
 *  @param  originSelector 原始方法
 *  @param  selector 用于交换的方法
 *  @param  class 前两个方法所属的类
 *  @return void
 */
+ (void)swizzleSelector:(SEL)originSelector withSelector:(SEL)selector class:(Class)class
{
    SEL originalSelector = originSelector;
    SEL swizzledSelector = selector;
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    /*
     交换两个方法
     //*/
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (void)swizzleSelector:(SEL)originSelector withSelector:(SEL)selector
{
    //Class class = object_getClass((id)self);
    [self swizzleSelector:originSelector
             withSelector:selector
                    class:[self class]];
}

- (void)swizzleSelector:(SEL)originSelector withSelector:(SEL)selector
{
    Class class = [self class];
    [[self class] swizzleSelector:originSelector
                     withSelector:selector
                            class:class];
    
}
@end
