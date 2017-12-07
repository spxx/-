//
//  TempTool.m
//  Wallet
//
//  Created by mac1 on 16/6/2.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "TempTool.h"

@implementation TempTool

static AFHTTPRequestOperationManager *manager;
static TempTool *tempTool;

static NSString *content;

//GCD单例
+(TempTool *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tempTool = [[TempTool alloc]init];
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
    return tempTool;
}

//GCD单例
+(id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tempTool = [super allocWithZone:zone];
        [self initManager];
    });
    return tempTool;
}

+(void)initManager
{
    //    NSString *baseUrlStr = [[FirstHttpTools shareInstance] baseUrl];
    NSURL *url = [NSURL URLWithString:Temp_BASE_URL];
    manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    manager.requestSerializer.timeoutInterval = 60;
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.securityPolicy = securityPolicy;
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
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:url parameters:infoParameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                successed(responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              failured(error);
          }];
}


@end
