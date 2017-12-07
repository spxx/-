//
//  BNUploadTools.m
//  Wallet
//
//  Created by mac1 on 15/5/7.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNUploadTools.h"
#import "HttpTools.h"
#import "FirstHttpTools_YJF.h"

@implementation BNUploadTools

#define kUploadFile_URL       @"/loan/app/v3/file_upload"
#define kTiXianLoadFile_URL   @"/withdraw/app/v3/file_upload"
#define kUploadAvatar_URL     @"/app/member/v1/upload_portrait_image"

static AFHTTPRequestOperationManager *manager;
static BNUploadTools *uploadTools;

static NSString *content;

//GCD单例
+(BNUploadTools *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        uploadTools = [[BNUploadTools alloc]init];
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
    return uploadTools;
}

//GCD单例
-(id)init
{
    self = [super init];
    if (self) {
        content = [[NSString alloc]
                   initWithFormat:
                   @"localized model: %@ \nsystem version: %@ \nsystem name: %@ \nmodel: %@ \napp version: %@" ,
                   
                   [[UIDevice currentDevice] localizedModel],
                   [[UIDevice currentDevice] systemVersion],
                   [[UIDevice currentDevice] systemName],
                   [[UIDevice currentDevice] model],
                   [[NSBundle mainBundle] objectForInfoDictionaryKey: kBundleKey]
                   ];
        
        [self initManager];
    }
    
    return self;
}


- (void)initManager{
    NSURL *url = [NSURL URLWithString:First_BaseURL];
    manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.securityPolicy = securityPolicy;
    
}
//提现上传文件
- (void)uploadTiXianFileWithParameters:(NSDictionary *)parameters
                               success:(void(^)(id responseObject)) successed
                              progress:(void(^)(long long totalBytesWritten, long long totalBytesExpectedToWrite))progress
                               failure:(void(^)(NSError *error)) failured
{
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSString *url = [NSString stringWithFormat:@"%@%@",First_BaseURL,kTiXianLoadFile_URL];
    NSError *error = nil;
    NSMutableURLRequest *request = [serializer multipartFormRequestWithMethod:@"POST"
                                                                    URLString:url
                                                                   parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                    {
                                        [formData appendPartWithFileData:[parameters valueForKey:@"up_file"]
                                                                    name:[parameters valueForKey:@"file_name"]
                                                                fileName:[NSString stringWithFormat:@"%@.%@", [parameters valueForKey:@"file_name"], [parameters valueForKey:@"file_type"]]
                                                                mimeType:[parameters valueForKey:@"mimeType"]];
                                        
                                    } error:&error];
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successed(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failured(error);
    }];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        BNLog(@"Wrote %lld/%lld", totalBytesWritten, totalBytesExpectedToWrite);
        progress(totalBytesWritten, totalBytesExpectedToWrite);
        
    }];
    
    [operation start];
}

//个人中心上传头像
- (void)uploadUserAvatarWithData:(NSData *)data
                         success:(void(^)(id responseObject)) successed
                        progress:(void(^)(long long totalBytesWritten, long long totalBytesExpectedToWrite))progress
                         failure:(void(^)(NSError *error)) failured
{
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSString *url = [NSString stringWithFormat:@"%@%@",First_BaseURL,kUploadAvatar_URL];
    NSError *error = nil;
    NSMutableURLRequest *request = [serializer multipartFormRequestWithMethod:@"POST"
                                                                    URLString:url
                                                                   parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                    {
                                                                                [formData appendPartWithFileData:data
                                                                                                            name:@"portrait_image"
                                                                                                        fileName:@"usr_avatar_file.png"
                                                                                                        mimeType:@"image/png"];
                                        
                                    } error:&error];
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successed(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failured(error);
    }];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//        BNLog(@"Wrote %lld/%lld", totalBytesWritten, totalBytesExpectedToWrite);
        progress(totalBytesWritten, totalBytesExpectedToWrite);
        
    }];
    [operation start];
}


//小额贷上传文件
-(void)JsonParameters:(NSDictionary *) parameters
                 type:(UploadFileType) fileType
              success:(void(^)(id responseObject)) successed
             progress:(void(^)(long long totalBytesWritten, long long totalBytesExpectedToWrite))progress
              failure:(void(^)(NSError *error)) failured
{
    
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    
    NSString *baseurl = (fileType == UploadFileTypeImage) ? UploadImageFile_BaseURL : UploadVideoFile_BaseURL;
    
    NSError *error =  nil;
    NSString *url = [NSString stringWithFormat:@"%@%@",baseurl, kUploadFile_URL];
    NSMutableURLRequest *request = [serializer multipartFormRequestWithMethod:@"POST" URLString:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:[parameters valueForKey:@"up_file"]
                                    name:[parameters valueForKey:@"file_name"]
                                fileName:[NSString stringWithFormat:@"%@.%@", [parameters valueForKey:@"file_name"], [parameters valueForKey:@"file_type"]]
                                mimeType:[parameters valueForKey:@"mimeType"]];

        
    } error:&error];
    
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request
                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {

                                         successed(responseObject);
                                     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         BNLog(@"%@", [error localizedDescription]);
                                         failured(error);
                                     }];

    [operation setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
                                        long long totalBytesWritten,
                                        long long totalBytesExpectedToWrite) {
        BNLog(@"Wrote %lld/%lld", totalBytesWritten, totalBytesExpectedToWrite);
        progress(totalBytesWritten, totalBytesExpectedToWrite);
    }];
    [operation start];
}


@end
