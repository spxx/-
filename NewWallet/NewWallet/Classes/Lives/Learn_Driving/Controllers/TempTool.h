//
//  TempTool.h
//  Wallet
//
//  Created by mac1 on 16/6/2.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TempTool : NSObject



//此tool 仅用于访问罗璇或者张盛的IP，有时候还未部署到114上面

#define Temp_BASE_URL            @"http://192.168.1.114"
//http请求单例
+(TempTool *)shareInstance;

//Get请求JSON数据方法
-(void)JsonGetRequst:(NSString *)url parameters:(NSDictionary *) parameters
             success:(void(^)(id responseObject)) successed
             failure:(void(^)(NSError *error)) failured;

//Post请求JSON数据方法
-(void)JsonPostRequst:(NSString *)url parameters:(NSDictionary *) parameters
              success:(void(^)(id responseObject)) successed
              failure:(void(^)(NSError *error)) failured;

@end
