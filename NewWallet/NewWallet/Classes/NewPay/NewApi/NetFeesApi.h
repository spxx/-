//
//  NetFeesApi.h
//  Wallet
//
//  Created by mac1 on 16/2/16.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetFeesApi : NSObject


/**
 *  获取校园信息
 *
 *  @param successMethod
 *  @param errorMethod
 */
+ (void)getCampusesInfoSuccess:(void (^)(NSDictionary *successData))successMethod
                       failure:(void (^)(NSError *error))errorMethod;


/**
 *  获取余额接口
 *
 *  @param net_account   宽带账号
 *  @param campus_id     校区ID
 *  @param successMethod
 *  @param errorMethod
 */
+ (void)getNetBalanceWithNet_account:(NSString *)net_account
                           campus_id:(NSString *)campus_id
                             success:(void (^)(NSDictionary *successData))successMethod
                             failure:(void (^)(NSError *error))errorMethod;

/**
 *  获取网费充值业务订单
 *
 *  @param campus_id       校区ID
 *  @param recharge_amount 充值金额
 *  @param net_account     宽带账号
 *  @param successMethod
 *  @param errorMethod
 */
+ (void)create_netfee_orderWithCampus_id:(NSString *)campus_id
                         recharge_amount:(NSString *)recharge_amount
                             net_account:(NSString *)net_account
                                 success:(void (^)(NSDictionary *successData))successMethod
                                 failure:(void (^)(NSError *error))errorMethod;

@end
