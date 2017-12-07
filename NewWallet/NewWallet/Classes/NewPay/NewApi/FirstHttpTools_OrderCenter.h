//
//  FirstHttpTools_OrderCenter.h
//  httpsRequest
//
//  Created by Lcyu on 14-7-11.
//  Copyright (c) 2014年 Lcyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"


#ifdef SERVER_114
//114测试环境,电费使用
static  NSString *Newpay_BASE_URL = @"http://192.168.1.114";

#elif SERVER_HTTP
//灰度HTTP环境
static  NSString *Newpay_BASE_URL = @"http://api.bionictech.cn";


#elif SERVER_HTTPS
static  NSString *Newpay_BASE_URL = @"https://api.bionictech.cn";
#endif

@interface FirstHttpTools_OrderCenter : NSObject


//http请求单例
+(FirstHttpTools_OrderCenter *)shareInstance;

//Get请求JSON数据方法
-(void)JsonGetRequst:(NSString *)url parameters:(NSDictionary *) parameters
             success:(void(^)(id responseObject)) successed
             failure:(void(^)(NSError *error)) failured;

//Post请求JSON数据方法
-(void)JsonPostRequst:(NSString *)url parameters:(NSDictionary *) parameters
              success:(void(^)(id responseObject)) successed
              failure:(void(^)(NSError *error)) failured;



@end