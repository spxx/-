//
//  CollectFeesApi.h
//  Wallet
//
//  Created by mac1 on 15/8/31.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectFeesApi : NSObject


/**
 *  确认收款
 *
 *  @param key           项目key
 *  @param successMethod 成功
 *  @param errorMethod   失败
 */
+ (void)confirmPayeeWithProjectKey:(NSString *)key
                      Success:(void (^)(NSDictionary *returnData))successMethod
                      failure:(void (^)(NSError *error))errorMethod;


/**
 *  放款查询
 *
 *  @param prj_key       项目 key
 *  @param successMethod 成功
 *  @param errorMethod   失败
 */
+ (void)queryPayeeWithPrj_key:(NSString *)prj_key
                      Success:(void (^)(NSDictionary *returnData))successMethod
                      failure:(void (^)(NSError *error))errorMethod;


/**
 *  是否有待领取费用
 *
 *  @param successMethod 成功block
 *  @param errorMethod   失败block
 */
+ (void)haveNoDrawFeesSuccess:(void (^)(NSDictionary *returnData))successMethod
                      failure:(void (^)(NSError *error))errorMethod;

@end
