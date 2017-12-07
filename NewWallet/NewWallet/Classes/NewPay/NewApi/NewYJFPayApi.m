//
//  NewYJFPayApi.m
//  Wallet
//
//  Created by Mac on 14-7-18.
//  Copyright (c) 2014年 BoEn. All rights reserved.
//

#import "NewYJFPayApi.h"
#import "FirstHttpTools_YJF.h"
#import <sys/utsname.h>

#define Newpay_PayTrade  @"/yjf_pay/external/v1/pay_trade"                   //支付接口（客户端调用）

#define Newpay_GetYJFPayWays  @"/yjf_pay/external/v1/get_yjf_pay_type"       //获取易极付支付方式列表(客户端调用)

#define Newpay_getYJFBindid  @"/app/member/v1/get_yjf_bind_id"   //获取易极付关联ID

#define Newpay_unloadYJFPayStatus  @"/amend_order_server/external/v1/upload"   //支付完成后，向喜付后台上传支付状态


@implementation NewYJFPayApi

static FirstHttpTools_YJF *tool;

+(void)initialize
{
    tool = [FirstHttpTools_YJF shareInstance];
}


//NewPay-api
//支付接口（客户端调用）
+ (void)newPay_PayTradeWithIs_no_password:(NSString *)is_no_password
                               goods_name:(NSString *)goods_name
                              seller_name:(NSString *)seller_name
                               pay_amount:(NSString *)pay_amount
                                 pay_no:(NSString *)pay_no
                                 order_no:(NSString *)order_no
                             pay_password:(NSString *)pay_password
                            buyer_card_no:(NSString *)buyer_card_no
                        buyer_card_bindid:(NSString *)buyer_card_bindid
                                 pay_type:(NSString *)pay_type
                                  success:(void (^)(NSDictionary *))successMethod
                                  failure:(void (^)(NSError *))errorMethod
{
//    is_no_password //是否小额免密
//    goods_name //商品名称
//    seller_name //商家名称
//    pay_amount // 支付金额
//    pay_no  //支付订单号
//    pay_password //非小额免密必填
//    buyer_card_no //银行卡号 银行卡支付必填
//    buyer_card_bindid //银行卡卡id 银行卡支付必填
//    pay_type //支付类型
//  增加传order_no

    NSDictionary *reportLossInfo = @{
                                     @"is_no_password":is_no_password,
                                     @"goods_name":goods_name,
                                     @"seller_name":seller_name,
                                     @"pay_amount":pay_amount,
                                     @"pay_no":pay_no,
                                     @"order_no":order_no,
                                     @"pay_password":pay_password,
                                     @"buyer_card_no":buyer_card_no,
                                     @"buyer_card_bindid":buyer_card_bindid,
                                     @"pay_type":pay_type,
                                     };
    [tool JsonPostRequst:Newpay_PayTrade parameters:reportLossInfo success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

//获取易极付支付方式列表(客户端调用)
+ (void)newPay_GetYJFPayWaysWithSuccess:(void (^)(NSDictionary *))successMethod
                                failure:(void (^)(NSError *))errorMethod
{

    [tool JsonPostRequst:Newpay_GetYJFPayWays parameters:nil success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}
//获取易极付关联ID - 调起易极付SDK银行卡管理模块之前，调用此接口。
+ (void)getYJFBindidWithSuccess:(void (^)(NSDictionary *))successMethod
                        failure:(void (^)(NSError *))errorMethod
{
    
    [tool JsonPostRequst:Newpay_getYJFBindid parameters:nil success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}
//支付完成后，向喜付后台上传支付返回码
+ (void)unloadYJFPayStatusWithOrder_no:(NSString *)order_no
                              pay_type:(NSString *)pay_type
                        sdk_pay_status:(NSString *)sdk_pay_status
                               success:(void (^)(NSDictionary *))successMethod
                               failure:(void (^)(NSError *))errorMethod
{
//    order_no 	喜付订单号 	字符串 	是 	喜付支付订单号 	20161017383385001233469383
//    pay_type 	支付方式 	整形 	是 	6-绑卡支付， 7-银联支付 	6
//    sdk_pay_status 	sdk返回的支付状态 	字符串 	是 	支付完成后用户退出SDK时，SDK返回的状态 	FINISH
//    mobiletype 	手机型号 	字符串 	是 	各个手机的型号， 为及时定位问题 	m3 note
//    app_version 	app版本号 	字符串 	是 	app版本号 	4.7.0
//    os 	手机系统类型 	字符串 	是 	android/ ios 	android
//    osversion 	手机系统版本 	字符串 	是 	5.1/ 10 	5.1

    NSDictionary *reportLossInfo = @{
                                     @"order_no" : order_no,
                                     @"pay_type" : pay_type,
                                     @"sdk_pay_status" : sdk_pay_status,
                                     @"mobiletype" : [self iphoneType],
                                     @"app_version" : [[NSBundle mainBundle] objectForInfoDictionaryKey: kBundleKey],
                                     @"os" : @"ios",
                                     @"osversion" : [[UIDevice currentDevice] systemVersion],
                                     };
    [tool JsonPostRequst:Newpay_unloadYJFPayStatus parameters:reportLossInfo success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}







+ (NSString *)iphoneType
{
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPod1,1"])  return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"])  return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"])  return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"])  return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"])  return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])  return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])  return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"])  return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"])  return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])  return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"])  return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"])  return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"])  return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"])  return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"])  return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])  return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"])  return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"])  return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])  return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"])  return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"])  return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    return platform;
    
}

@end
