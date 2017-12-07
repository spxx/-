//
//  UnionPayApi.m
//  Wallet
//
//  Created by mac on 2017/3/29.
//  Copyright © 2017年 BNDK. All rights reserved.
//

#import "UnionPayApi.h"

@implementation UnionPayApi

#define KGetUnionBankListURL     @"/app/bankAccount/version_1/bankListUrl"    //获取银联银行卡管理H5页面-返回URL。
#define KGetUnionPaySettingURL   @"/app/bankAccount/version_1/payConfigUrl"   //获取银联支付设置H5页面-返回URL。。

static HttpTools *tool;

+(void)initialize
{
    tool = [HttpTools shareInstance];
}


//获取银联银行卡管理H5页面-返回URL。
+ (void)getUnionBankListURLSucceed:(void (^)(NSDictionary *returnData))successMethod
                           failure:(void (^)(NSError *error)) errorMethod
{
    [tool JsonGetRequst:KGetUnionBankListURL parameters:nil success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}
//获取银联支付设置H5页面-返回URL。
+ (void)getUnionPaySettingURLSucceed:(void (^)(NSDictionary *returnData))successMethod
                             failure:(void (^)(NSError *error)) errorMethod
{
    [tool JsonGetRequst:KGetUnionPaySettingURL parameters:nil success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}
@end
