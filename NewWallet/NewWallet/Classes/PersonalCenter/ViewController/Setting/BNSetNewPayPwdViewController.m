//
//  BNSetNewPayPwdViewController.m
//  NewWallet
//
//  Created by mac1 on 14-10-31.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNSetNewPayPwdViewController.h"

#import "BNMobileRechargeResaultVC.h"

#import "PayClient.h"

#import "CardApi.h"
#import "DenoteApi.h"
#import "MobileRechargeApi.h"
#import "BNMobileRechargeRasultInfo.h"

#import "Password.h"

#import "RechargePhoneNumer.h"

#import "SchoolFeesClient.h"
#import "BNFeesCheckCardSuccessedVC.h"
#import "BNXiHaDaiHomeViewController.h"

@interface BNSetNewPayPwdViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) UIScrollView *scrollView;

@property (weak, nonatomic) UIView *inputView;

@property (weak, nonatomic) UITextField *passwordTextField;


@property (weak, nonatomic) UIView *passwordBackgroundView;

@property (weak, nonatomic) UIView *passwordSecondBKView;

@property (weak, nonatomic) UILabel *firstTipsMsgLabel;

@property (weak, nonatomic) UIButton *finishButton;

@property (strong, nonatomic) NSString *payPassword;

@property (strong, nonatomic) BNMobileRechargeRasultInfo *resultInfo;

@property (assign, nonatomic) PayProjectType payProjectType;
@end


@implementation BNSetNewPayPwdViewController


@synthesize useStyle;
@synthesize payModel;

#pragma makr - setup loaded view
- (void)setupLoadedView
{
    
    self.view.backgroundColor = UIColor_Gray_BG;
    
    UIScrollView *theScollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT- self.sixtyFourPixelsView.viewBottomEdge)];
    theScollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge + ((SCREEN_HEIGHT < 500) ? 80 : 0));
    self.scrollView = theScollView;
    [self.view addSubview:theScollView];
    
    CGFloat originY = 10*BILI_WIDTH;
    CGFloat oneSeperateWidth = (SCREEN_WIDTH-20*2)/6;
    
    UILabel *firstTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, originY, SCREEN_WIDTH-20*2, 21)];
    firstTipsLabel.textAlignment = NSTextAlignmentLeft;
    firstTipsLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
    firstTipsLabel.textColor = [UIColor lightGrayColor];
    firstTipsLabel.backgroundColor = [UIColor clearColor];
    self.firstTipsMsgLabel = firstTipsLabel;
    
    switch (self.useStyle) {
        case SetNewPayPwdViewControllerUseStyleBindCardSetPwd:
            self.navigationTitle = @"添加银行卡";
            firstTipsLabel.text = @"请设置支付密码，支付密码勿与登录密码相同";
            break;
         
        case SetNewPayPwdViewControllerUseStyleModifyPwd:
            self.navigationTitle = @"修改支付密码";
            firstTipsLabel.text = @"设置新密码";
            break;
        case SetNewPayPwdViewControllerUseStyleFindPayPwdBindCard:
            self.navigationTitle = @"找回支付密码";
            firstTipsLabel.text = @"设置新密码";
            break;
            
        case SetNewPayPwdViewControllerUseStyleCollectFees:
        {
            self.navigationTitle = @"添加银行卡";
            firstTipsLabel.text = @"请设置支付密码，支付密码勿与登录密码相同";
            break;
        }
        default:
            break;
    }
    
    
    originY += firstTipsLabel.frame.size.height +10*BILI_WIDTH;
    
    UIView *pwdBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(20, originY, SCREEN_WIDTH-20*2, oneSeperateWidth)];
    pwdBackgroundView.layer.borderColor = UIColorFromRGB(0xa2a2a2).CGColor;
    pwdBackgroundView.layer.borderWidth = .5;
    pwdBackgroundView.backgroundColor = [UIColor whiteColor];
    self.passwordBackgroundView = pwdBackgroundView;
    
    UITextField *pwdTextField = [[UITextField alloc] initWithFrame:pwdBackgroundView.frame];
    pwdTextField.borderStyle = UITextBorderStyleNone;
    pwdTextField.delegate = self;
    pwdTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    pwdTextField.secureTextEntry = YES;
    pwdTextField.keyboardType = UIKeyboardTypeNumberPad;
    [pwdTextField addTarget:self action:@selector(passwordFirstChangedAction:) forControlEvents:UIControlEventEditingChanged];
    self.passwordTextField = pwdTextField;
    
    originY += pwdBackgroundView.frame.size.height +10*BILI_WIDTH;

    UILabel *secondTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, originY, SCREEN_WIDTH-20*2, 21)];
    secondTipsLabel.text = @"再次输入密码";
    secondTipsLabel.textAlignment = NSTextAlignmentLeft;
    secondTipsLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
    secondTipsLabel.textColor = [UIColor lightGrayColor];
    secondTipsLabel.backgroundColor = [UIColor clearColor];
    
    originY += secondTipsLabel.frame.size.height +10*BILI_WIDTH;
    
    UIView *pwdSecondBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(20, originY, SCREEN_WIDTH-20*2, oneSeperateWidth)];
    pwdSecondBackgroundView.layer.borderColor = UIColorFromRGB(0xa2a2a2).CGColor;
    pwdSecondBackgroundView.layer.borderWidth = .5;
    pwdSecondBackgroundView.backgroundColor = [UIColor whiteColor];
    self.passwordSecondBKView = pwdSecondBackgroundView;
    
    
    for (int i = 1; i <= 5; i++) {
        CALayer *oneVLineLayer = [[CALayer alloc] init];
        oneVLineLayer.frame = CGRectMake(oneSeperateWidth * i, 0, .5, oneSeperateWidth);
        oneVLineLayer.backgroundColor = UIColorFromRGB(0xa2a2a2).CGColor;
        [pwdBackgroundView.layer addSublayer:oneVLineLayer];
        
        CALayer *twoVLineLayer = [[CALayer alloc] init];
        twoVLineLayer.frame = CGRectMake(oneSeperateWidth * i, 0, .5, oneSeperateWidth);
        twoVLineLayer.backgroundColor = UIColorFromRGB(0xa2a2a2).CGColor;
        [pwdSecondBackgroundView.layer addSublayer:twoVLineLayer];
    }
    
    for (int i = 1; i <= 6; i++) {
        UIView *blackPoint = [[UIView alloc] initWithFrame:CGRectMake((oneSeperateWidth-8)/2 + oneSeperateWidth * (i - 1), (oneSeperateWidth-8)/2, 8, 8)];
        blackPoint.tag = i;
        blackPoint.layer.cornerRadius = 4;
        blackPoint.backgroundColor = [UIColor blackColor];
        blackPoint.hidden = YES;
        [pwdBackgroundView addSubview:blackPoint];
        
        UIView *twoBlackPoint = [[UIView alloc] initWithFrame:CGRectMake((oneSeperateWidth-8)/2 + oneSeperateWidth * (i - 1), (oneSeperateWidth-8)/2, 8, 8)];
        twoBlackPoint.tag = 6 + i;
        twoBlackPoint.layer.cornerRadius = 4;
        twoBlackPoint.backgroundColor = [UIColor blackColor];
        twoBlackPoint.hidden = YES;
        [pwdSecondBackgroundView addSubview:twoBlackPoint];
    }
    
    [_scrollView addSubview:firstTipsLabel];
    [_scrollView addSubview:pwdTextField];
    [_scrollView addSubview:pwdBackgroundView];
    
    [_scrollView addSubview:secondTipsLabel];
    [_scrollView addSubview:pwdSecondBackgroundView];
    
    originY += pwdSecondBackgroundView.frame.size.height +45*BILI_WIDTH;
    
    UIButton *nextStepButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextStepButton.frame = CGRectMake(30, originY, SCREEN_WIDTH - 30 *2, 40*NEW_BILI);
    [nextStepButton setupTitle:@"完成" enable:NO];
    [nextStepButton addTarget:self action:@selector(finishPasswordAction:) forControlEvents:UIControlEventTouchUpInside];
    [nextStepButton addTarget:self action:@selector(finishPasswordAction:) forControlEvents:UIControlEventTouchDown];
    self.finishButton = nextStepButton;
    [self.scrollView addSubview:nextStepButton];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupLoadedView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.passwordTextField becomeFirstResponder];
//    if (SCREEN_HEIGHT < 500) {
//        [self addResponseKeyboardAction];
//    }
    
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
//    if (SCREEN_HEIGHT < 500) {
//        [self removeResponseKeyboardAction];
//    }
}

//#pragma mark - keyboard
//- (void)keyboardWillHidden:(NSNotification *)note
//{
//    [self.scrollView setContentOffset:CGPointMake(0, 0)];
//}
//
//- (void)keyboardDidShow:(NSNotification *)note
//{
//    [self.scrollView setContentOffset:CGPointMake(0, 20)];
//}
#pragma mark -text field action
- (void)passwordFirstChangedAction:(UITextField *)tf
{
    BNLog(@"password %@", tf.text);
    NSString *password = tf.text;
    NSInteger pwdLength = password.length;
    if (password != nil && pwdLength > 0) {
        if (pwdLength == 12) {
            [self.finishButton setBackgroundColor:UIColor_Button_Normal];
            [self.finishButton setEnabled:YES];
        }else{
            [self.finishButton setBackgroundColor:UIColor_Button_Disable];
            [self.finishButton setEnabled:NO];
        }
        for (int i = 1; i <= 12; i++) {
            UIView *blackPoint = nil;
            if (i <= 6) {
                blackPoint = [self.passwordBackgroundView viewWithTag:i];
            }else{
                blackPoint = [self.passwordSecondBKView viewWithTag:i];
            }
            if (i <= pwdLength) {
                blackPoint.hidden = NO;
            }else{
                blackPoint.hidden = YES;
            }
        }
    }else{
        for (int i = 1; i <= 12; i++) {
            UIView *blackPoint = [self.passwordBackgroundView viewWithTag:i];
            blackPoint.hidden = YES;
        }
        
    }
    if (SCREEN_HEIGHT < 500) {
        if (pwdLength > 6) {
            [UIView animateWithDuration:.2 animations:^{
                [self.scrollView setContentOffset:CGPointMake(0, 80)];
            }];
        } else {
            [UIView animateWithDuration:.2 animations:^{
                [self.scrollView setContentOffset:CGPointMake(0, 0)];
            }];
        }

    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        return NO;
    }
    if ([string isEqualToString:@""]) {
        return YES;
    }
    NSMutableString *text = [NSMutableString stringWithString:textField.text];
    [text replaceCharactersInRange:range withString:string];
    
    return text.length <= 12 ? YES : NO;
}

#pragma mark - button action 
- (void)finishPasswordTouchDownAction:(UIButton *)btn
{
    [self.finishButton setBackgroundColor:UIColor_Button_Disable];
    
}
- (void)finishPasswordAction:(UIButton *)btn
{
    NSString *password = self.passwordTextField.text;
    NSInteger pwdLength = password.length;
    if (pwdLength == 12) {
        [self.finishButton setBackgroundColor:UIColor_Button_Normal];
        [self.finishButton setEnabled:YES];
        NSString *firstPwd = [password substringWithRange:NSMakeRange(0, 6)];
        NSString *secondPwd = [password substringWithRange:NSMakeRange(6, 6)];
        __weak typeof(self) weakSelf = self;
        __weak typeof(shareAppDelegateInstance) weakAppDelegate = shareAppDelegateInstance;
        NSString *userID = shareAppDelegateInstance.boenUserInfo.userid;
//        NSString *userName = shareAppDelegateInstance.boenUserInfo.name;
        Class objVC = NSClassFromString(weakAppDelegate.popToViewController);
        NSArray *viewControllers = weakSelf.navigationController.viewControllers;
        
        if ([firstPwd isEqualToString:secondPwd]) {
            self.payPassword = firstPwd;
            switch (self.useStyle) {
                case SetNewPayPwdViewControllerUseStyleFindPayPwdBindCard:///找支付密码
                {
                    [SVProgressHUD showWithStatus:@"请稍候..."];
                    
                    //findPsw接口。
                    NSString *isCridet = payModel.bankCardBinModel.bankCardTypeCode;
                    if ([isCridet isEqualToString:@"DEBIT"]) {
                        isCridet = @"no";
                    }else{
                        isCridet = @"yes";
                    }
                    [PayClient forgetPayPasswordWithUserID:shareAppDelegateInstance.boenUserInfo.userid bankCardNo:payModel.bankCardBinModel.bankNumber cert_no:payModel.bindCardInfoModel.personalIDNum pay_password:firstPwd success:^(NSDictionary *returnData) {
                    
                                    BNLog(@"forgetPayPasswordWithUserID--%@", returnData);
                                    NSString *retCode = [returnData valueNotNullForKey:kRequestRetCode];
                                    if ([retCode isEqualToString:kRequestSuccessCode]) {
                                        [SVProgressHUD dismiss];

                                        if ([weakAppDelegate.popToViewController isEqualToString:@"BNSettingsViewController"]) {
                                            //个人中心首次绑卡
                                            [Tools showMessageWithTitle:@"提示" message:@"找回支付密码成功"];
                                            UIViewController *skipVC = nil;
                                            for (UIViewController *obj in viewControllers) {
                                                if ([obj isKindOfClass:objVC] == YES) {
                                                    skipVC = (UIViewController *)obj;
                                                    [weakSelf.navigationController popToViewController:skipVC animated:YES];
                                                    break;
                                                }
                                            }
                                        }
                                    }else{
                                        NSString *retMsg = [returnData valueNotNullForKey:kRequestRetMessage];
                                        [SVProgressHUD showErrorWithStatus:retMsg];
                                    }
                                }
                                failure:^(NSError *error) {
                                    
                                    [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                }];
                }
                    break;
                case SetNewPayPwdViewControllerUseStyleBindCardSetPwd://首次绑卡
                {
                    
                    [SVProgressHUD showWithStatus:@"请稍候..."];
                    
                    [PayClient bindCard:payModel.bankCardBinModel.bankId
                             bankCardNo:payModel.bankCardBinModel.bankNumber
                                is_cert:@"yes"
                               isCredit:payModel.bindCardInfoModel.personalIsCredit
                                 userid:userID
                            payPassWord:firstPwd
                                 mobile:payModel.bindCardInfoModel.personalBankPhone
                               realName:payModel.bindCardInfoModel.personalName
                                 certNo:payModel.bindCardInfoModel.personalIDNum
                               safeCode:payModel.bindCardInfoModel.personalSafeCode
                           certValidate:payModel.bindCardInfoModel.personalVanlidate
                             verifyCode:_verifyCode
                                success:^(NSDictionary *returnData) {
                                    BNLog(@"bind card--%@", returnData);
//                                    NSArray *viewControllers = weakSelf.navigationController.viewControllers;
//                                    UIViewController *skipVC = nil;
//                                    for (UIViewController *obj in viewControllers) {
//                                        if ([obj isKindOfClass:objVC] == YES) {
//                                            skipVC = (UIViewController *)obj;
//                                            break;
//                                        }
//                                    }
                                    NSString *retCode = [returnData valueNotNullForKey:kRequestRetCode];
                                    if ([retCode isEqualToString:kRequestSuccessCode]) {
                                        
                                        weakAppDelegate.boenUserInfo.isCert = @"yes";
                                        
                                        NSDictionary *retData = [returnData valueForKey:kRequestReturnData];
                                        NSArray *bankCards = [retData valueForKey:@"binded_cards"];
                                        weakAppDelegate.boenUserInfo.bankCardNumbers = [Tools saveto:weakAppDelegate.boenUserInfo.bankCardNumbers valueNotNegative:[NSString stringWithFormat:@"%lu", (unsigned long)[bankCards count]]];//赋值判断，如果为-1或是不正常数据时，则不赋值。
                                        [SVProgressHUD dismiss];

                                        UIViewController *skipVC = nil;
                                        if ([weakAppDelegate.popToViewController isEqualToString:@"BNBankCardsListViewController"] || [weakAppDelegate.popToViewController isEqualToString:@"BNPayWayListVC"]) {
                                            //从银行卡列表界面和BNPayWayListVC界面首次绑卡
                                            for (UIViewController *obj in viewControllers) {
                                                if ([obj isKindOfClass:objVC] == YES) {
                                                    skipVC = (UIViewController *)obj;
                                                    break;
                                                }
                                            }
                                        }
                                        if (skipVC) {
                                            [weakSelf.navigationController popToViewController:skipVC animated:YES];
                                        } else {
                                            //改版后在“我”界面点击实名认证，首次绑卡界面，直接返回到“我”界面
                                            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                                        }
                                    } else {
                                        NSString *retMsg = [returnData valueNotNullForKey:kRequestRetMessage];
                                        [SVProgressHUD showErrorWithStatus:retMsg];
                                    }
                                } failure:^(NSError *error) {
                                    [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                }];
                }
                    break;
                    
                case SetNewPayPwdViewControllerUseStyleModifyPwd://修改支付密码
                {
                    if (self.oldPayPassword.length > 0 && weakSelf.payPassword.length > 0 &&
                        weakAppDelegate.boenUserInfo.userid.length > 0 && weakAppDelegate.haveGetPrefile == YES) {
                        
                        [SVProgressHUD showWithStatus:@"请稍候..."];
                        
                        [Password modifyPayPwdWithUserid:weakAppDelegate.boenUserInfo.userid
                                              old_payPwd:weakSelf.oldPayPassword
                                              new_payPwd:weakSelf.payPassword
                                                 success:^(NSDictionary *returnData) {
                                                     BNLog(@"modify pay --%@", returnData);
                                                     NSString *retCode = [returnData valueNotNullForKey:kRequestRetCode];
                                                     if ([retCode isEqualToString:kRequestSuccessCode]) {
                                                         [SVProgressHUD showSuccessWithStatus:@"修改支付密码成功"];

                                                         UIViewController *skipVC = nil;
                                                         if ([weakAppDelegate.popToViewController isEqualToString:@"BNSettingsViewController"]) {
                                                             for (UIViewController *obj in viewControllers) {
                                                                 if ([obj isKindOfClass:objVC] == YES) {
                                                                     skipVC = (UIViewController *)obj;
                                                                     [weakSelf.navigationController popToViewController:skipVC animated:YES];
                                                                     break;
                                                                 }
                                                             }
                                                         }
                                                         
                                                     }else{
                                                         NSString *retMsg = [returnData valueNotNullForKey:kRequestRetMessage];
                                                         [SVProgressHUD showErrorWithStatus:retMsg];
                                                     }
                                                     
                                                 }
                                                 failure:^(NSError *error) {
                                                     [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                                     
                                                 }];
                    }

                }
                    
                    break;
                case SetNewPayPwdViewControllerUseStyleCollectFees:
                {
                    [SVProgressHUD showWithStatus:@"请稍候..."];
                    
                    [PayClient bindCard:payModel.bankCardBinModel.bankId
                             bankCardNo:payModel.bankCardBinModel.bankNumber
                                is_cert:@"yes"
                               isCredit:payModel.bindCardInfoModel.personalIsCredit
                                 userid:userID
                            payPassWord:firstPwd
                                 mobile:payModel.bindCardInfoModel.personalBankPhone
                               realName:payModel.bindCardInfoModel.personalName
                                 certNo:payModel.bindCardInfoModel.personalIDNum
                               safeCode:payModel.bindCardInfoModel.personalSafeCode
                           certValidate:payModel.bindCardInfoModel.personalVanlidate
                             verifyCode:_verifyCode
                                success:^(NSDictionary *returnData) {
                                    
                                    BNLog(@"bind card--%@", returnData);
                                    NSArray *viewControllers = weakSelf.navigationController.viewControllers;
                                    UIViewController *skipVC = nil;
                                    for (UIViewController *obj in viewControllers) {
                                        if ([obj isKindOfClass:objVC] == YES) {
                                            skipVC = (UIViewController *)obj;
                                            break;
                                        }
                                    }
                                    NSString *retCode = [returnData valueNotNullForKey:kRequestRetCode];
                                    if ([retCode isEqualToString:kRequestSuccessCode]) {
                                        [SVProgressHUD dismiss];
                                        
                                        weakAppDelegate.boenUserInfo.isCert = @"yes";
                                        
                                        NSDictionary *retData = [returnData valueForKey:kRequestReturnData];
                                        NSArray *bankCards = [retData valueForKey:@"binded_cards"];
                                        weakAppDelegate.boenUserInfo.bankCardNumbers = [Tools saveto:weakAppDelegate.boenUserInfo.bankCardNumbers valueNotNegative:[NSString stringWithFormat:@"%lu", (unsigned long)[bankCards count]]];//赋值判断，如果为-1或是不正常数据时，则不赋值。
                                        
                                        BNFeesCheckCardSuccessedVC *checkCardSuccessedVC = [[BNFeesCheckCardSuccessedVC alloc] init];
                                        [self pushViewController:checkCardSuccessedVC animated:YES];
                                    }
                                    else {
                                        NSString *retMsg = [returnData valueNotNullForKey:kRequestRetMessage];
                                        [SVProgressHUD showErrorWithStatus:retMsg];
                                    }
                                    
                                } failure:^(NSError *error) {
                                    [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                }];
                    
                    break;
                }
                default:
                    break;
            }

        }else{
            [Tools showMessageWithTitle:@"提示" message:@"您两次输入的密码不同，请重新输入"];
        }
        
    }else{
        [self.finishButton setBackgroundColor:UIColor_Button_Disable];
        [self.finishButton setEnabled:NO];
    }
    
}

- (void)gotoMobilePayResaultVC
{
    BNMobileRechargeResaultVC *resaultVC = [[BNMobileRechargeResaultVC alloc] init];
    resaultVC.payProjectType = _payProjectType;
    resaultVC.payWayType = PayWayTypeBankCard;
    resaultVC.resultInfo = _resultInfo;    //payWayType要在resultInfo之前赋值。
    [self pushViewController:resaultVC animated:YES];
    
}
- (void)networkErrorStoped
{
    [SVProgressHUD showErrorWithStatus:kNetworkErrorMsgWhenPay];
}

- (void)backButtonClicked:(UIButton *)sender {
    if (self.useStyle == SetNewPayPwdViewControllerUseStyleCollectFees) {
        BOOL isFoundDetailVC = NO;
        for (UIViewController *viewController in self.navigationController.viewControllers) {
            if ([viewController isKindOfClass:NSClassFromString(@"BNFeeDetailViewController")]) {
                isFoundDetailVC = YES;
                [self.navigationController popToViewController:viewController animated:YES];
                break;
            }
        }
        
        if (!isFoundDetailVC) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    else {
        [super backButtonClicked:sender];
    }
}

@end
