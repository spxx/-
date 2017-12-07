//
//  BNHomeDropItem.h
//  Wallet
//
//  Created by mac1 on 2017/2/24.
//  Copyright © 2017年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNHomeDropItem : UIView


- (instancetype)initWithFrame:(CGRect)frame itemDic:(NSDictionary *)dic;

@property (nonatomic, copy) void(^clickBlock)(void);

@end
