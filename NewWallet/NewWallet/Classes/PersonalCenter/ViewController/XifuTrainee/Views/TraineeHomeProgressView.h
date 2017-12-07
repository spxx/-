//
//  TraineeHomeProgressView.h
//  Wallet
//
//  Created by mac1 on 15/12/21.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TraineeHomeProgressView : UIView


/**
 *  当前等级
 */
@property (copy, nonatomic) NSString *currentLevel;

/**
 *  本月获得经验值
 */
@property (copy, nonatomic) NSString *mothValue;

/**
 *  当前经验值
 */
@property (copy, nonatomic) NSString *currentValue;

/**
 *  升级总需经验值
 */
@property (copy, nonatomic) NSString *needValue;

/**
 *  初始化方法
 *
 *  @param frame        frame
 *  @param currentLevel 当前等级
 *  @param monthValue   本月获得经验值
 *  @param currentValue 当前经验值
 *  @param needValue    升级所需经验值
 *
 *  @return
 */
- (instancetype)initWithFrame:(CGRect)frame currentLevel:(NSString *)currentLevel currentMonthValue:(NSString *)monthValue currentValue:(NSString *)currentValue needValue:(NSString *)
needValue;


- (void)startAnimation;

@end
