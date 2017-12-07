//
//  UPPayModel.h
//  UnionPay
//
//  Created by iXcoder on 16/5/16.
//  Copyright © 2016年 YIJI.COM. All rights reserved.
//

#import <YJPaySDK/YJBasePayModel.h>

@interface UPPayModel : YJBasePayModel

/** 交易流水号(必)
 * 商户后台向银联后台提交订单信息后，由银联后台生成并下发给商户后台的交易凭证
 */
@property (nonatomic, strong) NSString *payTn;
/** 返回协议(必)
 * 商户在调用支付接口完成支付后，用于引导支付控件返回而定义的协议
 */
@property (nonatomic, strong) NSString *schemeStr;
/** 支付环境(必)
 * "00"代表接入生产环境（正式版本需要），"01"代表接入开发测试环境（测试版本需要）；
 */
@property (nonatomic, strong) NSString *mode;

@property (nonatomic, assign) UIViewController *container;

@end
