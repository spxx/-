//
//  YJBasePayEngine.h
//  YJUnionPay
//
//  Created by iXcoder on 16/5/16.
//  Copyright © 2016年 YIJI.COM. All rights reserved.
//

#ifndef YJ_BASE_PAY_ENGINE_H
#define YJ_BASE_PAY_ENGINE_H

#import <UIKit/UIKit.h>

@protocol YJPayDelegate;
@class YJBasePayModel;

@interface YJBasePay : NSObject

+ (YJBasePayModel *)payModelWithInfo:(NSDictionary *)info;

@property (nonatomic) BOOL fromSuperPay;

- (BOOL)validateParams:(YJBasePayModel *)payModel;
- (BOOL)startPay:(YJBasePayModel *)payModel error:(NSError **)error;

+ (BOOL)isAppInstalled;

- (BOOL)handleOpenURL:(NSURL *)URL srcApp:(NSString *)srcApp;

@end


#endif
