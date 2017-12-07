//
//  JavaHttpTools.h
//  Wallet
//
//  Created by mac1 on 16/4/8.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


#ifdef SERVER_114

//测试环境-配合114环境使用
//#define JavaServer_BaseUrl @"http://192.168.0.114"
#define JavaServer_BaseUrl @"http://192.168.0.104:8080"

#elif SERVER_HTTP
//http灰度环境
#define JavaServer_BaseUrl @"http://139.196.155.133:8080"

//#define JavaServer_BaseUrl @"http://www.xifuapp.com"
#elif SERVER_HTTPS
//正式https环境
#define JavaServer_BaseUrl @"https://www.xifuapp.com"

#endif

//#define kSchoolFessH5Url [NSString stringWithFormat:@"%@/school/h5/collect/forCollectFeeList.action",JavaServer_BaseUrl]
//#define kCollectFeesH5Url  [NSString stringWithFormat:@"%@/school/h5/send/forSendFeeList.action",JavaServer_BaseUrl]
//#define kElectricityH5Url  [NSString stringWithFormat:@"%@/school/h5/electricity/info.action",JavaServer_BaseUrl]

//一卡通退费
#define krefundFeesH5Url  [NSString stringWithFormat:@"%@/school/h5/back/onecard/forOneCardBackApply.action",JavaServer_BaseUrl]
//#define kBindStumpH5Url   [NSString stringWithFormat:@"%@/app/web_files/v1/business/studentInfo/bindSid.html",JavaServer_BaseUrl]




@interface JavaHttpTools : NSObject


+ (JavaHttpTools *)shareInstance;

- (void)JsonGetRequst:(NSString *)url parameters:(NSDictionary *) parameters
             success:(void(^)(NSURLSessionDataTask *task,id responseObject))successed
             failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failured;

- (void)JsonPostRequst:(NSString *)url parameters:(NSDictionary *) parameters
              success:(void(^)(NSURLSessionDataTask *task,id responseObject))successed
              failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failured;

- (void)removeHttpCookie;

@end
