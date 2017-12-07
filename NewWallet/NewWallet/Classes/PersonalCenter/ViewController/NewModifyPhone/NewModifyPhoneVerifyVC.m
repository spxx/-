//
//  NewModifyPhoneVerifyVC.m
//  Wallet
//
//  Created by mac on 15/6/2.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "NewModifyPhoneVerifyVC.h"
#import "TixianApi.h"
#import "LoginApi.h"

#import "BNModifyBindPhoneNumVC.h"

@interface NewModifyPhoneVerifyVC ()<UIAlertViewDelegate>

@property (nonatomic) UIScrollView *theScollView;
@property (nonatomic) UITextField *nameTF;
@property (nonatomic) UITextField *studentnoTF;
@property (nonatomic) UITextField *identityTF;
@property (nonatomic) UIButton *nextButton;
@property (nonatomic) NSInteger errorCount;

@end

@implementation NewModifyPhoneVerifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"修改手机号";
    self.view.backgroundColor = UIColor_Gray_BG;
    _errorCount = 0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taped)];
    [self.view addGestureRecognizer:tap];
    
    self.theScollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT- self.sixtyFourPixelsView.viewBottomEdge)];
    _theScollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge + 1);
    [self.view addSubview:_theScollView];

    NSInteger rows = _verifyType == ModifyPhoneVerifyTypeIdentity ? 3 : 1;
    
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 12*BILI_WIDTH, SCREEN_WIDTH, rows*45*BILI_WIDTH)];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.borderColor = UIColor_GrayLine.CGColor;
    whiteView.layer.borderWidth = 0.5;
    [_theScollView addSubview:whiteView];
    
    //1
    UILabel *nameLbl = [[UILabel alloc]initWithFrame:CGRectMake(10*BILI_WIDTH, 0, 80*BILI_WIDTH, 45*BILI_WIDTH)];
    nameLbl.backgroundColor = [UIColor clearColor];
    nameLbl.textColor = [UIColor blackColor];
    nameLbl.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
    nameLbl.text = _verifyType == ModifyPhoneVerifyTypeIdentity ? @"姓名" : @"登录密码";
    [whiteView addSubview:nameLbl];
    
    self.nameTF = [[UITextField alloc]initWithFrame:CGRectMake(100*BILI_WIDTH, 0, SCREEN_WIDTH-110*BILI_WIDTH, 45*BILI_WIDTH)];
    _nameTF.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
    _nameTF.textColor = [UIColor blackColor];
    _nameTF.placeholder = _verifyType == ModifyPhoneVerifyTypeIdentity ? @"请填写自己姓名" : @"请输入登录密码";
    _nameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_nameTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [whiteView addSubview:_nameTF];
    if (_verifyType == ModifyPhoneVerifyTypeLoginPsw) {
        _nameTF.secureTextEntry = YES;
    }
    UIView *lineView0 = [[UIView alloc]initWithFrame:CGRectMake(10*BILI_WIDTH, 45*BILI_WIDTH, SCREEN_WIDTH-10*BILI_WIDTH, 0.5)];
    lineView0.backgroundColor = UIColor_GrayLine;
    [whiteView addSubview:lineView0];

    if (_verifyType == ModifyPhoneVerifyTypeIdentity) {
        //2
        UILabel *studentnoLbl = [[UILabel alloc]initWithFrame:CGRectMake(10*BILI_WIDTH, 45*BILI_WIDTH, 80*BILI_WIDTH, 45*BILI_WIDTH)];
        studentnoLbl.backgroundColor = [UIColor clearColor];
        studentnoLbl.textColor = [UIColor blackColor];
        studentnoLbl.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
        studentnoLbl.text = @"学号";
        [whiteView addSubview:studentnoLbl];
        
        self.studentnoTF = [[UITextField alloc]initWithFrame:CGRectMake(100*BILI_WIDTH, 45*BILI_WIDTH, SCREEN_WIDTH-110*BILI_WIDTH, 45*BILI_WIDTH)];
        _studentnoTF.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
        _studentnoTF.textColor = [UIColor blackColor];
        _studentnoTF.placeholder = @"请填写自己学号/工号";
        _studentnoTF.keyboardType = UIKeyboardTypeASCIICapable;
        _studentnoTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_studentnoTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        [whiteView addSubview:_studentnoTF];
        
        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(10*BILI_WIDTH, 90*BILI_WIDTH, SCREEN_WIDTH-10*BILI_WIDTH, 0.5)];
        lineView1.backgroundColor = UIColor_GrayLine;
        [whiteView addSubview:lineView1];
        
        //3
        UILabel *identityLbl = [[UILabel alloc]initWithFrame:CGRectMake(10*BILI_WIDTH, 90*BILI_WIDTH, 80*BILI_WIDTH, 45*BILI_WIDTH)];
        identityLbl.backgroundColor = [UIColor clearColor];
        identityLbl.textColor = [UIColor blackColor];
        identityLbl.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
        identityLbl.text = @"身份证号";
        [whiteView addSubview:identityLbl];
        
        self.identityTF = [[UITextField alloc]initWithFrame:CGRectMake(100*BILI_WIDTH, 90*BILI_WIDTH, SCREEN_WIDTH-110*BILI_WIDTH, 45*BILI_WIDTH)];
        _identityTF.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
        _identityTF.textColor = [UIColor blackColor];
        _identityTF.placeholder = @"请填写自己身份证号";
        _identityTF.keyboardType = UIKeyboardTypeASCIICapable;
        _identityTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_identityTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        [whiteView addSubview:_identityTF];
    }
    
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextButton.frame = CGRectMake(10*BILI_WIDTH, CGRectGetMaxY(whiteView.frame)+33*BILI_WIDTH, SCREEN_WIDTH - 20*BILI_WIDTH, 40 * BILI_WIDTH);
    [_nextButton setupTitle:@"提交验证" enable:YES];
    [_nextButton addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _nextButton.enabled = NO;
    [_theScollView addSubview:_nextButton];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];

}

- (void)textFieldChanged:(UITextField *)textField
{
    if (textField == _identityTF) {
        if (_identityTF.text.length > 18) {
            [textField deleteBackward];
        }
        if (textField.text.length > 0) {
            NSString *str = [Tools limiteIDOfString:textField.text];
            textField.text = str;
        }
    }
    if (_verifyType == ModifyPhoneVerifyTypeLoginPsw) {
        if (_nameTF.text.length > 0) {
            _nextButton.enabled = YES;
        } else {
            _nextButton.enabled = NO;
        }
    } else {
        if (_nameTF.text.length > 0 && _studentnoTF.text.length > 0 && _identityTF.text.length > 0) {
            _nextButton.enabled = YES;
        } else {
            _nextButton.enabled = NO;
        }
    }
   
}
- (void)nextButtonAction:(UIButton *)button
{
    [self.view endEditing:YES];
    
    [SVProgressHUD showWithStatus:@"请稍候..."];
    if (_verifyType == ModifyPhoneVerifyTypeLoginPsw) {
        //登录密码验证
        NSDictionary *loginInfo = @{@"mobile":shareAppDelegateInstance.boenUserInfo.phoneNumber,
                                    @"password":_nameTF.text};
        [LoginApi loginWithUsernameAndPwd:loginInfo
                                  success:^(NSDictionary *successData) {
                                      BNLog(@"login-psw-%@", successData);
                                      NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                                      if ([retCode isEqualToString:kRequestSuccessCode]) {
                                          [SVProgressHUD dismiss];
                                          //新手机号
                                          BNModifyBindPhoneNumVC *modifyPhoneVC = [[BNModifyBindPhoneNumVC alloc] init];
                                          modifyPhoneVC.useStyle = ViewControllerUseStyleVerifyNewPhone;
                                          [self pushViewController:modifyPhoneVC animated:YES];
                                      } else if ([retCode isEqualToString:@"2104"]) {
                                          [SVProgressHUD showErrorWithStatus:@"输入信息有误，请重新输入"];
                                      } else {
                                          NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                          [SVProgressHUD showErrorWithStatus:retMsg];
                                      }
                                      
                                  } failure:^(NSError *error) {
                                      
                                      [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                      
                                  }];
    } else {
        //身份信息验证
        [TiXianApi modifyPswVerifyCertInfoWIthRealName:_nameTF.text stuempno:_studentnoTF.text certNo:_identityTF.text Success:^(NSDictionary *returnData) {
            BNLog(@"returnData--%@",returnData);

            NSString *code = [NSString stringWithFormat:@"%@",[returnData valueNotNullForKey:kRequestRetCode]];
            if ([code isEqualToString:kRequestSuccessCode])
            {
                [SVProgressHUD dismiss];

                NSDictionary *dataDict = [returnData valueNotNullForKey:kRequestReturnData];
                NSString *binded = [NSString stringWithFormat:@"%@",[dataDict valueNotNullForKey:@"binded"]];
                NSString *status = [NSString stringWithFormat:@"%@",[dataDict valueNotNullForKey:@"status"]];
                if ([binded isEqualToString:@"1"] && [status isEqualToString:@"1"]) {
                    //新手机号
                    BNModifyBindPhoneNumVC *modifyPhoneVC = [[BNModifyBindPhoneNumVC alloc] init];
                    modifyPhoneVC.useStyle = ViewControllerUseStyleVerifyNewPhone;
                    [self pushViewController:modifyPhoneVC animated:YES];

                } else if ([binded isEqualToString:@"0"]) {
                    //没绑过卡或学号, 需要使用其他的修改手机号方式.
                    shareAppDelegateInstance.alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"验证身份信息失败，请选择其它校验方式。" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                    shareAppDelegateInstance.alertView.tag = 101;
                    [shareAppDelegateInstance.alertView show];
                    
                } else{

                    if (_errorCount >= 2) {
                        shareAppDelegateInstance.alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"身份信息有误，你可以选择其它校验方式。" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                        shareAppDelegateInstance.alertView.tag = 102;
                        [shareAppDelegateInstance.alertView show];
                    } else {
                        shareAppDelegateInstance.alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"身份信息有误，请重新输入！" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                        shareAppDelegateInstance.alertView.tag = 103;
                        [shareAppDelegateInstance.alertView show];
                        _errorCount++;
                    }
                }
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:returnData[kRequestRetMessage]];
            }
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
        }];
    }
}
- (void)taped
{
    [self.view endEditing:YES];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 101: {
            //没绑过卡或学号
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
            break;
        }
        case 102: {
            //错误3次以上
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            break;
        }
        case 103: {
            //验证错误
            _nameTF.text = @"";
            _studentnoTF.text = @"";
            _identityTF.text = @"";
            break;
        }
    }
}
#pragma mark -NSNotification事件
//当键盘高度改变时调用
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //
    if (SCREEN_HEIGHT > 500) {
        return;  //不是iPhone4s则
    }
    if (endFrame.origin.y == SCREEN_HEIGHT ) {
        //键盘隐藏时
        [UIView animateWithDuration:duration animations:^{
            [_theScollView scrollRectToVisible:CGRectMake(0, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge + 1, SCREEN_WIDTH, 1) animated:YES];
            _theScollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge + 1);
        }];

    }else  {
        //键盘出现或切换键盘类型时
        [UIView animateWithDuration:duration animations:^{
            [_theScollView scrollRectToVisible:CGRectMake(0, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge +85, SCREEN_WIDTH, 1) animated:YES];
            _theScollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge + 85);
        }];
    }
}
@end
