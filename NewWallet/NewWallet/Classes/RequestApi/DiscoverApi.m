//
//  DiscoverApi.m
//  Wallet
//
//  Created by mac1 on 16/7/12.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "DiscoverApi.h"

@implementation DiscoverApi


static NSString *const get_user_privilege_list = @"/app/member/v1/get_user_privilege_detail_list";

static HttpTools *tool;
+(void)initialize
{
    tool = [HttpTools shareInstance];
}

// 获取特权信息接口
+ (void)get_user_privilege_list:(void (^)(NSDictionary *returnData))successMethod
                        failure:(void (^)(NSError *error)) errorMethod
{
    [tool JsonPostRequst:get_user_privilege_list parameters:nil success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];

}


@end
