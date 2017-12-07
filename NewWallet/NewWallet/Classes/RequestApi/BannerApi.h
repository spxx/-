//
//  BannerApi.h
//  Wallet
//
//  Created by 陈荣雄 on 16/2/15.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BannerApi : NSObject

+ (void)getBannerData:(void (^)(NSDictionary *returnData))successMethod failure:(void (^)(NSError *error)) errorMethod;

//首页九宫格数据-查询学校业务
+ (void)querySchoolBizCodeWithBiz_area:(NSString *)biz_area
                               success:(void (^)(NSDictionary *successData))successMethod
                               failure:(void (^)(NSError *error)) errorMethod;

//获取喜付特权-活动列表
+ (void)queryActivitiesListWithSuccess:(void (^)(NSDictionary *successData))successMethod
                               failure:(void (^)(NSError *error)) errorMethod;

//获取事件流
+ (void)getEventFlow:(void (^)(NSDictionary *))successMethod
             failure:(void (^)(NSError *))errorMethod;

//检查业务是否正常可用
+(void)pythonCheckService:(NSString *)userid
                   busiId:(NSString *)busiId
                  success:(void (^)(NSDictionary *))successMethod
                  failure:(void (^)(NSError *))errorMethod;
//获取已处理事件
+ (void)getEventHistoryFlowPage:(NSInteger)page
                        success:(void (^)(NSDictionary *))successMethod
                        failure:(void (^)(NSError *))errorMethod;

//注销事件
+ (void)closeEvent:(NSInteger)eventId
           success:(void (^)(NSDictionary *))successMethod
           failure:(void (^)(NSError *))errorMethod;
//事件标记为已读
+ (void)markAsReadEventWithSuccess:(void (^)(NSDictionary *))successMethod
                           failure:(void (^)(NSError *))errorMethod;

//业务开通状态检查-busiId同步请求
+ (void)checkServiceSynchronousStatus:(NSString *)userid
                               busiId:(NSString *)busiId
                              success:(void(^)(NSDictionary *))successHandler
                              failure:(void (^)(NSString *errorMsg))errorHandler;
//业务开通状态检查-biz_url同步请求
+ (void)urlCheckServiceSynchronousStatus:(NSString *)userid
                                 biz_url:(NSString *)biz_url
                                 success:(void(^)(NSDictionary *))successHandler
                                 failure:(void (^)(NSString *errorMsg))errorHandler;

//业务开通状态检查-busiId异步请求
+ (void)checkServiceAsynchronousStatus:(NSString *)userid
                                busiId:(NSString *)busiId
                               success:(void (^)(NSDictionary *successData))successMethod
                               failure:(void (^)(NSError *error))errorMethod;
//业务开通状态检查-biz_url异步请求
+ (void)urlCheckServiceAsynchronousStatus:(NSString *)userid
                                  busiUrl:(NSString *)busiurl
                                  success:(void (^)(NSDictionary *))successMethod
                                  failure:(void (^)(NSError *))errorMethod;
//同步getCode
+ (NSString *)getCodeString;

//获取启动广告
+ (void)getLaunchADDataSuccess:(void (^)(NSDictionary *))successMethod
                       failure:(void (^)(NSError *))errorMethod;
//获取Home浮层广告
+ (void)getHomeWindowADSuccess:(void (^)(NSDictionary *))successMethod
                       failure:(void (^)(NSError *))errorMethod;

//获取电费余额
+ (void)homeVCGetElecBalanceSuccess:(void (^)(NSDictionary *))successMethod
                            failure:(void (^)(NSError *))errorMethod;

@end
