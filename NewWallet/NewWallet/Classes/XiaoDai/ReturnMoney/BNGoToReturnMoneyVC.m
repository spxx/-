//
//  BNGoToReturnMoneyVC.m
//  Wallet
//
//  Created by mac on 15/5/5.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNGoToReturnMoneyVC.h"
#import "CardApi.h"
#import "XiaoDaiApi.h"

@interface BNGoToReturnMoneyVC ()<UITextFieldDelegate>

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UILabel *titleLbl;
@property (nonatomic) UILabel *timeLbl;
@property (nonatomic) UIView *redYuQiBGView;
@property (nonatomic) UILabel *timeOutLbl;
@property (nonatomic) UILabel *moneyLbl;
@property (nonatomic) UILabel *remainMoneyLbl;
@property (nonatomic) UIButton *shouldReturnLbl;
@property (nonatomic) UIButton *remainTimeBtn;
@property (nonatomic) UITextField *textfiled;
@property (nonatomic) UIButton *nextbutton;

@end

@implementation BNGoToReturnMoneyVC
static CGFloat whiteViewOriginY;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addResponseKeyboardAction];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeResponseKeyboardAction];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"我要还钱";
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT-self.sixtyFourPixelsView.viewBottomEdge)];
    _scrollView.backgroundColor = UIColor_Gray_BG;
    _scrollView.contentSize = CGSizeMake(0, _scrollView.frame.size.height+1);
    [self.view addSubview:_scrollView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [_scrollView addGestureRecognizer:tap];
    
    whiteViewOriginY = 8*BILI_WIDTH;
    
    UIView *whiteView =[[UIView alloc]initWithFrame:CGRectMake(0, 8*BILI_WIDTH, SCREEN_WIDTH, 122*BILI_WIDTH)];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.borderColor = UIColor_Gray_BG.CGColor;
    whiteView.layer.borderWidth = 0.5;
    [_scrollView addSubview:whiteView];
    
    self.titleLbl = [[UILabel alloc]init];
    _titleLbl.textColor = [UIColor blackColor];
    _titleLbl.font = [UIFont systemFontOfSize:14*BILI_WIDTH];
    _titleLbl.backgroundColor = [UIColor clearColor];
    [whiteView addSubview:_titleLbl];
    _titleLbl.frame = CGRectMake(14*BILI_WIDTH, whiteViewOriginY, SCREEN_WIDTH-(110+2*14)*BILI_WIDTH, 14*BILI_WIDTH);
    _titleLbl.text = @"随时还";

    self.timeLbl = [[UILabel alloc]init];
    _timeLbl.textColor = UIColorFromRGB(0xbcbcbc);
    _timeLbl.font = [UIFont systemFontOfSize:11*BILI_WIDTH];
    _timeLbl.textAlignment = NSTextAlignmentRight;
    _timeLbl.backgroundColor = [UIColor clearColor];
    [whiteView addSubview:_timeLbl];
    _timeLbl.frame = CGRectMake(SCREEN_WIDTH-(110+14)*BILI_WIDTH, whiteViewOriginY+2, 110*BILI_WIDTH, 11*BILI_WIDTH);
    _timeLbl.text = [NSString stringWithFormat:@"%@",[_dict valueNotNullForKey:@"create_time"]];

    whiteViewOriginY += _titleLbl.frame.size.height + 14*BILI_WIDTH;
    
    float overduedAmount = [[_dict valueNotNullForKey:@"overdued_amount"] floatValue];
    
    //    NSString *yuqiStr = @"本期还款已逾期3天，罚息12元!若逾期30天未还款将记入征信系统，影响个人信用记录！请尽快还款！";
    NSString *yuqiStr = [NSString stringWithFormat:@"本期还款已逾期，逾期会产生罚息，你总共需要还款%.2f元，若逾期30天未还款将记入征信系统，影响个人信用记录。",overduedAmount];
    
    if (overduedAmount > 0) {
        CGFloat redTitleHeight = [Tools caleNewsCellHeightWithTitle:yuqiStr font:[UIFont systemFontOfSize:13*BILI_WIDTH] width:SCREEN_WIDTH-2*14*BILI_WIDTH];
        
        UIView *redYuQiBGView =[[UIView alloc]initWithFrame:CGRectMake(0, whiteViewOriginY, SCREEN_WIDTH, 10)];
        redYuQiBGView.backgroundColor = UIColor_RedButtonBGHighLight;
        [whiteView addSubview:redYuQiBGView];
        
        self.timeOutLbl = [[UILabel alloc]initWithFrame:CGRectMake(14*BILI_WIDTH, 7*BILI_WIDTH, SCREEN_WIDTH-2*14*BILI_WIDTH, redTitleHeight)];
        _timeOutLbl.backgroundColor = [UIColor clearColor];
        _timeOutLbl.textColor = [UIColor whiteColor];
        _timeOutLbl.font = [UIFont systemFontOfSize:13*BILI_WIDTH];
        _timeOutLbl.numberOfLines = 0;
        _timeOutLbl.text = yuqiStr;
        [redYuQiBGView addSubview:_timeOutLbl];
        
        _timeOutLbl.frame = CGRectMake(14*BILI_WIDTH, 7*BILI_WIDTH, SCREEN_WIDTH-2*14*BILI_WIDTH, redTitleHeight);
        redYuQiBGView.frame = CGRectMake(0, whiteViewOriginY, SCREEN_WIDTH, 2*7*BILI_WIDTH+redTitleHeight);
        
        whiteViewOriginY += redYuQiBGView.frame.size.height;
    }
    
    whiteViewOriginY += 14*BILI_WIDTH;
    
    UILabel *moneyTitleLbl = [[UILabel alloc]init];
    moneyTitleLbl.textColor = UIColorFromRGB(0xbcbcbc);
    moneyTitleLbl.font = [UIFont systemFontOfSize:13*BILI_WIDTH];
    moneyTitleLbl.backgroundColor = [UIColor clearColor];
    [whiteView addSubview:moneyTitleLbl];
    moneyTitleLbl.text = @"借款金额(元)";
    
    moneyTitleLbl.frame = CGRectMake(14*BILI_WIDTH, whiteViewOriginY, SCREEN_WIDTH/2, 13*BILI_WIDTH);
    
    UILabel *remainMoneyTitleLbl = [[UILabel alloc]init];
    remainMoneyTitleLbl.textColor = UIColorFromRGB(0xbcbcbc);
    remainMoneyTitleLbl.font = [UIFont systemFontOfSize:13*BILI_WIDTH];
    remainMoneyTitleLbl.backgroundColor = [UIColor clearColor];
    [whiteView addSubview:remainMoneyTitleLbl];
    remainMoneyTitleLbl.text = @"余额加利息剩余未还(元)";
    remainMoneyTitleLbl.textAlignment = NSTextAlignmentRight;
    remainMoneyTitleLbl.frame = CGRectMake(SCREEN_WIDTH - (145+14)*BILI_WIDTH, whiteViewOriginY, 145*BILI_WIDTH, 13*BILI_WIDTH);
    
    UIView *redLineView = [[UIView alloc] init];
    redLineView.backgroundColor = UIColor_Gray_BG;
    [whiteView addSubview:redLineView];
    
    redLineView.frame = CGRectMake(SCREEN_WIDTH/2, whiteViewOriginY, 0.5, 47*BILI_WIDTH);
    
    whiteViewOriginY += moneyTitleLbl.frame.size.height + 10*BILI_WIDTH;
    
    self.moneyLbl = [[UILabel alloc]init];
    _moneyLbl.textColor = [UIColor blackColor];
    _moneyLbl.font = [UIFont systemFontOfSize:22*BILI_WIDTH];
    _moneyLbl.backgroundColor = [UIColor clearColor];
    [whiteView addSubview:_moneyLbl];
    _moneyLbl.frame = CGRectMake(14*BILI_WIDTH, whiteViewOriginY, SCREEN_WIDTH/2, 22*BILI_WIDTH);
    _moneyLbl.text = [NSString stringWithFormat:@"%@",[_dict valueNotNullForKey:@"amount"]];
    
    self.remainMoneyLbl = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 115*BILI_WIDTH, whiteViewOriginY, 115*BILI_WIDTH, 22*BILI_WIDTH)];
    _remainMoneyLbl.textColor = UIColor_RedButtonBGNormal;
    _remainMoneyLbl.font = [UIFont systemFontOfSize:22*BILI_WIDTH];
    _remainMoneyLbl.backgroundColor = [UIColor clearColor];
    _remainMoneyLbl.textAlignment = NSTextAlignmentRight;
    [whiteView addSubview:_remainMoneyLbl];
    _remainMoneyLbl.frame = CGRectMake(SCREEN_WIDTH - (115+14)*BILI_WIDTH, whiteViewOriginY, 115*BILI_WIDTH, 22*BILI_WIDTH);
    _remainMoneyLbl.text = [NSString stringWithFormat:@"%@",[_dict valueNotNullForKey:@"current_installment_amount"]];

    whiteViewOriginY += _moneyLbl.frame.size.height + 22*BILI_WIDTH;
    
//    if (@"如果是分期") {
//        self.shouldReturnLbl = [[UIButton alloc]initWithFrame:CGRectMake(0, whiteViewOriginY, SCREEN_WIDTH, 35*BILI_WIDTH)];
//        [_shouldReturnLbl setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        _shouldReturnLbl.titleLabel.font = [UIFont systemFontOfSize:12*BILI_WIDTH];
//        _shouldReturnLbl.backgroundColor = [UIColor whiteColor];
//        _shouldReturnLbl.userInteractionEnabled = NO;
//        [_shouldReturnLbl setTitleEdgeInsets:UIEdgeInsetsMake(0, 10*BILI_WIDTH, 0, 0)];
//        _shouldReturnLbl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        _shouldReturnLbl.layer.borderColor = UIColor_GrayLine.CGColor;
//        _shouldReturnLbl.layer.borderWidth = 0.5;
//        [whiteView addSubview:_shouldReturnLbl];
//        [_shouldReturnLbl setTitle:@"第3期   本期应还100.00元" forState:UIControlStateNormal];
//        whiteViewOriginY += _shouldReturnLbl.frame.size.height;
//    }
    
    
    //还款时间
    self.remainTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_remainTimeBtn setBackgroundColor:UIColor_NavBarBGColor];
    [_remainTimeBtn setTitleColor:UIColorFromRGB(0xbcbcbc) forState:UIControlStateNormal];
    _remainTimeBtn.titleLabel.font = [UIFont systemFontOfSize:11*BILI_WIDTH];
    _remainTimeBtn.userInteractionEnabled = NO;
    [_remainTimeBtn setImage:[UIImage imageNamed:@"ReturnMoney_timeIcon"] forState:UIControlStateNormal];
    [_remainTimeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15*BILI_WIDTH)];
    [_remainTimeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10*BILI_WIDTH)];
    _remainTimeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [whiteView addSubview:_remainTimeBtn];
    _remainTimeBtn.frame = CGRectMake(0, whiteViewOriginY, SCREEN_WIDTH, 40*BILI_WIDTH);
    NSString *next_installment_repay_date = [NSString stringWithFormat:@"还款时间：%@前",[_dict valueNotNullForKey:@"repay_date"]];
    [_remainTimeBtn setTitle:next_installment_repay_date forState:UIControlStateNormal];

    whiteView.frame = CGRectMake(0, 8*BILI_WIDTH, SCREEN_WIDTH, whiteViewOriginY);
    
    whiteViewOriginY += _remainTimeBtn.frame.size.height + 16*BILI_WIDTH;
    
    UIView *whiteView2 =[[UIView alloc]initWithFrame:CGRectMake(0, whiteViewOriginY, SCREEN_WIDTH, 45*BILI_WIDTH)];
    whiteView2.backgroundColor = [UIColor whiteColor];
    whiteView2.layer.borderColor = UIColor_GrayLine.CGColor;
    whiteView2.layer.borderWidth = 0.5;
    [_scrollView addSubview:whiteView2];
    
    UILabel *returnMoneyTitleLbl = [[UILabel alloc]initWithFrame:CGRectMake(14*BILI_WIDTH, 0, 100, whiteView2.frame.size.height)];
    returnMoneyTitleLbl.textColor = [UIColor blackColor];
    returnMoneyTitleLbl.font = [UIFont systemFontOfSize:14*BILI_WIDTH];
    returnMoneyTitleLbl.backgroundColor = [UIColor clearColor];
    [whiteView2 addSubview:returnMoneyTitleLbl];
    returnMoneyTitleLbl.text = @"还款金额";

    self.textfiled = [[UITextField alloc]initWithFrame:CGRectMake(95*BILI_WIDTH, 0, SCREEN_WIDTH-95*BILI_WIDTH-20*BILI_WIDTH, whiteView2.frame.size.height)];
    _textfiled.placeholder = @"请填写金额";
    _textfiled.delegate = self;
    _textfiled.borderStyle = UITextBorderStyleNone;
    _textfiled.keyboardType = UIKeyboardTypeDecimalPad;
    _textfiled.textColor = [UIColor blackColor];
    _textfiled.font = [UIFont systemFontOfSize:14*BILI_WIDTH];
    [_textfiled addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    _textfiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    [whiteView2 addSubview:_textfiled];

    whiteViewOriginY += whiteView2.frame.size.height + 38*BILI_WIDTH;

    self.nextbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextbutton.frame = CGRectMake(10*BILI_WIDTH, whiteViewOriginY, SCREEN_WIDTH - 20*BILI_WIDTH, 40 * BILI_WIDTH);
    [_nextbutton setupLightBlueBtnTitle:@"立即还款" enable:YES];
    [_nextbutton addTarget:self action:@selector(nextBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_nextbutton];
    _nextbutton.enabled = NO;

    whiteViewOriginY += _nextbutton.frame.size.height + 10*BILI_WIDTH;

}
- (void)textFieldValueChanged:(UITextField *)textField
{
    if (textField.text.length > 0) {
        _nextbutton.enabled = YES;
    } else {
        _nextbutton.enabled = NO;
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length == 0) {
        return YES;   //退格删除
    }
    if ([string isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
        return NO;
    }
    NSString *strVar = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:NumAndDecimal] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
    if (![string isEqualToString:filtered]) {
        return NO;    //特殊字符
    }
    if (strVar.length > 11) {
        return NO;
    }
    
    if (string.length != 0) {
        if (textField.text.length == 0 && [string isEqualToString:@"."]) {
            //小数点开头
            return NO;
        }
        if ([textField.text rangeOfString:@"."].location != NSNotFound && [string isEqualToString:@"."]) {
            //输入多个小数点
            return NO;
        }
        NSArray *array = [textField.text componentsSeparatedByString:@"."];
        if (array.count > 1){
            NSString *followStr = array[1];
            if (followStr.length >= 2) {
                return NO;
            }
        }
    }
    return YES;
}

- (void)nextBtnAction
{
    NSString *remainAmountStr = [_dict valueNotNullForKey:@"current_installment_amount"];
    if ([_textfiled.text floatValue] > [remainAmountStr floatValue]) {
        shareAppDelegateInstance.alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"还款金额不能大于应还金额" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [shareAppDelegateInstance.alertView show];
        return;
    }
   
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"请稍候..."];
    [CardApi CardListWithUser:shareAppDelegateInstance.boenUserInfo.userid success:^(NSDictionary *successData) {
        BNLog(@"successData--%@",successData);
        NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
        
        if ([retCode isEqualToString:kRequestSuccessCode]) {
            [SVProgressHUD dismiss];
            [weakSelf removeResponseKeyboardAction];
            
            [self loanCreatOrder];
            
//            NSDictionary *data = [successData valueForKey:kRequestReturnData];
//            if (data[@"binded_cards"]) {
//                NSArray *bindedOnlineArray = data[@"binded_cards"];
//                BNPayViewController *payVC = [[BNPayViewController alloc]init];
//                payVC.moneyStr = _textfiled.text;
//                payVC.cardIdStr = @"";
//                payVC.disPlayMoneyStr = _textfiled.text;
//                payVC.repayRestInstallments = @"";
//                payVC.orderNumber = [_dict valueNotNullForKey:@"order_no"];
//                payVC.payProjectType = PayProjectTypeXiaoDaiReturnMoney;
//                payVC.bindedCardsArray = bindedOnlineArray.count > 0?bindedOnlineArray:nil;
//                payVC.noticeMobilePhone = @"";
//                payVC.bank_name = @"喜付钱包";
//                [weakSelf pushViewController:payVC animated:YES];
//            }
        } else {
            NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:retMsg];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];
}
- (void)tapAction
{
    [_textfiled resignFirstResponder];
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
    NSDictionary *userInfo = [note userInfo];
//    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    if (height > 0) {
        [UIView animateWithDuration:.25 animations:^{
            
            //        if (SCREEN_HEIGHT < 500) {
            CGFloat dddd = (_scrollView.frame.size.height-whiteViewOriginY);
            BNLog(@"dddd--%f",dddd);

            [self.scrollView setContentOffset:CGPointMake(0, height-dddd)];
            self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, height-dddd, 0);
            //        }
            
            
        }];
    }
    
}
- (void)loanCreatOrder
{
    [SVProgressHUD showWithStatus:@"请稍候..."];
    [XiaoDaiApi loanCreatOrderWithProjectOrder_no:[_dict valueNotNullForKey:@"order_no"] repay_amount:_textfiled.text repay_rest_installments:@"" success:^(NSDictionary *returnData) {
        BNLog(@"loanCreatOrderWithProjectOrder_no--%@",returnData);
        NSString *retCode = [returnData valueNotNullForKey:kRequestRetCode];
        
        if ([retCode isEqualToString:kRequestSuccessCode]) {
            [SVProgressHUD dismiss];
            NSDictionary *dataDic = [returnData valueForKey:kRequestReturnData];
            BNPayModel *payModel = [[BNPayModel alloc]init];
            payModel.order_no = [dataDic valueNotNullForKey:@"order_no"];
            payModel.biz_no = [dataDic valueNotNullForKey:@"biz_no"];
            
            [self goToPayCenterWithPayProjectType:PayProjectTypeSchoolPay
                                         payModel:payModel
                                      returnBlockone:^(PayVCJumpType jumpType, id params) {
                                          if (jumpType == PayVCJumpType_PayCompletedBackHomeVC) {
                                              [self.navigationController popToRootViewControllerAnimated:YES];
                                          }
                                      }];
        } else {
            NSString *retMsg = [returnData valueNotNullForKey:kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:retMsg];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];
}

@end
