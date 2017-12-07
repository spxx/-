//
//  ServiceCenterApi.m
//  NewWallet
//
//  Created by mac1 on 14-11-11.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "ServiceCenterApi.h"

#import "HttpTools.h"

@implementation ServiceCenterApi

static HttpTools *tool;

+(void)initialize
{
    tool = [HttpTools shareInstance];
}

+(void)fetchYKTNewsWithUserID:(NSString *)userid type:(NSString *)type begin_time:(NSString *)time success:(void (^)(NSDictionary *returnData))successMethod failure:(void (^)(NSError *error)) errorMethod
{
    if (!userid || userid.length <= 0) {
        return;
    }
    NSDictionary *requstData;
    if (!time) {
        requstData = @{@"type":type,
                       @"userid": userid
                       };
    } else {
        requstData = @{@"type":type,
                       @"begin_time":time,
                       @"userid": userid
                       };
    }

    [tool JsonPostRequst:SERVICE_CENTER_YKT_SERVICE_LIST parameters:requstData success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

+(void)fetchXiFuNewsWithUserID:(NSString *)userid begin_time:(NSString *)time success:(void (^)(NSDictionary *returnData))successMethod failure:(void (^)(NSError *error)) errorMethod
{
    if (!userid || userid.length <= 0) {
        return;
    }
    NSDictionary *requstData;
    if (!time) {
        requstData = @{@"begin_time":@"",
                       @"user_id": userid};
    } else {
        requstData = @{@"begin_time":time,
                       @"user_id": userid};
    }
#ifdef SERVER_114
    NSString *url = [NSString stringWithFormat:@"%@:10002%@", BASE_URL, SERVICE_CENTER_XIFU_SERVICE_LIST];
    [tool JsonPostRequst:url parameters:requstData success:^(id responseObject) {
#else
    [tool JsonPostRequst:SERVICE_CENTER_XIFU_SERVICE_LIST parameters:requstData success:^(id responseObject) {
#endif
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

@end
