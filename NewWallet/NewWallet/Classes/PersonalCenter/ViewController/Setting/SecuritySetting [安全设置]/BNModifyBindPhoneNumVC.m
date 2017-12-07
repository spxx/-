//
//  BNModifyBindPhoneNumVC.m
//  Wallet
//
//  Created by mac1 on 15/3/3.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNModifyBindPhoneNumVC.h"

#import "BNVerifySMSCodeViewController.h"

#import "RegisterClient.h"
@interface BNModifyBindPhoneNumVC ()<UITextFieldDelegate>

@property (weak, nonatomic) UITextField *phoneNumTF;

@property (weak, nonatomic) UIButton *verifyPhoneBtn;
@end

@implementation BNModifyBindPhoneNumVC

- (void)setupLoadedView
{
    self.navigationTitle = @"修改手机号";
    

    
    self.view.backgroundColor = UIColor_Gray_BG;
    
    UIScrollView *theScollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT- self.sixtyFourPixelsView.viewBottomEdge)];
    theScollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge + 1);
    [self.view addSubview:theScollView];
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, [BNTools sizeFit:15 six:17 sixPlus:19], SCREEN_WIDTH - 30, 30)];
    tipsLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:15 sixPlus:16]];
    tipsLabel.textColor = UIColorFromRGB(0xa2a2a2);
    tipsLabel.textAlignment = NSTextAlignmentLeft;
    [theScollView addSubview:tipsLabel];
    if (_useStyle == ViewControllerUseStyleVerifyCurrentPhone) {
        tipsLabel.text = @"请输入原手机号码";
    }else{
        tipsLabel.text = @"请输入新手机号码";
    }
    
    
    
    UIView *infoBGView = [[UIView alloc] initWithFrame:CGRectMake(0, tipsLabel.frame.origin.y + tipsLabel.frame.size.height, SCREEN_WIDTH, 45 *BILI_WIDTH)];
    infoBGView.backgroundColor = [UIColor whiteColor];
    
    UIView *infoUpLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    infoUpLine.backgroundColor = UIColor_GrayLine;
    
    UIView *infoDownLine = [[UIView alloc] initWithFrame:CGRectMake(0, infoBGView.frame.size.height - 1, SCREEN_WIDTH, 1)];
    infoDownLine.backgroundColor = UIColor_GrayLine;
    
    UITextField *phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 45 *BILI_WIDTH)];
    phoneTF.placeholder = @"手机号";
    phoneTF.tag = 11;
    phoneTF.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
    phoneTF.clearButtonMode = UITextFieldViewModeAlways;
    phoneTF.borderStyle = UITextBorderStyleNone;
    phoneTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    phoneTF.keyboardType = UIKeyboardTypePhonePad;
    phoneTF.delegate = self;
    [phoneTF addTarget:self action:@selector(infoTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    _phoneNumTF = phoneTF;
    
    [infoBGView addSubview:phoneTF];
    [infoBGView addSubview:infoUpLine];
    [infoBGView addSubview:infoDownLine];
    
    [theScollView addSubview:infoBGView];
    
    UIButton *nextStepButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextStepButton.frame = CGRectMake(30, infoBGView.frame.origin.y + infoBGView.frame.size.height + 40 * BILI_WIDTH, SCREEN_WIDTH - 2*30, 40 * BILI_WIDTH);
    [nextStepButton setupTitle:@"下一步" enable:NO];
    [nextStepButton addTarget:self action:@selector(verifyPhoneAction:) forControlEvents:UIControlEventTouchUpInside];
    _verifyPhoneBtn = nextStepButton;
    [theScollView addSubview:nextStepButton];
    
    
    UITapGestureRecognizer *cancelKeyboardTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelKeyboard:)];
    [self.view addGestureRecognizer:cancelKeyboardTap];
}

- (void)cancelKeyboard:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupLoadedView];
}

#pragma mark - text field
- (void)infoTextFieldChanged:(UITextField *)tf
{
    NSString *str = tf.text;
    if ([str hasPrefix:@"1"]) {
        if (str.length > 0) {
            str = [[str componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""];
        }
        if (str.length > 11) {
            str = [str substringWithRange:NSMakeRange(0, 11)];
        }
        
        tf.text = str;
        
        if (str.length == 11) {
            _verifyPhoneBtn.enabled = YES;
        }else{
            _verifyPhoneBtn.enabled = NO;
        }
    }else{
        tf.text = nil;
        [SVProgressHUD showErrorWithStatus:@"请输入1开头的手机号"];
    }

}

#pragma mark - button action
- (void)verifyPhoneAction:(UIButton *)btn
{
    BNPayModel *payModel = [[BNPayModel alloc]init];
    payModel.bindCardInfoModel.personalBankPhone = _phoneNumTF.text;
    
    NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithDictionary:@{@"PersonalBankPhone": _phoneNumTF.text}];
    BNVerifySMSCodeViewController *verifySMSVC = [[BNVerifySMSCodeViewController alloc] init];
    verifySMSVC.useStyle = _useStyle;
    verifySMSVC.phoneNumber = _phoneNumTF.text;
    verifySMSVC.payModel = payModel;
    
    __weak typeof(self) weakSelf = self;
    if (_useStyle == ViewControllerUseStyleVerifyCurrentPhone) {
        if ([shareAppDelegateInstance.boenUserInfo.phoneNumber isEqualToString:_phoneNumTF.text] == YES) {
            [self pushViewController:verifySMSVC animated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:@"手机号有误，请重新输入"];
        }
    }else{
        [SVProgressHUD showWithStatus:@"请稍候..."];
        [RegisterClient requestVerifyCode:_phoneNumTF.text
                                  success:^(NSDictionary *successData) {
                                      BNLog(@"%@", successData);
                                      NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                                      if ([retCode isEqualToString:kRequestSuccessCode]) {
                                          [SVProgressHUD dismiss];
                                          
                                        [weakSelf pushViewController:verifySMSVC animated:YES];
                                          
                                          BNLog(@"%@", [successData valueNotNullForKey:kRequestRetMessage]) ;
                                      }else{
                                          NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                          [SVProgressHUD showErrorWithStatus:retMsg];
                                      }
                                  } failure:^(NSError *error) {
                                      [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                  }];
    }

   
}
@end
