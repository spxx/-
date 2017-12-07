//
//  BNLoginViewController.m
//  NewWallet
//
//  Created by mac1 on 14-10-27.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNLoginViewController.h"

#import "BNVerifyPhoneViewController.h"

#import "LoginApi.h"
#import "KeychainItemWrapper.h"
#import "GesturePasswordController.h"

#import "XifuLoginAccount.h"

#import "SelectItemView.h"

#import "BNShowActivityViewController.h"

#import "BNMainViewController.h"
#import "BNNotLoginViewController.h"

#import "BNSelectSchoolViewController.h"
#import "BPush.h"

#import "BNXiaoDaiInfoRecordTool.h"
#import "BNNewXiaodaiRealNameInfo.h"
#import "BNBaseTextField.h"
#import "BNProtocolViewController.h"
#import "BNSetLoginPwdViewController.h"

@interface BNLoginViewController ()<UITextFieldDelegate, UIGestureRecognizerDelegate, SelectItemViewDelegate>

@property (weak, nonatomic) UIScrollView *scrollView;

@property (weak, nonatomic) UITextField *phoneTextField;

@property (weak, nonatomic) UITextField *passwordTextField;

@property (weak, nonatomic) UIButton *loginButton;

@property (assign, nonatomic) BOOL moreAccountViewIsShow;

@property (strong, nonatomic) SelectItemView *selectView;

@property (weak, nonatomic) UIButton *moreLoginAccountButton;
@end


@implementation BNLoginViewController

#pragma mark - setup login view;
- (void)setupLoadedView
{
    self.navigationTitle = @"登录";
    self.backButton.hidden = _hideBackBtn;
    
    self.sixtyFourPixelsView.backgroundColor = [UIColor whiteColor];
    UILabel *lineLbl = (UILabel *)[self.customNavigationBar viewWithTag:10001];
    lineLbl.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *theScollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT- self.sixtyFourPixelsView.viewBottomEdge)];
    theScollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge + 1);
    [self.view addSubview:theScollView];
    self.scrollView = theScollView;
    
    CGFloat originY = 60*NEW_BILI;

    UIView *loginInfoBGView = [[UIView alloc] initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, 59 * 2)];
    loginInfoBGView.backgroundColor = [UIColor whiteColor];
    originY += loginInfoBGView.heightValue;

    BNBaseTextField *phoneTF = [[BNBaseTextField alloc] initWithFrame:CGRectMake(0, 0, loginInfoBGView.frame.size.width, 59)];
    phoneTF.font = [UIFont systemFontOfSize:[BNTools sizeFit:16 six:18 sixPlus:20]];
    self.phoneTextField = phoneTF;
    phoneTF.keyboardType = UIKeyboardTypePhonePad;
    phoneTF.borderStyle = UITextBorderStyleNone;
    phoneTF.clearButtonMode = UITextFieldViewModeAlways;
    phoneTF.delegate = self;
    phoneTF.placeholder = @"手机号";
    phoneTF.tag = 100;
    [phoneTF addTarget:self action:@selector(textFieldEditingChangedValue:) forControlEvents:UIControlEventEditingChanged];

    
    BNBaseTextField *passwordTF = [[BNBaseTextField alloc] initWithFrame:CGRectMake(0, 59, loginInfoBGView.frame.size.width, 59)];
    passwordTF.font = [UIFont systemFontOfSize:[BNTools sizeFit:16 six:18 sixPlus:20]];
    self.passwordTextField = passwordTF;
    passwordTF.placeholder = @"密码";
    passwordTF.clearButtonMode = UITextFieldViewModeAlways;
    passwordTF.borderStyle = UITextBorderStyleNone;
    passwordTF.secureTextEntry = YES;
    passwordTF.delegate = self;
    [passwordTF addTarget:self action:@selector(textFieldEditingChangedValue:) forControlEvents:UIControlEventEditingChanged];
    passwordTF.tag = 101;
    
    [loginInfoBGView addSubview:phoneTF];
    [loginInfoBGView addSubview:passwordTF];
    
    [theScollView addSubview:loginInfoBGView];
   
    originY += 10*NEW_BILI;

    NSString *str = @"忘记密码？";
    CGSize size = [[UIFont systemFontOfSize:[BNTools sizeFit:14 six:15 sixPlus:16]] useThisFontWithString:str];
    
    UIButton *findPwdButton = [UIButton buttonWithType:UIButtonTypeCustom];
    findPwdButton.frame = CGRectMake(SCREEN_WIDTH - size.width - 30, originY, size.width + 5, 35*NEW_BILI);
    [findPwdButton setTitleColor:UIColor_NewBlueColor forState:UIControlStateNormal];
    [findPwdButton.titleLabel setFont:[UIFont systemFontOfSize:[BNTools sizeFit:14 six:15 sixPlus:16]]];
    [findPwdButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [findPwdButton addTarget:self action:@selector(findPasswordAction:) forControlEvents:UIControlEventTouchUpInside];
    [theScollView addSubview:findPwdButton];
    
    originY += findPwdButton.frame.size.height+30*NEW_BILI;

    UIButton *nextStepButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextStepButton.frame = CGRectMake(30, originY, SCREEN_WIDTH - 2*30, 40 * BILI_WIDTH);
    [nextStepButton setupTitle:@"登录" enable:NO];
    [nextStepButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [theScollView addSubview:nextStepButton];
    _loginButton = nextStepButton;

    originY += nextStepButton.frame.size.height + 20*NEW_BILI;
    
    UIButton *fastRegister = [UIButton buttonWithType:UIButtonTypeCustom];
    fastRegister.frame = CGRectMake((theScollView.frame.size.width -100)/2, originY, 100, 40);
    [fastRegister setTitleColor:UIColor_NewBlueColor forState:UIControlStateNormal];
    [fastRegister.titleLabel setFont:[UIFont systemFontOfSize:[BNTools sizeFit:14 six:15 sixPlus:16]]];
    [fastRegister setTitle:@"快速注册" forState:UIControlStateNormal];
    fastRegister.contentMode = UIViewContentModeCenter;
    [fastRegister addTarget:self action:@selector(fastRegitsteAction:) forControlEvents:UIControlEventTouchUpInside];
    [theScollView addSubview:fastRegister];

    //底部使用协议
    UIView *protocolBKView = [[UIView alloc] initWithFrame:CGRectMake(0, theScollView.frame.size.height-50*NEW_BILI, SCREEN_WIDTH, 24*NEW_BILI)];
    protocolBKView.backgroundColor = [UIColor clearColor];
    [theScollView addSubview:protocolBKView];
    
    UILabel *agreeLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 130*NEW_BILI, 24*NEW_BILI)];
    agreeLbl.textColor = UIColorFromRGB(0xb0adad);
    agreeLbl.font = [UIFont systemFontOfSize:11*NEW_BILI];
    [protocolBKView addSubview:agreeLbl];
    agreeLbl.text = @"点击登录代表同意「喜付」";
    CGFloat textWidth = [Tools getTextWidthWithText:agreeLbl.text font:agreeLbl.font height:agreeLbl.frame.size.height];
    agreeLbl.frame = CGRectMake(agreeLbl.frame.origin.x, agreeLbl.frame.origin.y, textWidth, agreeLbl.frame.size.height);
    
    UIButton *readButton = [UIButton buttonWithType:UIButtonTypeCustom];
    readButton.tag = 104;
    [readButton addTarget:self action:@selector(displayProtocolAction:) forControlEvents:UIControlEventTouchUpInside];
    [readButton setTitle:@" 使用协议" forState:UIControlStateNormal];
    [readButton setTitleColor:UIColorFromRGB(0xb0adad) forState:UIControlStateNormal];
    [readButton setTitleColor:UIColorFromRGB(0xbbbbbb) forState:UIControlStateHighlighted];
    readButton.titleLabel.font = [UIFont systemFontOfSize:11*NEW_BILI];
    CGFloat redTextWidth = [Tools getTextWidthWithText:@" 使用协议" font:agreeLbl.font height:agreeLbl.frame.size.height];
    readButton.frame = CGRectMake(CGRectGetMaxX(agreeLbl.frame), 0, redTextWidth+10*NEW_BILI, 24*NEW_BILI);
    
    UILabel *bottomLine = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(agreeLbl.frame)+4, 1*NEW_BILI, redTextWidth+12*NEW_BILI, 24*NEW_BILI)];
    bottomLine.textColor = UIColorFromRGB(0xb0adad);
    bottomLine.font = [UIFont systemFontOfSize:11*NEW_BILI];
    [protocolBKView addSubview:bottomLine];
    bottomLine.text = @"_________";
    
    readButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    readButton.layer.cornerRadius = 3;
    readButton.layer.masksToBounds = YES;
    [protocolBKView addSubview:readButton];
    
    CGFloat allTextWidth = [Tools getTextWidthWithText:[agreeLbl.text stringByAppendingString:readButton.currentTitle] font:agreeLbl.font height:agreeLbl.frame.size.height];
    
    protocolBKView.frame = CGRectMake((SCREEN_WIDTH-allTextWidth)/2, protocolBKView.origin.y, allTextWidth, protocolBKView.heightValue);
    

    self.selectView = [[SelectItemView alloc]initWithRelateView:loginInfoBGView style:SelectItemViewUseStyleSelectXiFuAccount delegate:self];
    _selectView.hidden = YES;
    [theScollView addSubview:_selectView];
    
    UITapGestureRecognizer *cancelKeyboardTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelKeyboard:)];
    cancelKeyboardTap.delegate = self;
    [self.scrollView addGestureRecognizer:cancelKeyboardTap];

    [self updataLastLoginRecord];
}


- (void)updataLastLoginRecord
{
    KeychainItemWrapper * keychinLogin = [[KeychainItemWrapper alloc]initWithIdentifier:kKeyChainAccessGroup_LastLoginUserId accessGroup:kKeyChainAccessGroup_LastLoginUserId];
    NSString *phoneNum = [keychinLogin objectForKey:(__bridge id)kSecAttrAccount];
    BOOL userIDArrayContain = [Tools userIDArrayContain:kKeyChainAccessGroup_LastLoginUserId];
    
    if (phoneNum.length > 0 && userIDArrayContain) {
        _phoneTextField.text = phoneNum;
    }
}
- (void)cancelKeyboard:(UITapGestureRecognizer *)tap
{
    _selectView.hidden = YES;
    [self.view endEditing:YES];
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}

#pragma mark - SelectItemViewDelegate
- (void)selectLoginedAccount:(NSString *)account
{
    self.phoneTextField.text = account;
    self.passwordTextField.text = @"";
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (self.phoneTextField.text.length > 0 && self.passwordTextField.text.length > 0) {
        [self.loginButton setBackgroundColor:UIColor_Button_Normal];
        [self.loginButton setEnabled:YES];
    }else{
        [self.loginButton setBackgroundColor:UIColor_Button_Disable];
        [self.loginButton setEnabled:NO];
    }

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupLoadedView];
    
    self.moreAccountViewIsShow = NO;
    
}
#pragma makr - text field delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 100) {
        if (textField.text.length > 0) {
            _selectView.hidden = YES;
        }else{
            if (_selectView.hidden == YES) {
                [_selectView loadLoginAccountData];
            }
            _selectView.hidden = NO;
        }
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length == 0) {
        return YES;   //退格删除
    }
    if([string isEqualToString:@" "])//屏蔽空格
    {
        return NO;
    }
    if (textField.tag == 100) {
        NSString *strVar = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if ([strVar hasPrefix:@"1"]) {
            if (strVar.length > 0 && strVar.length <= 11) {
                NSRange range = [@"0123456789" rangeOfString:string];
                if (range.length > 0) {
                    return YES;
                } else {
                    return NO;
                }
            } else if (strVar.length > 11) {
                return NO;
            }
        } else{
            return NO;
        }
    }
    
    return YES;
}
-(void)textFieldEditingChangedValue:(UITextField *)tf
{
    if (tf.tag == 100) {
        if (tf.text.length > 0) {
            _selectView.hidden = YES;
        }else{
            if (_selectView.hidden == YES) {
                [_selectView loadLoginAccountData];
            }
            _selectView.hidden = NO;
            
        }
        if (tf.text.length < 11) {
            _passwordTextField.text = @"";
        }
    }

    if (_phoneTextField.text.length > 0 && _passwordTextField.text.length > 0) {
        [_loginButton setEnabled:YES];
    }else{
        [_loginButton setEnabled:NO];
    }
}

#pragma mark - button action
- (void)fastRegitsteAction:(UIButton *)btn
{
    [BNXiaoDaiInfoRecordTool clearXiaoDaiInfo];
    BNVerifyPhoneViewController *verifyVC = [[BNVerifyPhoneViewController alloc] init];
    verifyVC.useStyle = ViewControllerUseStyleRegist;
    [self pushViewController:verifyVC animated:YES];
}
- (void)loginAction:(UIButton *)btn
{
    [self.view endEditing:YES];
    
    __block NSString *phoneNum = self.phoneTextField.text;
    __block NSString *pwd      = self.passwordTextField.text;
    if (phoneNum == nil || pwd == nil || phoneNum.length <= 0 || pwd.length <= 0) {
        [Tools showMessageWithTitle:@"提示" message:@"请输入正确的手机号和密码"];
    }else{
        [[JavaHttpTools shareInstance] removeHttpCookie];//切换用户时，先清除上次登录用户的缓存。

        __weak typeof(self) weakSelf = self;
        NSDictionary *loginInfo = @{@"mobile":phoneNum,
                                    @"password":pwd};
        [SVProgressHUD showWithStatus:@"请稍候..."];
        [LoginApi loginWithUsernameAndPwd:loginInfo
                                  success:^(NSDictionary *successData) {
                                      BNLog(@"login-%@", successData);
                                      NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                                      
                                      if ([retCode isEqualToString:kRequestSuccessCode]) {
                                          __block NSDictionary *retData = [successData valueForKey:kRequestReturnData];
                                          
                                          [BNTools saveLoginCookies];
                                          
                                          shareAppDelegateInstance.boenUserInfo.userid = [retData valueNotNullForKey:@"userid"];
                                          shareAppDelegateInstance.boenUserInfo.phoneNumber = phoneNum;
 
                                          //记录登录过的账号到数据库
                                          NSArray *accountSorted = [XifuLoginAccount MR_findByAttribute:@"xifuLoginAccount" withValue:weakSelf.phoneTextField.text];
                                          if ([accountSorted count] == 0) {//没有在数据库中找到添加到数据库
                                              XifuLoginAccount *account = [XifuLoginAccount MR_createEntity];
                                              account.xifuLoginAccount = weakSelf.phoneTextField.text;
                                              [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfAndWait];
                                          }
                                          
                                          
                                          
                                         
                                          [LoginApi getProfile:shareAppDelegateInstance.boenUserInfo.userid
                                                       success:^(NSDictionary *successData) {
                                                           
                                                            BNLog(@"loginVC-getProfile--%@", successData);
                                                           NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                                                           
                                                           if ([retCode isEqualToString:kRequestSuccessCode]) {
                                                               
                                                               [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshBanner object:nil];
                                                               
                                                               //刷新数据
                                                               [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshPersonalCenterDetail object:nil];
                                                               [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshOneCardHomeInfoAndProfile object:nil];

                                                               //清除实名认证信息
                                                               [[BNNewXiaodaiRealNameInfo sharedBNNewXiaodaiRealNameInfo] clearRealNameInfo];
                                                               
                                                               NSDictionary *prefileRetData= [successData valueForKey:kRequestReturnData];
                                                               KeychainItemWrapper * keychinLogin = [[KeychainItemWrapper alloc]initWithIdentifier:kKeyChainAccessGroup_LastLoginUserId accessGroup:kKeyChainAccessGroup_LastLoginUserId];
//                                                               NSString *lastUserID = [keychinLogin objectForKey:(__bridge id)kSecAttrDescription];
                                                               
//                                                               [SVProgressHUD dismiss];
//                                                               [weakSelf saveUserInfoData:successData]; //开启百度推送删除这一行，打开下面的注释
                                                               
                                                              //不判断userid，直接每次都调绑定接口
//                                                               if (![lastUserID isEqualToString:[retData valueNotNullForKey:@"userid"]]) {
                                                                   //百度推送设置
                                                                   //如果上次登录用户userId和此次登录的不一样，更新百度推送tag,并重新绑定userid
                                                                   shareAppDelegateInstance.schoolIdForBaiDuTag = [NSString stringWithFormat:@"%@",[prefileRetData valueForKey:@"school_id"]];
                                                            
                                                                   [BPush listTagsWithCompleteHandler:^(id result, NSError *error) {
                                                                       //获取tagList
                                                                       int returnCode = [[result valueForKey:BPushRequestErrorCodeKey] intValue];
                                                                       if (returnCode == 0) {
                                                                           NSDictionary* params = [result valueForKey:BPushRequestResponseParamsKey];
                                                                           NSArray *tagAry = [params valueForKey:@"tags"];
                                                                           NSMutableArray *tempTagsAry = [@[] mutableCopy];
                                                                           for (NSDictionary *tagDict in tagAry) {
                                                                               [tempTagsAry addObject:tagDict[@"name"]];
                                                                           }
                                                                           if([tempTagsAry count] > 0)
                                                                           {
                                                                               //如果有Tag,先删除再setTag，防止用户换学校。
                                                                               [BPush delTags:tempTagsAry withCompleteHandler:^(id result, NSError *error) {
                                                                                   int returnCode = [[result valueForKey:BPushRequestErrorCodeKey] intValue];
                                                                                   if (returnCode == 0) {
                                                                                       if (shareAppDelegateInstance.schoolIdForBaiDuTag && shareAppDelegateInstance.schoolIdForBaiDuTag.length > 0) {
                                                                                           NSString *schollTag = [NSString stringWithFormat:@"school_%@",shareAppDelegateInstance.schoolIdForBaiDuTag];
                                                                                           BNLog(@"baidu-schollTag:%@",schollTag);
                                                                                           [BPush setTag:schollTag withCompleteHandler:^(id result, NSError *error) {
                                                                                               BNLog(@"baidu-setTag-result:%@",result);

                                                                                           }];
                                                                                       }
                                                                                   }

                                                                               }];
                                                                           } else {
                                                                               //如果没有Tag, 直接setTag
                                                                               if (shareAppDelegateInstance.schoolIdForBaiDuTag && shareAppDelegateInstance.schoolIdForBaiDuTag.length > 0) {
                                                                                   NSString *schollTag = [NSString stringWithFormat:@"school_%@",shareAppDelegateInstance.schoolIdForBaiDuTag];
                                                                                   BNLog(@"baidu-schollTag2:%@",schollTag);
                                                                                   [BPush setTag:schollTag withCompleteHandler:^(id result, NSError *error) {
                                                                                       BNLog(@"baidu-setTag2-result:%@",result);

                                                                                   }];                                                                               }
                                                                           }
                                                                           
                                                                       }
                                                                   }];
                                                               
                                                                   //更新绑定百度userid和喜付userid
                                                                   [LoginApi bindBaiDuPushWithUserID:[retData valueNotNullForKey:@"userid"]
                                                                                        baidu_userid:shareAppDelegateInstance.baiDuUserId
                                                                                     baidu_channelid:shareAppDelegateInstance.baiDuChannelId
                                                                                             success:^(NSDictionary *data) {
                                                                       BNLog(@"bindBaiDuPushWithUserID--%@", data);
                                                                        //由于百度推送生产模式的证书是个人开发者证书生产的，所以企业发布时，baiDuChannelId会是空的，此时只能强制让此接口返回成功，让用户登录成功。

                                                                           [keychinLogin setObject:phoneNum forKey:(__bridge id)kSecAttrAccount];
                                                                           [keychinLogin setObject:shareAppDelegateInstance.boenUserInfo.userid forKey:(__bridge id)kSecAttrDescription];
                                                                                               
                                                                            [SVProgressHUD dismiss];
                                                                           [weakSelf saveUserInfoData:successData];

                                                                   } failure:^(NSError *error) {
                                                                       [keychinLogin setObject:phoneNum forKey:(__bridge id)kSecAttrAccount];
                                                                       [keychinLogin setObject:shareAppDelegateInstance.boenUserInfo.userid forKey:(__bridge id)kSecAttrDescription];
                                                                       
                                                                       [SVProgressHUD dismiss];
                                                                       [weakSelf saveUserInfoData:successData];

                                                                   }];
//                                                               }
//                                                               else {
//                                                                   //如果上次登录用户userId和此次登录的一样，则不更新百度推送tag，也不重新绑定userid
//                                                                   [keychinLogin setObject:phoneNum forKey:(__bridge id)kSecAttrAccount];
//                                                                   
//                                                                   [keychinLogin setObject:shareAppDelegateInstance.boenUserInfo.userid forKey:(__bridge id)kSecAttrDescription];
//                                                                   [weakSelf saveUserInfoData:successData];
//                                                                   [SVProgressHUD dismiss];
//                                                               }
                                                           }else{
                                                               shareAppDelegateInstance.haveGetPrefile = NO;
                                                               [weakSelf.loginButton setEnabled:YES];
                                                               NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                                               [SVProgressHUD showErrorWithStatus:retMsg];
                                                           }
                                                           
                                                       } failure:^(NSError *error) {
                                                           [weakSelf.loginButton setEnabled:YES];
                                                           shareAppDelegateInstance.haveGetPrefile = NO;
    
                                                           [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                                       }];

                                          
                                      }else{
                                          weakSelf.passwordTextField.text = @"";
                                          [weakSelf.loginButton setEnabled:NO];
                                          
                                          NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                          [SVProgressHUD showErrorWithStatus:retMsg];
                                      }
 
                                  } failure:^(NSError *error) {
                                      weakSelf.passwordTextField.text = @"";
                                      [weakSelf.loginButton setEnabled:NO];
                                      [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                  }];
    }
    
}
- (void)saveUserInfoData:(NSDictionary *)successData
{
    
    NSDictionary *retData = [successData valueForKey:kRequestReturnData];
    [BNTools setProfileUserInfo:retData];
    
    shareAppDelegateInstance.haveGetPrefile = YES;

    KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:shareAppDelegateInstance.boenUserInfo.userid accessGroup:kKeyChainAccessGroup_Gesture];
    NSString *password = [keychin objectForKey:(__bridge id)kSecValueData];
    
    BOOL userIDArrayContain = [Tools userIDArrayContain:shareAppDelegateInstance.boenUserInfo.userid];

    if ([password isEqualToString:@""] || (![password isEqualToString:@""] && _isFromForget) || userIDArrayContain == NO) {
        
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
            if (!_isFromChangeUser) {
                gestureVC.nameOfRootPushVC = @"BNHomeViewController";
            }
        }
        
        
        
        [self pushViewController:gestureVC animated:YES];
    }
    else {
        if (_isFromChangeUser) {
            [self dismissViewControllerAnimated:YES completion:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_SetTabBarTo0 object:nil];

        } else {
            if (_hideBackBtn){
                [self dismissViewControllerAnimated:YES completion:nil];
                NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:kBundleKey];
                
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                
                NSString *saveVersion = [userDefault objectForKey:kBundleKey];
                
                if ([version isEqualToString:saveVersion] == NO) {
                    
                    BNMainViewController *mainVC = (BNMainViewController *)shareAppDelegateInstance.window.rootViewController;
                    
                    BNShowActivityViewController *showActivityVC = [[BNShowActivityViewController alloc] init];
                    showActivityVC.homeVC = mainVC.homeVC;
                    [shareAppDelegateInstance.window.rootViewController presentViewController:showActivityVC animated:YES completion:nil];
                }
                
            } else {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
    }
}
- (void)findPasswordAction:(UIButton *)btn
{
//    BNSetLoginPwdViewController *setLoginVC = [[BNSetLoginPwdViewController alloc] init];
//    setLoginVC.useStyle = ViewControllerUseStyleFindPassword;
//    setLoginVC.oldLoginPassword = self.phoneTextField.text;
//    [self pushViewController:setLoginVC animated:YES];
//    return;
    //找回登录密码
    BNVerifyPhoneViewController *verifyVC = [[BNVerifyPhoneViewController alloc] init];
    verifyVC.useStyle = ViewControllerUseStyleFindPassword;
    [self pushViewController:verifyVC animated:YES];
}

- (void)showMoreAccount:(UIButton *)btn
{
    if (_selectView.hidden == YES) {
        [_selectView loadLoginAccountData];
    }
    _selectView.hidden = !_selectView.hidden;
   
    btn.selected = !btn.selected;
}
- (void)displayProtocolAction:(UIButton *)btn
{
    BNProtocolViewController *protocolVC = [[BNProtocolViewController alloc] init];
    protocolVC.protocolFileName = @"xifu_protocol.htm";
    protocolVC.titleName = @"喜付服务协议";
    [self pushViewController:protocolVC animated:YES];
    
}
@end
