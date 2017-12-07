//
//  FirstHttpTools_YJF.h
//  httpsRequest
//
//  Created by Lcyu on 14-7-11.
//  Copyright (c) 2014年 Lcyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"



//UploadImageFile_BaseURL 小额贷上传照片文件使用
//UploadVideoFile_BaseURL  以前上传视频文件使用，现在暂时无用


#ifdef SERVER_114
//114测试环境,电费使用
static  NSString *Newpay_BASE_URL = @"http://192.168.1.114";

#elif SERVER_HTTP
//灰度HTTP环境
static  NSString *Newpay_BASE_URL = @"http://api.bionictech.cn";

#elif SERVER_HTTPS
//正式HTTPs环境
static  NSString *Newpay_BASE_URL = @"https://api.bionictech.cn";
#endif




@interface FirstHttpTools_YJF : NSObject


//http请求单例
+(FirstHttpTools_YJF *)shareInstance;

//Get请求JSON数据方法
-(void)JsonGetRequst:(NSString *)url parameters:(NSDictionary *) parameters
             success:(void(^)(id responseObject)) successed
             failure:(void(^)(NSError *error)) failured;

//Post请求JSON数据方法
-(void)JsonPostRequst:(NSString *)url parameters:(NSDictionary *) parameters
              success:(void(^)(id responseObject)) successed
              failure:(void(^)(NSError *error)) failured;



@end