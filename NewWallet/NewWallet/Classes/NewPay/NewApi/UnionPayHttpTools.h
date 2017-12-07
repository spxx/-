//
//  UnionPayHttpTools.h
//  httpsRequest
//
//  Created by Lcyu on 14-7-11.
//  Copyright (c) 2014年 Lcyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"

static  NSString *Newpay_BASE_URL = @"https://101.231.204.84:8091";

@interface UnionPayHttpTools : NSObject


//http请求单例
+(UnionPayHttpTools *)shareInstance;

//Get请求JSON数据方法
-(void)JsonGetRequst:(NSString *)url parameters:(NSDictionary *) parameters
             success:(void(^)(id responseObject)) successed
             failure:(void(^)(NSError *error)) failured;

//Post请求JSON数据方法
-(void)JsonPostRequst:(NSString *)url parameters:(NSDictionary *) parameters
              success:(void(^)(id responseObject)) successed
              failure:(void(^)(NSError *error)) failured;

//银联支付，获取TN码
- (void)unionPay_GetTNWithSuccess:(void (^)(NSDictionary *))successMethod
                          failure:(void (^)(NSError *))errorMethod;


@end