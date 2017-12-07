//
//  FirstHttpTools_OrderCenter.m
//  httpsRequest
//
//  Created by Lcyu on 14-7-11.
//  Copyright (c) 2014年 Lcyu. All rights reserved.
//

#import "FirstHttpTools_OrderCenter.h"
#import "LoginApi.h"


@implementation FirstHttpTools_OrderCenter

static AFHTTPRequestOperationManager *manager;
static FirstHttpTools_OrderCenter *httpTools;

static NSString *baseUrl;
static NSString *content;

//GCD单例
+(FirstHttpTools_OrderCenter *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpTools = [[FirstHttpTools_OrderCenter alloc]init];
        content = [[NSString alloc]
                   initWithFormat:
                   @"localized model: %@ \nsystem version: %@ \nsystem name: %@ \nmodel: %@ \napp version: %@" ,
                   
                   [[UIDevice currentDevice] localizedModel],
                   [[UIDevice currentDevice] systemVersion],
                   [[UIDevice currentDevice] systemName],
                   [[UIDevice currentDevice] model],
                   [[NSBundle mainBundle] objectForInfoDictionaryKey: kBundleKey]
                   ];
    });
    return httpTools;
}



//GCD单例
+(id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpTools = [super allocWithZone:zone];
        [self initManager];
    });
    return httpTools;
}

+(void)initManager
{
    NSURL *url = [NSURL URLWithString:Newpay_BASE_URL];
    manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    manager.requestSerializer.timeoutInterval = 40;
    
    AFJSONResponseSerializer *responseSerializer= [AFJSONResponseSerializer serializer];
    manager.responseSerializer = responseSerializer;

    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.securityPolicy = securityPolicy;
}


-(void)JsonGetRequst:(NSString *)url parameters:(NSDictionary *) parameters
             success:(void(^)(id responseObject)) successed
             failure:(void(^)(NSError *error)) failured

{
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successed(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failured(error);
    }];
}

-(void)JsonPostRequst:(NSString *)url parameters:(NSDictionary *) parameters
              success:(void(^)(id responseObject)) successed
              failure:(void(^)(NSError *error)) failured
{
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:url parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              successed(responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              failured(error);
          }];
}


@end
