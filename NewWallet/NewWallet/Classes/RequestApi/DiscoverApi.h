//
//  DiscoverApi.h
//  Wallet
//
//  Created by mac1 on 16/7/12.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscoverApi : NSObject

// 获取特权信息接口
+ (void)get_user_privilege_list:(void (^)(NSDictionary *returnData))successMethod
                        failure:(void (^)(NSError *error)) errorMethod;

@end
