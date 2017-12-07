//
//  TraineeHomeHeaderView.h
//  Wallet
//
//  Created by mac1 on 15/12/21.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TraineeHomeHeaderView : UIView

/**
 *  姓名
 */
@property (copy, nonatomic) NSString *name;

/**
 *  加入天数
 */
@property (copy, nonatomic) NSString *daysCount;

/**
 *  总经验值
 */
@property (copy, nonatomic) NSString *value;

/**
 *  当前等级
 */
@property (copy, nonatomic) NSString *level;

/**
 *  初始化方法
 *
 *  @param frame     frame
 *  @param name      姓名
 *  @param daysCount 加入天数
 *  @param value     经验值
 *  @param level     等级
 *
 *  @return
 */
- (instancetype)initWithFrame:(CGRect)frame name:(NSString *)name joinDays:(NSString *)daysCount empiricalValue:(NSString *)value level:(NSString *)level;



@end
