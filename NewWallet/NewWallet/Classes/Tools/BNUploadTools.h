//
//  BNUploadTools.h
//  Wallet
//
//  Created by mac1 on 15/5/7.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>
//文件类型
typedef NS_ENUM(NSInteger, UploadFileType) {
    UploadFileTypeImage,         //照片
    UploadFileTypeVedio,         //视频
};
@interface BNUploadTools : NSObject

//提现上传文件
- (void)uploadTiXianFileWithParameters:(NSDictionary *)parameters
                               success:(void(^)(id responseObject)) successed
                              progress:(void(^)(long long totalBytesWritten, long long totalBytesExpectedToWrite))progress
                               failure:(void(^)(NSError *error)) failured;

+(BNUploadTools *)shareInstance;



//小额贷上传文件
-(void)JsonParameters:(NSDictionary *) parameters
                 type:(UploadFileType) fileType
              success:(void(^)(id responseObject)) successed
             progress:(void(^)(long long totalBytesWritten, long long totalBytesExpectedToWrite))progress
              failure:(void(^)(NSError *error)) failured;


// 个人中心上传头像
- (void)uploadUserAvatarWithData:(NSData *)data
                               success:(void(^)(id responseObject)) successed
                              progress:(void(^)(long long totalBytesWritten, long long totalBytesExpectedToWrite))progress
                               failure:(void(^)(NSError *error)) failured;


@end
