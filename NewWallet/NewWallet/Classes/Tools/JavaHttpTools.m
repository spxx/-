//
//  JavaHttpTools.m
//  Wallet
//
//  Created by mac1 on 16/4/8.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "JavaHttpTools.h"

@implementation JavaHttpTools

static AFHTTPSessionManager *manager;
static NSString *content;
static JavaHttpTools *httpTools;

+ (JavaHttpTools *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpTools = [[JavaHttpTools alloc] init];
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
    NSURL *url = [NSURL URLWithString:JavaServer_BaseUrl];
    manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    manager.requestSerializer.timeoutInterval = 60;
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer = responseSerializer;
    manager.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", nil];
    
//    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
//    requestSerializer.HTTPShouldHandleCookies = NO;
//    manager.requestSerializer = requestSerializer;
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.securityPolicy = securityPolicy;
}

- (void)JsonGetRequst:(NSString *)url parameters:(NSDictionary *) parameters
             success:(void(^)(NSURLSessionDataTask *task,id responseObject))successed
             failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failured

{
    NSMutableDictionary *infoParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [infoParameters setObject:content forKey:@"os_info"];
    
    [manager GET:url
      parameters:infoParameters
         success:^(NSURLSessionDataTask *task, id responseObject) {
              successed(task,responseObject);
         }
         failure:^(NSURLSessionDataTask *task, NSError *error) {
             failured(task,error);
         }];
}

- (void)JsonPostRequst:(NSString *)url parameters:(NSDictionary *) parameters
              success:(void(^)(NSURLSessionDataTask *task,id responseObject))successed
              failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failured
{
    NSMutableDictionary *infoParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [infoParameters setObject:content forKey:@"os_info"];
    [manager POST:url
      parameters:infoParameters
         success:^(NSURLSessionDataTask *task, id responseObject) {
             successed(task,responseObject);
         }
         failure:^(NSURLSessionDataTask *task, NSError *error) {
             failured(task,error);
         }];
}

- (void)removeHttpCookie
{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    //清楚缓存
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
    
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", JavaServer_BaseUrl ,@"/school/business/app/platform/fee/list.action"]];
//    if (url) {
//        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
//        for (int i = 0; i < [cookies count]; i++) {
//            NSHTTPCookie *cookie = (NSHTTPCookie *)[cookies objectAtIndex:i];
//            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
//        }
//    }
    
}

@end
