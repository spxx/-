//
//  NetFeesApi.m
//  Wallet
//
//  Created by mac1 on 16/2/16.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "NetFeesApi.h"
#import "FirstHttpTools_YKT.h"

#define Net_get_campuses  @"/external/netfee_recharge_biz/v1/get_campuses"//获取校园信息
#define Net_get_balance  @"/external/netfee_recharge_biz/v1/query_balance"//获取余额
#define Net_create_netfee_order  @"/external/netfee_recharge_biz/v1/create_netfee_order"//获取网费充值业务订单

@implementation NetFeesApi


static FirstHttpTools_YKT *tool;

+(void)initialize
{
    tool = [FirstHttpTools_YKT shareInstance];
}

//获取校园信息
+ (void)getCampusesInfoSuccess:(void (^)(NSDictionary *successData))successMethod
                       failure:(void (^)(NSError *error))errorMethod
{
    
    [tool JsonPostRequst:Net_get_campuses parameters:nil success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];

}

//获取余额
+ (void)getNetBalanceWithNet_account:(NSString *)net_account
                           campus_id:(NSString *)campus_id
                             success:(void (^)(NSDictionary *successData))successMethod
                             failure:(void (^)(NSError *error))errorMethod
{
    NSDictionary *parameters = @{
                                 @"net_account":net_account,
                                 @"campus_id":campus_id
                                 };
    
    [tool JsonPostRequst:Net_get_balance parameters:parameters success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];

}

//获取网费充值业务订
+ (void)create_netfee_orderWithCampus_id:(NSString *)campus_id
                         recharge_amount:(NSString *)recharge_amount
                             net_account:(NSString *)net_account
                                 success:(void (^)(NSDictionary *successData))successMethod
                                 failure:(void (^)(NSError *error))errorMethod
{
    NSDictionary *parameters = @{
                                 @"recharge_amount":recharge_amount,
                                 @"campus_id":campus_id,
                                 @"net_account":net_account
                                 };
    
    [tool JsonPostRequst:Net_create_netfee_order parameters:parameters success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];

}


@end
