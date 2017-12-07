//
//  UnionPayHttpTools.m
//  httpsRequest
//
//  Created by Lcyu on 14-7-11.
//  Copyright (c) 2014年 Lcyu. All rights reserved.
//

#import "UnionPayHttpTools.h"
#import "LoginApi.h"

#define kUnionPay_GetTN     @"/sim/getacptn"

@implementation UnionPayHttpTools

static AFHTTPRequestOperationManager *manager;
static UnionPayHttpTools *httpTools;

static NSString *baseUrl;

//GCD单例
+(UnionPayHttpTools *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpTools = [[UnionPayHttpTools alloc]init];
       
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
              successed(responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              failured(error);
          }];
}

//银联支付，获取TN码
- (void)unionPay_GetTNWithSuccess:(void (^)(NSDictionary *))successMethod
                          failure:(void (^)(NSError *))errorMethod
{
//    NSDictionary *reportLossInfo = @{
//                                     @"student_no":student_no,
//                                     @"school_id":school_id
//                                     };
    [self JsonGetRequst:kUnionPay_GetTN parameters:nil success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}
@end