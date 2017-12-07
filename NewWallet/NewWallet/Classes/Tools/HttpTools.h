//
//  HttpTools.h
//  httpsRequest
//
//  Created by Lcyu on 14-7-11.
//  Copyright (c) 2014年 Lcyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
#import <YJPaySDK/YJPaySDKDefine.h>

//First_BaseURL 只有实名认证的时候才用;

#ifdef SERVER_114
//114测试环境
#define BASE_URL            @"http://192.168.1.114"
#define First_BaseURL       @"http://192.168.1.114"
#define YJPayServerType   ENV_SERVER_SNET      //易极付联调环境
#define kH5CouponVCUrl    [NSString stringWithFormat:@"%@/app/web_files/v1/business/cardCoupons/paycoupons.html",BASE_URL] //优惠券H5
#define kBindStumpH5Url   [NSString stringWithFormat:@"%@/app/web_files/v1/business/studentInfo/bindSid.html",JavaServer_BaseUrl] //绑定一卡通H5
#define kPayResultH5Url   [NSString stringWithFormat:@"%@/static/web_app/business/payment/index.html",BASE_URL] //支付结果H5

#define KBNScanedByShopVC_IntroduceUrl     [NSString stringWithFormat:@"%@/static/xifu_files/schools/payment/paymentIntro.html" ,BASE_URL] //付款码，说明页面
#define KBNScanedByShopVC_QR_paymentAuthorize   [NSString stringWithFormat:@"%@/static/web_app/test_business/paymentAuthorize/index.html" ,BASE_URL]//付款码，二维码付款授权页面
#define KBNScanedByShopVC_QR_payment   [NSString stringWithFormat:@"%@/static/web_app/test_business/qrPay/index.html" ,BASE_URL] //付款码，查询有订单则跳转H5一卡通支付页面
#define KBNScanedByShopVC_QR_payResult   [NSString stringWithFormat:@"%@/static/web_app/test_business/payment/qrPayResult.html",BASE_URL]//付款码，支付结果页面，只用于判断跳转
#define KBNScanedByShopVC_QR_yktPayManage   [NSString stringWithFormat:@"%@/static/web_app/test_business/qrPay/yktPayManage.html",BASE_URL]//一卡通支付管理页面。
#define KUserCenter_VeinInfo_H5BindVC  [NSString stringWithFormat:@"%@/static/web_app/test_venueH5/tideCard.html?fromVeinInfo=1",BASE_URL]//个人中心-静脉信息，静脉绑定页面H5。 //此H5是共用的体育场馆的静脉绑定页面,故在后面拼接了字段做区分。
#define KUserCenter_VeinInfo_H5BindBack   [NSString stringWithFormat:@"%@/static/web_app/test_venueH5/index.html",BASE_URL]//个人中心-静脉信息，H5绑定完成的跳转URL，如果跳转此URL，则本地拦截并返回上一页。//此H5是共用的体育场馆的静脉绑定页面，所以此页面其实是场馆首页。


#elif SERVER_HTTP
//正式环境http （灰度）
#define BASE_URL          @"http://api.bionictech.cn"
#define First_BaseURL     @"http://api.bionictech.cn"
#define YJPayServerType   ENV_SERVER_RELEASE   //易极付正式环境
#define kH5CouponVCUrl    [NSString stringWithFormat:@"%@/static/web_app/test_business/cardCoupons/paycoupons.html",BASE_URL] //优惠券H5
#define kBindStumpH5Url   [NSString stringWithFormat:@"%@/static/web_app/test_business/studentInfo/bindSid.html",BASE_URL] //绑定一卡通H5
#define kPayResultH5Url   [NSString stringWithFormat:@"%@/static/web_app/test_business/payment/index.html",BASE_URL] //支付结果H5

#define KBNScanedByShopVC_IntroduceUrl     [NSString stringWithFormat:@"%@/static/xifu_files/schools/payment/paymentIntro.html" ,BASE_URL] //付款码，说明页面
#define KBNScanedByShopVC_QR_paymentAuthorize   [NSString stringWithFormat:@"%@/static/web_app/test_business/paymentAuthorize/index.html" ,BASE_URL]   //付款码，二维码付款授权页面
#define KBNScanedByShopVC_QR_payment   [NSString stringWithFormat:@"%@/static/web_app/test_business/qrPay/index.html" ,BASE_URL] //付款码，查询有订单则跳转H5一卡通支付页面
#define KBNScanedByShopVC_QR_payResult   [NSString stringWithFormat:@"%@/static/web_app/test_business/payment/qrPayResult.html",BASE_URL]//付款码，支付结果页面，只用于判断跳转
#define KBNScanedByShopVC_QR_yktPayManage   [NSString stringWithFormat:@"%@/static/web_app/test_business/qrPay/yktPayManage.html",BASE_URL]//一卡通支付管理页面。
#define KUserCenter_VeinInfo_H5BindVC  [NSString stringWithFormat:@"%@/static/web_app/test_venueH5/tideCard.html?fromVeinInfo=1",BASE_URL]//个人中心-静脉信息，静脉绑定页面H5。 //此H5是共用的体育场馆的静脉绑定页面,故在后面拼接了字段做区分。
#define KUserCenter_VeinInfo_H5BindBack   [NSString stringWithFormat:@"%@/static/web_app/test_venueH5/index.html",BASE_URL]//个人中心-静脉信息，H5绑定完成的跳转URL，如果跳转此URL，则本地拦截并返回上一页。//此H5是共用的体育场馆的静脉绑定页面，所以此页面其实是场馆首页。


#elif SERVER_HTTPS
//正式环境https
#define BASE_URL          @"https://api.bionictech.cn"
#define First_BaseURL     @"https://api.bionictech.cn"
#define YJPayServerType   ENV_SERVER_RELEASE   //易极付正式环境
//#define kH5CouponVCUrl    [NSString stringWithFormat:@"%@/static/web_app/business/cardCoupons/paycoupons.html",BASE_URL] //优惠券H5 //4.7.2以前
#define kH5CouponVCUrl    [NSString stringWithFormat:@"%@/static/web_app/business/cardCoupons/newpaycoupons.html",BASE_URL] //优惠券H5 //4.7.2及以后
#define kBindStumpH5Url   [NSString stringWithFormat:@"%@/static/web_app/business/studentInfo/bindSid.html",BASE_URL] //绑定一卡通H5
#define kPayResultH5Url   [NSString stringWithFormat:@"%@/static/web_app/business/payment/index.html",BASE_URL] //支付结果H5

#define KBNScanedByShopVC_IntroduceUrl     [NSString stringWithFormat:@"%@/static/xifu_files/schools/payment/paymentIntro.html" ,BASE_URL] //付款码，说明页面
#define KBNScanedByShopVC_QR_paymentAuthorize   [NSString stringWithFormat:@"%@/static/web_app/business/paymentAuthorize/index.html" ,BASE_URL]//付款码，二维码付款授权页面
#define KBNScanedByShopVC_QR_payment   [NSString stringWithFormat:@"%@/static/web_app/business/qrPay/index.html" ,BASE_URL] //付款码，查询有订单则跳转H5一卡通支付页面
#define KBNScanedByShopVC_QR_payResult   [NSString stringWithFormat:@"%@/static/web_app/business/payment/qrPayResult.html",BASE_URL]//付款码，支付结果页面，只用于判断跳转
#define KBNScanedByShopVC_QR_yktPayManage   [NSString stringWithFormat:@"%@/static/web_app/business/qrPay/yktPayManage.html",BASE_URL]//一卡通支付管理页面。

#define KUserCenter_VeinInfo_H5BindVC  [NSString stringWithFormat:@"%@/static/web_app/venueH5/tideCard.html?fromVeinInfo=1",BASE_URL]//个人中心-静脉信息，静脉绑定页面H5。 //此H5是共用的体育场馆的静脉绑定页面,故在后面拼接了字段做区分。
#define KUserCenter_VeinInfo_H5BindBack   [NSString stringWithFormat:@"%@/static/web_app/venueH5/index.html",BASE_URL]//个人中心-静脉信息，H5绑定完成的跳转URL，如果跳转此URL，则本地拦截并返回上一页。//此H5是共用的体育场馆的静脉绑定页面，所以此页面其实是场馆首页。
#endif

//调起收银台URL
#define PaycenterGotoPayURL     @"xifu://paycenter/gotopay"
//绑定学号完成URL
#define PaycenterBindStumpSuccessURL     @"xifu://bindStumpSuccess"
//调用扫码功能
#define ScanURL @"xifu://scan"
//付款码-支付功能授权-返回成功，（失败的话H5会提示）
#define QR_PaymentAuthorize_succeedURL     @"xifu://paymentAuthorize_succeed"
//给银联H5传的returnURL
#define UnionXifuReturnBackUrl     @"https://xifureturnbackurl.com"

//重要常量定义：（由于害怕上线时忘记改，故写在此处）
//测试时的最低最高充值限额
//static CGFloat YKTRechargeMiniAmount = 0.01;
//static CGFloat ElectricRechargeMiniAmount = 0.01;
//static CGFloat ElectricRechargeMaxAmount = 500;
//static BOOL isRechargeTest = YES;

//正式发布时的最低最高充值限额
static CGFloat YKTRechargeMiniAmount = 10.0;
static CGFloat ElectricRechargeMiniAmount = 1.0;
static CGFloat ElectricRechargeMaxAmount = 500;
static BOOL isRechargeTest = NO;





@interface HttpTools : NSObject

//http请求单例
+(HttpTools *)shareInstance;

// headers
-(void)JsonGetRequst:(NSString *)url
          parameters:(NSDictionary *)parameters
             headers:(NSDictionary *)headers
             success:(void(^)(id responseObject))successed
             failure:(void(^)(NSError *error))failured;

//Get请求JSON数据方法
-(void)JsonGetRequst:(NSString *)url parameters:(NSDictionary *) parameters
             success:(void(^)(id responseObject)) successed
             failure:(void(^)(NSError *error)) failured;

//Post请求JSON数据方法
-(void)JsonPostRequst:(NSString *)url parameters:(NSDictionary *) parameters
              success:(void(^)(id responseObject)) successed
              failure:(void(^)(NSError *error)) failured;


//返回操作的Post请求JSON数据方法
- (AFHTTPRequestOperation *)Operation_JsonPostRequst:(NSString *)url parameters:(NSDictionary *) parameters
                                   success:(void(^)(id responseObject)) successed
                                   failure:(void(^)(NSError *error)) failured;

@end
