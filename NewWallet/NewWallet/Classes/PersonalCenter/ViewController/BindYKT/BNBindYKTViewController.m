//
//  BNBindYKTViewController.m
//  Wallet
//
//  Created by mac1 on 15/3/3.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNBindYKTViewController.h"

#import "CardApi.h"
#import "BNCollectFeesListVC.h"

NSString *const kBindXueHaoUseTypeKey = @"kBindXueHaoUseTypeKey";

@interface BNBindYKTViewController ()<UITextFieldDelegate, UIScrollViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) UITextField *nameTextField;
@property (weak, nonatomic) UITextField *YKTNumTextField;
@property (weak, nonatomic) UITextField *YKTPWDTextField;
@property (weak, nonatomic) UIButton *submitInfoBtn;
@property (weak, nonatomic) UIScrollView *scrollView;

@end

@implementation BNBindYKTViewController

- (void)setupLoadedView
{
    self.navigationTitle = (_bindType == BindTypeXueHao) ? @"绑定学号" : @"绑定一卡通";
    
    self.view.backgroundColor = UIColor_Gray_BG;
    
    UIScrollView *theScollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT- self.sixtyFourPixelsView.viewBottomEdge)];
    theScollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge + 1);
    theScollView.delegate = self;
    _scrollView = theScollView;
    [self.view addSubview:theScollView];
    
    if (self.useType == BNBindYKTUseTypeCollectFees) {
        UILabel *promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * BILI_WIDTH, 0, SCREEN_WIDTH - 10 * BILI_WIDTH, 40 * BILI_WIDTH)];
        promptLabel.text = @"使用此功能，需要绑定学号。";
        promptLabel.textColor = [UIColor colorWithRed:157/255.0 green:157/255.0 blue:157/255.0 alpha:1.f];
        promptLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:13 six:15 sixPlus:17]];
        [theScollView addSubview:promptLabel];
    }
    
    
    UIView *infoBGView = [[UIView alloc] init];
    infoBGView.backgroundColor = [UIColor whiteColor];
    
    UIView *infoUpLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    infoUpLine.backgroundColor = UIColor_GrayLine;
    
    UIView *infoMidLine = [[UIView alloc] initWithFrame:CGRectMake(10, 45 * BILI_WIDTH, SCREEN_WIDTH - 10, 0.5)];
    infoMidLine.backgroundColor = UIColor_GrayLine;
    
    UIView *infoDownLine = [[UIView alloc] init];
    infoDownLine.backgroundColor = UIColor_GrayLine;
    
    UILabel *nameTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 90, 45 *BILI_WIDTH)];
    nameTitle.textColor = [UIColor blackColor];
    nameTitle.textAlignment = NSTextAlignmentLeft;
    nameTitle.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
    nameTitle.text = @"姓名";
    
    UITextField *nameTF = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, SCREEN_WIDTH - 110, 45 *BILI_WIDTH)];
    nameTF.tag = 10;
    NSString *placeholderStr1 = (_bindType == BindTypeXueHao) ? @"请填写本人姓名" : @"持卡人姓名";
    nameTF.placeholder = (_useType == BNBindYKTUseTypeCollectFees) ? @"请输入您的姓名":placeholderStr1;
    nameTF.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
    nameTF.clearButtonMode = UITextFieldViewModeAlways;
    nameTF.borderStyle = UITextBorderStyleNone;
    nameTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    nameTF.keyboardType = UIKeyboardTypeDefault;
    nameTF.delegate = self;
    [nameTF addTarget:self action:@selector(infoTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    _nameTextField = nameTF;
    
    
    UILabel *yktTitle = [[UILabel alloc] init];
    yktTitle.textColor = [UIColor blackColor];
    yktTitle.textAlignment = NSTextAlignmentLeft;
    yktTitle.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
    yktTitle.text = (_bindType == BindTypeXueHao) ? @"学号" : ([_yktType isEqualToString:@"1"]) ? @"学工号" : @"一卡通号";
    
    UITextField *yktNumTF = [[UITextField alloc] init];
    NSString *placeholderStr2 = (_bindType == BindTypeXueHao) ? @"请填写对应的学号" : ([_yktType isEqualToString:@"1"]) ? @"学号或工号" : @"一卡通号";
    yktNumTF.placeholder = (_useType == BNBindYKTUseTypeCollectFees) ? @"请输入学号":placeholderStr2;
    yktNumTF.tag = 11;
    yktNumTF.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
    yktNumTF.clearButtonMode = UITextFieldViewModeAlways;
    yktNumTF.borderStyle = UITextBorderStyleNone;
    yktNumTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    yktNumTF.keyboardType = UIKeyboardTypeASCIICapable;
    yktNumTF.delegate = self;
    [yktNumTF addTarget:self action:@selector(infoTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    _YKTNumTextField = yktNumTF;
    
    
    UIButton *nextStepButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    if ([_yktType isEqualToString:@"1"] == YES || (_bindType == BindTypeXueHao)) {
        
        infoBGView.frame = CGRectMake(0, self.useType == BNBindYKTUseTypeCollectFees ? 40 * BILI_WIDTH : kSectionHeight, SCREEN_WIDTH, 45 *BILI_WIDTH *2);
        
        infoDownLine.frame = CGRectMake(0, infoBGView.frame.size.height - 1, SCREEN_WIDTH, 1);
        
        yktTitle.frame = CGRectMake(10, 45 * BILI_WIDTH, 90, 45 *BILI_WIDTH);
        
        yktNumTF.frame = CGRectMake(100, 45 *BILI_WIDTH, SCREEN_WIDTH - 110, 45 *BILI_WIDTH);
        
        nextStepButton.frame = CGRectMake(10, infoBGView.frame.origin.y + infoBGView.frame.size.height + 40 * BILI_WIDTH, SCREEN_WIDTH - 20, 40 * BILI_WIDTH);
        
        [infoBGView addSubview:nameTitle];
        [infoBGView addSubview:yktTitle];
        [infoBGView addSubview:nameTF];
        [infoBGView addSubview:yktNumTF];
        
        [infoBGView addSubview:infoUpLine];
        [infoBGView addSubview:infoMidLine];
        [infoBGView addSubview:infoDownLine];
        
    }else if([_yktType isEqualToString:@"2"] == YES || [_yktType isEqualToString:@"0"] == YES){
        infoBGView.frame = CGRectMake(0, kSectionHeight, SCREEN_WIDTH, 45 *BILI_WIDTH);
        infoDownLine.frame = CGRectMake(0, infoBGView.frame.size.height - 1, SCREEN_WIDTH, 1);
        
        [infoBGView addSubview:nameTitle];
        [infoBGView addSubview:nameTF];
        
        UIView *yktBGView = [[UIView alloc] initWithFrame:CGRectMake(0, infoBGView.frame.origin.y + infoBGView.frame.size.height + kSectionHeight, SCREEN_WIDTH, 45 *BILI_WIDTH *2)];
        yktBGView.backgroundColor = [UIColor whiteColor];
        
        UIView *yktUpLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        yktUpLine.backgroundColor = UIColor_GrayLine;
        
        UIView *yktDownLine = [[UIView alloc] initWithFrame:CGRectMake(0, yktBGView.frame.size.height - 1, SCREEN_WIDTH, 1)];
        yktDownLine.backgroundColor = UIColor_GrayLine;
        
        yktTitle.frame = CGRectMake(10, 0, 90, 45 *BILI_WIDTH);
        
        yktNumTF.frame = CGRectMake(100, 0, SCREEN_WIDTH - 110, 45 *BILI_WIDTH);
        
        UILabel *yktPWDTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 45 *BILI_WIDTH, 90, 45 *BILI_WIDTH)];
        yktPWDTitle.textColor = [UIColor blackColor];
        yktPWDTitle.textAlignment = NSTextAlignmentLeft;
        yktPWDTitle.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
        yktPWDTitle.text = @"密码";
        
        UITextField *yktPWDTF = [[UITextField alloc] initWithFrame:CGRectMake(100, 45 *BILI_WIDTH, SCREEN_WIDTH - 110, 45 *BILI_WIDTH)];
        yktPWDTF.placeholder = @"一卡通密码";
        yktPWDTF.tag = 12;
        yktPWDTF.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
        yktPWDTF.clearButtonMode = UITextFieldViewModeAlways;
        yktPWDTF.borderStyle = UITextBorderStyleNone;
        yktPWDTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        yktPWDTF.keyboardType = UIKeyboardTypeASCIICapable;
        yktPWDTF.delegate = self;
        [yktPWDTF addTarget:self action:@selector(infoTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        _YKTPWDTextField = yktPWDTF;
        
        nextStepButton.frame = CGRectMake(10, yktBGView.frame.origin.y + yktBGView.frame.size.height + 40 * BILI_WIDTH, SCREEN_WIDTH - 20, 40 * BILI_WIDTH);
        
        [yktBGView addSubview:yktTitle];
        [yktBGView addSubview:yktNumTF];
        [yktBGView addSubview:yktPWDTitle];
        [yktBGView addSubview:yktPWDTF];
        
        
        
        [infoBGView addSubview:infoUpLine];
        [infoBGView addSubview:infoDownLine];
        
        [yktBGView addSubview:yktUpLine];
        [yktBGView addSubview:infoMidLine];
        [yktBGView addSubview:yktDownLine];
        [theScollView addSubview:yktBGView];
    }
    [theScollView addSubview:infoBGView];
    
    [nextStepButton setupTitle:(_bindType == BindTypeXueHao) ? @"确认绑定" :@"下一步" enable:NO];
    [nextStepButton addTarget:self action:@selector(submitYKTAction:) forControlEvents:UIControlEventTouchUpInside];
    _submitInfoBtn = nextStepButton;
    
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
#pragma mark - scrollView

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - TextField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(string.length == 0)//退格能删除
    {
        return YES;
    }
    if ([string isEqualToString:@" "]) {//不让输入空格
        return NO;
    }
    
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 11:
        case 12:
            if(SCREEN_HEIGHT == 480){
            [UIView animateWithDuration:0.3 animations:^{
                 [self.scrollView setContentOffset:CGPointMake(0, 45 * BILI_WIDTH + kSectionHeight * 1)];
            }];
              
            }
            
            break;
        default:
            break;
    }
    return YES;
}
- (void)infoTextFieldChanged:(UITextField *)tf
{

    if ([_yktType isEqualToString:@"1"] == YES || (_bindType == BindTypeXueHao)) {
        if (_nameTextField.text.length > 0 && _YKTNumTextField.text.length > 0) {
            _submitInfoBtn.enabled = YES;
        }else{
            _submitInfoBtn.enabled = NO;
        }
    }else{
        if (_nameTextField.text.length > 0 && _YKTNumTextField.text.length > 0 && _YKTPWDTextField.text.length > 0) {
            _submitInfoBtn.enabled = YES;
        }else{
            _submitInfoBtn.enabled = NO;
        }

    }
}

#pragma mark - button action
- (void)submitYKTAction:(UIButton *)btn
{
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.scrollView setContentOffset:CGPointMake(0, 0)];
    }];
    
    
    NSString *msg = (_bindType == BindTypeXueHao) ? [NSString stringWithFormat:@"\n确定绑定\"%@\"的学号吗？\n", _nameTextField.text] : [NSString stringWithFormat:@"\n确定绑定\"%@\"的一卡通吗？\n", _nameTextField.text];
    shareAppDelegateInstance.alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [shareAppDelegateInstance.alertView show];
    
}

#pragma mark - alert delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    __weak typeof(shareAppDelegateInstance) weakAppDelegate = shareAppDelegateInstance;
    __weak typeof(self) weakSelf = self;
    if (_bindType == BindTypeXueHao) {
        //绑定学号
        [SVProgressHUD showWithStatus:@"请稍候..."];
        
        [CardApi bindYKT:shareAppDelegateInstance.boenUserInfo.userid
                ykt_type:_yktType
                stuempno:_YKTNumTextField.text
               studentno:[_yktType isEqualToString:@"1"] ? nil :_YKTNumTextField.text
                password:[_yktType isEqualToString:@"1"] ? nil :_YKTPWDTextField.text
               real_name:_nameTextField.text
                 success:^(NSDictionary *successData) {
                     BNLog(@"bind ykt--%@", successData);
                     
                     NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                     
                     if ([retCode isEqualToString:kRequestSuccessCode]) {
                         [SVProgressHUD showSuccessWithStatus:@"学号绑定成功"];
                         //绑定成功之后,保存已阅读校园缴费须知。。。
                         [Tools setHasShowPaySchoolFeesExplainWithUserId:shareAppDelegateInstance.boenUserInfo.userid];
                         
                         weakAppDelegate.boenUserInfo.name = weakSelf.nameTextField.text;
                         weakAppDelegate.boenUserInfo.studentno = weakSelf.YKTNumTextField.text;
                         if ([_yktType isEqualToString:@"1"]) {
                             weakAppDelegate.boenUserInfo.stuempno = weakSelf.YKTNumTextField.text;
                         }
                         [weakAppDelegate refreshPersonProfile];
                         
                         if (self.useType == BNBindYKTUseTypeCollectFees) {
                             BNCollectFeesListVC *listVC = [[BNCollectFeesListVC alloc] init];
                             [weakSelf pushViewController:listVC animated:YES];
                             return; //如果是费用领取绑定学号，成功则直接跳转到费用领取列表状态，不执行以后代码.
                         }
                         // 小额贷绑定学号，手机充值绑定学号，学校费用缴纳，跳转到生活界面走通知
                         [weakSelf.navigationController popToRootViewControllerAnimated:NO];
                     }else{
                         NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                         [SVProgressHUD showErrorWithStatus:retMsg];
                     }
                 }
                 failure:^(NSError *error) {
                     [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                 }];
        
    } else {
        //绑定一卡通
        [SVProgressHUD showWithStatus:@"请稍候..."];
        
        [CardApi bindYKT:shareAppDelegateInstance.boenUserInfo.userid
                ykt_type:_yktType
                stuempno:_YKTNumTextField.text
               studentno:nil
                password:[_yktType isEqualToString:@"1"] ? nil :_YKTPWDTextField.text
               real_name:_nameTextField.text
                 success:^(NSDictionary *successData) {
                     BNLog(@"bind ykt--%@", successData);
                     
                     NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                     
                     if ([retCode isEqualToString:kRequestSuccessCode]) {
                         [SVProgressHUD showErrorWithStatus:@"一卡通绑定成功"];
                         
                         weakAppDelegate.boenUserInfo.name = weakSelf.nameTextField.text;
                         weakAppDelegate.boenUserInfo.stuempno = weakSelf.YKTNumTextField.text;
                         if ([_yktType isEqualToString:@"1"]) {
                             weakAppDelegate.boenUserInfo.studentno = weakSelf.YKTNumTextField.text;
                         }
                         [weakAppDelegate refreshPersonProfile];
                         
                         [weakSelf.navigationController popViewControllerAnimated:YES];
                     }else{
                         NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                         [SVProgressHUD showErrorWithStatus:retMsg];
                     }
                 }
                 failure:^(NSError *error) {
                     [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                 }];
    }
}
@end
