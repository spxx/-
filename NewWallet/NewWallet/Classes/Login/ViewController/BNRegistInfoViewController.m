//
//  BNRegistInfoViewController.m
//  NewWallet
//
//  Created by mac1 on 14-10-27.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNRegistInfoViewController.h"

#import "SelectItemView.h"

#import "BNSetLoginPwdViewController.h"

#import "RegisterClient.h"

@interface BNRegistInfoViewController ()<UITextFieldDelegate, SelectItemViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) UIScrollView *scrollView;

@property (weak, nonatomic) UIView *inputView;

@property (assign, nonatomic) BOOL isShowSchoolSelectView;

@property (strong, nonatomic) UITapGestureRecognizer *cancelKeyboardTap;

@property (copy, nonatomic) NSString *selectSchoolNum;

@property (copy, nonatomic) NSString *selectSchoolName;

@property (weak, nonatomic) UITextField *studentNumTextField;

@property (weak, nonatomic) UIButton *showOtherItemButton;

@property (weak, nonatomic) UIButton *nextStepButton;

@end


@implementation BNRegistInfoViewController
static NSString *cardTypeName;

@synthesize schoolListArray = _schoolListArray;

#pragma mark - setup loaded view
- (void)setupLoadedView
{
    self.view.backgroundColor = UIColor_Gray_BG;
    cardTypeName = [shareAppDelegateInstance.boenUserInfo.yktType isEqualToString:@"1"] ? @"学号" : @"一卡通号";

    
    UIScrollView *theScollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT- self.sixtyFourPixelsView.viewBottomEdge)];
    theScollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge + 1);
    [self.view addSubview:theScollView];
    self.scrollView = theScollView;
    
    
    UIView *inputBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 15, 300)];
    inputBackgroundView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    self.inputView = inputBackgroundView;
    
    UIBezierPath *maskPathLB = [UIBezierPath bezierPathWithRoundedRect:inputBackgroundView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayerLB = [[CAShapeLayer alloc] init];
    maskLayerLB.frame = inputBackgroundView.bounds;
    maskLayerLB.path = maskPathLB.CGPath;
    inputBackgroundView.layer.mask = maskLayerLB;
    
    [self.scrollView addSubview:inputBackgroundView];
    
    
    CGRect backgroundViewRect = inputBackgroundView.frame;
    
    UILabel *tipsPhoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, backgroundViewRect.size.width - 20, 40)];
    tipsPhoneLabel.backgroundColor = [UIColor clearColor];
    tipsPhoneLabel.font = [UIFont systemFontOfSize:14];
    tipsPhoneLabel.numberOfLines = 0;
    tipsPhoneLabel.text = [NSString stringWithFormat:@"为保障功能的正常使用和资金安全，请务必填写本人的%@",cardTypeName];
    tipsPhoneLabel.textColor = [UIColor lightGrayColor];
    [inputBackgroundView addSubview:tipsPhoneLabel];
    
    
    UIView *schoolNameBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(10, tipsPhoneLabel.frame.origin.y + tipsPhoneLabel.frame.size.height + 10, backgroundViewRect.size.width - 20, 40)];
    schoolNameBackgroundView.layer.cornerRadius = 3;
    schoolNameBackgroundView.layer.borderColor = UIColorFromRGB(0xe7e7e7).CGColor;
    schoolNameBackgroundView.layer.borderWidth = 1;
    schoolNameBackgroundView.tag = 100;
    [inputBackgroundView addSubview:schoolNameBackgroundView];
        
    UIButton *showPullDownView = [UIButton buttonWithType:UIButtonTypeCustom];
    showPullDownView.frame = CGRectMake(schoolNameBackgroundView.frame.size.width - 5 - 40, 0, 40, 40);
    [showPullDownView  setImage:[UIImage imageNamed:@"Main_MoreArrow_Btn"] forState:UIControlStateNormal];
    [showPullDownView addTarget:self action:@selector(showSelectSchoolView:) forControlEvents:UIControlEventTouchUpInside];
    [schoolNameBackgroundView addSubview:showPullDownView];
    self.showOtherItemButton = showPullDownView;
    NSDictionary *fristSchoolInfo = [self.schoolListArray firstObject];
    
    self.selectSchoolName = [fristSchoolInfo valueNotNullForKey:@"name"];
    self.selectSchoolNum  = [NSString stringWithFormat:@"%i",[[fristSchoolInfo valueNotNullForKey:@"id"] intValue]];
    
    
    UILabel *schoolNameLabel =[[UILabel alloc] initWithFrame:CGRectMake(10, 5, schoolNameBackgroundView.frame.size.width - 40 - 5 - 10, 30)];
    schoolNameLabel.text = self.selectSchoolName;
    schoolNameLabel.font = [UIFont systemFontOfSize:15];
    schoolNameLabel.textColor = [UIColor blackColor];
    schoolNameLabel.backgroundColor = [UIColor clearColor];
    [schoolNameBackgroundView addSubview:schoolNameLabel];
    
    
    
    UIView *stuNumBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(10, schoolNameBackgroundView.frame.origin.y + schoolNameBackgroundView.frame.size.height + 15, backgroundViewRect.size.width - 20, 40)];
    stuNumBackgroundView.layer.cornerRadius = 3;
    stuNumBackgroundView.layer.borderColor = UIColorFromRGB(0xe7e7e7).CGColor;
    stuNumBackgroundView.layer.borderWidth = 1;
    
    [inputBackgroundView addSubview:stuNumBackgroundView];

    UITextField *sutdentNumberTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, stuNumBackgroundView.frame.size.width - 10 * 2, 30)];
    sutdentNumberTF.placeholder = cardTypeName;
    sutdentNumberTF.clearButtonMode = UITextFieldViewModeAlways;
    sutdentNumberTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    sutdentNumberTF.borderStyle = UITextBorderStyleNone;
    sutdentNumberTF.keyboardType = UIKeyboardTypeASCIICapable;
    sutdentNumberTF.delegate = self;
    [sutdentNumberTF addTarget:self action:@selector(textFieldEditingChangedValue:) forControlEvents:UIControlEventEditingChanged];
    self.studentNumTextField = sutdentNumberTF;
    [stuNumBackgroundView addSubview:sutdentNumberTF];
    
    
    UIButton *nextStepButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextStepButton.frame = CGRectMake(30, stuNumBackgroundView.frame.origin.y + stuNumBackgroundView.frame.size.height + 20, backgroundViewRect.size.width - 30 *2, 40*NEW_BILI);
    [nextStepButton setupTitle:@"下一步" enable:NO];
    [nextStepButton addTarget:self action:@selector(nextStepTouchUpAction:) forControlEvents:UIControlEventTouchUpInside];
    [nextStepButton addTarget:self action:@selector(nextStepTouchDownAction:) forControlEvents:UIControlEventTouchDown];
    self.nextStepButton = nextStepButton;
    [inputBackgroundView addSubview:nextStepButton];
    
    
    self.cancelKeyboardTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelKeyboard:)];
    [self.scrollView addGestureRecognizer:self.cancelKeyboardTap];
    
    
    self.isShowSchoolSelectView = NO;
    
    self.navigationTitle = @"注册";

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
    if (self.studentNumTextField.text.length > 0) {
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
    
    if (self.isShowSchoolSelectView == YES) {
        [self.scrollView addGestureRecognizer:self.cancelKeyboardTap];
        
        UIView *view = [self.inputView viewWithTag:200];
        [view removeFromSuperview];
        self.isShowSchoolSelectView = NO;
    }
}

- (void)keyboardDidShow:(NSNotification *)note
{
    [self.scrollView setContentOffset:CGPointMake(0, 55)];
}


-(void)textFieldEditingChangedValue:(UITextField *)tf
{
    if (self.studentNumTextField.text.length > 0) {
        [self.nextStepButton setBackgroundColor:UIColor_Button_Normal];
        [self.nextStepButton setEnabled:YES];
    }else{
        [self.nextStepButton setBackgroundColor:UIColor_Button_Disable];
        [self.nextStepButton setEnabled:NO];
    }
}

#pragma mark - button action
- (void)nextStepTouchUpAction:(UIButton *)btn
{
    [btn setBackgroundColor:UIColor_Button_Normal];
    [btn setEnabled:NO];
    //
    NSString *stuNum = self.studentNumTextField.text;
    if (stuNum == nil || stuNum.length <= 0) {
        [Tools showMessageWithTitle:@"提示" message:[NSString stringWithFormat:@"请输入%@", cardTypeName]];
    }else{
        
        //检查一卡通号
        __weak typeof(self) weakSelf = self;
        [SVProgressHUD showWithStatus:@"请稍候..."];
        [RegisterClient verifySchoolID:weakSelf.selectSchoolNum
                         studentNumber:stuNum
                               success:^(NSDictionary *successData) {
                                   BNLog(@"Return data %@", successData);
                                   
                                   NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                                   
                                   if ([retCode isEqualToString:kRequestSuccessCode]) {
                                       NSDictionary *retData = [successData valueForKey:kRequestReturnData];
                                       //提示姓名alert
                                       NSString *stuName = [retData valueNotNullForKey:@"custname"];
                                       if (stuName.length > 0) {
                                           [SVProgressHUD dismiss];

                                           NSMutableString *msg = [[NSMutableString alloc] initWithString:stuName];
                                           [msg replaceCharactersInRange:NSMakeRange(0, 1) withString:@"*"];
                                           NSString *alertMsg = [NSString stringWithFormat:@"您正在绑定%@的%@，若是本人操作请点击就是我", msg, cardTypeName];
                                           shareAppDelegateInstance.alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"请确认%@", cardTypeName] message:alertMsg delegate:self cancelButtonTitle:@"不是我" otherButtonTitles:@"就是我", nil];
                                           [shareAppDelegateInstance.alertView show];
                                       }else{
                                           [weakSelf.nextStepButton setEnabled:YES];
                                           [SVProgressHUD showErrorWithStatus:@"很抱歉，我们没有获取到正确的名字，请稍后重试"];

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
    
    
    
}

- (void)nextStepTouchDownAction:(UIButton *)btn
{
    [btn setBackgroundColor:UIColor_Button_HighLight];
    [self.view endEditing:YES];
}

- (void)showSelectSchoolView:(UIButton *)btn
{
    if (self.isShowSchoolSelectView == NO) {
        [self.scrollView removeGestureRecognizer:self.cancelKeyboardTap];
        
        UIView *relateView = [self.inputView viewWithTag:100];
        NSArray *array = [NSArray arrayWithArray:self.schoolListArray];
        SelectItemView *selectSchoolView = [[SelectItemView alloc] initWithDataSource:array relateView:relateView style:SelectItemViewUseStyleSelectSchool delegate:self];
        selectSchoolView.tag = 200;
        [selectSchoolView showInView:self.inputView];
        self.isShowSchoolSelectView = YES;
        [btn  setImage:[UIImage imageNamed:@"Main_MoreArrow_Btn_up"] forState:UIControlStateNormal];
    }else{
        [self.scrollView addGestureRecognizer:self.cancelKeyboardTap];

        UIView *view = [self.inputView viewWithTag:200];
        [view removeFromSuperview];
        self.isShowSchoolSelectView = NO;
        [btn  setImage:[UIImage imageNamed:@"Main_MoreArrow_Btn"] forState:UIControlStateNormal];
    }
    
}

#pragma mark - SelectItemView delegate
- (void)selectSchoolName:(NSString *)scName schoolNumber:(NSString *)scNum
{
    [self.scrollView addGestureRecognizer:self.cancelKeyboardTap];
    self.selectSchoolName = scName;
    self.selectSchoolNum = scNum;
    
    [self.showOtherItemButton  setImage:[UIImage imageNamed:@"Main_MoreArrow_Btn"] forState:UIControlStateNormal];
}

#pragma mark - alert delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSDictionary *registInfo = @{@"name":      self.selectSchoolName,
                                     @"verifycode":self.verifycode,
                                     @"phoneNum":  self.registPhone,
                                     @"stuNum":    self.studentNumTextField.text,
                                     @"schoolid":  self.selectSchoolNum};
        
        
        
        BNSetLoginPwdViewController *setPwdVC = [[BNSetLoginPwdViewController alloc] init];
        setPwdVC.registInfoDictionary = registInfo;
        
        [self pushViewController:setPwdVC animated:YES];
    }
}

@end
