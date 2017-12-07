//
//  FirstHttpTools.h
//  httpsRequest
//
//  Created by Lcyu on 14-7-11.
//  Copyright (c) 2014年 Lcyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"



#ifdef SERVER_114

//211测试环境,小额贷
#define kBASE_URL                   @"http://211.149.198.113"
#define UploadImageFile_BaseURL     @"http://211.149.198.113"
#define UploadVideoFile_BaseURL     @"http://211.149.198.113"

#elif SERVER_HTTP
//http灰度环境
#define kBASE_URL                   @"http://api.bionictech.cn"
#define UploadImageFile_BaseURL     @"http://api.bionictech.cn"
#define UploadVideoFile_BaseURL     @"http://api.bionictech.cn"

#elif SERVER_HTTPS
//正式环境,小额贷
#define kBASE_URL                   @"https://api.bionictech.cn"
#define UploadImageFile_BaseURL     @"https://api.bionictech.cn"
#define UploadVideoFile_BaseURL     @"https://api.bionictech.cn"

#endif



@interface FirstHttpTools : NSObject


//http请求单例
+(FirstHttpTools *)shareInstance;

//Get请求JSON数据方法
-(void)JsonGetRequst:(NSString *)url parameters:(NSDictionary *) parameters
             success:(void(^)(id responseObject)) successed
             failure:(void(^)(NSError *error)) failured;

//Post请求JSON数据方法
-(void)JsonPostRequst:(NSString *)url parameters:(NSDictionary *) parameters
              success:(void(^)(id responseObject)) successed
              failure:(void(^)(NSError *error)) failured;



@end