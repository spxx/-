//
//  BannerApi.m
//  Wallet
//
//  Created by 陈荣雄 on 16/2/15.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "BannerApi.h"
#import "HttpTools.h"

@implementation BannerApi

#define GET_AD_INFO @"/external/push_msg/info_center/get_ad_info"

//static NSString *const query_school_biz_code = @"/external/config_center/v3/query_school_biz";

static NSString *const query_activities_list = @"/external/config_center/v1/query_activities_list";

//static NSString *const query_school_biz_code = @"/business/app/api/list.action";

//#define CHECK_SERVICE_STATUS        @"/app/business/config/version_1/status.action"
//#define URL_CHECK_SERVICE_STATUS     @"/app/business/config/version_1/urlStatus.action"
#define CHECK_SERVICE_STATUS        @"/app/business/config/version_1/appShowBizStatus.action"
#define URL_CHECK_SERVICE_STATUS     @"/app/business/config/version_1/appShowBizUrlStatus.action"

#define OLD_CHECK_SERVICE_STATUS    @"/app/v4/check_service"

#define EVENT_STREAM @"/events_stream/external/v1/events"
#define EVENT_HISTORY @"/events_stream/external/v1/history_events"
#define EVENT_CLOSE @"/events_stream/external/v1/cancel"
#define URL_getLaunchAD     @"/app/business/config/version_1/adv/getFlashScreenBackgroundPicture.action"
#define URL_getHomeWindowAD     @"/app/business/config/version_1/adv/getFloatBackgroundPicture.action"
#define EVENT_mark_as_read  @"/events_stream/external/v1/mark_as_read"

#define HomeVCGetElecBalance  @"/school/h5/electricity/getElectricityFeeBalance.action"   //获取电费余额

static NSString *const query_school_biz_code = @"/app/business/config/version_1/appShowList.action";
//static NSString *const query_school_biz_code = @"/app/business/config/version_1/list.action";


static HttpTools *tool;

+(void)initialize
{
    tool = [HttpTools shareInstance];
}

+ (void)getBannerData:(void (^)(NSDictionary *returnData))successMethod failure:(void (^)(NSError *error)) errorMethod {
    [tool JsonGetRequst:GET_AD_INFO parameters:nil success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

//首页九宫格数据-查询学校业务
+ (void)querySchoolBizCodeWithBiz_area:(NSString *)biz_area
                           success:(void (^)(NSDictionary *successData))successMethod
                           failure:(void (^)(NSError *error)) errorMethod
{
//    NSDictionary *requstData = @{@"biz_area": biz_area,
//                                 };
    NSDictionary *requstData = @{};
    [tool JsonPostRequst:query_school_biz_code
              parameters:requstData
                 success:^(id responseObject) {
                     successMethod(responseObject);
                 }
                 failure:^(NSError *error) {
                     errorMethod(error);
                 }];
    
}
//获取喜付特权-活动列表
+ (void)queryActivitiesListWithSuccess:(void (^)(NSDictionary *successData))successMethod
                              failure:(void (^)(NSError *error)) errorMethod
{
    [tool JsonPostRequst:query_activities_list
              parameters:nil
                 success:^(id responseObject) {
                     successMethod(responseObject);
                 }
                 failure:^(NSError *error) {
                     errorMethod(error);
                 }];
    
}
//获取事件流
+ (void)getEventFlow:(void (^)(NSDictionary *))successMethod
            failure:(void (^)(NSError *))errorMethod
{
    [[HttpTools shareInstance] JsonGetRequst:EVENT_STREAM parameters:nil success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

//获取已处理事件
+ (void)getEventHistoryFlowPage:(NSInteger)page
                        success:(void (^)(NSDictionary *))successMethod
                        failure:(void (^)(NSError *))errorMethod
{
    NSDictionary *params = @{@"page": @(page)};
    [[HttpTools shareInstance] JsonGetRequst:EVENT_HISTORY parameters:params success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

//注销事件
+ (void)closeEvent:(NSInteger)eventId
           success:(void (^)(NSDictionary *))successMethod
           failure:(void (^)(NSError *))errorMethod
{
    NSDictionary *params = @{@"event_id": @(eventId)};
    [[HttpTools shareInstance] JsonPostRequst:EVENT_CLOSE parameters:params success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}
//事件标记为已读
+ (void)markAsReadEventWithSuccess:(void (^)(NSDictionary *))successMethod
                           failure:(void (^)(NSError *))errorMethod
{
    [[HttpTools shareInstance] JsonGetRequst:EVENT_mark_as_read parameters:nil success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

//检查业务是否正常可用
+(void)pythonCheckService:(NSString *)userid
                   busiId:(NSString *)busiId
                  success:(void (^)(NSDictionary *))successMethod
                  failure:(void (^)(NSError *))errorMethod{
    
    NSDictionary *requstData = @{
                                 @"userid": userid,
                                 @"busi_type": busiId,
                                 };
    [[HttpTools shareInstance] JsonPostRequst:OLD_CHECK_SERVICE_STATUS parameters:requstData success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}
//业务开通状态检查-busiId异步请求
+ (void)checkServiceAsynchronousStatus:(NSString *)userid
                                busiId:(NSString *)busiId
                               success:(void (^)(NSDictionary *))successMethod
                               failure:(void (^)(NSError *))errorMethod
{
    NSDictionary *requstData = @{
                                 @"userid": userid,
                                 @"biz_id": busiId,
                                 };
    [[HttpTools shareInstance] JsonPostRequst:CHECK_SERVICE_STATUS parameters:requstData success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];

}
//业务开通状态检查-biz_url异步请求
+ (void)urlCheckServiceAsynchronousStatus:(NSString *)userid
                                   busiUrl:(NSString *)busiurl
                                  success:(void (^)(NSDictionary *))successMethod
                                  failure:(void (^)(NSError *))errorMethod
{
    NSDictionary *requstData = @{
                                 @"userid": userid,
                                 @"biz_url": busiurl,
                                 };
    [[HttpTools shareInstance] JsonPostRequst:URL_CHECK_SERVICE_STATUS parameters:requstData success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
    
}
//业务开通状态检查-busiId同步请求
+ (void)checkServiceSynchronousStatus:(NSString *)userid
                               busiId:(NSString *)busiId
                              success:(void(^)(NSDictionary *))successHandler
                              failure:(void (^)(NSString *errorMsg))errorHandler
{
    //获取checkService
    NSString *urlStr2 = [NSString stringWithFormat:@"%@%@", BASE_URL, CHECK_SERVICE_STATUS];
    NSDictionary *postParam = @{@"userid": userid,
                                @"biz_id": busiId,
                                };
    NSDictionary *backDict = [self synchronousWithUrl:urlStr2 request:postParam];
    if (!backDict) {
        errorHandler(@"系统维护中, 暂不可用!");
        return ;
    }
    NSString *retCode = [backDict valueNotNullForKey:kRequestRetCode];
    if ([retCode isEqualToString:kRequestNewSuccessCode]) {
        NSDictionary *retData = [backDict valueForKey:kRequestReturnData];
        NSString *biz_open_flag = [retData valueNotNullForKey:@"biz_open_flag"];
//            NSString *payStatus = [retData valueNotNullForKey:@"pay_status"];
//            NSString *systemStatus = [retData valueNotNullForKey:@"system_status"];

        if ([biz_open_flag integerValue] == 1) {
            [SVProgressHUD dismiss];
            successHandler(backDict);
            return;
        } else {
            errorHandler(@"业务暂未开通，敬请期待！");
        }
    } else {
        NSString *errorMsg = [backDict valueNotNullForKey:kRequestRetMessage];
        if (!errorMsg && errorMsg.length <= 0) {
            errorHandler(@"业务暂未开通，敬请期待！");
        }
        errorHandler(errorMsg);
    }
}
//业务开通状态检查-biz_url同步请求
+ (void)urlCheckServiceSynchronousStatus:(NSString *)userid
                                 biz_url:(NSString *)biz_url
                                 success:(void(^)(NSDictionary *))successHandler
                                 failure:(void (^)(NSString *errorMsg))errorHandler
{
    //url获取checkService
    NSString *urlStr2 = [NSString stringWithFormat:@"%@%@", BASE_URL, URL_CHECK_SERVICE_STATUS];
    NSDictionary *postParam = @{@"userid": userid,
                                @"biz_url": biz_url,
                                };
    NSDictionary *backDict = [self synchronousWithUrl:urlStr2 request:postParam];
    if (!backDict) {
        errorHandler(@"系统维护中, 暂不可用!");
        return ;
    }
    NSString *retCode = [backDict valueNotNullForKey:kRequestRetCode];
    if ([retCode isEqualToString:kRequestNewSuccessCode]) {
        NSDictionary *retData = [backDict valueForKey:kRequestReturnData];
        NSString *biz_open_flag = [NSString stringWithFormat:@"%@", [retData valueWithNoDataForKey:@"biz_open_flag"]];
        NSString *biz_h5_url = [NSString stringWithFormat:@"%@", [retData valueWithNoDataForKey:@"biz_h5_url"]];
        //            NSString *systemStatus = [retData valueNotNullForKey:@"system_status"];
        
        if ([biz_open_flag integerValue] == 1) {
            [SVProgressHUD dismiss];
            successHandler(retData);
            return;
        } else if (biz_open_flag.length <= 0 && biz_h5_url.length <= 0) {
            [SVProgressHUD dismiss];
            successHandler(retData);
            return;
        }{
            errorHandler(@"业务暂未开通，敬请期待！");
        }
    }else {
        NSString *errorMsg = [backDict valueNotNullForKey:kRequestRetMessage];
        if (!errorMsg && errorMsg.length <= 0) {
            errorHandler(@"业务暂未开通，敬请期待！");
        }
        errorHandler(errorMsg);
    }

}
//同步getCode
+ (NSString *)getCodeString
{
    //第一步，创建URL
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", BASE_URL, @"/openapi/version_1.0/auth/auth_code"];
    NSDictionary *postParam = @{@"code":@"code"};
    
    NSDictionary *backDict = [self synchronousWithUrl:urlStr request:postParam];
    if (!backDict) {
        [SVProgressHUD showErrorWithStatus:@"系统维护中, 暂不可用!"];
        return nil;
    }
    if ([[backDict valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestNewSuccessCode]) {
        NSDictionary *data = [backDict valueNotNullForKey:@"data"];
        NSString *code = data[@"code"];
        BNLog(@"同步get-code--->>>%@",code);
        if (code || code.length > 0) {
            return code;
        }
    }
    return nil;

}
//同步请求
+ (NSDictionary *)synchronousWithUrl:(NSString *)urlStr
                             request:(NSDictionary *)retData
{
    //第一步，创建URL
    NSURL *url = [NSURL URLWithString:urlStr];
    NSString *postParam = @"";
    for (NSString *key in [retData allKeys]) {
        postParam = [postParam stringByAppendingString:[NSString stringWithFormat:@"%@=%@&", key, [retData valueForKey:key]]];
    }
    //第二步，创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
    [request setHTTPMethod:@"POST"];
    [request HTTPShouldHandleCookies];
    NSData *data = [postParam dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:data];
    
    //第三步，连接服务器
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (received) {
        NSError *error = nil;
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingAllowFragments error:&error];
        BNLog(@"synchronousRequest--jsonObject%@",jsonObject);
        return jsonObject;
    }
    return nil;
    
    

}
//获取启动广告
+ (void)getLaunchADDataSuccess:(void (^)(NSDictionary *))successMethod
                       failure:(void (^)(NSError *))errorMethod
{
    [[HttpTools shareInstance] JsonPostRequst:URL_getLaunchAD parameters:nil success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}
//获取Home浮层广告
+ (void)getHomeWindowADSuccess:(void (^)(NSDictionary *))successMethod
                       failure:(void (^)(NSError *))errorMethod
{
    [[HttpTools shareInstance] JsonPostRequst:URL_getHomeWindowAD parameters:nil success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}
//获取电费余额
+ (void)homeVCGetElecBalanceSuccess:(void (^)(NSDictionary *))successMethod
                            failure:(void (^)(NSError *))errorMethod
{
    [[HttpTools shareInstance] JsonPostRequst:HomeVCGetElecBalance parameters:nil success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

@end
