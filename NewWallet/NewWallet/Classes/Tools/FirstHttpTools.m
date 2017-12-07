//
//  FirstHttpTools.m
//  httpsRequest
//
//  Created by Lcyu on 14-7-11.
//  Copyright (c) 2014年 Lcyu. All rights reserved.
//

#import "FirstHttpTools.h"
#import "LoginApi.h"


@implementation FirstHttpTools

static AFHTTPRequestOperationManager *manager;
static FirstHttpTools *httpTools;

static NSString *baseUrl;
static NSString *content;

//GCD单例
+(FirstHttpTools *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpTools = [[FirstHttpTools alloc]init];
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
    NSURL *url = [NSURL URLWithString:@""];
    manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    manager.requestSerializer.timeoutInterval = 60;
    
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


@end