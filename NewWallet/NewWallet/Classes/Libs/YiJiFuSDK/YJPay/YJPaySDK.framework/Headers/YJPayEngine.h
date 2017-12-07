//
//  YJPayEngine.h
//  YJPaySDK
//
//  Created by iXcoder on 16/5/17.
//  Copyright © 2016年 YIJI.COM. All rights reserved.
//

#import <Foundation/Foundation.h>


@class YJBasePay;
@class YJOrder;

@class YJLaunchEntity;
@class YJPayEntity;
@class YJSettingEntity;
@class YJCardManageEntity;
@class YJWithdrawEntity;
@class YJUpgradeAccountEntity;

@class YJExtraParams;

@interface YJPayEngine : NSObject

+ (instancetype)sharedEngine;

+ (NSBundle *)bundle;

@property (nonatomic, strong) YJLaunchEntity *entity;
@property (nonatomic, strong) YJBasePay *pay;

@property (nonatomic, strong) YJExtraParams *extParams;

@property (nonatomic, strong) YJOrder *order;

@property (nonatomic, strong) NSString *reportId;   //设备信息编号

- (BOOL)startPayScene:(YJPayEntity *)entity;
- (void)setPayWithType:(NSInteger)type;

- (BOOL)startSetting:(YJSettingEntity *)sEntity;
- (BOOL)startBankCardMange:(YJCardManageEntity *)cEntity;

- (BOOL)startWithdraw:(YJWithdrawEntity *)wEntity;
- (BOOL)startUpgradeAccount:(YJUpgradeAccountEntity *)aEntity;

/*!
 * @brief           退出支付
 * @method          exitWith:code:
 * @param           type      -- 支付平台类型
 * @param           code      -- 对应支付平台返回的编码
 * @param           info      -- 对应支付平台返回的数据
 * @return          (void)
 */
- (void)exitWith:(NSInteger)type code:(id)code extInfo:(NSDictionary *)info;
- (void)dismiss;

/*!
 * @brief           处理其他支付平台返回的请求
 * @method          handleOpenURL:srcApp:
 * @param           URL         -- 回调路径和参数
 * @param           srcApp      -- 三方App Bundle id
 * @return          (void)
 */
- (BOOL)handleOpenURL:(NSURL *)URL srcApp:(NSString *)srcApp;

@end
