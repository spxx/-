//
//  YJBasePayModel.h
//  YJUnionPay
//
//  Created by iXcoder on 16/5/16.
//  Copyright © 2016年 YIJI.COM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJBasePayModel : NSObject

+ (instancetype)payModelWithInfo:(NSDictionary *)info;
// 直接启动还是通过聚合支付界面启动
@property (nonatomic, getter=isSuperPay) BOOL superPay;

@end
