//
//  NewSchoolFeesApi.m
//  Wallet
//
//  Created by mac1 on 16/1/18.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "NewSchoolFeesApi.h"
#import "JavaHttpTools.h"



#define New_schoolFessList  @"/school/business/app/platform/fee/list.action"
#define New_schoolFessCreate  @"/school/business/app/platform/fee/create_order.action"
#define New_schoolFessDetail  @"/school/business/app/platform/fee/detail.action"

@implementation NewSchoolFeesApi

static JavaHttpTools *javaTool;

+(void)initialize
{
    javaTool = [JavaHttpTools shareInstance];
}


//获取新架构的缴费列表
+ (void)shoolFeesListWithCode:(NSString *)code
                      success:(void (^)(NSURLSessionDataTask *task,NSDictionary *successData))successMethod
                      failure:(void (^)(NSURLSessionDataTask *task,NSError *error))errorMethod
{
    NSDictionary *parameters = @{@"code":code};
    [javaTool JsonPostRequst:New_schoolFessList parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        successMethod(task,responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorMethod(task, error);
    }];
    
}

//生成缴费订单
+ (void)create_OrderWithPrj_key:(NSString *)fees_prj_key
                         amount:(NSString *)amount
                  prj_child_key:(NSString *)prj_child_key
                       level_id:(NSString *)level_id
                        success:(void (^)(NSURLSessionDataTask *task,NSDictionary *successData))successMethod
                        failure:(void (^)(NSURLSessionDataTask *task,NSError *error))errorMethod
{
    NSDictionary *reportLossInfo = @{
                                     @"amount":amount,
                                     @"fees_prj_key":fees_prj_key,
                                     @"prj_child_key":prj_child_key,
                                     @"level_id":level_id,
                                     };
    [javaTool JsonPostRequst:New_schoolFessCreate parameters:reportLossInfo success:^(NSURLSessionDataTask *task, id responseObject) {
        successMethod(task,responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorMethod(task, error);
    }];
}


@end
