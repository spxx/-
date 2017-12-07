//
//  HttpTools.m
//  httpsRequest
//
//  Created by Lcyu on 14-7-11.
//  Copyright (c) 2014年 Lcyu. All rights reserved.
//

#import "HttpTools.h"
#import "KeychainItemWrapper.h"
#import "LoginApi.h"



@implementation HttpTools
static AFHTTPRequestOperationManager *manager;
static HttpTools *httpTools;

static NSString *content;

//GCD单例
+(HttpTools *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpTools = [[HttpTools alloc]init];
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
//    NSString *baseUrlStr = [[FirstHttpTools shareInstance] baseUrl];
    NSURL *url = [NSURL URLWithString:BASE_URL];
    manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    manager.requestSerializer.timeoutInterval = 60;
    manager.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain",@"text/html", nil];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.securityPolicy = securityPolicy;
}

-(void)JsonGetRequst:(NSString *)url
          parameters:(NSDictionary *)parameters
             headers:(NSDictionary *)headers
             success:(void(^)(id responseObject))successed
             failure:(void(^)(NSError *error))failured

{
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    for (NSString *key in headers.allKeys) {
        [requestSerializer setValue:headers[key] forHTTPHeaderField:key];
    }
    
    manager.requestSerializer = requestSerializer;
    
    NSMutableDictionary *infoParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [infoParameters setObject:content forKey:@"os_info"];
    
    [manager GET:url parameters:infoParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successed(responseObject);
        
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failured(error);
        
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
    }];
}

-(void)JsonGetRequst:(NSString *)url parameters:(NSDictionary *) parameters
             success:(void(^)(id responseObject)) successed
             failure:(void(^)(NSError *error)) failured

{ 
        NSMutableDictionary *infoParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [infoParameters setObject:content forKey:@"os_info"];
    
    [manager GET:url parameters:infoParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successed(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failured(error);
    }];
}

-(void)JsonPostRequst:(NSString *)url parameters:(NSDictionary *) parameters
              success:(void(^)(id responseObject)) successed
              failure:(void(^)(NSError *error)) failured
{
    
    NSMutableDictionary *infoParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [infoParameters setObject:content forKey:@"os_info"];

    [manager POST:url parameters:infoParameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
//              NSString *retCode = [responseObject valueNotNullForKey:kRequestRetCode];
//              if ([retCode isEqualToString:@"2002"]) {
//                  KeychainItemWrapper * keychinLogin = [[KeychainItemWrapper alloc]initWithIdentifier:kKeyChainAccessGroup_LastLoginUserId accessGroup:kKeyChainAccessGroup_LastLoginUserId];
//                  NSString *phoneNum = [keychinLogin objectForKey:(__bridge id)kSecAttrAccount];
////                  NSString *userId = [keychinLogin objectForKey:(__bridge id)kSecAttrDescription];
//                  
////                  KeychainItemWrapper *keychinGesture = [[KeychainItemWrapper alloc]initWithIdentifier:userId accessGroup:kKeyChainAccessGroup_Gesture];
////                  NSString *gesturePwd = [keychinGesture objectForKey:(__bridge id)kSecValueData];
////                  if ([gesturePwd isEqualToString:@""]) {//用户没有设置手势密码
////                      return;
////                  }
//                  
//                  if (phoneNum.length <= 0) {
//                      return ;
//                  }
//                  NSDictionary *loginInfo = @{@"mobile":phoneNum,
//                                              @"password":pwd};
//                  [LoginApi loginWithUsernameAndPwd:loginInfo
//                                            success:^(NSDictionary *successData) {
//                                                BNLog(@"后台重新登陆：%@", successData);
//                                            } failure:^(NSError *error) {
//                                            }];
//              }
            successed(responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              failured(error);
          }];
}

- (AFHTTPRequestOperation *)Operation_JsonPostRequst:(NSString *)url parameters:(NSDictionary *) parameters
                                             success:(void(^)(id responseObject)) successed
                                             failure:(void(^)(NSError *error)) failured
{
    NSMutableDictionary *infoParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [infoParameters setObject:content forKey:@"os_info"];
    return  [manager POST:url parameters:infoParameters
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
              successed(responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              failured(error);
          }];
}
@end
