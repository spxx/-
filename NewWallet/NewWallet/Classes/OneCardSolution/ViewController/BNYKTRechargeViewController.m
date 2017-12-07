//
//  BNYKTRechargeViewController.m
//  Wallet
//
//  Created by mac1 on 15/3/4.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNYKTRechargeViewController.h"

#import "CardApi.h"
#import "BNBillViewController.h"
#import "BNReportLossVC.h"
#import "BNExplainViewController.h"
#import "BNBindYKTViewController.h"
#import "BNPublicHtml5BusinessVC.h"

@interface BNYKTRechargeViewController ()<UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) UITextField *nameTF;
@property (weak, nonatomic) UITextField *yktNumTF;

@property (weak, nonatomic) UITextField *moneyAmountTF;

@property (weak, nonatomic) UITextField *noticePhoneTF;

@property (weak, nonatomic) UIButton *rechargeBtn;

@property (weak, nonatomic) UISwitch *noticeSwitch;

@property (weak, nonatomic) UIView *noticeBGView;



@property (weak, nonatomic) UIView *rechargeBGView;




@property (strong, nonatomic) NSString *busiStatus;//yes维护中

@property (strong, nonatomic) NSString *payStatus;//yes维护中
@property (strong, nonatomic) BNPayModel *payModel;

@end

@implementation BNYKTRechargeViewController
static NSString *cardTypeName;

- (void)setupLoadedView
{
//    self.sixtyFourPixelsView.backgroundColor = [UIColor whiteColor];
    
    self.navigationTitle = @"一卡通充值";
    self.payModel = [[BNPayModel alloc]init];
    
    self.view.backgroundColor = UIColor_Gray_BG;
    cardTypeName = [shareAppDelegateInstance.boenUserInfo.yktType isEqualToString:@"1"] ? @"学号" : @"一卡通号";

    UIScrollView *theScollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT- self.sixtyFourPixelsView.viewBottomEdge)];
    theScollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge + 1);
    [self.view addSubview:theScollView];
    
    CGFloat originY = kSectionHeight;

    NSArray *titleAry = @[@"姓名", cardTypeName, @"金额"];

    UIView *infoBGView = [[UIView alloc] initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, 45 *BILI_WIDTH * titleAry.count)];
    infoBGView.backgroundColor = [UIColor whiteColor];
    _rechargeBGView = infoBGView;
    [theScollView addSubview:infoBGView];

    originY += CGRectGetHeight(infoBGView.frame);
    
    for (int i = 0; i < titleAry.count; i++) {
        UILabel *leftTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, i*45 * BILI_WIDTH, 90, 45 *BILI_WIDTH)];
        leftTitle.textColor = [UIColor blackColor];
        leftTitle.textAlignment = NSTextAlignmentLeft;
        leftTitle.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
        leftTitle.text = titleAry[i];
        
        [infoBGView addSubview:leftTitle];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(100, i*45 * BILI_WIDTH, SCREEN_WIDTH - 110, 45 *BILI_WIDTH)];
        textField.tag = 10+i;
        textField.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
        textField.clearButtonMode = UITextFieldViewModeAlways;
        textField.borderStyle = UITextBorderStyleNone;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.delegate = self;
        [textField addTarget:self action:@selector(infoTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
         if (i == 0) {
             _nameTF = textField;
             _nameTF.keyboardType = UIKeyboardTypeDefault;
             _nameTF.placeholder = @"请输入姓名";
             if (_yktInfo) {
                 NSString *yktNumber = [NSString stringWithFormat:@"%@", [_yktInfo valueNotNullForKey:@"recharge_ykt_name"]];
                 _nameTF.text = yktNumber;
             }
         } else if (i == 1) {
            _yktNumTF = textField;
            _yktNumTF.keyboardType = UIKeyboardTypeASCIICapable;
            _yktNumTF.placeholder = [NSString stringWithFormat:@"请输入%@", cardTypeName];
            if (_yktInfo) {
                NSString *yktNumber = [NSString stringWithFormat:@"%@", [_yktInfo valueNotNullForKey:@"recharge_stuempno"]];
                _yktNumTF.text = yktNumber;
            }
         } else{
             _moneyAmountTF.keyboardType = UIKeyboardTypeDecimalPad;
             _moneyAmountTF = textField;
             _moneyAmountTF.placeholder = @"请输入您要充值的金额";
             _moneyAmountTF.text = @"100";
         }
        [infoBGView addSubview:textField];

        UIView *infoUpLine = [[UIView alloc] initWithFrame:CGRectMake(0, (i+1)*45*BILI_WIDTH, SCREEN_WIDTH, 0.5)];
        infoUpLine.backgroundColor = UIColor_GrayLine;
        [infoBGView addSubview:infoUpLine];

    }

    
//    UIView *noticeBGView = [[UIView alloc] initWithFrame:CGRectMake(0, infoBGView.frame.origin.y + infoBGView.frame.size.height + kSectionHeight, SCREEN_WIDTH, 45 *BILI_WIDTH)];
//    noticeBGView.backgroundColor = [UIColor whiteColor];
//    _noticeBGView = noticeBGView;
//    
//    UIView *noticeUpLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
//    noticeUpLine.backgroundColor = UIColor_GrayLine;
//    
//    UIView *noticeMidLine = [[UIView alloc] initWithFrame:CGRectMake(10, 45 * BILI_WIDTH, SCREEN_WIDTH - 10, 0.5)];
//    noticeMidLine.tag = 2;
//    noticeMidLine.alpha = 0.0;
//    noticeMidLine.hidden = YES;
//    noticeMidLine.backgroundColor = UIColor_GrayLine;
//    
//    UIView *noticeDownLine = [[UIView alloc] initWithFrame:CGRectMake(0, noticeBGView.frame.size.height - 0.5, SCREEN_WIDTH, 0.5)];
//    noticeDownLine.tag = 3;
//    noticeDownLine.backgroundColor = UIColor_GrayLine;
//    
//    UILabel *noticeTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 190, 45 *BILI_WIDTH)];
//    noticeTitle.tag = 4;
//    noticeTitle.textColor = [UIColor blackColor];
//    noticeTitle.textAlignment = NSTextAlignmentLeft;
//    noticeTitle.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
//    noticeTitle.text = @"免费短信通知";
//
//    UILabel *phoneTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 45 *BILI_WIDTH, 90, 45 *BILI_WIDTH)];
//    phoneTitle.tag = 5;
//    phoneTitle.alpha = 0.0;
//    phoneTitle.hidden = YES;
//    phoneTitle.textColor = [UIColor blackColor];
//    phoneTitle.textAlignment = NSTextAlignmentLeft;
//    phoneTitle.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
//    phoneTitle.text = @"手机号";
//    
//    UISwitch *noticeSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 51 - 10, (45 *BILI_WIDTH - 31)/2.0, 51, 31)];
//    noticeSwitch.tag = 6;
//    [noticeSwitch setOn: NO];
//    [noticeSwitch addTarget:self action:@selector(noticeSwithChanged:) forControlEvents:UIControlEventValueChanged];
//    _noticeSwitch = noticeSwitch;
//    
//    UITextField *phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(100, 45 *BILI_WIDTH, SCREEN_WIDTH - 110, 45 *BILI_WIDTH)];
//    phoneTF.placeholder = @"手机号";
//    phoneTF.tag = 7;
//    phoneTF.alpha = 0.0;
//    phoneTF.hidden = YES;
//    phoneTF.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
//    phoneTF.clearButtonMode = UITextFieldViewModeAlways;
//    phoneTF.borderStyle = UITextBorderStyleNone;
//    phoneTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    phoneTF.keyboardType = UIKeyboardTypePhonePad;
//    phoneTF.delegate = self;
//    [phoneTF addTarget:self action:@selector(infoTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
//    _noticePhoneTF = phoneTF;
//    
//    [noticeBGView addSubview:noticeTitle];
//    [noticeBGView addSubview:phoneTitle];
//    [noticeBGView addSubview:noticeSwitch];
//    [noticeBGView addSubview:phoneTF];
//    
//    [noticeBGView addSubview:noticeUpLine];
//    [noticeBGView addSubview:noticeMidLine];
//    [noticeBGView addSubview:noticeDownLine];
//    [theScollView addSubview:noticeBGView];
    
    originY += 50*BILI_WIDTH;
    UIButton *nextStepButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextStepButton.frame = CGRectMake(10, originY, SCREEN_WIDTH - 20, 40 * BILI_WIDTH);
    [nextStepButton setupTitle:@"确定" enable:YES];
    [nextStepButton addTarget:self action:@selector(rechargeYKTAction:) forControlEvents:UIControlEventTouchUpInside];
    _rechargeBtn = nextStepButton;
    [theScollView addSubview:nextStepButton];
    

    UITapGestureRecognizer *cancelKeyboardTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelKeyboard:)];
    cancelKeyboardTap.delegate = self;
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


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self refreshOkBtnEnableStatus];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self addResponseKeyboardAction];
}

#pragma mark - text field
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (void)infoTextFieldChanged:(UITextField *)tf
{
    NSString *str = tf.text;
    if (tf.tag == 12) {
        if (!isRechargeTest && ([str isEqualToString:@"0"] || [str isEqualToString:@"."])) {
            str = @"";
        } else {
            if (str.length > 0){
                str = [[str componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet]] componentsJoinedByString:@""];
            }
            NSString *findStr = @".";
            NSRange foundObj=[str rangeOfString:findStr options:NSCaseInsensitiveSearch];
            if(foundObj.length>0) {
                if (str.length > foundObj.location + 3) {
                    str = [str substringWithRange:NSMakeRange(0, foundObj.location + 3)];
                }
            }
            NSInteger pointCount = [[str componentsSeparatedByString:@"."] count]-1;
            //pointCount为str中“.“的个数。
            if(pointCount > 1) {
                str = [str substringWithRange:NSMakeRange(0, str.length-1)];
            }
        }
        tf.text = str;
    }
 
    if (_noticeSwitch.isOn == YES) {
        if (tf.tag == 7) {
            
            if ([str hasPrefix:@"1"] == YES) {
                if (str.length > 0) {
                    str = [[str componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""];
                }
                if (str.length > 11) {
                    str = [str substringWithRange:NSMakeRange(0, 11)];
                }
                tf.text = str;
            }else{
                tf.text = nil;
                [SVProgressHUD showErrorWithStatus:@"请输入1开头的手机号"];
            }
        }
        
        if (_nameTF.text.length > 0 && _yktNumTF.text.length > 0 && _moneyAmountTF.text.length > 0 && _noticePhoneTF.text.length == 11) {
            _rechargeBtn.enabled = YES;
        }else{
            _rechargeBtn.enabled = NO;
        }
    }else{
        if (_nameTF.text.length > 0 && _yktNumTF.text.length > 0 && _moneyAmountTF.text.length > 0 ) {
            _rechargeBtn.enabled = YES;
        }else{
            _rechargeBtn.enabled = NO;
        }

    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length == 0) {
        return YES;   //退格删除
    }
    if (textField.tag == 11) {
        NSRange range = [@"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLIMNOPQRSTUVWXYZ.-_=+@$#%*~|[]^" rangeOfString:string];
        if (range.length > 0) {
            return YES;
        } else {
            return NO;
        }
    }
    if (textField.tag == 12) {
        NSString *strVar = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if ([strVar floatValue] > 9999) {
            //充值金额只能小于9999
            return NO;
        }
    }
   
    
    return YES;
}

-(void)rechargeYKTAction:(UIButton *)btn
{
    [self.view endEditing:YES];
    if (_yktNumTF.text.length <= 0)
    {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"请输入%@", cardTypeName]];
        return;
    }
    if (_noticeSwitch.isOn == YES && _noticePhoneTF.text.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确地手机号码"];
        return;
    }
    
    CGFloat amount = [_moneyAmountTF.text doubleValue];
    
        if (amount > _transLimite) {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"单笔最多充值%li元", (long)_transLimite]];
        }
        else if(amount < YKTRechargeMiniAmount){
            [SVProgressHUD showErrorWithStatus:@"单笔充值金额必须大于10元"];
        }
        else{
            //一卡通状态
            //确认支付
            NSString *schoolID = shareAppDelegateInstance.boenUserInfo.schoolId;
            if (_yktInfo) {
                schoolID = [NSString stringWithFormat:@"%@", [_yktInfo valueNotNullForKey:@"recharge_school_id"]];
            }
            [SVProgressHUD showWithStatus:@"请稍候..."];
            [NewCardApi newPay_oneCardCreateOrderWithYkt_name:_nameTF.text
                                                       student_no:_yktNumTF.text
                                                        school_id:schoolID
                                                  recharge_amount:_moneyAmountTF.text
                                                       pay_amount:_moneyAmountTF.text
                                                           coupon:@""
                                                   receive_mobile:nil
                                                          success:^(NSDictionary *successData) {
                                                              BNLog(@"创建一卡通充值订单 --%@", successData);
                                                              NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                                                              
                                                              if ([retCode isEqualToString:kRequestNewSuccessCode]) {
                                                                  NSDictionary *dataDict = [successData valueNotNullForKey:kRequestReturnData];
                                                                  
                                                                  _payModel.order_no = [dataDict valueNotNullForKey:@"order_no"];
                                                                  _payModel.biz_no = [dataDict valueNotNullForKey:@"biz_no"];
                                                                  _payModel.goodsNumber = _yktNumTF.text;

                                                                  [self goToPayCenterWithPayProjectType:PayProjectTypeOneCard
                                                                                               payModel:_payModel
                                                                                            returnBlockone:^(PayVCJumpType jumpType, id params) {
                                                                                                if (jumpType == PayVCJumpType_PayCompletedBackHomeVC) {
                                                                                                    [self.navigationController popToRootViewControllerAnimated:YES];
                                                                                                }
                                                                                            }];
                                                                  
                                                              }else{
                                                                  NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                                                  [SVProgressHUD showErrorWithStatus:retMsg];
                                                              }
                                                          } failure:^(NSError *error) {
                                                              [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                                          }];

        }

    
}

- (void)noticeSwithChanged: (UISwitch *)theSwitch
{
    _noticePhoneTF.text = nil;
    if (theSwitch.isOn) {
        [self selectedSMSNotice];
    }else{
        [self unselectedSMSNotice];
    }
    [self refreshOkBtnEnableStatus];
}

- (void)selectedSMSNotice
{
    UILabel *phoneLab = (UILabel *)[_noticeBGView viewWithTag:5];
    UIView *midLine = [_noticeBGView viewWithTag:2];
    UIView *downLine = [_noticeBGView viewWithTag:3];
    CGRect bgRect = _noticeBGView.frame;
    
    __weak typeof(self) weakSelf = self;
    
    midLine.hidden = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.noticeBGView.frame = CGRectMake(bgRect.origin.x, bgRect.origin.y, SCREEN_WIDTH, 45 * BILI_WIDTH * 2);
        midLine.alpha = 1;
        downLine.frame = CGRectMake(bgRect.origin.x, weakSelf.noticeBGView.frame.size.height - 1.0, SCREEN_WIDTH, 1);
        weakSelf.rechargeBtn.frame = CGRectMake(10, weakSelf.noticeBGView.frame.origin.y + weakSelf.noticeBGView.frame.size.height + 40 * BILI_WIDTH, SCREEN_WIDTH - 20, 40 * BILI_WIDTH);
    } completion:^(BOOL finished) {
        phoneLab.hidden = NO;
        weakSelf.noticePhoneTF.hidden = NO;
        phoneLab.alpha = 1;
        weakSelf.noticePhoneTF.alpha = 1;
    }];
}

- (void)unselectedSMSNotice
{
    UILabel *phoneLab = (UILabel *)[_noticeBGView viewWithTag:5];
    
    UIView *midLine = [_noticeBGView viewWithTag:2];
    UIView *downLine = [_noticeBGView viewWithTag:3];
    CGRect bgRect = _noticeBGView.frame;
    
    phoneLab.alpha = 0.0;
    _noticePhoneTF.hidden = 0.0;
    _noticePhoneTF.text = nil;
    phoneLab.hidden = YES;
    _noticePhoneTF.hidden = YES;
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.noticeBGView.frame = CGRectMake(bgRect.origin.x, bgRect.origin.y, SCREEN_WIDTH, 45 * BILI_WIDTH);
        midLine.alpha = 0.0;
        downLine.frame = CGRectMake(bgRect.origin.x, weakSelf.noticeBGView.frame.size.height - 1.0, SCREEN_WIDTH, 1);
        weakSelf.rechargeBtn.frame = CGRectMake(10, weakSelf.noticeBGView.frame.origin.y + weakSelf.noticeBGView.frame.size.height + 40 * BILI_WIDTH, SCREEN_WIDTH - 20, 40 * BILI_WIDTH);
    } completion:^(BOOL finished) {
        midLine.hidden = YES;
    }];

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

- (void)refreshOkBtnEnableStatus
{
    if (_noticeSwitch.isOn == YES) {
        
        if (_nameTF.text.length > 0 && _yktNumTF.text.length > 0 && _moneyAmountTF.text.length > 0 && _noticePhoneTF.text.length == 11) {
            _rechargeBtn.enabled = YES;
        }else{
            _rechargeBtn.enabled = NO;
        }
    }else{
        if (_nameTF.text.length > 0 && _yktNumTF.text.length > 0 && _moneyAmountTF.text.length > 0) {
            _rechargeBtn.enabled = YES;
        }else{
            _rechargeBtn.enabled = NO;
        }
        
    }

}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //去绑定一卡通
        //绑定一卡通，改为H5页面
        BNPublicHtml5BusinessVC *bindOneCardVCVC = [[BNPublicHtml5BusinessVC alloc] init];
        bindOneCardVCVC.businessType = Html5BusinessType_NativeBusiness;
        bindOneCardVCVC.url = kBindStumpH5Url;
        [self pushViewController:bindOneCardVCVC animated:YES];

//        BNBindYKTViewController *bindYKTVC = [[BNBindYKTViewController alloc] init];
//        bindYKTVC.yktType = shareAppDelegateInstance.boenUserInfo.yktType;
//        [self pushViewController:bindYKTVC animated:YES];
        
    }
}
@end
