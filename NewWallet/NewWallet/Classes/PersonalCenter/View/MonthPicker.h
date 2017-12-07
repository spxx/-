//
//  MonthPicker.h
//  Wallet
//
//  Created by mac1 on 15/2/12.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMonthPickerBarHeight 36

@protocol MonthPickerDelegate <NSObject>

- (void)selectMonth:(NSInteger) month year:(NSInteger) year;
- (void)cancelSelectDate;

@end

@interface MonthPicker : UIView
@property (assign, nonatomic) BOOL isShow;
@property (assign, nonatomic) NSString *defaultAmount;

@property (weak, nonatomic)   id<MonthPickerDelegate> delegate;

- (void)setDefaultMonth:(NSInteger) month year:(NSInteger) year;
- (void)show;

- (void)dismiss;

@end
