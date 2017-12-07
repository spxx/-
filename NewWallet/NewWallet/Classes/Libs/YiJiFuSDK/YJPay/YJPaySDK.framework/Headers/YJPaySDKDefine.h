//
//  YJUnionPayDefine.h
//  YJUnionPay
//
//  Created by iXcoder on 16/5/16.
//  Copyright © 2016年 YIJI.COM. All rights reserved.
//

#ifndef YJPaySDKDefine_h
#define YJPaySDKDefine_h


#import <Foundation/Foundation.h>

#define YJ_DEPRECATED(msg, ...) __attribute__((deprecated(msg)))


// 支付错误码定义
typedef NS_ENUM(NSInteger, YJPayErrorCode) {
    YJPayErrorCodeSuccess = 0,              // 支付成功
    YJPayErrorCodeUnknown = -1,             // 未知错误
    YJPayErrorCodeProcessing = -2,          // 支付处理中
    YJPayErrorCodeFailed = -3,              // 支付失败
    YJPayErrorCodeCancel = -4,              // 支付取消
    YJPayErrorCodeUnsupport = -5,           // 部分支付方式不支持
    YJPayErrorCodeUnexpected = -6,          // 用户异常返回（跳转微信/银联等支付app后未按照正常流程返回商户app，如支付过程中或支付完成时按Home键返回商户app）
};


FOUNDATION_EXPORT NSString *YJPayErrorDomain;
// 服务器地址
FOUNDATION_EXPORT NSString *kYJPayServer;
FOUNDATION_EXPORT NSString *ENV_SERVER_SNET;        // 联调环境
FOUNDATION_EXPORT NSString *ENV_SERVER_RELEASE;     // 正式环境

// 商户partenerid
FOUNDATION_EXPORT NSString *kYJPayPartnerId;
// 商户安全码
FOUNDATION_EXPORT NSString *kYJPaySecurityKey;

FOUNDATION_EXPORT NSString *kYJPayUserId;
// 用户类型
FOUNDATION_EXPORT NSString *kYJPayUserType;
FOUNDATION_EXPORT NSString *MEMBER_TYPE_YIJI;       // 内部会员
FOUNDATION_EXPORT NSString *MEMBER_TYPE_PATERN;     // 商户会员
FOUNDATION_EXPORT NSString *MEMBER_TYPE_CARD;       // 收单模式


FOUNDATION_EXPORT NSString *kYJPayTradeNo;
// 支付方式
FOUNDATION_EXPORT NSString *kYJPayType YJ_DEPRECATED("use kYJPayWay instead");
FOUNDATION_EXPORT NSString *kYJPayWay;
//FOUNDATION_EXPORT NSString *PAYMENT_TYPE_SUPER;     // 聚合支付
//FOUNDATION_EXPORT NSString *PAYMENT_TYPE_UPMP;      // 银联支付
//FOUNDATION_EXPORT NSString *PAYMENT_TYPE_WECHAT;    // 微信支付
//FOUNDATION_EXPORT NSString *PAYMENT_TYPE_YIJI;      // 易手富支付
// 自版本2.0开始，修改可选支付方式定义，方便商户传入特定支付方式组合
typedef NS_OPTIONS(NSUInteger, YJPayWay) {
    YJPayWayNone = 0,                       // 默认支付方式（聚合支付）
    YJPayWayYiji = 1 << 0,                  // 易手富支付
    YJPayWayUPMP = 1 << 1,                  // 银联支付
    YJPayWayWechat = 1 << 2,                // 微信支付
    YJPayWaySuper = 1 << 3,                 // 聚合支付
    YJPayWayUPWAP = 1 << 4,                 // 银联WAP支付
    YJPayWayDefault = YJPayWaySuper,        // 默认支付方式（聚合支付）
};
// 取消支付结果页展示。可选值：YES(不显示支付结果页), NO(显示支付结果页, 默认)
FOUNDATION_EXPORT NSString *kYJPayCancelResult;

// scheme
FOUNDATION_EXPORT NSString *kYJPayScheme YJ_DEPRECATED("use kYJPayWXAppId instead");
FOUNDATION_EXPORT NSString *kYJPayWXAppId;

// 扩展参数 必须传入 @ref YJExtraParams类型
FOUNDATION_EXPORT NSString *kYJPayExtraParams;



#endif /* YJUnionPayDefine_h */
