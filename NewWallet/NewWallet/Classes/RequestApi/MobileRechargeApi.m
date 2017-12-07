
//
//  MobileRechargeApi.m
//  Wallet
//
//  Created by Mac on 14-12-31.
//  Copyright (c) 2014年 BoEn. All rights reserved.
//

#import "MobileRechargeApi.h"
#import "HttpTools.h"
//#define  Mobile_BaseUrl @"http://192.168.1.60:20088"
#define  Mobile_BaseUrl @""
#define  MobileAmountList_URL    [Mobile_BaseUrl stringByAppendingString:@"/app/mobile_recharge/v1/amount_list"]             //可充金额列表
#define  MobileSalePrice_URL     [Mobile_BaseUrl stringByAppendingString:@"/app/mobile_recharge/v1/sale_price"]              //可充金额列表
#define  MobileBankCard_Pay_URL  [Mobile_BaseUrl stringByAppendingString:@"/app/mobile_recharge/v1/mobile_pay"]              //银行卡支付
#define  MobileBalance_Pay_URL   [Mobile_BaseUrl stringByAppendingString:@"/app/mobile_recharge/v1/mobile_pay_balance"]      //余额支付
#define  MobileQueryName_URL     [Mobile_BaseUrl stringByAppendingString:@"/app/mobile_recharge/v1/query_service_provider"]  //银行卡支付
#define  MobileRechargeList_URL  [Mobile_BaseUrl stringByAppendingString:@"/app/mobile_recharge/v1/mobile_recharge_list"]    //充值记录列表

#define ALL_RECHARGE_ITEMS_URL [Mobile_BaseUrl stringByAppendingString:@"/app/mobile_recharge/v2/amount_list"] //所有话费充值可选项，仅供显示
#define ALL_RECHARGE_FLOW_ITEMS_URL [Mobile_BaseUrl stringByAppendingString:@"/app/mobile_recharge/v1/query_flow_products"] //所有流量充值可选项

//使用银行卡支付流量订单
#define PAY_FLOWORDER_BYBK_URL [Mobile_BaseUrl stringByAppendingString:@"/app/mobile_recharge/v1/mobile_flow_pay"]

//使用余额支付流量订单
#define PAY_FLOWORDER_BYBALANCE_URL [Mobile_BaseUrl stringByAppendingString:@"/app/mobile_recharge/v1/mobile_flow_pay_balance"]

// 创建话费充值订单
#define CREATE_MOBILE_ORDER [Mobile_BaseUrl stringByAppendingString:@"/external/mobile_biz/v1/create_mobile_order"]

// 创建流量充值订单
#define CREATE_FLOW_ORDER [Mobile_BaseUrl stringByAppendingString:@"/external/mobile_biz/v1/create_flow_order"]

@implementation MobileRechargeApi

static HttpTools *tool;

+(void)initialize
{
    tool = [HttpTools shareInstance];
}

+(void)amountListSuccess:(void (^)(NSDictionary *))successMethod
                 failure:(void (^)(NSError *error)) errorMethod
{
    [tool JsonPostRequst:MobileAmountList_URL parameters:nil success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];

}
+(void)rechargeRecordListSuccess:(void (^)(NSDictionary *))successMethod
                         failure:(void (^)(NSError *error)) errorMethod
{
    [tool JsonPostRequst:MobileRechargeList_URL parameters:nil success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
    
}
+(void)getSalePriceWithMobile:(NSString *)mobile
                       amount:(NSString *)amount
                      success:(void (^)(NSDictionary *))successMethod
                      failure:(void (^)(NSError *error)) errorMethod
{
    NSDictionary *requstData = @{
                                 @"mobile": mobile,
                                 @"amount": amount,
                                 };
    [tool JsonPostRequst:MobileSalePrice_URL parameters:requstData success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}
+(void)getNameWithMobile:(NSString *)mobile
                 success:(void (^)(NSDictionary *))successMethod
                 failure:(void (^)(NSError *error)) errorMethod
{
    NSDictionary *requstData = @{
                                 @"mobile": mobile,
                                 };
    [tool JsonPostRequst:MobileQueryName_URL parameters:requstData success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}
+(void)mobileBankCardPayWithUerid:(NSString *)userid
                           mobile:(NSString *)mobile
                           amount:(NSString *)amount
                     bank_card_no:(NSString *)bank_card_no
                        bank_code:(NSString *)bank_code
                   is_no_password:(NSString *)is_no_password
                     pay_password:(NSString *)pay_password
                      sale_amount:(NSString *)sale_amount
                      bndk_amount:(NSString *)bndk_amount
                        sp_amount:(NSString *)sp_amount
                              pid:(NSString *)pid
                          success:(void (^)(NSDictionary *))successMethod
                          failure:(void (^)(NSError *error)) errorMethod
{
    NSDictionary *requstData;
    if (pay_password) {
        requstData = @{
                       @"userid": userid,
                       @"amount": amount,
                       @"mobile": mobile,
                       @"bank_card_no":bank_card_no,
                       @"bank_code":bank_code,
                       @"is_no_password":@"no",
                       @"pay_password":pay_password,
                       @"sale_amount":sale_amount,
                       @"bndk_amount":bndk_amount,
                       @"sp_amount":sp_amount,
                       @"pid":pid,
                       };
    }else {
        requstData = @{
                       @"userid": userid,
                       @"amount": amount,
                       @"mobile": mobile,
                       @"bank_card_no":bank_card_no,
                       @"bank_code":bank_code,
                       @"is_no_password":@"yes",
                       @"sale_amount":sale_amount,
                       @"bndk_amount":bndk_amount,
                       @"sp_amount":sp_amount,
                       @"pid":pid,
                       };
    }
    [tool JsonPostRequst:MobileBankCard_Pay_URL parameters:requstData success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];

}
+(void)mobileBalancePayWithUerid:(NSString *)userid
                          mobile:(NSString *)mobile
                          amount:(NSString *)amount
                  is_no_password:(NSString *)is_no_password
                    pay_password:(NSString *)pay_password
                     sale_amount:(NSString *)sale_amount
                     bndk_amount:(NSString *)bndk_amount
                       sp_amount:(NSString *)sp_amount
                             pid:(NSString *)pid
                         success:(void (^)(NSDictionary *))successMethod
                         failure:(void (^)(NSError *error)) errorMethod
{
    NSDictionary *requstData;
    if (pay_password) {
        requstData = @{
                       @"userid": userid,
                       @"amount": amount,
                       @"mobile": mobile,
                       @"is_no_password":@"no",
                       @"pay_password":pay_password,
                       @"sale_amount":sale_amount,
                       @"bndk_amount":bndk_amount,
                       @"sp_amount":sp_amount,
                       @"pid":pid,
                       };
    }else {
        requstData = @{
                       @"userid": userid,
                       @"amount": amount,
                       @"mobile": mobile,
                       @"is_no_password":@"yes",
                       @"sale_amount":sale_amount,
                       @"bndk_amount":bndk_amount,
                       @"sp_amount":sp_amount,
                       @"pid":pid,
                       };
    }
    [tool JsonPostRequst:MobileBalance_Pay_URL parameters:requstData success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

+ (void)getAllRechargeItems:(void (^)(NSDictionary *))successBlock
                    failure:(void (^)(NSError *error)) failureBlock
{
    [tool JsonPostRequst:ALL_RECHARGE_ITEMS_URL parameters:nil success:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        failureBlock(error);
    }];
}

+ (void)getAllRechargeFlowItems:(void (^)(NSDictionary *))successBlock
                    failure:(void (^)(NSError *error)) failureBlock
{
    [tool JsonPostRequst:ALL_RECHARGE_FLOW_ITEMS_URL parameters:nil success:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        failureBlock(error);
    }];
}

+ (void)mobileFlowBankCardPayWithProductID:(NSString *)productid
                                mobile:(NSString *)mobile
                                amount:(NSString *)amount
                          bank_card_no:(NSString *)bank_card_no
                             bank_code:(NSString *)bank_code
                        is_no_password:(NSString *)is_no_password
                          pay_password:(NSString *)pay_password
                               success:(void (^)(NSDictionary *))successMethod
                               failure:(void (^)(NSError *error)) errorMethod
{
    NSDictionary *requstData;
    if (pay_password) {
        requstData = @{
                       @"product_id": productid,
                       @"amount": amount,
                       @"mobile": mobile,
                       @"bank_card_no":bank_card_no,
                       @"bank_code":bank_code,
                       @"is_no_password":@"no",
                       @"pay_password":pay_password,
                       };
    }else {
        requstData = @{
                       @"product_id": productid,
                       @"amount": amount,
                       @"mobile": mobile,
                       @"bank_card_no":bank_card_no,
                       @"bank_code":bank_code,
                       @"is_no_password":@"yes",
                       };
    }
    [tool JsonPostRequst:PAY_FLOWORDER_BYBK_URL parameters:requstData success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
    
}

+ (void)mobileFlowBalancePayWithProductID:(NSString *)productid
                                   mobile:(NSString *)mobile
                                   amount:(NSString *)amount
                           is_no_password:(NSString *)is_no_password
                             pay_password:(NSString *)pay_password
                                  success:(void (^)(NSDictionary *))successMethod
                                  failure:(void (^)(NSError *error)) errorMethod
{
    NSDictionary *requstData;
    if (pay_password) {
        requstData = @{
                       @"product_id": productid,
                       @"amount": amount,
                       @"mobile": mobile,
                       @"is_no_password":@"no",
                       @"pay_password":pay_password,
                       };
    }else {
        requstData = @{
                       @"product_id": productid,
                       @"amount": amount,
                       @"mobile": mobile,
                       @"is_no_password":@"yes",
                       };
    }
    [tool JsonPostRequst:PAY_FLOWORDER_BYBALANCE_URL parameters:requstData success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}


+ (void)mobileCreateOrder:(NSString *)productID
              phoneNumber:(NSString *)phoneNumber
                   amount:(NSString *)amount
               saleAmount:(NSString *)saleAmount
                 spAmount:(NSString *)spAmount
               bndkAmount:(NSString *)bndkAmount
                  success:(void (^)(NSDictionary *))successBlock
                  failure:(void (^)(NSError *error))errorBlock
{
    NSAssert(productID != nil, @"product id is nil");
    NSAssert(phoneNumber != nil, @"phone number is nil");
    NSAssert(amount != nil, @"amount id is nil");
    NSAssert(saleAmount != nil, @"sale_amount id is nil");
    NSAssert(spAmount != nil, @"sp_amount is nil");
    NSAssert(bndkAmount != nil, @"bndk_amount id is nil");
    
    NSDictionary *params = @{@"product_id": productID,
                             @"recharge_mobile": phoneNumber,
                             @"pay_amount": amount,
                             @"sale_amount": saleAmount,
                             @"sp_amount": spAmount,
                             @"bndk_amount": bndkAmount};
    
    [tool JsonPostRequst:CREATE_MOBILE_ORDER parameters:params success:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        errorBlock(error);
    }];
}

+ (void)mobileFlowCreateOrder:(NSString *)productID
                  phoneNumber:(NSString *)phoneNumber
                       amount:(NSString *)amount
                      success:(void (^)(NSDictionary *))successBlock
                      failure:(void (^)(NSError *error))errorBlock
{
    NSAssert(productID != nil, @"product id is nil");
    NSAssert(phoneNumber != nil, @"phone number is nil");
    NSAssert(amount != nil, @"amount id is nil");
    
    NSDictionary *params = @{@"product_id": productID,
                             @"recharge_mobile": phoneNumber,
                             @"pay_amount": amount};
    
    [tool JsonPostRequst:CREATE_FLOW_ORDER parameters:params success:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        errorBlock(error);
    }];
}

@end
