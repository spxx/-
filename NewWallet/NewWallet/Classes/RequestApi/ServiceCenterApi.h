//
//  ServiceCenterApi.h
//  NewWallet
//
//  Created by mac1 on 14-11-11.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SERVICE_CENTER_YKT_SERVICE_LIST @"/app/v5/service_list"
#define SERVICE_CENTER_XIFU_SERVICE_LIST @"/app/v6/xifu_service_list"

@interface ServiceCenterApi : NSObject

//获取一卡通新闻

+(void)fetchYKTNewsWithUserID:(NSString *)userid type:(NSString *)type begin_time:(NSString *)time success:(void (^)(NSDictionary *returnData))successMethod failure:(void (^)(NSError *error)) errorMethod;

//获取喜付新闻
+(void)fetchXiFuNewsWithUserID:(NSString *)userid begin_time:(NSString *)time success:(void (^)(NSDictionary *returnData))successMethod failure:(void (^)(NSError *error)) errorMethod;

@end
