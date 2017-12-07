//
//  MyJSInterface.h
//  EasyJSWebViewSample
//
//  Created by Lau Alex on 19/1/13.
//  Copyright (c) 2013 Dukeland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EasyJSDataFunction.h"

@protocol MyJSInterfaceDelegate <NSObject>

- (void)MyJSInterfaceGetParams:(NSDictionary *)dict;

@end


@interface MyJSInterface : NSObject

@property (weak, nonatomic) id <MyJSInterfaceDelegate> delegate;
@property (nonatomic) NSDictionary *params;

- (void) test;
- (void) testWithParam: (NSString*) param;
- (void) testWithTwoParam: (NSString*) param AndParam2: (NSString*) param2;

- (void) testWithFuncParam: (EasyJSDataFunction*) param;
- (void) testWithFuncParam2: (EasyJSDataFunction*) param;

- (NSString*) testWithRet;

- (NSString*)tdtc_decode:(NSString *)string;  //天大天财解码方法

- (NSString *)jsGetAppCouponParams;                 //打开优惠券网页时，H5调用此方法，我们返回给他需要的参数。
- (void)jsGiveCouponParamsToApp:(NSString *)params;   //H5里面选择了优惠券之后，H5调用此方法，返回给我们参数。


@end




//EasyJSWebView---JS调用本地OC代码
//这个类优点是，可传参并且返回值。相关资料 http://blog.csdn.net/cnsxhza985/article/details/20053839
//如果不需要返回值，用iOS系统自带的JSContext也可以。JSContext好像不能返回值。 相关资料 http://blog.csdn.net/j_akill/article/details/44463301
