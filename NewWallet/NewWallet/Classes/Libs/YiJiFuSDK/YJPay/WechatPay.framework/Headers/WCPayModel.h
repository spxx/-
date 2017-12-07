//
//  WCPayModel.h
//  WechatPay
//
//  Created by Yaphets on 16/5/18.
//  Copyright © 2016年 YIJI.COM. All rights reserved.
//

#import <YJPaySDK/YJBasePayModel.h>

@interface WCPayModel : YJBasePayModel

/**  应用ID
  *  微信开放平台审核通过的应用APPID；
  */
@property (nonatomic, strong) NSString *appid;
/**  扩展字段
  *  暂填写固定值Sign=WXPay
  */
@property (nonatomic, strong) NSString *package;
/**  商户号
  *  微信支付分配的商户号
  */
@property (nonatomic, strong) NSString *partnerId;
/**  签名
  *  服务端返回的签名
  */
@property (nonatomic, strong) NSString *sign;
/**  预支付交易会话ID
  *  微信返回的支付交易会话ID
  */
@property (nonatomic, strong) NSString *prepayId;
/**  随机字符串
  *  服务端返回的随机字符串
  */
@property (nonatomic, strong) NSString *nonceStr;
/**  时间戳
  *  服务端返回的时间戳
  */
@property (nonatomic, assign) int timeStamp;


@end
