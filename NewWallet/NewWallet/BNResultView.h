//
//  BNResultView.h
//  Wallet
//
//  Created by mac1 on 15/9/25.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BNResultViewDataSource <NSObject>

@optional

- (NSInteger)numberOfmembersInResultView:(UIView *)resultView;
- (NSArray *)titleForView:(UIView *)resultView;
- (NSArray *)contentForView:(UIView *)resultView;


@end

@protocol BNResultViewDelegate <NSObject>

@optional
- (void)resultViewFinshButtonAcion:(UIView *)resultView;

@end

typedef NS_ENUM(NSInteger, ResultViewStatus) {
    ResultStatusSuccesed,  //成功
    ResultStatusUnderWay,  //进行中
    ResultStatusFailure    //失败
};


@interface BNResultView : UIView


@property (nonatomic, copy) NSString *headBtnStr;//头部按钮的标题
@property (nonatomic, copy) NSString *tipsLabelMsg;//中间的提示文字

@property (nonatomic, assign) ResultViewStatus status;
@property (nonatomic, assign, getter=isHiddenFinshButton) BOOL hiddenFinshButton; //是否隐藏完成按钮

@property (nonatomic, weak) id<BNResultViewDataSource>dataSource;//数据源
@property (nonatomic, weak) id<BNResultViewDelegate>delegate;//代理


- (void)reloadData;//刷新数据
@end
