//
//  UnionPayApi.h
//  Wallet
//
//  Created by mac on 2017/3/29.
//  Copyright © 2017年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnionPayApi : NSObject

//获取银联银行卡管理H5页面-返回URL。
+ (void)getUnionBankListURLSucceed:(void (^)(NSDictionary *returnData))successMethod
                           failure:(void (^)(NSError *error)) errorMethod;

//获取银联支付设置H5页面-返回URL。
+ (void)getUnionPaySettingURLSucceed:(void (^)(NSDictionary *returnData))successMethod
                             failure:(void (^)(NSError *error)) errorMethod;


@end
