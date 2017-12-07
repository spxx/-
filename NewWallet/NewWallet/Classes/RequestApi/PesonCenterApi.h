//
//  PesonCenterApi.h
//  Wallet
//
//  Created by mac1 on 16/7/12.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PesonCenterApi : NSObject

//获取用户详细信息接口
+ (AFHTTPRequestOperation *)get_user_detail_info:(void (^)(NSDictionary *returnData))successMethod
                                         failure:(void (^)(NSError *error)) errorMethod;


// 获取用户绑卡张数
+ (AFHTTPRequestOperation *)get_bind_card_countWithCount_only:count_only
                                                      success:(void (^)(NSDictionary *returnData))successMethod
                                                      failure:(void (^)(NSError *error)) errorMethod;


// 获取卡券数量
+ (AFHTTPRequestOperation *)get_coupon_card_count:(void (^)(NSDictionary *returnData))successMethod
                                          failure:(void (^)(NSError *error)) errorMethod;

@end
