//
//  NewElectricFeesApi.h
//  Wallet
//
//  Created by mac1 on 16/1/11.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewElectricFeesApi : NSObject

//绑定房间号
+ (void)bandRoomWithRoomId:(NSString *)roomId
                   success:(void (^)(NSDictionary *returnData))successMethod
                   failure:(void (^)(NSError *error))errorMethod;

//房间号和电费查询
+ (void)getRoomIdAndEletricSuccess:(void (^)(NSDictionary *returnData))successMethod
                           failure:(void (^)(NSError *error))errorMethod;

//查询电费类型 - 1 预充值、2 账单缴费
+ (void)getqueryEleTypeSuccess:(void (^)(NSDictionary *returnData))successMethod
                       failure:(void (^)(NSError *error))errorMethod;

// 创建电费充值订单
+ (void)newPay_Electric_Create_orderWithSchool_id:(NSString *)school_id
                                           amount:(NSString *)amount
                                          room_id:(NSString *)room_id
                                          bill_id:(NSString *)bill_id
                                          success:(void (^)(NSDictionary *))successMethod
                                          failure:(void (^)(NSError *))errorMethod;

@end
