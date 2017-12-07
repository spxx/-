//
//  SelectItemView.h
//  NewWallet
//
//  Created by mac1 on 14-10-28.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SelectItemViewUseStyle) {
    SelectItemViewUseStyleSelectSchool,//选择学校
    SelectItemViewUseStyleSelectOneCardNumber,//选择一卡通号码
    SelectItemViewUseStyleSelectXiFuAccount,
    SelectItemViewUseStyleSelectMobileRechrgeNum,
    SelectItemViewUseStyleSelectNetFees
};

@protocol SelectItemViewDelegate <NSObject>

@optional

- (void)selectSchoolName:(NSString *)scName schoolNumber:(NSString *)scNum;

- (void)selectOneCardNum:(NSString *)scName password:(NSString *)scNum;

- (void)selectLoginedAccount:(NSString *)account;

- (void)selectMobileRechargeNumber:(NSString *)num;

- (void)selectRechargedNetId:(NSString *)netId;

@end

@interface SelectItemView : UIView

@property (weak, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataSourceArray;

@property (assign, nonatomic) SelectItemViewUseStyle useStyle;

@property (weak, nonatomic) id<SelectItemViewDelegate> delegate;

- (id)initWithDataSource:(NSArray *)dataArray relateView:(UIView *)relateView style:(SelectItemViewUseStyle) useStyle delegate:(id) theDelegate;

- (id)initWithRelateView:(UIView *)relateView style:(SelectItemViewUseStyle) style delegate:(id) theDelegate;

- (void)loaDataArray;

- (void)loadLoginAccountData;
- (void)loadMobileRechargeData;
- (void)loadNetFeesRechargeData;
//下拉选择的父视图
- (void)showInView:(UIView *) inView;

//隐藏下拉xuan
- (void)dismiss;

@end
