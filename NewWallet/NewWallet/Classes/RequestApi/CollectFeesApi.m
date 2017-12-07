//
//  CollectFeesApi.m
//  Wallet
//
//  Created by mac1 on 15/8/31.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "CollectFeesApi.h"

@implementation CollectFeesApi

NSString *const url = @"/open-platform/delivery";

//确认收款
NSString *const payeeConfirm = @"payee_confirm";

//放款状态查询
NSString *const payeeQuery = @"payee_query";

//是否有待领取费用
NSString *const haveNoDraw = @"payee_not_draw";
static  HttpTools *tool;

+(void)initialize
{
    tool = [HttpTools shareInstance];
}


#pragma mark 确认收款
+ (void)confirmPayeeWithProjectKey:(NSString *)key
                           Success:(void (^)(NSDictionary *returnData))successMethod
                           failure:(void (^)(NSError *error))errorMethod
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",url,payeeConfirm];
    NSDictionary *parameterDic = @{@"prj_key":key};
    [tool JsonPostRequst:urlString parameters:parameterDic success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}


#pragma mark 放款状态查询
+ (void)queryPayeeWithPrj_key:(NSString *)prj_key
                      Success:(void (^)(NSDictionary *returnData))successMethod
                      failure:(void (^)(NSError *error))errorMethod
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",url,payeeQuery];
    NSDictionary *parameters = @{
                                 @"prj_key":prj_key
                                 };
    [tool JsonPostRequst:urlString parameters:parameters success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

#pragma mark 是否有待领取费用
+ (void)haveNoDrawFeesSuccess:(void (^)(NSDictionary *returnData))successMethod
                      failure:(void (^)(NSError *error))errorMethod
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",url,haveNoDraw];
    [tool JsonPostRequst:urlString parameters:@{} success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

@end
