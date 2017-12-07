//
//  BNReportLossVC.m
//  NewWallet
//
//  Created by mac on 14-10-28.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNReportLossVC.h"
#import "SelectItemView.h"
#import "CardApi.h"

@interface BNReportLossVC ()<UITextFieldDelegate, SelectItemViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UITextField *cardIDTextField;
@property (nonatomic) UITextField *passWordsTextField;
@property (nonatomic) UIButton *okButton;
@property (nonatomic) UIButton *cardIdBtn;
@property (nonatomic) SelectItemView *selectView;

@end

@implementation BNReportLossVC

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self addResponseKeyboardAction];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self removeResponseKeyboardAction];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"一卡通挂失";
    self.view.backgroundColor = UIColor_Gray_BG;

    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scrollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT+1);
    [self.view insertSubview:_scrollView belowSubview:self.sixtyFourPixelsView];
    UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bgViewTaped)];
    tap0.delegate = self;
    [_scrollView addGestureRecognizer:tap0];

    CGFloat originY = self.sixtyFourPixelsView.viewBottomEdge;
    UILabel *alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*BILI_WIDTH, originY, _scrollView.frame.size.width-30*BILI_WIDTH, 35*BILI_WIDTH)];
    alertLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
    alertLabel.textColor = UIColorFromRGB(0x9e9e9e);
    alertLabel.backgroundColor = [UIColor clearColor];
    alertLabel.text = @"挂失后，一卡通将不可用，请谨慎操作！";
    [_scrollView addSubview:alertLabel];
    originY += alertLabel.frame.size.height;
    
    UIView *whiteBGView1 = [[UIView alloc]initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, 90*BILI_WIDTH)];
    whiteBGView1.backgroundColor = [UIColor whiteColor];
    whiteBGView1.layer.borderColor = UIColor_GrayLine.CGColor;
    whiteBGView1.layer.borderWidth = 0.5;
    [_scrollView addSubview:whiteBGView1];
    originY = 0;

    UILabel *textFieldBorder1 = [[UILabel alloc]initWithFrame:CGRectMake(20*BILI_WIDTH, originY, whiteBGView1.frame.size.width-20*BILI_WIDTH, 45*BILI_WIDTH)];
    textFieldBorder1.userInteractionEnabled = YES;
    textFieldBorder1.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
    textFieldBorder1.backgroundColor = [UIColor clearColor];
    textFieldBorder1.text = [shareAppDelegateInstance.boenUserInfo.yktType isEqualToString:@"1"] ? @"学号" : @"一卡通号";
    [whiteBGView1 addSubview:textFieldBorder1];
    
    originY += textFieldBorder1.frame.size.height;

    UIView *infoMidLine = [[UIView alloc] initWithFrame:CGRectMake(20 * BILI_WIDTH, originY, SCREEN_WIDTH - 20*BILI_WIDTH, 0.5)];
    infoMidLine.backgroundColor = UIColor_GrayLine;
    [whiteBGView1 addSubview:infoMidLine];
    originY += infoMidLine.frame.size.height;
    
    UILabel *textFieldBorder2 = [[UILabel alloc]initWithFrame:CGRectMake(20*BILI_WIDTH, originY, whiteBGView1.frame.size.width-20*BILI_WIDTH, 45*BILI_WIDTH)];
    textFieldBorder2.userInteractionEnabled = YES;
    textFieldBorder2.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
    textFieldBorder2.backgroundColor = [UIColor clearColor];
    textFieldBorder2.text = @"密码";
    [whiteBGView1 addSubview:textFieldBorder2];
    
    originY += textFieldBorder2.frame.size.height;

    self.cardIdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cardIdBtn.frame = CGRectMake(textFieldBorder1.frame.size.width-32*BILI_WIDTH, (textFieldBorder1.frame.size.height-30*BILI_WIDTH)/2, 30*BILI_WIDTH, 30*BILI_WIDTH);
    _cardIdBtn.tag = 101;
    [_cardIdBtn setImage:[UIImage imageNamed:@"history_down_arrow_img"] forState:UIControlStateNormal];
    [_cardIdBtn setImage:[UIImage imageNamed:@"history_up_arrow_img"] forState:UIControlStateSelected];
    [_cardIdBtn setContentEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    
    [_cardIdBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [textFieldBorder1 addSubview:_cardIdBtn];

    self.cardIDTextField = [[UITextField alloc]initWithFrame:CGRectMake(60*BILI_WIDTH, 0, whiteBGView1.frame.size.width-90*BILI_WIDTH - 30*BILI_WIDTH, textFieldBorder1.frame.size.height)];
    _cardIDTextField.delegate = self;
    _cardIDTextField.font = [UIFont systemFontOfSize:[BNTools sizeFit:13 six:15 sixPlus:17]];
    _cardIDTextField.textColor = [UIColor blackColor];
    _cardIDTextField.keyboardType = UIKeyboardTypeASCIICapable;
    _cardIDTextField.returnKeyType = UIReturnKeyDone;
    _cardIDTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _cardIDTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [textFieldBorder1 addSubview:_cardIDTextField];
    
    self.passWordsTextField = [[UITextField alloc]initWithFrame:CGRectMake(60*BILI_WIDTH, 0, whiteBGView1.frame.size.width-80*BILI_WIDTH, textFieldBorder2.frame.size.height)];
    _passWordsTextField.font = [UIFont systemFontOfSize:[BNTools sizeFit:13 six:15 sixPlus:17]];
    _passWordsTextField.delegate = self;
    _passWordsTextField.textColor = [UIColor blackColor];
    _passWordsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _passWordsTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _passWordsTextField.returnKeyType = UIReturnKeyDone;
    _passWordsTextField.secureTextEntry = YES;
    _passWordsTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [textFieldBorder2 addSubview:_passWordsTextField];
    
    originY = CGRectGetMaxY(whiteBGView1.frame) + 40*BILI_WIDTH;
    
    self.okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _okButton.frame = CGRectMake(10*BILI_WIDTH, originY, _scrollView.frame.size.width-20*BILI_WIDTH, 40*BILI_WIDTH);
    _okButton.layer.cornerRadius = 2;
    _okButton.layer.masksToBounds = YES;
    UIImage *image1 = [Tools imageWithColor:UIColor_Button_Normal andSize:_okButton.frame.size];
    [_okButton setBackgroundImage:image1 forState:UIControlStateNormal];
    UIImage *image2 = [Tools imageWithColor:UIColor_Button_Disable andSize:_okButton.frame.size];
    [_okButton setBackgroundImage:image2 forState:UIControlStateDisabled];
    [_okButton setTitle:@"确  定" forState:UIControlStateNormal];
    [_okButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    _okButton.titleLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
    _okButton.tag = 102;
    [_okButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_okButton];
    _okButton.enabled = NO;

    self.selectView = [[SelectItemView alloc]initWithRelateView:whiteBGView1 style:SelectItemViewUseStyleSelectOneCardNumber delegate:self];
    [_scrollView addSubview:_selectView];
    _selectView.hidden = YES;

}
- (void)gotoReportLoss
{
//    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"正在挂失，请勿离开"];
    [CardApi oneCardReportLossWithUserid:shareAppDelegateInstance.boenUserInfo.userid stuempno:_cardIDTextField.text schoolID:shareAppDelegateInstance.boenUserInfo.schoolId ykt_password:_passWordsTextField.text success:^(NSDictionary *successData) {
        BNLog(@"挂失-返回结果--%@", successData);
        NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
        
        if ([retCode isEqualToString:kRequestSuccessCode]) {
            [SVProgressHUD dismiss];
            NSDictionary *retData = [successData valueForKey:kRequestReturnData];
            NSString *msgStr = [NSString stringWithFormat:@"卡内余额：%@\n最后一次消费：%@",retData[@"balance"],retData[@"last_consume"]];
            [Tools showMessageWithTitle:@"挂失成功" message:msgStr btnTitle:@"我知道了"];
        }else{
            NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:retMsg];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *strVar = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ((textField == _cardIDTextField && _passWordsTextField.text.length > 0 && strVar.length > 0) || (textField == _passWordsTextField && _cardIDTextField.text.length > 0 && strVar.length > 0)) {
        _okButton.enabled = YES;
    } else {
        _okButton.enabled = NO;
    }
    return YES;
}
- (void)buttonAction:(UIButton *)button
{
    switch (button.tag) {
        case 101: {
            //cardIdBtn 一卡通号选择列表
            if (_selectView.hidden == YES) {
                [_selectView loaDataArray];
            }
            _selectView.hidden = !_selectView.hidden;
            button.selected = !button.selected;
            break;
        }
        case 102: {
            //okBtn 确定
            
            [self gotoReportLoss];
            
            break;
        }
    }
    }
- (void)bgViewTaped
{
    _selectView.hidden = YES;
    _cardIdBtn.selected = NO;
    [_cardIDTextField resignFirstResponder];
    [_passWordsTextField resignFirstResponder];
}
#pragma mark - SelectItemViewDelegate
-(void)selectOneCardNum:(NSString *)scName password:(NSString *)scNum
{
    _cardIDTextField.text = scName;
    _cardIdBtn.selected = !_cardIdBtn.selected;
    [self textFieldDidChange];
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

- (void)textFieldDidChange
{
    if ((_passWordsTextField.text.length > 0 && _cardIDTextField.text.length > 0) ) {
        _okButton.enabled = YES;
    } else {
        _okButton.enabled = NO;
    }
}
#pragma mark - keyboard
- (void)keyboardWillHidden:(NSNotification *)note
{
    [UIView animateWithDuration:.25 animations:^{
        [self.scrollView setContentOffset:CGPointMake(0, 0)];
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }];
}

- (void)keyboardDidShow:(NSNotification *)note
{
    [UIView animateWithDuration:.25 animations:^{
        if (SCREEN_HEIGHT < 500) {
            [self.scrollView setContentOffset:CGPointMake(0, 35*BILI_WIDTH)];
            self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 35*BILI_WIDTH, 0);
        }
       
    }];
}

@end
