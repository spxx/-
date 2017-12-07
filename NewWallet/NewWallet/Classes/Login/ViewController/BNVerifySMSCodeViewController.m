//
//  BNVerifySMSCodeViewController.m
//  NewWallet
//
//  Created by mac1 on 14-10-27.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNVerifySMSCodeViewController.h"

#import "BNRegistInfoViewController.h"

#import "BNSetLoginPwdViewController.h"

#import "RegisterClient.h"
#import "CardApi.h"

#import "SchoolName.h"

#import "PinYin4Objc.h"

#import "BNSelectSchoolViewController.h"
#import "BNSetNewPayPwdViewController.h"


#import "BNYKTRechargeViewController.h"

#import "BNMobileRechargeVC.h"
#import "BNSettingsViewController.h"
#import "BNPublicHtml5BusinessVC.h"

#import "BNModifyBindPhoneNumVC.h"

#import "XifuLoginAccount.h"
#import "KeychainItemWrapper.h"
#import "BNXiaoDaiReadServiceAgreementVC.h"
#import "BNXiHaDaiHomeViewController.h"

#define kTimerSeconds 60

#define kSortSchools @"sort_schools"

#define kIndex @"index"

#import "PayClient.h"

#import "RegisterClient.h"

#import "XiaoDaiApi.h"


#import "BNXiaoDaiReadServiceAgreementVC.h"


@interface BNVerifySMSCodeViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) UIScrollView *scrollView;

@property (weak, nonatomic) UITextField *smsCodeField;

@property (strong, nonatomic) NSTimer *fetchSMSCodeTimer;

@property (weak, nonatomic) UIButton *fetchSMSCodeButton;

@property (assign, nonatomic) NSInteger timerSeconds;

@property (weak, nonatomic) UIButton *nextStepButton;


@end


@implementation BNVerifySMSCodeViewController

@synthesize phoneNumber = _phoneNumber;
@synthesize useStyle;
@synthesize payModel;

#pragma mark - setup loaded view
- (void)setupLoadedView
{
    self.sixtyFourPixelsView.backgroundColor = [UIColor whiteColor];
    UILabel *lineLbl = (UILabel *)[self.customNavigationBar viewWithTag:10001];
    lineLbl.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *theScollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT- self.sixtyFourPixelsView.viewBottomEdge)];
    theScollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge);
    [self.view addSubview:theScollView];
    self.scrollView = theScollView;
    theScollView.backgroundColor = [UIColor whiteColor];
    
    CGFloat originY = 60*NEW_BILI;
    
    CGRect backgroundViewRect = self.scrollView.frame;
    
//    UILabel *tipsPhoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, originY, backgroundViewRect.size.width - 20, 36*BILI_WIDTH)];
//    tipsPhoneLabel.backgroundColor = [UIColor clearColor];
//    tipsPhoneLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
//    tipsPhoneLabel.textColor = [UIColor lightGrayColor];
//    [self.scrollView addSubview:tipsPhoneLabel];
//    
//    NSMutableString *phoneNo = [NSMutableString stringWithString:self.phoneNumber];
//    if (self.phoneNumber.length > 7) {
//        [phoneNo replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
//    }
//    NSString *tipsTitle = [NSString stringWithFormat:@"请输入%@收到的短信验证码", phoneNo];
//    tipsPhoneLabel.text = tipsTitle;
//    originY += tipsPhoneLabel.frame.size.height;

    UIView *codeBGView = [[UIView alloc] initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, 59)];
    codeBGView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:codeBGView];
    originY += codeBGView.frame.size.height + 50*NEW_BILI;
    
    UITextField *verifyCodeTf = [[UITextField alloc] initWithFrame:CGRectMake(30, 0, SCREEN_WIDTH - 160, codeBGView.heightValue)];
    verifyCodeTf.placeholder = @"填写短信验证码";
    verifyCodeTf.font = [UIFont systemFontOfSize:[BNTools sizeFit:16 six:18 sixPlus:20]];
    verifyCodeTf.clearButtonMode = UITextFieldViewModeAlways;
    verifyCodeTf.borderStyle = UITextBorderStyleNone;
    verifyCodeTf.keyboardType = UIKeyboardTypeNumberPad;
    verifyCodeTf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    verifyCodeTf.delegate = self;
    [verifyCodeTf addTarget:self action:@selector(textFieldEditingChangedValue:) forControlEvents:UIControlEventEditingChanged];
    [codeBGView addSubview:verifyCodeTf];
    self.smsCodeField = verifyCodeTf;
    
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 130, (codeBGView.heightValue-17*NEW_BILI)/2, 1, 17*NEW_BILI)];
    line3.backgroundColor = UIColor_GrayLine;
    [codeBGView addSubview:line3];
    
    UIButton *fetchCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fetchCodeButton.frame = CGRectMake(backgroundViewRect.size.width - 125, 0, 104, codeBGView.heightValue);
    [fetchCodeButton setTitleColor:UIColor_NewBlueColor forState:UIControlStateNormal];
    [fetchCodeButton setTitle:@"60 S" forState:UIControlStateNormal];
    [fetchCodeButton.titleLabel setFont:[UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]]];
    [fetchCodeButton addTarget:self action:@selector(fetchSMSTouchUpAction:) forControlEvents:UIControlEventTouchUpInside];
    [fetchCodeButton addTarget:self action:@selector(fetchSMSTouchDownAction:) forControlEvents:UIControlEventTouchDown];
    self.fetchSMSCodeButton = fetchCodeButton;
    [codeBGView addSubview:fetchCodeButton];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(30, codeBGView.heightValue-1, SCREEN_WIDTH-30*2, 1)];
    line2.backgroundColor = UIColor_GrayLine;
    [codeBGView addSubview:line2];

    UIButton *nextStepButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextStepButton.frame = CGRectMake(30, originY, backgroundViewRect.size.width - 30 *2, 40*NEW_BILI);
    [nextStepButton setupTitle:@"下一步" enable:NO];
    [nextStepButton addTarget:self action:@selector(nextStepTouchUpAction:) forControlEvents:UIControlEventTouchUpInside];
    [nextStepButton addTarget:self action:@selector(nextStepTouchDownAction:) forControlEvents:UIControlEventTouchDown];

    self.nextStepButton = nextStepButton;
    [self.scrollView addSubview:nextStepButton];
    
    
    UITapGestureRecognizer *cancelKeyboardTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelKeyboard:)];
    [self.scrollView addGestureRecognizer:cancelKeyboardTap];
    
    self.navigationTitle = @"填写验证码";

    switch (self.useStyle) {
        case ViewControllerUseStyleFindPassword:
            self.navigationTitle = @"填写验证码";
            break;
            
        case ViewControllerUseStyleRegist:
        /*
            self.navigationTitle = @"注 册";
            break;
         */
        case ViewControllerUseStyleAddBankCard:
            self.navigationTitle = @"添加银行卡";
            [self getVerifycodeForAddCard];
            break;
        case ViewControllerUseStyleVerifyCurrentPhone:
        {
            UILabel *changeTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, nextStepButton.frame.origin.x + nextStepButton.frame.size.height + 44*BILI_WIDTH, SCREEN_WIDTH - 20, 200)];
            changeTipsLabel.numberOfLines = 0;
            NSMutableAttributedString *tipsStr= [[NSMutableAttributedString alloc] initWithString:kVerifyTipsString];
            [tipsStr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, [tipsStr length])];
            [tipsStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, 5)];
            [tipsStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(5, [tipsStr length] - 5)];
            changeTipsLabel.attributedText = tipsStr;
            [self.scrollView addSubview:changeTipsLabel];
            self.navigationTitle = @"验证手机号";
            [self getVerifycodeForForget];
        }
            break;
        case ViewControllerUseStyleVerifyNewPhone:
            self.navigationTitle = @"修改手机号";
//            [self getVerifycode];//进来不请求，在上级页面发请求。
            break;
        case ViewControllerUseStyleXiaoDai:
        {
            self.navigationTitle = @"我要用钱";
            [self getXiaoDaiVerifyCode];
        }
            break;
        case ViewControllerUseStyleModifyStudentNumber:
        {
            self.navigationTitle = @"修改学号";
            [self getVerifycodeForModifyStudentNumber];
            break;
        }
        case ViewControllerUseStyleCollectFees:
        {
            self.navigationTitle = @"添加银行卡";
            [self getVerifycodeForAddCard];
            break;
        }
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
    
    [self setupLoadedView];
    
    [self createTimer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (SCREEN_HEIGHT < 500) {
        [self addResponseKeyboardAction];
    }
    if (self.smsCodeField.text.length >= 4) {
        [self.nextStepButton setBackgroundColor:UIColor_Button_Normal];
        [self.nextStepButton setEnabled:YES];
    }else{
        [self.nextStepButton setBackgroundColor:UIColor_Button_Disable];
        [self.nextStepButton setEnabled:NO];
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
    [self.scrollView setContentOffset:CGPointMake(0, 20)];
}


#pragma mark - timer
- (void)createTimer{
    [self.fetchSMSCodeTimer invalidate];
    self.fetchSMSCodeTimer = nil;
    
    self.timerSeconds = kTimerSeconds;
    NSString *fetchTitle = [NSString stringWithFormat:@"%li S", (long)self.timerSeconds];
    
    [self.fetchSMSCodeButton setTitle:fetchTitle forState:UIControlStateNormal];
    [self.fetchSMSCodeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
    self.fetchSMSCodeTimer = timer;
}

- (void)timerMethod
{
    self.timerSeconds = self.timerSeconds - 1;
    NSString *fetchTitle = [NSString stringWithFormat:@"%li S", (long)self.timerSeconds];
    [self.fetchSMSCodeButton setTitle:fetchTitle forState:UIControlStateNormal];
    [self.fetchSMSCodeButton setNeedsDisplay];
    if (self.timerSeconds <= 0) {
        [self.fetchSMSCodeButton setTitleColor:UIColor_Blue_BarItemText forState:UIControlStateNormal];
        [self.fetchSMSCodeButton setTitle:@"重发" forState:UIControlStateNormal];
        [self.fetchSMSCodeTimer invalidate];
        self.fetchSMSCodeTimer = nil;
    }
}


#pragma makr - text field  delegate
- (void)textFieldEditingChangedValue:(UITextField *)tf
{
    if (tf.text.length >= 4) {
        [self.nextStepButton setBackgroundColor:UIColor_Button_Normal];
        [self.nextStepButton setEnabled:YES];
    }else{
        [self.nextStepButton setBackgroundColor:UIColor_Button_Disable];
        [self.nextStepButton setEnabled:NO];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
        return NO;
    }
    if (string.length == 0) {
        return YES;   //退格删除
    }
    NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
    if (![string isEqualToString:filtered]) {
        return NO;    //特殊字符
    }
    NSString *strVar = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([strVar length] > 6) {//最多可以输6位，但第4位就开始激活重发和确定按钮。
        return NO;
    }
    
    return YES;
}

#pragma mark - button action
- (void)fetchSMSTouchUpAction:(UIButton *)btn
{
    if (self.fetchSMSCodeTimer == nil) {
        [self createTimer];
    }
}

- (void)fetchSMSTouchDownAction:(UIButton *)btn
{
    
    if (self.fetchSMSCodeTimer) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    switch (self.useStyle) {
        case ViewControllerUseStyleRegist://注册重新请求验证码
        {
//            [self getVerifycode];
        }
            break;
        
        case ViewControllerUseStyleFindPassword:
        {
            [RegisterClient findLoginPwdWithUserPhone:weakSelf.phoneNumber
                                              success:^(NSDictionary *successData) {
                                                  BNLog(@"%@", successData);
                                                  NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                                                  if ([retCode isEqualToString:kRequestSuccessCode]) {
                                                      [SVProgressHUD dismiss];
                                                      
                                                      BNLog(@"%@", [successData valueNotNullForKey:kRequestRetMessage]) ;
                                                  }else{
                                                      
                                                      NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                                      [SVProgressHUD showErrorWithStatus:retMsg];
                                                  }
                                              } failure:^(NSError *error) {
                                                  
                                                  
                                                  [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                              }];

        }
            break;
        case ViewControllerUseStyleVerifyCurrentPhone:
        {
            //添加银行卡重新请求验证码
            [self getVerifycodeForForget];
        }
            break;
        case ViewControllerUseStyleAddBankCard:
        {
            //添加银行卡重新请求验证码
            [self getVerifycodeForAddCard];
        }
            break;
        case ViewControllerUseStyleVerifyNewPhone:
        {
            //修改新的手机号重新请求验证码
            [self getVerifycode];
        }
            break;
        case ViewControllerUseStyleXiaoDai:
        {
            //添加银行卡重新请求验证码
            [self getXiaoDaiVerifyCode];
        }
            break;
        case ViewControllerUseStyleModifyStudentNumber:
        {
            //修改学号重新请求验证码
            [self getVerifycodeForModifyStudentNumber];
        }
            break;
        case ViewControllerUseStyleCollectFees:
        {
            [self getVerifycodeForAddCard];
        }
            break;
        default:
            break;
    }
}
- (void)getVerifycode
{
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"请稍候..."];
    [RegisterClient requestVerifyCode:weakSelf.phoneNumber
                              success:^(NSDictionary *successData) {
                                  BNLog(@"requestVerifyCode%@", successData);
                                  NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                                  if ([retCode isEqualToString:kRequestSuccessCode]) {
                                      [SVProgressHUD dismiss];
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

- (void)getXiaoDaiVerifyCode
{
    __weak typeof(self) weakSelf = self;
    
    [XiaoDaiApi requestXiaoDaiVerifyCode:payModel.bindCardInfoModel.personalBankPhone
                               success:^(NSDictionary *successData) {
                                   BNLog(@"bank Mobile verify code %@", successData);
                                   NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                                   if ([retCode isEqualToString:kRequestSuccessCode]) {
                                       [SVProgressHUD dismiss];
                                       BNLog(@"小额贷验证码已发送");
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

//获取原手机号验证码
- (void)getVerifycodeForForget
{
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"请稍候..."];
    [RegisterClient findLoginPwdWithUserPhone:payModel.bindCardInfoModel.personalBankPhone
                               success:^(NSDictionary *successData) {
                                   BNLog(@"findLoginPwdWithUserPhone %@", successData);
                                   NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                                   if ([retCode isEqualToString:kRequestSuccessCode]) {
                                       [SVProgressHUD dismiss];
                                       
                                       
                                       BNLog(@"%@", [successData valueNotNullForKey:kRequestRetMessage]) ;
                                   }else{
                                       [self.nextStepButton setEnabled:YES];
                                       NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                       [SVProgressHUD showErrorWithStatus:retMsg];
                                       [weakSelf.navigationController popViewControllerAnimated:YES];

                                   }
                                   
                               }
                               failure:^(NSError *error) {
                                   [self.nextStepButton setEnabled:YES];
                                   [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                               }];
    
    
}
- (void)getVerifycodeForAddCard
{
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"请稍候..."];

    [PayClient getVerifycodeForAddCard:payModel.bindCardInfoModel.personalBankPhone
                        success:^(NSDictionary *successData) {
                            BNLog(@"getVerifycodeForAddCard %@", successData);
                            NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                            if ([retCode isEqualToString:kRequestSuccessCode]) {
                                [SVProgressHUD dismiss];
                                
                                BNLog(@"%@", [successData valueNotNullForKey:kRequestRetMessage]) ;
                            }else{
                                [self.nextStepButton setEnabled:YES];
                                NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                [SVProgressHUD showErrorWithStatus:retMsg];
                                [weakSelf.navigationController popViewControllerAnimated:YES];

                            }
                            
                        }
                        failure:^(NSError *error) {
                            [self.nextStepButton setEnabled:YES];
                            [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                        }];
    
    
}

//修改学号获取验证码
- (void)getVerifycodeForModifyStudentNumber
{
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"请稍候..."];
    [RegisterClient findLoginPwdWithUserPhone:self.phoneNumber
                                      success:^(NSDictionary *successData) {
                                          BNLog(@"findLoginPwdWithUserPhone %@", successData);
                                          NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                                          if ([retCode isEqualToString:kRequestSuccessCode]) {
                                              [SVProgressHUD dismiss];
                                              
                                              
                                              BNLog(@"%@", [successData valueNotNullForKey:kRequestRetMessage]) ;
                                          }else{
                                              [self.nextStepButton setEnabled:YES];
                                              NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                              [SVProgressHUD showErrorWithStatus:retMsg];
                                              [weakSelf.navigationController popViewControllerAnimated:YES];
                                              
                                          }
                                          
                                      }
                                      failure:^(NSError *error) {
                                          [self.nextStepButton setEnabled:YES];
                                          [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                      }];
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

- (void)nextStepTouchUpAction:(UIButton *)btn
{
    [btn setBackgroundColor:UIColor_Button_Normal];
    [btn setEnabled:NO];
    [self.view endEditing:YES];
    //判断sms code
    __weak typeof(self) weakSelf = self;
    __block NSString *verifyCode = self.smsCodeField.text;
    if (verifyCode == nil || verifyCode.length <= 0) {
        [Tools showMessageWithTitle:@"提示" message:@"请填写验证码"];
    }
    else if(verifyCode.length >= 4)
    {
        if (weakSelf.useStyle != ViewControllerUseStyleXiaoDai)
        {
            [SVProgressHUD showWithStatus:@"请稍候..."];
        }
        switch (weakSelf.useStyle) {
            case ViewControllerUseStyleRegist:
            {
                /* 校验验证码 现在走BNVerifyPhoneViewController 不走这里
                [RegisterClient checkVerifyCode:weakSelf.phoneNumber verifyCode:verifyCode
                                        success:^(NSDictionary *successData) {
                                            NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                                            
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
                                                                    
                                                                    selectSC.registPhone = weakSelf.phoneNumber;
                                                                    selectSC.verifycode = verifyCode;
                                                                    
                                                                    [weakSelf pushViewController:selectSC animated:YES];
                                                                    BNLog(@"Check and save school list  successfule");
                                                                }
                                                            }];
                                                            
                                                        }else{//加载成功，但是没有获取到任何数据出错
                                                            
                                                            
                                                            [SVProgressHUD showErrorWithStatus:@"很抱歉，没有获取到学校列表，请稍候重试！"];
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
                                                [weakSelf.nextStepButton setEnabled:YES];
                                            }
                                        } failure:^(NSError *error) {
                                            [weakSelf.nextStepButton setEnabled:YES];
                                            [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                        }];
                 */
                
            }
                break;

            case ViewControllerUseStyleFindPassword:
            {
                [RegisterClient findLoginPwdWithCheckVerifyCode:weakSelf.phoneNumber
                                                     verifyCode:verifyCode
                                                        success:^(NSDictionary *successData) {
                                                            NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                                                            
                                                            if ([retCode isEqualToString:kRequestSuccessCode]) {
                                                                [SVProgressHUD dismiss];

                                                                NSDictionary *info = @{@"verifycode":verifyCode,
                                                                                       @"phoneNumber":weakSelf.phoneNumber};
                                                                BNSetLoginPwdViewController *setLoginVC = [[BNSetLoginPwdViewController alloc] init];
                                                                setLoginVC.useStyle = ViewControllerUseStyleFindPassword;
                                                                setLoginVC.registInfoDictionary = info;
                                                                [weakSelf pushViewController:setLoginVC animated:YES];
                                                            }else{
                                                                NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                                                [SVProgressHUD showErrorWithStatus:retMsg];
                                                                [weakSelf.nextStepButton setEnabled:YES];
                                                            }
                                                            
                                                        } failure:^(NSError *error) {

                                                            [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                                            [weakSelf.nextStepButton setEnabled:YES];
                                                        }];
                
            }
                break;
            case ViewControllerUseStyleAddBankCard:
            {
                //添加银行卡
                [RegisterClient checkVerifyCodeForAddCard:weakSelf.phoneNumber verifyCode:verifyCode
                                        success:^(NSDictionary *successData) {
                                            NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                                            if ([retCode isEqualToString:kRequestSuccessCode]) {
                                                [SVProgressHUD dismiss];
                                                //验证银行预留手机号
                                                
                                                if ([payModel.bindCardInfoModel.personalIsFristBindCard isEqualToString:@"yes"] == YES) {//首次绑卡
                                                    [weakSelf turnAnotherController];
                                                }else{//非首次绑卡
                                                    [self accountHasCertBindCard:payModel];
                                                }

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
                break;
            case ViewControllerUseStyleXiaoDai:
            {
                
                //先校验验证码，如果验证码正确再发请求申请贷款，如果验证码错误提示验证码错误
                [SVProgressHUD showWithStatus:@"正在校验验证码..."];
                [XiaoDaiApi checkXiaoDaiVerifyCode:weakSelf.phoneNumber
                                               verifyCode:verifyCode
                                                  success:^(NSDictionary *successData) {
                                                      NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                                                      BNLog(@"校验验证码%@",successData);
                                                      if ([retCode isEqualToString:kRequestSuccessCode])
                                                      {
                                                          //发申请贷款请求
                                                          [XiaoDaiApi loanApplyWithcertNumber:nil
                                                                                   cardNumber:shareAppDelegateInstance.xiaodaiBorrowInfo.cardId
                                                                                  applyAmount:shareAppDelegateInstance.xiaodaiBorrowInfo.amount
                                                                                repaymentType:shareAppDelegateInstance.xiaodaiBorrowInfo.repaymentType
                                                                                 installments:shareAppDelegateInstance.xiaodaiBorrowInfo.installments
                                                                                 mobileNumber:shareAppDelegateInstance.xiaodaiBorrowInfo.mobileNumber
                                                                                          psw:@""
                                                                                   verifycode:verifyCode
                                                                                      success:^(NSDictionary *returnData) {
                                                                                          BNLog(@"borrow money result %@", returnData);
                                                                                          if ([[returnData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode])
                                                                                          {
                                                                                              [SVProgressHUD dismiss];
                                                                                              
                                                                                              shareAppDelegateInstance.xiaodaiBorrowInfo.status = returnData[@"data"][@"status"];
                                                                                              BNXiaoDaiReadServiceAgreementVC *agrenmentVC = [[BNXiaoDaiReadServiceAgreementVC alloc] init];
                                                                                              agrenmentVC.protocalType = XiaoDaiProtocalTypeElectronTicket;
                                                                                              agrenmentVC.orderNO = returnData[@"data"][@"order_no"];
                                                                                              agrenmentVC.econtractProtocol = returnData[@"data"][@"loan_receipt"];
                                                                                              [weakSelf pushViewController:agrenmentVC animated:YES];
                                                                                          }
                                                                                          else
                                                                                          {
                                                                                              NSString *retMessage = returnData[kRequestRetMessage];
                                                                                              [SVProgressHUD showErrorWithStatus:retMessage];
                                                                                          }
                                                                                      } failure:^(NSError *error) {
                                                                                          [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                                                                      }];
                                                      }
                                                      else
                                                      {
                                                          [SVProgressHUD showErrorWithStatus:successData[@"retmsg"]];
                                                      }
                                                      
                                                  } failure:^(NSError *error) {
                                                      [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                                  }];
            }
                break;
            case ViewControllerUseStyleVerifyCurrentPhone:
            {
                //检查旧手机验证码
                [RegisterClient findLoginPwdWithCheckVerifyCode:weakSelf.phoneNumber verifyCode:verifyCode
                                                  success:^(NSDictionary *successData) {
                                                      NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                                                      if ([retCode isEqualToString:kRequestSuccessCode]) {
                                                          [SVProgressHUD dismiss];
                                                          //去输入新手机号
                                                          BNModifyBindPhoneNumVC *bindNewPhoneVC = [[BNModifyBindPhoneNumVC alloc] init];
                                                          bindNewPhoneVC.useStyle = ViewControllerUseStyleVerifyNewPhone;
                                                          [weakSelf pushViewController:bindNewPhoneVC animated:YES];
                                                  
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
                break;
            case ViewControllerUseStyleVerifyNewPhone:
            {
                //检查新手机号
                [RegisterClient checkVerifyCode:weakSelf.phoneNumber verifyCode:verifyCode
                                                        success:^(NSDictionary *successData) {
                                                            NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                                                            if ([retCode isEqualToString:kRequestSuccessCode]) {
                                                                [SVProgressHUD dismiss];
                                                                
                                                                //验证新的手机号码成功，绑定新的手机号
                                                                [weakSelf bindNewPhoneNum:weakSelf.phoneNumber];
                                                            
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
                break;
            case ViewControllerUseStyleModifyStudentNumber:
            {
                [RegisterClient findLoginPwdWithCheckVerifyCode:weakSelf.phoneNumber
                                                     verifyCode:verifyCode
                                                        success:^(NSDictionary *successData) {
                                                            NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                                                            
                                                            if ([retCode isEqualToString:kRequestSuccessCode]) {
                                                                [CardApi modifyStudentNumber:weakSelf.studentNumber userID:shareAppDelegateInstance.boenUserInfo.userid verifyCode:verifyCode success:^(NSDictionary *successData) {
                                                                    BNLog(@"modify student number: %@", successData.description);
                                                                    NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                                                                    if ([retCode isEqualToString:kRequestSuccessCode]) {
                                                                        [SVProgressHUD dismiss];
                                                                        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                                                                        [shareAppDelegateInstance refreshPersonProfile];
                                                                        Class popToClass = NSClassFromString(@"BNPersonalCenterViewController");
                                                                        for (UIViewController *viewController in weakSelf.navigationController.viewControllers) {
                                                                            if ([viewController isKindOfClass:popToClass]) {
                                                                                [weakSelf.navigationController popToViewController:viewController animated:NO];
                                                                                break;
                                                                            }
                                                                        }
                                                                    }
                                                                    else {
                                                                        NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                                                        [SVProgressHUD showErrorWithStatus:retMsg];
                                                                        [weakSelf.nextStepButton setEnabled:YES];
                                                                    }
                                                                } failure:^(NSError *error) {
                                                                    [weakSelf.nextStepButton setEnabled:YES];
                                                                    [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                                                }];
                                                            }
                                                            else {
                                                                NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                                                [SVProgressHUD showErrorWithStatus:retMsg];
                                                                [weakSelf.nextStepButton setEnabled:YES];
                                                            }
                                                        } failure:^(NSError *error) {
                                                            [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                                            [weakSelf.nextStepButton setEnabled:YES];
                                                        }];
            }
                break;
            case ViewControllerUseStyleCollectFees:
            {
                //费用领取
                [RegisterClient checkVerifyCodeForAddCard:weakSelf.phoneNumber verifyCode:verifyCode
                                                  success:^(NSDictionary *successData) {
                                                      NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                                                      if ([retCode isEqualToString:kRequestSuccessCode]) {
                                                          [SVProgressHUD dismiss];
                                                          //验证银行预留手机号
                                                          
                                                          if ([payModel.bindCardInfoModel.personalIsFristBindCard isEqualToString:@"yes"] == YES) {//首次绑卡
                                                              [weakSelf turnAnotherController];
                                                          }else{//非首次绑卡
                                                              [self accountHasCertBindCard:payModel];
                                                          }
                                                          
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
                break;
            default:
                break;
        }
        
    }else{
        [Tools showMessageWithTitle:@"提示" message:@"请填正确的验证码"];
        [weakSelf.nextStepButton setEnabled:YES];
    }
    
    
}
//首次绑卡
- (void)turnAnotherController
{
    BNSetNewPayPwdViewController *setPayPwdVC = [[BNSetNewPayPwdViewController alloc] init];
    setPayPwdVC.useStyle = self.useStyle == ViewControllerUseStyleCollectFees ? SetNewPayPwdViewControllerUseStyleCollectFees : SetNewPayPwdViewControllerUseStyleBindCardSetPwd;
    setPayPwdVC.verifyCode = _smsCodeField.text;
    setPayPwdVC.payModel = payModel;
    [self pushViewController:setPayPwdVC animated:YES];
    
}
- (void)nextStepTouchDownAction:(UIButton *)btn
{
    [btn setBackgroundColor:UIColor_Button_HighLight];
}

//验证银行预留手机号后非首次绑卡
- (void)accountHasCertBindCard:(BNPayModel *)tempPayModel{
    __weak typeof(self) weakSelf = self;
    __weak typeof(shareAppDelegateInstance) weakAppDelegate = shareAppDelegateInstance;
    [SVProgressHUD showWithStatus:@"请稍候..."];
    
    [PayClient bindCard:tempPayModel.bankCardBinModel.bankId
             bankCardNo:tempPayModel.bankCardBinModel.bankNumber
                is_cert:@"no"
               isCredit:tempPayModel.bindCardInfoModel.personalIsCredit
                 userid:weakAppDelegate.boenUserInfo.userid
            payPassWord:nil
                 mobile:tempPayModel.bindCardInfoModel.personalBankPhone
               realName:tempPayModel.bindCardInfoModel.personalName
                 certNo:tempPayModel.bindCardInfoModel.personalIDNum
               safeCode:tempPayModel.bindCardInfoModel.personalSafeCode
           certValidate:tempPayModel.bindCardInfoModel.personalVanlidate
             verifyCode:_smsCodeField.text
                success:^(NSDictionary *returnData) {
                    BNLog(@"bind card--%@", returnData);
                    NSString *retCode = [returnData valueNotNullForKey:kRequestRetCode];
                    if ([retCode isEqualToString:kRequestSuccessCode]) {
                        [SVProgressHUD dismiss];
                        Class objVC = NSClassFromString(weakAppDelegate.popToViewController);
                        NSArray *viewControllers = weakSelf.navigationController.viewControllers;
                        UIViewController *skipVC = nil;
                        NSDictionary *retData = [returnData valueForKey:kRequestReturnData];
                        NSArray *bankCards = [retData valueForKey:@"binded_cards"];
                        weakAppDelegate.boenUserInfo.bankCardNumbers = [Tools saveto:weakAppDelegate.boenUserInfo.bankCardNumbers valueNotNegative:[NSString stringWithFormat:@"%lu", (unsigned long)[bankCards count]]];//赋值判断，如果为-1或是不正常数据时，则不赋值。

                        for (UIViewController *obj in viewControllers) {
                            if ([obj isKindOfClass:objVC] == YES) {
                                skipVC = (UIViewController *)obj;
                                break;
                            }
                        }
                       
                            [weakSelf.navigationController popToViewController:skipVC animated:YES];
                        
                        
                    }else{
                        NSString *retMsg = [returnData valueNotNullForKey:kRequestRetMessage];
                        [SVProgressHUD showErrorWithStatus:retMsg];
                    }
                    
                }
                failure:^(NSError *error) {
                    
                    [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                }];
    
}

- (void)bindNewPhoneNum:(NSString *)newPhone
{
    NSString *verifyCode = self.smsCodeField.text;
    __weak typeof(self) weakSelf = self;
    __block NSString *blockNewPhone = newPhone;

    __weak typeof(shareAppDelegateInstance) weakAppDet = shareAppDelegateInstance;
    [SVProgressHUD showWithStatus:@"请稍候..."];
    
    [RegisterClient changeMobileWithUserID:shareAppDelegateInstance.boenUserInfo.userid
                                    moblie:newPhone
                                verifyCode:verifyCode
                                   success:^(NSDictionary *successData) {
                                       BNLog(@"changeMobileWithUserID%@", successData);
                                       
                                       NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                                       
                                       if ([retCode isEqualToString:kRequestSuccessCode]) {
                                           weakAppDet.boenUserInfo.phoneNumber = weakSelf.phoneNumber;
                                           [weakAppDet refreshPersonProfile];
                                           Class objVC = NSClassFromString(@"BNSettingsViewController");
                                           NSArray *viewControllers = weakSelf.navigationController.viewControllers;
                                           UIViewController *skipVC = nil;
                                           for (UIViewController *obj in viewControllers) {
                                               if ([obj isKindOfClass:objVC] == YES) {
                                                   skipVC = (UIViewController *)obj;
                                                   [weakSelf.navigationController popToViewController:skipVC animated:YES];
                                                   break;
                                               }
                                           }
                                           KeychainItemWrapper * keychinLogin = [[KeychainItemWrapper alloc]initWithIdentifier:kKeyChainAccessGroup_LastLoginUserId accessGroup:kKeyChainAccessGroup_LastLoginUserId];
                                           [keychinLogin setObject:blockNewPhone forKey:(__bridge id)kSecAttrAccount];
                                           [keychinLogin setObject:shareAppDelegateInstance.boenUserInfo.userid forKey:(__bridge id)kSecAttrDescription];

                                           //记录登录过的账号到数据库
                                           NSArray *accountSorted = [XifuLoginAccount MR_findByAttribute:@"xifuLoginAccount" withValue:blockNewPhone];
                                           if ([accountSorted count] == 0) {//没有在数据库中找到添加到数据库
                                               XifuLoginAccount *account = [XifuLoginAccount MR_createEntity];
                                               account.xifuLoginAccount = blockNewPhone;
                                               [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfAndWait];
                                           }
                                           [SVProgressHUD showSuccessWithStatus:@"绑定新手机号成功"];
                                       }else{
                                           NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                           [SVProgressHUD showErrorWithStatus:retMsg];
                                       }
                                   }
                                   failure:^(NSError *error) {
                                       [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                   }];
}



@end
