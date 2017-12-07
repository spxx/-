//
//  NewElectricFeesApi.m
//  Wallet
//
//  Created by mac1 on 16/1/11.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "NewElectricFeesApi.h"
#import "FirstHttpTools_YKT.h"

NSString *const New_ElectricUrl = @"/external/electric_biz/v1/create_order";  //创建电费充值订单（客户端调用）

//新接口20150601
//查询电费类型 - 1 预充值、2 账单缴费
NSString *const queryEleType = @"/external/electric_biz/v1/query_ele_type";

//房间号和电费查询
NSString *const queryRoomIdAndEletric = @"/external/electric_biz/v1/query_room_ele_info";

//绑定房间号
NSString *const bindRoom = @"/external/electric_biz/v1/bind_room";
@implementation NewElectricFeesApi


static FirstHttpTools_YKT *tool;

+(void)initialize
{
    tool = [FirstHttpTools_YKT shareInstance];
}


//绑定房间号
+ (void)bandRoomWithRoomId:(NSString *)roomId
                   success:(void (^)(NSDictionary *returnData))successMethod
                   failure:(void (^)(NSError *error))errorMethod;
{
    NSDictionary *parameterDic = @{
                                   @"room_id":roomId,
                                   };
    
    [tool JsonPostRequst:bindRoom parameters:parameterDic success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}
//房间号和电费查询
+ (void)getRoomIdAndEletricSuccess:(void (^)(NSDictionary *returnData))successMethod
                           failure:(void (^)(NSError *error))errorMethod
{
    [tool JsonPostRequst:queryRoomIdAndEletric parameters:nil success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
    
}
//查询电费类型 - 1 预充值、2 账单缴费
+ (void)getqueryEleTypeSuccess:(void (^)(NSDictionary *returnData))successMethod
                       failure:(void (^)(NSError *error))errorMethod
{
    [tool JsonPostRequst:queryEleType parameters:nil success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
    
}

//创建电费充值订单（客户端接口）
+ (void)newPay_Electric_Create_orderWithSchool_id:(NSString *)school_id
                                           amount:(NSString *)amount
                                          room_id:(NSString *)room_id
                                          bill_id:(NSString *)bill_id
                                          success:(void (^)(NSDictionary *))successMethod
                                          failure:(void (^)(NSError *))errorMethod
{
    NSDictionary *reportLossInfo;
    if (bill_id && bill_id.length > 0) {
        reportLossInfo = @{
                           @"school_id":school_id,
                           @"amount":amount,
                           @"room_id":room_id,
                           @"bill_id":bill_id,
                           };
    } else {
        reportLossInfo = @{
                           @"school_id":school_id,
                           @"amount":amount,
                           @"room_id":room_id,
                           };
    }
    
    
    [tool JsonPostRequst:New_ElectricUrl parameters:reportLossInfo success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
    
}

@end
