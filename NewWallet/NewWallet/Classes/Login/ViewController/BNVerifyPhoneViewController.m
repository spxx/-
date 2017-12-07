//
//  BNVerifyPhoneViewController.m
//  NewWallet
//
//  Created by mac1 on 14-10-27.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNVerifyPhoneViewController.h"
#import "BNSetLoginPwdViewController.h"
#import "BNVerifySMSCodeViewController.h"
#import "GesturePasswordController.h"
#import "RegisterClient.h"
#import "KeychainItemWrapper.h"
#import "Password.h"
#import "BNBaseTextField.h"
#import "BNProtocolViewController.h"
#import "BNNotLoginViewController.h"
#import "BNLoginViewController.h"
#import "XiaoDaiApi.h"
#import "BNAddInvitationCodeVC.h"
#import "PinYin4Objc.h"
#import "SchoolName.h"
#import "BNSelectSchoolViewController.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface BNVerifyPhoneViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) TPKeyboardAvoidingScrollView *scrollView;
@property (weak, nonatomic) BNBaseTextField *phoneTextField;
@property (nonatomic, weak) BNBaseTextField *pswTf;
@property (weak, nonatomic) UITextField *verifyCodeTf;
@property (weak, nonatomic) UILabel *verifyPhoneTipsLabel;
@property (weak, nonatomic) UIButton *nextStepButton;
@property (nonatomic, weak) UIButton *fetchCodeButton;


@property (assign, nonatomic) BOOL agreeProtocol;
@property (strong, nonatomic) NSTimer *fetchSMSCodeTimer;
@property (assign, nonatomic) NSInteger timerSeconds;

@end

@implementation BNVerifyPhoneViewController

NSInteger const kTmeier_second = 60;
NSString *const kSortSchools = @"sort_schools";
NSString *const kIndex = @"index";

#pragma mark - setup loaded view
- (void)setupLoadedView
{
    self.sixtyFourPixelsView.backgroundColor = [UIColor whiteColor];
    UILabel *lineLbl = (UILabel *)[self.customNavigationBar viewWithTag:10001];
    lineLbl.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    TPKeyboardAvoidingScrollView *theScollView = [[TPKeyboardAvoidingScrollView alloc]initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT- self.sixtyFourPixelsView.viewBottomEdge)];
    theScollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge);
    [self.view addSubview:theScollView];
    self.scrollView = theScollView;
    theScollView.backgroundColor = [UIColor whiteColor];
    
    CGFloat originY = 60*NEW_BILI;
    
    CGRect backgroundViewRect = self.scrollView.frame;
    
//    UILabel *tipsPhoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, originY, backgroundViewRect.size.width - 40, 22)];
//    tipsPhoneLabel.backgroundColor = [UIColor clearColor];
//    tipsPhoneLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
//    tipsPhoneLabel.textColor = [UIColor lightGrayColor];
//    self.verifyPhoneTipsLabel = tipsPhoneLabel;
//    [self.scrollView addSubview:tipsPhoneLabel];
//    originY += tipsPhoneLabel.frame.size.height;
//    
//    if(_useStyle == ViewControllerUseStyleRegist){
//        originY += 20 * NEW_BILI;
//    }
    
    BNBaseTextField *phoneTF = [[BNBaseTextField alloc] initWithFrame:CGRectMake(0, originY, backgroundViewRect.size.width, 59)];
    phoneTF.font = [UIFont systemFontOfSize:[BNTools sizeFit:16 six:18 sixPlus:20]];
    self.phoneTextField = phoneTF;
    phoneTF.keyboardType = UIKeyboardTypePhonePad;
    phoneTF.delegate = self;
    [phoneTF addTarget:self action:@selector(textFieldEditingChangedValue:) forControlEvents:UIControlEventEditingChanged];
    [self.scrollView addSubview:phoneTF];
    originY += phoneTF.frame.size.height;

    if(_useStyle == ViewControllerUseStyleRegist)
    {
        UIView *codeBGView = [[UIView alloc] initWithFrame:CGRectMake(0, phoneTF.bottomValue, SCREEN_WIDTH, phoneTF.heightValue)];
        codeBGView.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:codeBGView];
        
        UITextField *verifyCodeTf = [[UITextField alloc] initWithFrame:CGRectMake(30, 0, SCREEN_WIDTH - 160, codeBGView.heightValue)];
        verifyCodeTf.placeholder = @"请填写短信验证码";
        verifyCodeTf.font = [UIFont systemFontOfSize:[BNTools sizeFit:16 six:18 sixPlus:20]];
        verifyCodeTf.clearButtonMode = UITextFieldViewModeAlways;
        verifyCodeTf.borderStyle = UITextBorderStyleNone;
        verifyCodeTf.keyboardType = UIKeyboardTypeNumberPad;
        verifyCodeTf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        verifyCodeTf.delegate = self;
        [verifyCodeTf addTarget:self action:@selector(textFieldEditingChangedValue:) forControlEvents:UIControlEventEditingChanged];
        [codeBGView addSubview:verifyCodeTf];
        _verifyCodeTf = verifyCodeTf;
        
        UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 130, (codeBGView.heightValue-17*NEW_BILI)/2, 1, 17*NEW_BILI)];
        line3.backgroundColor = UIColor_GrayLine;
        [codeBGView addSubview:line3];
        
        UIButton *fetchCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        fetchCodeButton.frame = CGRectMake(SCREEN_WIDTH- 125, 0, 104, codeBGView.heightValue);
        [fetchCodeButton setTitleColor:UIColor_NewBlueColor forState:UIControlStateNormal];
        [fetchCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [fetchCodeButton.titleLabel setFont:[UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]]];
        [fetchCodeButton addTarget:self action:@selector(fetchSMSTouchUpAction:) forControlEvents:UIControlEventTouchUpInside];
//        [fetchCodeButton addTarget:self action:@selector(fetchSMSTouchDownAction:) forControlEvents:UIControlEventTouchDown];
        [codeBGView addSubview:fetchCodeButton];
         _fetchCodeButton = fetchCodeButton;
        
        
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(30, codeBGView.heightValue-1, SCREEN_WIDTH-30*2, 1)];
        line2.backgroundColor = UIColor_GrayLine;
        [codeBGView addSubview:line2];
        
        originY += codeBGView.heightValue + 38;

        BNBaseTextField *pswTf = [[BNBaseTextField alloc] initWithFrame:CGRectMake(0, originY, phoneTF.widthValue, phoneTF.heightValue)];
        pswTf.font = [UIFont systemFontOfSize:[BNTools sizeFit:16 six:18 sixPlus:20]];
        pswTf.placeholder = @"设置登录密码";
        pswTf.delegate = self;
        pswTf.secureTextEntry = YES;
        [pswTf addTarget:self action:@selector(textFieldEditingChangedValue:) forControlEvents:UIControlEventEditingChanged];
        [self.scrollView addSubview:pswTf];
        _pswTf = pswTf;
        originY += pswTf.frame.size.height+10*NEW_BILI;
        
        UIButton *addInvitationCode = [UIButton buttonWithType:UIButtonTypeCustom];
        addInvitationCode.frame = CGRectMake(backgroundViewRect.size.width - 150*NEW_BILI - 30, originY, 150*NEW_BILI, 35*NEW_BILI);
        [addInvitationCode setTitleColor:UIColor_NewBlueColor forState:UIControlStateNormal];
        [addInvitationCode setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [addInvitationCode setTitle:@"添加邀请码" forState:UIControlStateNormal];
        [addInvitationCode.titleLabel setFont:[UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]]];
        [addInvitationCode addTarget:self action:@selector(addInvitationCodeAction:) forControlEvents:UIControlEventTouchUpInside];
        addInvitationCode.layer.cornerRadius = 5;
        [self.scrollView addSubview:addInvitationCode];
        originY += addInvitationCode.frame.size.height;

    }
    originY += 50*NEW_BILI;

    UIButton *nextStepButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextStepButton.frame = CGRectMake(30, originY, backgroundViewRect.size.width - 30 *2, 40*NEW_BILI);
    [nextStepButton setupTitle:@"下一步" enable:NO];
    [nextStepButton addTarget:self action:@selector(nextStepTouchUpAction:) forControlEvents:UIControlEventTouchUpInside];
    [nextStepButton addTarget:self action:@selector(nextStepTouchDownAction:) forControlEvents:UIControlEventTouchDown];
       
    self.nextStepButton = nextStepButton;
    [self.scrollView addSubview:nextStepButton];
    originY += nextStepButton.frame.size.height+20*NEW_BILI;

    //阅读协议， 温馨提示
    if (_useStyle == ViewControllerUseStyleRegist) {
        UIView *protocolBKView = [[UIView alloc] initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, 24*NEW_BILI)];
        protocolBKView.backgroundColor = [UIColor clearColor];
        [_scrollView addSubview:protocolBKView];

        UILabel *agreeLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 130*NEW_BILI, 24*NEW_BILI)];
        agreeLbl.textColor = UIColorFromRGB(0xb0adad);
        agreeLbl.font = [UIFont systemFontOfSize:11*NEW_BILI];
        [protocolBKView addSubview:agreeLbl];
        agreeLbl.text = @"我已阅读并同意";
        CGFloat textWidth = [Tools getTextWidthWithText:agreeLbl.text font:agreeLbl.font height:agreeLbl.frame.size.height];
        agreeLbl.frame = CGRectMake(agreeLbl.frame.origin.x, agreeLbl.frame.origin.y, textWidth, agreeLbl.frame.size.height);
        
        UIButton *readButton = [UIButton buttonWithType:UIButtonTypeCustom];
        readButton.tag = 104;
        [readButton addTarget:self action:@selector(displayProtocolAction:) forControlEvents:UIControlEventTouchUpInside];
        [readButton setTitle:@"《喜付服务协议》" forState:UIControlStateNormal];
        [readButton setTitleColor:UIColorFromRGB(0xb0adad) forState:UIControlStateNormal];
        [readButton setTitleColor:UIColorFromRGB(0xbbbbbb) forState:UIControlStateHighlighted];
        readButton.titleLabel.font = [UIFont systemFontOfSize:11*NEW_BILI];
        CGFloat redTextWidth = [Tools getTextWidthWithText:@"《喜付服务协议》" font:agreeLbl.font height:agreeLbl.frame.size.height];
        readButton.frame = CGRectMake(CGRectGetMaxX(agreeLbl.frame), 0, redTextWidth+10*NEW_BILI, 24*NEW_BILI);
        
        UILabel *bottomLine = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(agreeLbl.frame)+5, 1*NEW_BILI, redTextWidth+10*NEW_BILI, 24*NEW_BILI)];
        bottomLine.textColor = UIColorFromRGB(0xb0adad);
        bottomLine.font = [UIFont systemFontOfSize:11*NEW_BILI];
        [protocolBKView addSubview:bottomLine];
        bottomLine.text = @"_________________";
        
        readButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        readButton.layer.cornerRadius = 3;
        readButton.layer.masksToBounds = YES;
        [protocolBKView addSubview:readButton];

        CGFloat allTextWidth = [Tools getTextWidthWithText:[agreeLbl.text stringByAppendingString:readButton.currentTitle] font:agreeLbl.font height:agreeLbl.frame.size.height];

        protocolBKView.frame = CGRectMake((SCREEN_WIDTH-allTextWidth)/2, originY, allTextWidth, 24*NEW_BILI+1);
        
        originY += protocolBKView.frame.size.height+10*NEW_BILI;

//        UIView *protocolBKView = [[UIView alloc] initWithFrame:CGRectMake(15, originY, backgroundViewRect.size.width - 15 * 2, 24*NEW_BILI)];
//        protocolBKView.backgroundColor = [UIColor clearColor];
//        
//        UIButton *selectProButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        selectProButton.frame = CGRectMake(0, 0, protocolHeight, protocolHeight);
//        
//        [selectProButton setImage:[UIImage imageNamed:@"Protocol_Selected"] forState:UIControlStateNormal];
//        [selectProButton setTitleColor:UIColorFromRGB(0xb0adad) forState:UIControlStateNormal];
//        [selectProButton addTarget:self action:@selector(selectProtocolAction:) forControlEvents:UIControlEventTouchUpInside];
//        
//        UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(protocolHeight, 0, 150, protocolHeight)];
//        tipsLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
//        tipsLabel.backgroundColor = [UIColor clearColor];
//        tipsLabel.text = @"我已阅读并同意";
//        tipsLabel.textColor = UIColorFromRGB(0xb0adad);
//        
//        UIButton *displayProButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        displayProButton.frame = CGRectMake([BNTools sizeFit:105 six:130 sixPlus:145], 0, 140*NEW_BILI, 24*NEW_BILI);
//        displayProButton.backgroundColor = [UIColor clearColor];
//        [displayProButton.titleLabel setFont:[UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]]];
//        [displayProButton setTitleColor:UIColorFromRGB(0xb0adad) forState:UIControlStateNormal];
//        [displayProButton setTitle:@"《喜付服务协议》" forState:UIControlStateNormal];
//        [displayProButton addTarget:self action:@selector(displayProtocolAction:) forControlEvents:UIControlEventTouchUpInside];
//        
//        [protocolBKView addSubview:selectProButton];
//        [protocolBKView addSubview:tipsLabel];
//        [protocolBKView addSubview:displayProButton];
//        [self.scrollView addSubview:protocolBKView];
//        originY += protocolBKView.frame.size.height+10*NEW_BILI;
        
    }
    
    
    UITapGestureRecognizer *cancelKeyboardTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelKeyboard:)];
    [self.scrollView addGestureRecognizer:cancelKeyboardTap];
    
    self.verifyPhoneTipsLabel.hidden = YES;//提示文字，全都不要了。

    switch (self.useStyle) {
        case ViewControllerUseStyleFindPassword:
//            self.verifyPhoneTipsLabel.text = @"通过短信验证的方式可找回登录密码";
            self.verifyPhoneTipsLabel.hidden = YES;
            self.navigationTitle = @"忘记密码";
            phoneTF.placeholder = @"手机号";
            phoneTF.secureTextEntry = NO;
            phoneTF.keyboardType = UIKeyboardTypePhonePad;
//            rechargeTips.hidden = YES;
            break;
         
        case ViewControllerUseStyleRegist:
//            self.verifyPhoneTipsLabel.text = @"请用您常用的手机号注册账户";
        self.verifyPhoneTipsLabel.hidden = YES;
            self.navigationTitle = @"注 册";
            phoneTF.placeholder = @"手机号";
            phoneTF.keyboardType = UIKeyboardTypePhonePad;
            phoneTF.secureTextEntry = NO;
//            rechargeTips.hidden = YES;
            break;
            
        case ViewControllerUseStyleModifyGesturePwd:
            //goto修改手势密码
//            self.verifyPhoneTipsLabel.text = @"修改手势密码前请验证登录密码";
            self.navigationTitle = @"修改手势密码";
            phoneTF.placeholder = @"请输入登录密码";
            phoneTF.keyboardType = UIKeyboardTypeDefault;
            phoneTF.secureTextEntry = YES;
//            rechargeTips.hidden = NO;
            break;
        case ViewControllerUseStyleModifyLoginPwd:
            //修改登录密码
//            self.verifyPhoneTipsLabel.text = @"修改登录密码前请验证登录密码";
            self.navigationTitle = @"修改登录密码";
            phoneTF.placeholder = @"请输入登录密码";
            phoneTF.keyboardType = UIKeyboardTypeDefault;
            phoneTF.secureTextEntry = YES;
//            rechargeTips.hidden = NO;
            break;
//        case ViewControllerUseStyleXiaoDai:
//            self.verifyPhoneTipsLabel.text = @"请填写手机号码";
//            self.navigationTitle = @"我要用钱";
//            self.goLoginButton.hidden = YES;
//            phoneTF.keyboardType = UIKeyboardTypePhonePad;
//            phoneTF.secureTextEntry = NO;
            
        default:
            break;
    }
}

- (void)cancelKeyboard:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.agreeProtocol = YES;
    [self setupLoadedView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (SCREEN_HEIGHT < 500) {
        [self addResponseKeyboardAction];
    }
    
    [self textFieldEditingChangedValue:_phoneTextField];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (SCREEN_HEIGHT < 500) {
       [self removeResponseKeyboardAction];
    }
    
    
}

#pragma mark - keyboard


#pragma makr - text field delegate
- (void)textFieldEditingChangedValue:(UITextField *)tf
{
    if (_useStyle == ViewControllerUseStyleRegist ) {
        if (self.phoneTextField.text.length == 11 && self.agreeProtocol == YES && self.verifyCodeTf.text.length > 0 && self.pswTf.text.length > 0) {
            [self.nextStepButton setEnabled:YES];
        }else{
            [self.nextStepButton setEnabled:NO];
        }
    }else if (_useStyle == ViewControllerUseStyleFindPassword){
        if (self.phoneTextField.text.length == 11 && self.agreeProtocol == YES) {
            [self.nextStepButton setEnabled:YES];
        }else{
            [self.nextStepButton setEnabled:NO];
        }
        
    }else {
        if (tf.text.length > 0 && self.agreeProtocol == YES) {
            [self.nextStepButton setEnabled:YES];
        }else{
            [self.nextStepButton setEnabled:NO];
        }
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length == 0) {
        return YES;   //退格删除
    }

    NSString *strVar = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (_useStyle == ViewControllerUseStyleRegist || _useStyle == ViewControllerUseStyleFindPassword) {
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        if (![string isEqualToString:filtered]) {
            return NO;    //特殊字符
        }
        if ([strVar length] > 11) {
            return NO;
        }
    } else {
        if ([strVar length] > 16) {
            return NO;
        }
    }

    return YES;
}
#pragma mark - button action
- (void)addInvitationCodeAction:(UIButton *) btn
{
/*以前的登录逻辑
    NSArray *viewControllers = self.navigationController.viewControllers;
    BNLoginViewController *logInVC = nil;
    for (UIViewController *obj in viewControllers) {
        if ([obj isKindOfClass:[BNLoginViewController class]] == YES) {
            logInVC = (BNLoginViewController *)obj;
        }
    }
    if (logInVC) {
        [self.navigationController popToViewController:logInVC animated:YES];
    } else {
        //登录
        BNLoginViewController *vc = [[BNLoginViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self pushViewController:vc animated:YES];
    }
 */
    //添加邀请码
    BNAddInvitationCodeVC *addVC = [[BNAddInvitationCodeVC alloc] init];
    [self presentViewController:addVC animated:YES completion:nil];
}

- (void)nextStepTouchDownAction:(UIButton *) btn
{
    [self.view endEditing:YES];
}

- (void)nextStepTouchUpAction:(UIButton *) btn
{

    [btn setEnabled:NO];
    NSString *phoneNum = self.phoneTextField.text;
    
    __weak typeof(self) weakSelf = self;
    switch (weakSelf.useStyle) {
        case ViewControllerUseStyleModifyGesturePwd:
        {
            if(phoneNum.length > 0 && shareAppDelegateInstance.boenUserInfo.userid.length > 0)
            {
                NSDictionary *info = @{@"userid":shareAppDelegateInstance.boenUserInfo.userid,
                                       @"password":phoneNum};
                [SVProgressHUD showWithStatus:@"请稍候..."];
                [Password verifyLoginPwd:info
                                 success:^(NSDictionary *successData) {
                                     BNLog(@"verify login pwd %@", successData);
                                     NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                                     if ([retCode isEqualToString:kRequestSuccessCode]) {
                                         [SVProgressHUD dismiss];
                                         
                                         KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:shareAppDelegateInstance.boenUserInfo.userid accessGroup:kKeyChainAccessGroup_Gesture];
                                         NSString *password = [keychin objectForKey:(__bridge id)kSecValueData];
                                         GesturePasswordController *gestureVC = [[GesturePasswordController alloc]init];
                                         if (!_isFromForgetPsw) {
                                             gestureVC.nameOfRootPushVC = @"BNSettingsViewController";
                                         }
                                         if ([password isEqualToString:@""]) {
                                             gestureVC.vcType = VcTypeFirstSetPsw;
                                         }else {
                                             gestureVC.vcType = VcTypeReSetPsw;
                                         }
                                         [weakSelf pushViewController:gestureVC animated:YES];
                                     }else{
                                         [weakSelf.nextStepButton setEnabled:YES];
                                         NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                         [SVProgressHUD showErrorWithStatus:retMsg];
                                     }
                                     
                                 }
                                 failure:^(NSError *error) {
                                     [weakSelf.nextStepButton setEnabled:YES];
                                     
                                     [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                 }];
                
            } else{
                [SVProgressHUD showErrorWithStatus:@"请输入登录密码"];
            }

        }
            break;
            
        case ViewControllerUseStyleRegist:
        {
            __block NSString *psw  = self.pswTf.text;
            if (psw == nil || psw.length <= 0) {
                [SVProgressHUD showErrorWithStatus:@"请输入正确的密码"];
            }else if (psw.length < 6 ||  psw.length > 16) {
                [SVProgressHUD showErrorWithStatus:@"密码长度应为6-16位"];
            }
            if (self.verifyCodeTf.text.length <= 0) {
                [SVProgressHUD showErrorWithStatus:@"请输入短信验证码"];
            }
            if (![phoneNum hasPrefix:@"1"]) {
                [weakSelf.nextStepButton setEnabled:YES];
                [SVProgressHUD showErrorWithStatus:@"手机号码格式错误"];
                
            }else if(phoneNum.length > 7){
                //校验验证码获取学校列表接口
                [RegisterClient checkVerifyCode:phoneNum
                                     verifyCode:weakSelf.verifyCodeTf.text
                                        success:^(NSDictionary *successData) {
                                            NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                                            BNLog(@"注册校验验证码---->>>> %@",successData);
                                            if ([retCode isEqualToString:kRequestSuccessCode]) {
                                                [SVProgressHUD dismiss];
                                                [RegisterClient fetchSchoolListSuccess:^(NSDictionary *returnData) {
                                                    BNLog(@"school list return data %@", returnData);
                                                    NSString *retCode = [returnData valueNotNullForKey:kRequestRetCode];
                                                    
                                                    if ([retCode isEqualToString:kRequestSuccessCode]) {
                                                        [SVProgressHUD dismiss];
                                                        NSDictionary *retData = [returnData valueForKey:kRequestReturnData];
                                                        NSArray *schools = [retData valueForKey:@"schools"];
                                                        
                                                        NSDictionary *schoolsInfo = [self buildIndexAndSortSchoolNames:schools];
                                                        
                                                        schools = [schoolsInfo valueForKey:kSortSchools];
                                                        if ([schools count] > 0) {
                                                            //保存新的学校列表
                                                            
                                                            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                                                                for (int i = 0; i < [schools count]; i++) {
                                                                    NSArray *objArray = [schools objectAtIndex:i];
                                                                    for (NSDictionary *theObj in objArray) {
                                                                        NSString *sourceText = [theObj valueForKey:@"name"];
                                                                        NSString *formart = [NSString stringWithFormat:@"schoolName_Chinese == '%@'", sourceText];
                                                                        NSPredicate * predicate = [NSPredicate predicateWithFormat:formart];
                                                                        
                                                                        NSArray *finded = [SchoolName MR_findAllWithPredicate:predicate];
                                                                        if ([finded count] == 0) {
                                                                            HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
                                                                            [outputFormat setToneType:ToneTypeWithoutTone];
                                                                            [outputFormat setVCharType:VCharTypeWithV];
                                                                            [outputFormat setCaseType:CaseTypeLowercase];
                                                                            
                                                                            SchoolName *schoolName = [SchoolName MR_createInContext:localContext];
                                                                            schoolName.schoolName_Chinese = sourceText;
                                                                            schoolName.schoolName_PinYin = [PinyinHelper toHanyuPinyinStringWithNSString:sourceText withHanyuPinyinOutputFormat:outputFormat withNSString:@""];
                                                                            schoolName.schoolName_ID = [NSString stringWithFormat:@"%@", [theObj valueForKey:@"id"]];
                                                                            NSString *schoolName_code = [theObj valueNotNullForKey:@"code"];
                                                                            schoolName.schoolName_Code = schoolName_code.length == 0 ? @"z":schoolName_code;
                                                                        }
                                                                    }
                                                                }
                                                                
                                                                
                                                            } completion:^(BOOL success, NSError *error) {
                                                                [SVProgressHUD dismiss];
                                                                if ([schools count] > 0) {
                                                                    
                                                                    BNSelectSchoolViewController *selectSC = [[BNSelectSchoolViewController alloc] init];
                                                                    [selectSC.dataSource removeAllObjects];
                                                                    selectSC.dataSource = [[NSMutableArray alloc] initWithArray:schools];
                                                                    selectSC.indexArray = [schoolsInfo valueForKey:kIndex];
                                                                    
                                                                    selectSC.registPhone = phoneNum;
                                                                    selectSC.verifycode = weakSelf.verifyCodeTf.text;
                                                                    selectSC.passwrod = weakSelf.pswTf.text;
                                                                    
                                                                    [weakSelf pushViewController:selectSC animated:YES];
                                                                    BNLog(@"Check and save school list  successfule");
                                                                }
                                                            }];
                                                            
                                                        }else{//加载成功，但是没有获取到任何数据出错
                                                            [SVProgressHUD showErrorWithStatus:@"很抱歉，系统错误，请稍候重试！"];
                                                            BNLog(@"Check school list failed");
                                                        }
                                                        
                                                    }else{//从服务器获取出错
                                                        NSString *retMsg = [returnData valueNotNullForKey:kRequestRetMessage];
                                                        [SVProgressHUD showErrorWithStatus:retMsg];
                                                        
                                                        BNLog(@"Check school list failed");
                                                    }
                                                } failure:^(NSError *error) {//网络原因出错
                                                    
                                                    [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                                    BNLog(@"Check school list failed");
                                                }];
                                                
                                            }else{
                                                NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                                [SVProgressHUD showErrorWithStatus:retMsg];
                                            }
                                        } failure:^(NSError *error) {
                                            [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                        }];
            }else{
                [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
            }
        }
            break;
        
        case ViewControllerUseStyleModifyLoginPwd:
        {
            if(phoneNum.length > 0 && shareAppDelegateInstance.boenUserInfo.userid.length > 0)
            {
                NSDictionary *info = @{@"userid":shareAppDelegateInstance.boenUserInfo.userid,
                                       @"password":phoneNum};
                [SVProgressHUD showWithStatus:@"请稍候..."];
                [Password verifyLoginPwd:info
                                 success:^(NSDictionary *successData) {
                                     BNLog(@"verify login pwd %@", successData);
                                     NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                                     if ([retCode isEqualToString:kRequestSuccessCode]) {
                                         [SVProgressHUD dismiss];

                                         BNSetLoginPwdViewController *setLoginVC = [[BNSetLoginPwdViewController alloc] init];
                                         setLoginVC.useStyle = ViewControllerUseStyleModifyLoginPwd;
                                         setLoginVC.oldLoginPassword = weakSelf.phoneTextField.text;
                                         [weakSelf pushViewController:setLoginVC animated:YES];
                                     }else{
                                         [weakSelf.nextStepButton setEnabled:YES];
                                         NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                         [SVProgressHUD showErrorWithStatus:retMsg];
                                     }
                                     
                                 }
                                 failure:^(NSError *error) {
                                     [weakSelf.nextStepButton setEnabled:YES];

                                     [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                 }];
                
            }

        }
            break;
            
        case ViewControllerUseStyleFindPassword:
        {
            if(phoneNum.length > 0)
            {
                [SVProgressHUD showWithStatus:@"请稍候..."];
                [RegisterClient findLoginPwdWithUserPhone:phoneNum
                                                  success:^(NSDictionary *successData) {
                                                      BNLog(@"%@", successData);
                                                      NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                                                      if ([retCode isEqualToString:kRequestSuccessCode]) {
                                                          [SVProgressHUD dismiss];

                                                          BNVerifySMSCodeViewController *smsCodeVerifyVC =[[BNVerifySMSCodeViewController alloc] init];
                                                          smsCodeVerifyVC.useStyle = ViewControllerUseStyleFindPassword;
                                                          smsCodeVerifyVC.phoneNumber = phoneNum;
                                                          [weakSelf pushViewController:smsCodeVerifyVC animated:YES];
                                                          
                                                      }else{
                                                          NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                                          [SVProgressHUD showErrorWithStatus:retMsg];
                                                          [weakSelf.nextStepButton setEnabled:YES];
                                                      }
                                                      

                                                  } failure:^(NSError *error) {
                                                       [weakSelf.nextStepButton setEnabled:YES];
                                                      [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];

                                                  }];

            }
        }
            break;
        default:
            break;
    }
    
}
#pragma mark - buttonAction
- (void)selectProtocolAction:(UIButton *)btn
{
    if (self.agreeProtocol == YES) {
        self.agreeProtocol = NO;
        [btn setImage:[UIImage imageNamed:@"Protocol_Unselected"] forState:UIControlStateNormal];
        
        self.nextStepButton.enabled = NO;
        
    }else{
        self.agreeProtocol = YES;
        [btn setImage:[UIImage imageNamed:@"Protocol_Selected"] forState:UIControlStateNormal];
        if (_useStyle == ViewControllerUseStyleRegist || _useStyle == ViewControllerUseStyleFindPassword) {
            if (_phoneTextField.text.length == 11) {
                self.nextStepButton.enabled = YES;
            }
        } else {
            if (_phoneTextField.text.length > 0) {
                self.nextStepButton.enabled = YES;
            }
        }
    }
}

- (void)displayProtocolAction:(UIButton *)btn
{
    BNProtocolViewController *protocolVC = [[BNProtocolViewController alloc] init];
    protocolVC.protocolFileName = @"xifu_protocol.htm";
    protocolVC.titleName = @"喜付服务协议";
    [self pushViewController:protocolVC animated:YES];
    
}

//获取验证码
- (void)fetchSMSTouchUpAction:(UIButton *)button
{
    if (self.phoneTextField.text.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"请填写11位手机号码"];
        return;
    }
    if (self.fetchSMSCodeTimer) {
        return;
    }

    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"请稍候..."];
    [RegisterClient requestVerifyCode:weakSelf.phoneTextField.text
                              success:^(NSDictionary *successData) {
                                  BNLog(@"requestVerifyCode%@", successData);
                                  NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                                  if ([retCode isEqualToString:kRequestSuccessCode]) {
                                      [SVProgressHUD dismiss];
                                      if (weakSelf.fetchSMSCodeTimer == nil) {
                                          [weakSelf createTimer];
                                      }
                                  }else{
                                      [weakSelf.nextStepButton setEnabled:YES];
                                      NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                      [SVProgressHUD showErrorWithStatus:retMsg];
                                  }
                              } failure:^(NSError *error) {
                                  [weakSelf.nextStepButton setEnabled:YES];
                                  [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                  
                              }];


}

- (void)createTimer{
    [self.fetchSMSCodeTimer invalidate];
    self.fetchSMSCodeTimer = nil;
    
    self.timerSeconds = kTmeier_second;
    NSString *fetchTitle = [NSString stringWithFormat:@"%li S", (long)self.timerSeconds];
    
    [self.fetchCodeButton setTitle:fetchTitle forState:UIControlStateNormal];
    [self.fetchCodeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
    self.fetchSMSCodeTimer = timer;
}

- (void)timerMethod
{
    self.timerSeconds = self.timerSeconds - 1;
    NSString *fetchTitle = [NSString stringWithFormat:@"%li S", (long)self.timerSeconds];
    [self.fetchCodeButton setTitle:fetchTitle forState:UIControlStateNormal];
    [self.fetchCodeButton setNeedsDisplay];
    
    if (self.timerSeconds <= 0) {
        [self.fetchCodeButton setTitleColor:UIColor_NewBlueColor forState:UIControlStateNormal];
        [self.fetchCodeButton setTitle:@"重发" forState:UIControlStateNormal];
        [self.fetchSMSCodeTimer invalidate];
        self.fetchSMSCodeTimer = nil;
    }
}

- (NSDictionary *)buildIndexAndSortSchoolNames:(NSArray *)schools
{
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    NSMutableArray *indexArray = [[NSMutableArray alloc] initWithArray:indexCollation.sectionTitles];
    
    NSMutableArray *sortArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [indexArray count]; i++) {
        NSMutableArray *sectionArray = [[NSMutableArray alloc] init];
        [sortArray addObject:sectionArray];
    }
    
    for (NSDictionary *obj in schools) {
        NSString *theCode = [obj valueNotNullForKey:@"code"];
        theCode = theCode.length == 0 ? @"z" : theCode;
        NSString *code = [[theCode uppercaseString] substringWithRange:NSMakeRange(0, 1)];
        NSInteger section = [indexArray indexOfObject:code];
        
        NSMutableArray *tempArray = [sortArray objectAtIndex:section];
        
        [tempArray addObject:obj];
    }
    
    NSMutableArray *deleteArray = [[NSMutableArray alloc] init];
    NSMutableArray *deleteIndexArray = [[NSMutableArray alloc] init];
    for (int m = 0; m < [sortArray count]; m++) {
        NSArray *obj = [sortArray objectAtIndex:m];
        if ([obj count] == 0) {
            [deleteIndexArray addObject:[indexArray objectAtIndex:m]];
            [deleteArray addObject:obj];
        }
    }
    [indexArray removeObjectsInArray:deleteIndexArray];
    [sortArray removeObjectsInArray:deleteArray];
    
    //每个section内的数组排序
    for (int i = 0; i < [sortArray count]; i++) {
        NSArray *array = [[sortArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
            NSString *firstLetter1 = [obj1 valueNotNullForKey:@"code"];
            firstLetter1 = firstLetter1.length == 0 ? @"z":firstLetter1;
            firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];
            
            NSString *firstLetter2 = [obj2 valueNotNullForKey:@"code"];
            firstLetter2 = firstLetter2.length == 0 ? @"z":firstLetter2;
            firstLetter2 = [[firstLetter2 substringToIndex:1] uppercaseString];
            
            return [firstLetter1 caseInsensitiveCompare:firstLetter2];
        }];
        
        
        [sortArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
    }
    
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:sortArray forKey:kSortSchools];
    [dic setObject:indexArray forKey:kIndex];
    return dic;
}
@end
