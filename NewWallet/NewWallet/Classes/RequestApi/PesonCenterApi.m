//
//  PesonCenterApi.m
//  Wallet
//
//  Created by mac1 on 16/7/12.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "PesonCenterApi.h"

@implementation PesonCenterApi

static HttpTools *tool;

NSString *const get_user_info = @"/app/member/v1/get_user_detail_info";

NSString *const bind_card_count = @"/app/v4/binded_cards_list";

NSString *const coupon_card_count = @"/coupon_server/external/v2/number_of_coupons";



+(void)initialize
{
    tool = [HttpTools shareInstance];
}

+ (AFHTTPRequestOperation *)get_user_detail_info:(void (^)(NSDictionary *returnData))successMethod
                     failure:(void (^)(NSError *error)) errorMethod
{
   return  [tool Operation_JsonPostRequst:get_user_info parameters:nil success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}


+ (AFHTTPRequestOperation *)get_bind_card_countWithCount_only:count_only
                                                      success:(void (^)(NSDictionary *returnData))successMethod
                                                      failure:(void (^)(NSError *error)) errorMethod
{
    //count_only=1只获取张数，0-获取整个列表
    return  [tool Operation_JsonPostRequst:bind_card_count parameters:@{@"count_only": count_only} success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

+ (AFHTTPRequestOperation *)get_coupon_card_count:(void (^)(NSDictionary *returnData))successMethod
                                        failure:(void (^)(NSError *error)) errorMethod
{
    
    return  [tool Operation_JsonPostRequst:coupon_card_count parameters:nil success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}


@end
