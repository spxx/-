//
//  YJUnionPayEngine.h
//  YJUnionPay
//
//  Created by iXcoder on 16/5/17.
//  Copyright © 2016年 YIJI.COM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YJPaySDK/YJPayDelegate.h>

@interface YJPayService : NSObject

/*!
 * @brief               环境初始化
 * @method              initEnvironment:
 * @param               environment         -- 环境
 * @param               error               -- 返回错误
 * @discussion          
            1.environment:需要包含三个key
                        kYJPayServer         -- 服务器
                        kYJPayPartnerId      -- 商户partnerId
                        kYJPaySecurityKey    -- 商户安全码
            2.error:初始化环境失败返回错误
 * @return              (BOOL)          -- 是否初始化成功
 */
+ (BOOL)initEnvironment:(NSDictionary *)environment error:(NSError **)error;

/*!
 * @brief               启动支付
 * @method              startPayment:delegate:error:
 * @param               params          -- 启动参数
 * @param               error           -- 返回错误
 * @discussion          
            参数根据不同的支付渠道传入不同的类型
 
 
 * @return              (void)
 */
+ (BOOL)startPayment:(NSDictionary *)params delegate:(id<YJPayDelegate>)delegate error:(NSError **)error;

+ (BOOL)handleOpenURL:(NSURL *)URL srcApp:(NSString *)srcApp;

@end

@interface YJPayService (Extend)

/*!
 * @brief               启动银行卡管理
 * @method              startBindCardList:delegate:error:
 * @param               params
 * @param               delegate
 * @param               error
 * @discussion          params可传入如下参数(*:必传)
                        1*. kYJPayUserId                -- 用户id
                        2*. kYJPayUserType              -- 用户类型
                        3 . kYJPayExtraParams           -- 扩展参数，必须传入指定类型@ref YJExtraParams
 * @return              (void)
 */
+ (BOOL)startBindCardList:(NSDictionary *)params delegate:(id<YJPayDelegate>)delegate error:(NSError **)error;

/*!
 * @brief               启动支付设置
 * @method              startPaymentSetting:delegate:error:
 * @param               params
 * @param               delegate
 * @param               error
 * @discussion
 

 * @return              (void)
 */
+ (BOOL)startPaymentSetting:(NSDictionary *)params delegate:(id<YJPayDelegate>)delegate error:(NSError **)error;

/*!
 * @brief               启动提现
 * @method              startWithdraw:delegate:error:
 * @param               params              -- 提现参数
 * @param               delegate            -- 回调
 * @param               error               -- 启动错误
 * @discussion          params可传入如下参数(*:必传)
                        1*. kYJPayUserId                -- 用户id
                        2*. kYJPayUserType              -- 用户类型
 
 * @return              (void)
 */
+ (BOOL)startWithdraw:(NSDictionary *)params delegate:(id<YJPayDelegate>)delegate error:(NSError **)error;

/*!
 * @brief               升级支付账户
 * @method              startUpgradeAccount:delegate:error:
 * @param               params              -- 提现参数
 * @param               delegate            -- 回调
 * @param               error               -- 启动错误
 * @discussion          params可传入如下参数(*:必传)
                        1*. kYJPayUserId                -- 用户id
                        2*. kYJPayUserType              -- 用户类型
 * @return              (void)
 */
+ (BOOL)startUpgradeAccount:(NSDictionary *)params delegate:(id<YJPayDelegate>)delegate error:(NSError **)error;

@end




