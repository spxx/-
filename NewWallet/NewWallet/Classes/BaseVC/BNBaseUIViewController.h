//
//  BNBaseUIViewController.h
//
//  Created by BN on 14-10-24.
//  Copyright (c) 2014年 xjy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ViewControllerUseStyle) {
    ViewControllerUseStyleRegist,//注册
    ViewControllerUseStyleFindPassword,//找回登录密码
    ViewControllerUseStyleModifyLoginPwd,//修改登录密码
    ViewControllerUseStyleModifyGesturePwd,//修改手势密码
    
    ViewControllerUseStyleAddBankCard,//添加银行卡
    
    ViewControllerUseStyleVerifyCurrentPhone,//验证当前绑定的手机号
    
    ViewControllerUseStyleVerifyNewPhone,//验证新的绑定手机号
    ViewControllerUseStyleXiaoDai,//小额贷款
    ViewControllerUseStyleModifyStudentNumber, //修改学工号
    ViewControllerUseStyleCollectFees // 费用领取
};

@interface BNBaseUIViewController : UIViewController
//导航栏
@property (nonatomic, assign)BOOL showNavigationBar;
@property (nonatomic, readonly)UIImageView *customNavigationBar;
@property (strong, nonatomic)UILabel *navigationLabel;
@property (nonatomic, readonly)UIButton *backButton;
@property (nonatomic, strong)NSString *navigationTitle;
@property (nonatomic, strong) UIColor *navigationTitleColor;
//64像素背景色view
@property (nonatomic, strong)UIView *sixtyFourPixelsView;

@property (nonatomic,   weak)UIScrollView *baseScrollView;

//如果需要,子类覆盖.默认操作是pop viewcontroller
- (void)backButtonClicked:(UIButton *)sender;

//动画隐藏显示
- (void)setNavigationBarHidden:(BOOL)hidden;

//添加键盘处理事件
- (void)addResponseKeyboardAction;

//去除键盘处理事件
- (void)removeResponseKeyboardAction;

//键盘隐藏
- (void)keyboardWillHidden:(NSNotification *)note;

//键盘弹出
- (void)keyboardDidShow:(NSNotification *)note;

- (void)pushViewController:(UIViewController *)vc animated:(BOOL)animated;

- (void)popToRootViewControllerAnimated:(BOOL)animated compliton:(void(^)(void))complitionBlock;

- (void)setupLoadedView;
@end
