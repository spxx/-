//
//  BNPickerBoard.h
//  Wallet
//
//  Created by mac1 on 15-1-4.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BNPickerBoardDelegate <NSObject>

- (void)selectMobileRechargeAmount:(NSDictionary *)amountInfo;

@end

@interface BNPickerBoard : UIView


@property (strong, nonatomic) NSArray *datasource;
@property (assign, nonatomic) BOOL isShow;
@property (assign, nonatomic) NSString *defaultAmount;

@property (weak, nonatomic)   id<BNPickerBoardDelegate> delegate;


- (void)show;

- (void)dismiss;

@end
