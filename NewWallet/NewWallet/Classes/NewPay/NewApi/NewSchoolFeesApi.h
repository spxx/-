//
//  NewSchoolFeesApi.h
//  Wallet
//
//  Created by mac1 on 16/1/18.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewSchoolFeesApi : NSObject

//获取新架构的缴费列表
+ (void)shoolFeesListWithCode:(NSString *)code
                      success:(void (^)(NSURLSessionDataTask *task,NSDictionary *successData))successMethod
                      failure:(void (^)(NSURLSessionDataTask *task,NSError *error))errorMethod;

//生成缴费订单
+ (void)create_OrderWithPrj_key:(NSString *)fees_prj_key
                         amount:(NSString *)amount
                  prj_child_key:(NSString *)prj_child_key
                       level_id:(NSString *)level_id
                        success:(void (^)(NSURLSessionDataTask *task,NSDictionary *successData))successMethod
                        failure:(void (^)(NSURLSessionDataTask *task,NSError *error))errorMethod;
@end
