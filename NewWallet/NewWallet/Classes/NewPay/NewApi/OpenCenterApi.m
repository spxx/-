//
//  OpenCenterApi.m
//  Wallet
//
//  Created by Mac on 14-7-18.
//  Copyright (c) 2014年 BoEn. All rights reserved.
//

#import "OpenCenterApi.h"
#import "FirstHttpTools_OpenCenter.h"
#import "NSString+MD5.h"

//open中心
#define APP_ID     @"B0BAEE9D279D34FA1DFD71AADB908C3F"
#define APP_SECRET @"074FD28EFF0F5ADEA071694061739E55"
#define OPEN_URL   @"/open/"


@implementation OpenCenterApi

static FirstHttpTools_OpenCenter *tool;

+(void)initialize
{
    tool = [FirstHttpTools_OpenCenter shareInstance];
}

//生产随机数作为trackId
+ (NSString *)getRandNumberToTrackId
{
    int randInt = (arc4random() % 999)+ 100;   //随机数100-999
    NSString *randStr = [NSString stringWithFormat:@"%ld",(long)randInt];
    
    return randStr;
}

#pragma mark - 调用open中心接口，要签名
//静脉信用金-还款接口
+ (void)refundVeinCreditMoneyWithUserid:(NSString *)xifu_id
                           repay_amount:(NSString *)repay_amount
                                success:(void (^)(NSDictionary *returnData))successMethod
                                failure:(void (^)(NSError *error)) errorMethod
{
    NSString *serviceName = @"creditRepay";
    NSString *trackId = [self getRandNumberToTrackId];

    NSString *parametersStr = [NSString stringWithFormat:@"POSTappId=%@app_sercet=%@repay_amount=%@serviceName=%@trackId=%@xifu_id=%@%@", APP_ID, APP_SECRET, repay_amount, serviceName, trackId, xifu_id, APP_SECRET];
    
    NSString *sign = [parametersStr MD5Digest];
    
    NSDictionary *requstData = @{@"appId" : APP_ID,
                                 @"app_sercet" : APP_SECRET,
                                 @"repay_amount" : repay_amount,
                                 @"serviceName" : serviceName,
                                 @"trackId" : trackId,
                                 @"xifu_id" : xifu_id,
                                 @"sign" : sign
                                 };
    
    [tool JsonPostRequst:OPEN_URL parameters:requstData success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

//静脉信用金-查询是否可还款接口
+ (void)checkVeinCreditMoneyisRepayAbleWithUserid:(NSString *)xifu_id
                                          success:(void (^)(NSDictionary *returnData))successMethod
                                          failure:(void (^)(NSError *error)) errorMethod
{
    NSString *serviceName = @"isRepayAble";
    NSString *trackId = [self getRandNumberToTrackId];

    NSString *parametersStr = [NSString stringWithFormat:@"POSTappId=%@app_sercet=%@serviceName=%@trackId=%@xifu_id=%@%@", APP_ID, APP_SECRET, serviceName, trackId, xifu_id, APP_SECRET];
    
    NSString *sign = [parametersStr MD5Digest];
    
    NSDictionary *requstData = @{@"appId" : APP_ID,
                                 @"app_sercet" : APP_SECRET,
                                 @"serviceName" : serviceName,
                                 @"trackId" : trackId,
                                 @"xifu_id" : xifu_id,
                                 @"sign" : sign
                                 };
    
    [tool JsonPostRequst:OPEN_URL parameters:requstData success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}
//静脉信用金-信用金_消费账单
+ (void)getVeinCreditConsumeOrderWithUserid:(NSString *)xifu_id
                                    success:(void (^)(NSDictionary *returnData))successMethod
                                    failure:(void (^)(NSError *error)) errorMethod
{
    NSString *serviceName = @"query_credit_pay_redcord";
    NSString *trackId = [self getRandNumberToTrackId];
    
    NSString *parametersStr = [NSString stringWithFormat:@"POSTappId=%@app_sercet=%@serviceName=%@trackId=%@xifu_id=%@%@", APP_ID, APP_SECRET, serviceName, trackId, xifu_id, APP_SECRET];
    
    NSString *sign = [parametersStr MD5Digest];
    
    NSDictionary *requstData = @{@"appId" : APP_ID,
                                 @"app_sercet" : APP_SECRET,
                                 @"serviceName" : serviceName,
                                 @"trackId" : trackId,
                                 @"xifu_id" : xifu_id,
                                 @"sign" : sign
                                 };
    
    [tool JsonPostRequst:OPEN_URL parameters:requstData success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

//静脉信用金-信用金_还款账单
+ (void)getVeinCreditRepayOrderWithUserid:(NSString *)xifu_id
                                  success:(void (^)(NSDictionary *returnData))successMethod
                                  failure:(void (^)(NSError *error)) errorMethod
{
    NSString *serviceName = @"queryRepayRecord";
    NSString *trackId = [self getRandNumberToTrackId];
    
    NSString *parametersStr = [NSString stringWithFormat:@"POSTappId=%@app_sercet=%@serviceName=%@trackId=%@xifu_id=%@%@", APP_ID, APP_SECRET, serviceName, trackId, xifu_id, APP_SECRET];
    
    NSString *sign = [parametersStr MD5Digest];
    
    NSDictionary *requstData = @{@"appId" : APP_ID,
                                 @"app_sercet" : APP_SECRET,
                                 @"serviceName" : serviceName,
                                 @"trackId" : trackId,
                                 @"xifu_id" : xifu_id,
                                 @"sign" : sign
                                 };
    
    [tool JsonPostRequst:OPEN_URL parameters:requstData success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

@end
