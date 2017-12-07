//
//  BNSetLoginPwdViewController.m
//  NewWallet
//
//  Created by mac1 on 14-10-28.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNSetLoginPwdViewController.h"

#import "RegisterClient.h"
#import "GesturePasswordController.h"
#import "Password.h"
#import "LoginApi.h"
#import "KeychainItemWrapper.h"
#import "XifuLoginAccount.h"
#import "BNBaseTextField.h"

@interface BNSetLoginPwdViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) UIScrollView *scrollView;

@property (weak, nonatomic) UIView *inputView;

@property (assign, nonatomic) BOOL isShowSchoolSelectView;

@property (weak, nonatomic) UITextField *firstPwdTextField;

@property (weak, nonatomic) UITextField *secondPwdTextField;

@property (weak, nonatomic) UIButton *finishButton;
@end


@implementation BNSetLoginPwdViewController

#pragma mark - setup loaded view
- (void)setupLoadedView
{
    
    self.sixtyFourPixelsView.backgroundColor = [UIColor whiteColor];
    UILabel *lineLbl = (UILabel *)[self.customNavigationBar viewWithTag:10001];
    lineLbl.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *theScollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT- self.sixtyFourPixelsView.viewBottomEdge)];
    theScollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge);
    theScollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:theScollView];
    self.scrollView = theScollView;
    
    CGFloat originY = 60*NEW_BILI;
    CGRect backgroundViewRect = _scrollView.frame;

    switch (self.useStyle) {
        case ViewControllerUseStyleFindPassword: {
            self.navigationTitle = @"忘记密码";

//            originY = 0;
//            UILabel *findPwdTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, originY, backgroundViewRect.size.width - 20, 36*BILI_WIDTH)];
//            findPwdTipsLabel.textColor = [UIColor lightGrayColor];
//            findPwdTipsLabel.textAlignment = NSTextAlignmentLeft;
//            findPwdTipsLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
//            findPwdTipsLabel.backgroundColor = [UIColor clearColor];
//            findPwdTipsLabel.text = @"请设置新的登录密码";
//            [_scrollView addSubview:findPwdTipsLabel];
//            originY += findPwdTipsLabel.frame.size.height;
            
            break;
        }
        case ViewControllerUseStyleRegist: {
            self.navigationTitle = @"注 册";
            break;
        }
        case ViewControllerUseStyleModifyLoginPwd: {
            self.navigationTitle = @"设置密码";
            break;
        }
        case ViewControllerUseStyleModifyGesturePwd: {
            //不会到此
            break;
        default:
            break;
        }
    }

    UIView *tfBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, originY, backgroundViewRect.size.width, 92*BILI_WIDTH)];
    tfBackgroundView.tag = 100;
    tfBackgroundView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:tfBackgroundView];

    BNBaseTextField *firstPwdTF = [[BNBaseTextField alloc] initWithFrame:CGRectMake(0, 0, tfBackgroundView.frame.size.width, 59)];
    firstPwdTF.font = [UIFont systemFontOfSize:[BNTools sizeFit:16 six:18 sixPlus:20]];
    self.firstPwdTextField = firstPwdTF;
    firstPwdTF.placeholder = @"输入密码";
    firstPwdTF.clearButtonMode = UITextFieldViewModeAlways;
    firstPwdTF.borderStyle = UITextBorderStyleNone;
    firstPwdTF.secureTextEntry = YES;
    firstPwdTF.delegate = self;
    [firstPwdTF addTarget:self action:@selector(textFieldEditingChangedValue:) forControlEvents:UIControlEventEditingChanged];
    firstPwdTF.tag = 100;
    
    BNBaseTextField *secondPwdTF = [[BNBaseTextField alloc] initWithFrame:CGRectMake(0, 59, tfBackgroundView.frame.size.width, 59)];
    secondPwdTF.font = [UIFont systemFontOfSize:[BNTools sizeFit:16 six:18 sixPlus:20]];
    self.secondPwdTextField = secondPwdTF;
    secondPwdTF.placeholder = @"确认密码";
    secondPwdTF.clearButtonMode = UITextFieldViewModeAlways;
    secondPwdTF.borderStyle = UITextBorderStyleNone;
    secondPwdTF.secureTextEntry = YES;
    secondPwdTF.delegate = self;
    [secondPwdTF addTarget:self action:@selector(textFieldEditingChangedValue:) forControlEvents:UIControlEventEditingChanged];
    secondPwdTF.tag = 101;
    
    [tfBackgroundView addSubview:firstPwdTF];
    [tfBackgroundView addSubview:secondPwdTF];

    
    originY += tfBackgroundView.frame.size.height+50*NEW_BILI;
    
    UIButton *nextStepButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextStepButton.frame = CGRectMake(30, originY, backgroundViewRect.size.width - 30 *2, 40*NEW_BILI);
    [nextStepButton setupTitle:@"确定" enable:YES];
    [nextStepButton addTarget:self action:@selector(finishTouchUpAction:) forControlEvents:UIControlEventTouchUpInside];
    [nextStepButton addTarget:self action:@selector(finishTouchDownAction:) forControlEvents:UIControlEventTouchDown];
    self.finishButton = nextStepButton;
    [_scrollView addSubview:nextStepButton];
    
//    UILabel *rechargeTips = [[UILabel alloc] initWithFrame:CGRectMake(0, nextStepButton.frame.origin.y + nextStepButton.frame.size.height + 10, _scrollView.frame.size.width, 80)];
//    rechargeTips.textAlignment = NSTextAlignmentCenter;
//    rechargeTips.numberOfLines = 0;
//    
//    NSMutableAttributedString *tipsStr = [[NSMutableAttributedString alloc] initWithString: @"温馨提示\n1、密码必须为6~16位字符;\n2、密码不支持空格和标点符号。"];
//    [tipsStr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, [tipsStr length])];
//    [tipsStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 4)];
//    [tipsStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(4, [tipsStr length] - 4)];
//    rechargeTips.attributedText = tipsStr;
//    [_scrollView addSubview:rechargeTips];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelKeyboard:)];
    [self.scrollView addGestureRecognizer:tap];
    
    
    self.isShowSchoolSelectView = NO;
    
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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (SCREEN_HEIGHT < 500) {
        [self addResponseKeyboardAction];
    }
    
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (SCREEN_HEIGHT < 500) {
        [self removeResponseKeyboardAction];
    }
}

#pragma mark - keyboard
- (void)keyboardWillHidden:(NSNotification *)note
{
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    
}

- (void)keyboardDidShow:(NSNotification *)note
{
    [self.scrollView setContentOffset:CGPointMake(0, 5)];
}

-(void)textFieldEditingChangedValue:(UITextField *)tf
{
//    if (self.firstPwdTextField.text.length >= 0 && self.secondPwdTextField.text.length >= 0) {
//        [self.finishButton setBackgroundColor:UIColor_Button_Normal];
//        [self.finishButton setEnabled:YES];
//    }else{
//        [self.finishButton setBackgroundColor:UIColor_Button_Disable];
//        [self.finishButton setEnabled:NO];
//    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length == 0) {
        return YES;
    }
    NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
    if (range.location > 0 && range.length == 1 && string.length == 0) {
        [textField deleteBackward];
        return NO;
    } else if (![string isEqualToString:filtered]) {
        return NO;    //特殊字符
    } else {
        NSString *strVar = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if ([strVar length] > 16) {
            return NO;
        }
    }
    return YES;
}
#pragma mark - button action
- (void)finishTouchUpAction:(UIButton *)btn
{
    [btn setBackgroundColor:UIColor_Button_Normal];
    [btn setEnabled:NO];
    __block NSString *firstPwd  = self.firstPwdTextField.text;
    __block NSString *secondPwd = self.secondPwdTextField.text;
    
//    NSDictionary *registInfo = @{@"name":      weakSelf.selectSchoolName,
//                                 @"verifycode":weakSelf.verifycode,
//                                 @"phoneNum":  weakSelf.registPhone,
//                                 @"schoolid":       weakSelf.selectSchoolNum};
    if (![firstPwd isEqualToString:secondPwd]) {
        self.firstPwdTextField.text = @"";
        self.secondPwdTextField.text = @"";
        [self.firstPwdTextField becomeFirstResponder];
        
        [SVProgressHUD showErrorWithStatus:@"您两次输入的密码不一致，请输入正确的密码"];
        
        [self.finishButton setEnabled:YES];

    } else if (firstPwd.length < 6 || secondPwd.length < 6 || firstPwd.length > 16 || secondPwd.length > 16) {
        self.firstPwdTextField.text = @"";
        self.secondPwdTextField.text = @"";
        [self.firstPwdTextField becomeFirstResponder];
        
        [SVProgressHUD showErrorWithStatus:@"密码必须为6~16位字符，且不支持空格和标点符号。"];
        
        [self.finishButton setEnabled:YES];
    }
    else if([firstPwd isEqualToString:secondPwd]){
        __weak typeof(self) weakSelf = self;
        [SVProgressHUD showWithStatus:@"请稍候"];

        
        switch (weakSelf.useStyle) {
            case ViewControllerUseStyleRegist:
            {
                [RegisterClient setLoginPhoneNum:[weakSelf.registInfoDictionary valueNotNullForKey:@"phoneNum"]
                                             pwd:firstPwd
                                      verifyCode:[weakSelf.registInfoDictionary valueNotNullForKey:@"verifycode"]
                                        schoolId:[weakSelf.registInfoDictionary valueNotNullForKey:@"schoolid"]
                                         success:^(NSDictionary *successData) {
                                             BNLog(@"注册--%@", successData);
                                             
                                             NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                                             
                                             if ([retCode isEqualToString:kRequestSuccessCode]) {
                                                 
                                                 
                                                 [SVProgressHUD showSuccessWithStatus:@"恭喜您注册成功"];
                                                 [kUserDefaults setObject:@"NO" forKey:kISOpenTouchIDKEY];
                                                 [self loginActionWithPhoneNum:[weakSelf.registInfoDictionary valueNotNullForKey:@"phoneNum"] andPsw:firstPwd];
                                                 
                                             }else{
                                                 NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                                 [SVProgressHUD showErrorWithStatus:retMsg];
                                                 [weakSelf.finishButton setEnabled:YES];
                                             }
                                             
                                         } failure:^(NSError *error) {
                                             [SVProgressHUD showErrorWithStatus:error.domain];
                                             [weakSelf.finishButton setEnabled:YES];
                                         }];

            }
                break;
                
            case ViewControllerUseStyleFindPassword:
            {
                [RegisterClient setNewLoginPwdWithUserPhone:[weakSelf.registInfoDictionary valueNotNullForKey:@"phoneNumber"]
                                                 verifycode:[weakSelf.registInfoDictionary valueNotNullForKey:@"verifycode"]
                                                   password:firstPwd
                                                    success:^(NSDictionary *successData) {
                                                        NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                                                        
                                                        if ([retCode isEqualToString:kRequestSuccessCode]) {
                                                            //提示姓名alert
                                                            [SVProgressHUD showSuccessWithStatus:@"恭喜您重新设置密码成功"];
                                                            
                                                            [self loginActionWithPhoneNum:[weakSelf.registInfoDictionary valueNotNullForKey:@"phoneNumber"] andPsw:firstPwd];
//                                                            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                                                            
                                                        }else{
                                                            NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                                            [SVProgressHUD showErrorWithStatus:retMsg];
                                                            [weakSelf.finishButton setEnabled:YES];
                                                        }
                                                        
                                                    } failure:^(NSError *error) {
                                                        [SVProgressHUD showErrorWithStatus:error.domain];
                                                        [weakSelf.finishButton setEnabled:YES];
                                                    }];

            }
                break;
                
            case ViewControllerUseStyleModifyLoginPwd:
            {
                if (self.oldLoginPassword.length > 0 && shareAppDelegateInstance.boenUserInfo.userid.length > 0) {
                    NSDictionary *info = @{@"old_password":self.oldLoginPassword,
                                           @"new_password":firstPwd,
                                           @"userid":shareAppDelegateInstance.boenUserInfo.userid
                                           
                                           };
                    shareAppDelegateInstance.popToViewController = @"BNSettingsViewController";
                    __weak typeof(shareAppDelegateInstance) weakAppDelegate = shareAppDelegateInstance;
                    [Password modifyLoginPwd:info
                                     success:^(NSDictionary *returnData) {
                                         BNLog(@"Verify login pwd data %@", returnData);
                                         NSString *retCode = [returnData valueNotNullForKey:kRequestRetCode];
                                         if ([retCode isEqualToString:kRequestSuccessCode]) {
                                             
                                             [SVProgressHUD showSuccessWithStatus:@"您已经重新设置登录密码"];
                                             Class objVC = NSClassFromString(weakAppDelegate.popToViewController);
                                             NSArray *viewControllers = weakSelf.navigationController.viewControllers;
                                             UIViewController *skipVC = nil;
                                             if ([weakAppDelegate.popToViewController isEqualToString:@"BNSettingsViewController"]) {
                                                 
                                                 for (UIViewController *obj in viewControllers) {
                                                     if ([obj isKindOfClass:objVC] == YES) {
                                                         skipVC = (UIViewController *)obj;
                                                         break;
                                                     }
                                                 }
                                                 [weakSelf.navigationController popToViewController:skipVC animated:YES];
                                             }else{
                                                 [weakSelf.finishButton setEnabled:YES];
                                             }
                                             
                                         }else{
                                             NSString *retMsg = [returnData valueNotNullForKey:kRequestRetMessage];
                                             [SVProgressHUD showErrorWithStatus:retMsg];
                                             [weakSelf.finishButton setEnabled:YES];
                                         }
                                     }
                                     failure:^(NSError *error) {
                                         [SVProgressHUD showErrorWithStatus:error.domain];
                                         [weakSelf.finishButton setEnabled:YES];
                                         [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];

                                     }];
                }

            }
                break;
            default:
                break;
        }
        
        
    }
}

- (void)finishTouchDownAction:(UIButton *)btn
{
    [btn setBackgroundColor:UIColor_Button_HighLight];
    [self.view endEditing:YES];
}
- (void)loginActionWithPhoneNum:(NSString *)phoneNums andPsw:(NSString *)pwds
{
    __block NSString *phoneNum = phoneNums;
    __block NSString *pwd      = pwds;
    __weak typeof(self) weakSelf = self;
    NSDictionary *loginInfo = @{@"mobile":phoneNum,
                                @"password":pwd};
    [SVProgressHUD showWithStatus:@"请稍候,正在登录..."];
    [LoginApi loginWithUsernameAndPwd:loginInfo
                              success:^(NSDictionary *successData) {
                                  BNLog(@"%@", successData);
                                  NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                                  
                                  if ([retCode isEqualToString:kRequestSuccessCode]) {
                                      NSDictionary *retData = [successData valueForKey:kRequestReturnData];
                                      
                                      shareAppDelegateInstance.boenUserInfo.userid = [retData valueNotNullForKey:@"userid"];
                                      shareAppDelegateInstance.boenUserInfo.phoneNumber = phoneNum;
                                      
                                      //如果有邀请码，确立老带新关系
                                      if (shareAppDelegateInstance.boenUserInfo.invitedCode.length > 0) {
                                          [LoginApi checkInvitationCodeWithUserId:[retData valueNotNullForKey:@"userid"]
                                                                         Ivt_code:shareAppDelegateInstance.boenUserInfo.invitedCode
                                                                          Success:^(NSDictionary *data) {
                                                                              BNLog(@"确立新老关系--->>>> %@",data);
                                                                              if ([[data valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                                                                                  //donoting
                                                                              }else{
                                                                                  [SVProgressHUD showErrorWithStatus:[data valueNotNullForKey:kRequestRetMessage]];
                                                                              }
                                                                          }
                                                                          failure:^(NSError *error) {
                                                                              [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                                                          }];
                                      }
                                      
                                      //记录登录过的账号到数据库
                                      NSArray *accountSorted = [XifuLoginAccount MR_findByAttribute:@"xifuLoginAccount" withValue:phoneNum];
                                      if ([accountSorted count] == 0) {//没有在数据库中找到添加到数据库
                                          XifuLoginAccount *account = [XifuLoginAccount MR_createEntity];
                                          account.xifuLoginAccount = phoneNum;
                                          [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfAndWait];
                                      }

                                      
                                      KeychainItemWrapper * keychinLogin = [[KeychainItemWrapper alloc]initWithIdentifier:kKeyChainAccessGroup_LastLoginUserId accessGroup:kKeyChainAccessGroup_LastLoginUserId];
                                      [keychinLogin setObject:phoneNum forKey:(__bridge id)kSecAttrAccount];
                                      [keychinLogin setObject:shareAppDelegateInstance.boenUserInfo.userid forKey:(__bridge id)kSecAttrDescription];

                                      [LoginApi getProfile:shareAppDelegateInstance.boenUserInfo.userid
                                                   success:^(NSDictionary *successData) {
                                                       
                                                       BNLog(@"getProfile--%@", successData);
                                                       NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                                                       
                                                       if ([retCode isEqualToString:kRequestSuccessCode]) {
                                                           [SVProgressHUD dismiss];

                                                           NSDictionary *retData = [successData valueForKey:kRequestReturnData];
                                                           [BNTools setProfileUserInfo:retData];

                                                           shareAppDelegateInstance.haveGetPrefile = YES;
                                                           
                                                           KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:shareAppDelegateInstance.boenUserInfo.userid accessGroup:kKeyChainAccessGroup_Gesture];
                                                           NSString *password = [keychin objectForKey:(__bridge id)kSecValueData];
                                                           if ([password isEqualToString:@""]) {
                                                               
                                                               GesturePasswordController *gestureVC = [[GesturePasswordController alloc]init];
                                                               gestureVC.vcType = VcTypeFirstSetPsw;
                                                               
                                                               NSArray *viewControllers = self.navigationController.viewControllers;
                                                               UIViewController *skipVC = nil;
                                                               Class tempClass =  NSClassFromString(@"BNSettingsViewController");
                                                               for (UIViewController *obj in viewControllers) {
                                                                   if ([obj isKindOfClass:tempClass] == YES) {
                                                                       skipVC = (UIViewController *)obj;
                                                                       break;
                                                                   }
                                                               }
                                                               if (skipVC != nil) {
                                                                   gestureVC.nameOfRootPushVC = @"BNSettingsViewController";

                                                               }else{
                                                                   if (!self.presentingViewController) {
                                                                        gestureVC.nameOfRootPushVC = @"BNHomeViewController";
                                                                   }
                                                               }
                                                               
                                                               
                                                               [weakSelf pushViewController:gestureVC animated:YES];
                                                           }
                                                           else {
                                                               
                                                               if (self.presentingViewController) {
                                                                   [weakSelf dismissViewControllerAnimated:YES completion:nil];
                                                               } else {
                                                                   [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                                                               }
                                                               [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshOneCardHomeInfoAndProfile object:nil];
                                                           }
                                                           
                                                       }else{
                                                           shareAppDelegateInstance.haveGetPrefile = NO;
                                                           NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                                           [SVProgressHUD showErrorWithStatus:retMsg];
                                                       }
                                                       
                                                   } failure:^(NSError *error) {
                                                       shareAppDelegateInstance.haveGetPrefile = NO;
                                                       
                                                       [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                                   }];
                                      
                                      
                                  }else{
                                      NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                      [SVProgressHUD showErrorWithStatus:retMsg];
                                  }
                                  
                              } failure:^(NSError *error) {
                                  
                                  [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                  
                              }];
    
}

@end
