//
//  OpenCenterApi.h
//  Wallet
//
//  Created by Mac on 14-7-18.
//  Copyright (c) 2014年 BoEn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OpenCenterApi : NSObject

//静脉信用金-还款接口
+ (void)refundVeinCreditMoneyWithUserid:(NSString *)xifu_id
                           repay_amount:(NSString *)repay_amount
                                success:(void (^)(NSDictionary *returnData))successMethod
                                failure:(void (^)(NSError *error)) errorMethod;

//静脉信用金-查询是否可还款接口
+ (void)checkVeinCreditMoneyisRepayAbleWithUserid:(NSString *)xifu_id
                                          success:(void (^)(NSDictionary *returnData))successMethod
                                          failure:(void (^)(NSError *error)) errorMethod;

//静脉信用金-信用金_消费账单
+ (void)getVeinCreditConsumeOrderWithUserid:(NSString *)xifu_id
                                    success:(void (^)(NSDictionary *returnData))successMethod
                                    failure:(void (^)(NSError *error)) errorMethod;

//静脉信用金-信用金_还款账单
+ (void)getVeinCreditRepayOrderWithUserid:(NSString *)xifu_id
                                  success:(void (^)(NSDictionary *returnData))successMethod
                                  failure:(void (^)(NSError *error)) errorMethod;

@end




