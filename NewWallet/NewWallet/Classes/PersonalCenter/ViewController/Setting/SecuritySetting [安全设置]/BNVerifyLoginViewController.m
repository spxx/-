//
//  BNVerifyLoginViewController.m
//  NewWallet
//
//  Created by mac1 on 14-11-11.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNVerifyLoginViewController.h"

#import "BNSetLoginPwdViewController.h"

#import "Password.h"

@interface BNVerifyLoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic)UIScrollView *scrollView;

@property (weak, nonatomic)UITextField *oldLoginPwdTextField;

@property (weak, nonatomic)UIButton *nextStepButton;

@end

@implementation BNVerifyLoginViewController

#pragma mark - setup loaded view
- (void)setupLoadedView
{
    self.navigationTitle = @"修改登录免密";
    
    self.view.backgroundColor = UIColor_Gray_BG;
    
    UIScrollView *theScollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT- self.sixtyFourPixelsView.viewBottomEdge)];
    theScollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge + 1);
    [self.view addSubview:theScollView];
    self.scrollView = theScollView;
    
    
    UIView *cardBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 10 * 2, 260)];
    cardBackgroundView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    
    UIBezierPath *maskPathLB = [UIBezierPath bezierPathWithRoundedRect:cardBackgroundView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayerLB = [[CAShapeLayer alloc] init];
    maskLayerLB.frame = cardBackgroundView.bounds;
    maskLayerLB.path = maskPathLB.CGPath;
    cardBackgroundView.layer.mask = maskLayerLB;
    
    [self.scrollView addSubview:cardBackgroundView];
    
    CGRect cardFrame = cardBackgroundView.frame;
    
    UITextField *passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 30, cardFrame.size.width - 10 *2, 40)];
    passwordTF.placeholder = @"验证旧密码";
    passwordTF.clearButtonMode = UITextFieldViewModeAlways;
    passwordTF.borderStyle = UITextBorderStyleNone;
    passwordTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passwordTF.secureTextEntry = YES;
    passwordTF.delegate = self;
    self.oldLoginPwdTextField = passwordTF;
    
    [passwordTF addTarget:self action:@selector(oldLoginPwdTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [cardBackgroundView addSubview:passwordTF];
    
    UIButton *nextStepButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextStepButton.frame = CGRectMake(30, passwordTF.frame.origin.y + passwordTF.frame.size.height + 15, SCREEN_WIDTH - 30 *2, 40*NEW_BILI);
    [nextStepButton setupTitle:@"下一步" enable:NO];
    [nextStepButton addTarget:self action:@selector(setNewLoginPwdAction:) forControlEvents:UIControlEventTouchUpInside];
    [nextStepButton addTarget:self action:@selector(setNewLoginPwdTouchDown:) forControlEvents:UIControlEventTouchDown];
    [cardBackgroundView addSubview:nextStepButton];
    self.nextStepButton = nextStepButton;
    
    
    UITapGestureRecognizer *cancelKeyboardTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelKeyboard:)];
    [self.scrollView addGestureRecognizer:cancelKeyboardTap];
    
    
}

- (void)cancelKeyboard:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - button action
- (void)oldLoginPwdTextFieldChanged:(UITextField *)tf
{
    if (tf.text.length > 0) {
        [self.nextStepButton setBackgroundColor:UIColor_Button_Normal];
        [self.nextStepButton setEnabled:YES];
    }else{
        [self.nextStepButton setBackgroundColor:UIColor_Button_Disable];
        [self.nextStepButton setEnabled:NO];
    }
}


- (void)setNewLoginPwdAction:(UIButton *)btn
{
    [self.nextStepButton setBackgroundColor:UIColor_Button_Normal];
    //设置新的登录密码
    NSString *old = self.oldLoginPwdTextField.text;
    
    if (old.length > 0) {
        __weak typeof(self) weakSelf = self;
        [SVProgressHUD showWithStatus:@"请稍候..."];
        if (shareAppDelegateInstance.boenUserInfo.userid.length > 0) {
            NSDictionary *info = @{@"password":old,
                                   @"userid":shareAppDelegateInstance.boenUserInfo.userid
                                   };
            [Password verifyLoginPwd:info
                             success:^(NSDictionary *returnData) {
                                 BNLog(@"Verify login pwd data %@", returnData);
                                 NSString *retCode = [returnData valueNotNullForKey:kRequestRetCode];
                                 if ([retCode isEqualToString:kRequestSuccessCode]) {
                                     [SVProgressHUD dismiss];
                                     
                                     BNSetLoginPwdViewController *setLoginPwd = [[BNSetLoginPwdViewController alloc] init];
                                     setLoginPwd.oldLoginPassword = weakSelf.oldLoginPwdTextField.text;
                                     [weakSelf pushViewController:setLoginPwd animated:YES];
                                     
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
}

- (void)setNewLoginPwdTouchDown:(UIButton *)btn
{
    [self.nextStepButton setBackgroundColor:UIColor_Button_Disable];
    [self.view endEditing:YES];
}

@end
