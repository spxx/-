//
//  BNVeinInfoViewController.m
//  Wallet
//
//  Created by mac on 2017/6/5.
//  Copyright © 2017年 BNDK. All rights reserved.
//

#import "BNVeinInfoViewController.h"
#import "UnionPayApi.h"
#import "BNPublicHtml5BusinessVC.h"
#import "PesonCenterApi.h"
#import "BannerApi.h"
#import "OpenCenterApi.h"
#import "BNVeinCreditOrderListVC.h"
#import "BNCommonWebViewController.h"

@interface BNVeinInfoViewController ()

@property (nonatomic) UIButton *memberKindBtn;
@property (nonatomic) UIButton *bankCardBtn;
@property (nonatomic) UIButton *veinPayBtn;
@property (nonatomic) UIButton *okButton;

@property (nonatomic, strong) AFHTTPRequestOperation *lastBankCardCountOp;
@property (nonatomic) NSArray *bankCardList;
@property (nonatomic) BOOL veinPayOpened;
@property (nonatomic) NSString *notOpenVeinPayMessage;  //条件都满足，但是接口返回未开通静脉支付，应该是后台强制关闭的，应该有原因信息。
@property (nonatomic, weak) UILabel *availableMoneyLbl;//可用信用金
@property (nonatomic, weak) UILabel *usedMoneyLbl;    //已用信用金
@property (nonatomic) NSString *repayAmount;  //应还款额
@property (nonatomic) NSInteger is_repay;     //可还款
@end

@implementation BNVeinInfoViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:NSClassFromString(@"BNPublicHtml5BusinessVC")]) {
            NSMutableArray *array = [self.navigationController.viewControllers mutableCopy];
            [array removeObject:vc];
            self.navigationController.viewControllers = array;
        }
    }
    [self getBankCardList];

    [self performSelector:@selector(getVeinCreditAmout) withObject:nil afterDelay:0.2];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.lastBankCardCountOp.isCancelled == NO) {
        BNLog(@"cancel__getCardCount");
        [self.lastBankCardCountOp cancel];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"静脉信息";
    self.view.backgroundColor = UIColor_Gray_BG;
    self.bankCardList = [[NSArray alloc]init];
    _is_repay = 0;
    _repayAmount = @"";
    
    if ([shareAppDelegateInstance.boenUserInfo.user_type integerValue] == 1 || [shareAppDelegateInstance.boenUserInfo.user_type integerValue] == 2) {
        //校内人员-才有信用金账单
        UIButton *rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
        rightItem.frame = CGRectMake(SCREEN_WIDTH - 100*NEW_BILI, 0, 100*NEW_BILI, 44);
        [rightItem setTitle:@"信用金账单" forState:UIControlStateNormal];
        [rightItem setTitleColor:UIColor_Blue_BarItemText forState:UIControlStateNormal];
        rightItem.titleLabel.font = [UIFont systemFontOfSize:14*NEW_BILI];
        rightItem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [rightItem setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 12*NEW_BILI)];
        [rightItem addTarget:self action:@selector(rightItemBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.customNavigationBar addSubview:rightItem];
        
    }

    
    [self setupLoadedView];
    
    UIView *topWhiteBGView = [[UIView alloc]initWithFrame:CGRectMake(0, -1000, SCREEN_WIDTH, 1000+300*NEW_BILI)];
    topWhiteBGView.backgroundColor = [UIColor whiteColor];
    [self.baseScrollView addSubview:topWhiteBGView];
    
    CGFloat originY = 20*NEW_BILI;
    
    UIImageView *blueBGView = [[UIImageView alloc]initWithFrame:CGRectMake(15*NEW_BILI, originY, SCREEN_WIDTH-2*15*NEW_BILI, 60*NEW_BILI)];
    UIImage *bgImg = [[UIImage imageNamed:@"BNVeinInfoVC_BlueBGImage"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 0, 2, 0)];
    blueBGView.image = bgImg;
    blueBGView.layer.cornerRadius = 10*NEW_BILI;
    blueBGView.layer.masksToBounds = YES;
    [self.baseScrollView addSubview:blueBGView];
    CALayer *subLayer=[CALayer layer];
    CGRect fixframe=blueBGView.layer.frame;
    subLayer.frame=fixframe;
    subLayer.cornerRadius=10*NEW_BILI;
    subLayer.backgroundColor=[UIColorFromRGB(0x4580ca) colorWithAlphaComponent:1].CGColor;
    subLayer.masksToBounds=NO;
    subLayer.shadowColor=UIColorFromRGB(0x4580ca).CGColor;
    subLayer.shadowOffset=CGSizeMake(0,3);
    subLayer.shadowOpacity=0.5;
    subLayer.shadowRadius=6;
    [self.baseScrollView.layer insertSublayer:subLayer below:blueBGView.layer];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(blueBGViewTaped)];
    [blueBGView addGestureRecognizer:tap];
    blueBGView.userInteractionEnabled = YES;
    
    UILabel *nameLbl = [[UILabel alloc]initWithFrame:CGRectMake(28*NEW_BILI, 0, 220*NEW_BILI, 60*NEW_BILI)];
    nameLbl.font = [UIFont boldSystemFontOfSize:23*NEW_BILI];
    nameLbl.textColor = [UIColor whiteColor];
    nameLbl.textAlignment = NSTextAlignmentLeft;
    nameLbl.numberOfLines = 2;
    nameLbl.contentMode = UIViewContentModeCenter;
    [blueBGView addSubview:nameLbl];
    nameLbl.text = [NSString stringWithFormat:@"%@", shareAppDelegateInstance.boenUserInfo.name];

    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(blueBGView.frame.size.width-(10+31)*NEW_BILI, (blueBGView.frame.size.height-31*NEW_BILI)/2, 31*NEW_BILI, 31*NEW_BILI)];
    icon.image = [UIImage imageNamed:@"BNVeinInfoVC_Icon"];
    [blueBGView addSubview:icon];

    UILabel *bindedLbl = [[UILabel alloc]initWithFrame:CGRectMake(icon.frame.origin.x-50*NEW_BILI, (blueBGView.frame.size.height-31*NEW_BILI)/2, 45*NEW_BILI, 31*NEW_BILI)];
    bindedLbl.font = [UIFont systemFontOfSize:11*NEW_BILI];
    bindedLbl.textColor = [UIColor whiteColor];
    bindedLbl.textAlignment = NSTextAlignmentRight;
    bindedLbl.contentMode = UIViewContentModeCenter;
    [blueBGView addSubview:bindedLbl];
    bindedLbl.text = @"业务说明";
    
    originY = 125*NEW_BILI;
    
    UILabel *leftLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH/2, 15*NEW_BILI)];
    leftLbl.font = [UIFont systemFontOfSize:14*NEW_BILI];
    leftLbl.textColor = UIColor_Black_Text;
    leftLbl.textAlignment = NSTextAlignmentCenter;
    leftLbl.contentMode = UIViewContentModeCenter;
    [self.baseScrollView addSubview:leftLbl];
    leftLbl.text = @"可用信用金";

    UILabel *rightLbl = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, originY, SCREEN_WIDTH/2, 15*NEW_BILI)];
    rightLbl.font = [UIFont systemFontOfSize:14*NEW_BILI];
    rightLbl.textColor = UIColor_Black_Text;
    rightLbl.textAlignment = NSTextAlignmentCenter;
    rightLbl.contentMode = UIViewContentModeCenter;
    [self.baseScrollView addSubview:rightLbl];
    rightLbl.text = @"已用信用金";
    
    originY += leftLbl.frame.size.height;
    
    UIView *line0 = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, originY, 1, 40*NEW_BILI)];
    line0.backgroundColor = UIColor_GrayLine;
    [self.baseScrollView addSubview:line0];
    
     originY += 15*NEW_BILI;

    UILabel *availableMoneyLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH/2, 36*NEW_BILI)];
    availableMoneyLbl.font = [UIFont boldSystemFontOfSize:34*NEW_BILI];
    availableMoneyLbl.textColor = UIColor_Black_Text;
    availableMoneyLbl.textAlignment = NSTextAlignmentCenter;
    availableMoneyLbl.contentMode = UIViewContentModeCenter;
    [self.baseScrollView addSubview:availableMoneyLbl];
    availableMoneyLbl.text = @"_ _";
    self.availableMoneyLbl = availableMoneyLbl;
    
    UILabel *usedMoneyLbl = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, originY, SCREEN_WIDTH/2, 36*NEW_BILI)];
    usedMoneyLbl.font = [UIFont boldSystemFontOfSize:34*NEW_BILI];
    usedMoneyLbl.textColor = UIColor_Black_Text;
    usedMoneyLbl.textAlignment = NSTextAlignmentCenter;
    usedMoneyLbl.contentMode = UIViewContentModeCenter;
    [self.baseScrollView addSubview:usedMoneyLbl];
    usedMoneyLbl.text = @"_ _";
    self.usedMoneyLbl = usedMoneyLbl;

    originY += availableMoneyLbl.frame.size.height + 57*NEW_BILI;

    CGFloat cellHeight = 50*NEW_BILI;
    NSArray *nameList = @[@"关联银行卡", @"会员属性", @"静脉支付",];

    UIView *whiteBGView = [[UIView alloc]initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, nameList.count * cellHeight + 10*NEW_BILI)];
    whiteBGView.backgroundColor = [UIColor whiteColor];
    [self.baseScrollView addSubview:whiteBGView];

    for (int i = 0; i < nameList.count; i++) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake((i==1 ? 0 : 15*NEW_BILI), i * cellHeight+(i==2 ? 10*NEW_BILI : 0), SCREEN_WIDTH - 2*(i==1 ? 0 : 15*NEW_BILI), 0.5+(i==1 ? 10*NEW_BILI : 0))];
        line.backgroundColor = UIColor_GrayLine;
        [whiteBGView addSubview:line];

        UILabel *nameLbl = [[UILabel alloc]initWithFrame:CGRectMake(15*NEW_BILI, i * cellHeight +(i>0 ? 10*NEW_BILI : 0), 120*NEW_BILI, cellHeight)];
        nameLbl.font = [UIFont systemFontOfSize:14*NEW_BILI];
        nameLbl.textColor = UIColor_Black_Text;
        nameLbl.textAlignment = NSTextAlignmentLeft;
        [whiteBGView addSubview:nameLbl];
        nameLbl.text = [NSString stringWithFormat:@"%@", nameList[i]];

        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(SCREEN_WIDTH-(15+250)*NEW_BILI, i * cellHeight +(i>0 ? 10*NEW_BILI : 0), 250*NEW_BILI, cellHeight);
        rightBtn.tag = 100 + i;
        rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        rightBtn.titleLabel.numberOfLines = 2;
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:14*NEW_BILI];
        [rightBtn setTitleColor:UIColorFromRGB(0x90a4ae) forState:UIControlStateDisabled];
        [rightBtn setTitleColor:UIColorFromRGB(0xff9124) forState:UIControlStateNormal];
        [whiteBGView addSubview:rightBtn];
        [rightBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn setTitle:@"绑定银行卡开通默认还款" forState:UIControlStateNormal];

        if (i == 0)  {
            self.bankCardBtn = rightBtn;
        } else if (i == 1){
            [rightBtn setTitle:shareAppDelegateInstance.boenUserInfo.user_type_name forState:UIControlStateNormal];
            self.memberKindBtn = rightBtn;
            _memberKindBtn.enabled = NO;
        } else if (i == 2) {
            self.veinPayBtn = rightBtn;
            _veinPayBtn.enabled = NO;
            [_veinPayBtn setTitle:@"已开通" forState:UIControlStateDisabled];
            [_veinPayBtn setTitle:@"未开通" forState:UIControlStateNormal];
        }
        
    }
    originY += whiteBGView.frame.size.height + 50*NEW_BILI;
    
    UILabel *bottomLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, 50*NEW_BILI)];
    [self.baseScrollView addSubview:bottomLbl];
    bottomLbl.text = @"温馨提示\n静脉支付优先使用信用金，绑定银行卡开通默认还款";
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = 6;
    NSDictionary *attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:14],
                                  NSParagraphStyleAttributeName:paragraphStyle};
    bottomLbl.attributedText = [[NSAttributedString alloc]initWithString:bottomLbl.text attributes:attributes];
    bottomLbl.font = [UIFont systemFontOfSize:11*NEW_BILI];
    bottomLbl.textColor = UIColorFromRGB(0xb5bfc4);
    bottomLbl.textAlignment = NSTextAlignmentCenter;
    bottomLbl.numberOfLines = 2;
    
    originY += bottomLbl.frame.size.height + 10*NEW_BILI;

    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    okButton.frame = CGRectMake(30, originY, SCREEN_WIDTH - 2*30, 30 * BILI_WIDTH);
    [okButton setupTitle:@"立即还款" enable:NO];
    [okButton addTarget:self action:@selector(okButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:okButton];
    self.okButton = okButton;
    
    originY += okButton.frame.size.height + 10*NEW_BILI;

    if (originY > self.baseScrollView.heightValue) {
        self.baseScrollView.contentSize = CGSizeMake(0, originY);
    }
    [self checkVeinCreditMoneyisRepayAble];

}

- (void)buttonAction:(UIButton *)button
{
 if (button.tag == 100) {
        //去绑定银行卡,用银联H5页面。
        __weak typeof(self) weakSelf = self;
        [SVProgressHUD showWithStatus:@"请稍候..."];
        [UnionPayApi getUnionBankListURLSucceed:^(NSDictionary *successData) {
            BNLog(@"getUnionBankListURLSucceed--%@", successData);
            NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
            if ([retCode isEqualToString:kRequestNewSuccessCode]) {
                [SVProgressHUD dismiss];
                
                NSDictionary *retData = [successData valueForKey:kRequestReturnData];
                BNPublicHtml5BusinessVC *bankVC = [[BNPublicHtml5BusinessVC alloc] init];
                bankVC.businessType = Html5BusinessType_NativeBusiness;
                bankVC.hideNavigationbar = YES;
                bankVC.url = [NSString stringWithFormat:@"%@", [retData valueWithNoDataForKey:@"bank_list_url"]];
                [weakSelf pushViewController:bankVC animated:YES];
                
            }else{
                NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                [SVProgressHUD showErrorWithStatus:retMsg];
            }
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
        }];

    }
    else if (button.tag == 103){
        //开通静脉支付
        if (_bankCardList.count > 0 && (_veinPayOpened == NO)) {
            shareAppDelegateInstance.alertView = [[UIAlertView alloc] initWithTitle:_notOpenVeinPayMessage message:@"" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            shareAppDelegateInstance.alertView.tag = 103;
            [shareAppDelegateInstance.alertView show];
        } else {
            shareAppDelegateInstance.alertView = [[UIAlertView alloc] initWithTitle:@"开通静脉支付需先绑定银行卡\n现在去绑定银行卡吗？" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            shareAppDelegateInstance.alertView.tag = 103;
            [shareAppDelegateInstance.alertView show];
        }
    }
    
}
- (void)checkIfOpenedVeinPay
{
//    [SVProgressHUD showWithStatus:@"请稍候..."];
    [NewPayOrderCenterApi veinInfo_checkIfOpenedVeinPayWithSuccess:^(NSDictionary *returnData) {
        BNLog(@"查询是否已开通静脉支付--->>>>%@",returnData);
        /*返回值："is_enabled_vein_pay": 0 // 0-未开通 1-已开通*/

        if ([[returnData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestNewSuccessCode]) {
            [SVProgressHUD dismiss];
            NSDictionary *datas = [returnData valueWithNoDataForKey:kRequestReturnData];
            NSString *msg = [returnData valueNotNullForKey:kRequestRetMessage];
            NSString *is_enabled_vein_pay = [datas valueWithNoDataForKey:@"is_enabled_vein_pay"];
            if ([is_enabled_vein_pay integerValue] == 1) {
                _veinPayOpened = YES;
            } else {
                _veinPayOpened = NO;
            }
            if (_bankCardList.count > 0 && (_veinPayOpened == NO)) {
                _notOpenVeinPayMessage = msg;
            }
            [self refreshUIWithData];
        }else{
            NSString *msg = [returnData valueNotNullForKey:kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:msg];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];
}
- (void)getBankCardList
{
    if (self.lastBankCardCountOp.isCancelled == NO) {
        BNLog(@"cancel__getCardCount");
        [self.lastBankCardCountOp cancel];
    }
    // 用户绑卡张数
    [SVProgressHUD showWithStatus:@"请稍候..."];
    self.lastBankCardCountOp = [PesonCenterApi get_bind_card_countWithCount_only:@"0" success:^(NSDictionary *returnData) {
        BNLog(@"绑卡列表--->>>>%@",returnData);
        if ([[returnData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
            [SVProgressHUD dismiss];
            NSDictionary *datas = [returnData valueWithNoDataForKey:kRequestReturnData];
            NSArray *bankList = [datas valueWithNoDataForKey:@"binded_cards"];
            if (bankList && bankList.count > 0) {
                _bankCardList = bankList;

                [self openedVeinPay];
            }else {
                [self checkIfOpenedVeinPay];
            }
            [self refreshUIWithData];
        }else{
            NSString *msg = [returnData valueNotNullForKey:kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:msg];
            [self checkIfOpenedVeinPay];
        }
        
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
        [self checkIfOpenedVeinPay];
    }];

}
- (void)refreshUIWithData
{
    if (_bankCardList.count > 0) {
        NSDictionary *bankDict = _bankCardList[0];
        NSString *bankName = [NSString stringWithFormat:@"%@", [bankDict valueWithNoDataForKey:@"bankName"]];
        NSString *bankNo = [NSString stringWithFormat:@"%@", [bankDict valueWithNoDataForKey:@"bankCardNo"]];
        if (bankNo.length >= 4) {
            bankNo = [bankNo substringFromIndex:bankNo.length-4];
        }
        [_bankCardBtn setTitle:[NSString stringWithFormat:@"%@  %@",bankName, bankNo] forState:UIControlStateNormal];
    } else {
        [_bankCardBtn setTitle:@"绑定银行卡开通默认还款" forState:UIControlStateNormal];
    }
    if (_veinPayOpened == YES) {
        _veinPayBtn.enabled = NO;
    } else {
        _veinPayBtn.enabled = YES;
    }
    
//    [_memberKindBtn setTitle:[NSString stringWithFormat:@"%@", shareAppDelegateInstance.boenUserInfo.stuempno] forState:UIControlStateDisabled];

    
}
- (void)openedVeinPay
{
    //开通静脉支付-调一下接口，让后台知道就行了。
    [NewPayOrderCenterApi veinInfo_openVeinPayWithStatus:@"1"
                                                 success:^(NSDictionary *returnData) {
                                                     BNLog(@"开通静脉支付--->>>>%@",returnData);
                                                     [self checkIfOpenedVeinPay];

        } failure:^(NSError *error) {
            [self checkIfOpenedVeinPay];
    }];
}

#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 103) {
        if (buttonIndex == 1) {
            //绑定银行卡
            UIButton *button = [[UIButton alloc]init];
            button.tag = 102;
            [self buttonAction:button];
        }
    }
    
}
- (void)okButtonAction
{
    [SVProgressHUD showWithStatus:@"请稍候..."];
    [OpenCenterApi refundVeinCreditMoneyWithUserid:shareAppDelegateInstance.boenUserInfo.userid
                                      repay_amount:_repayAmount
                                           success:^(NSDictionary *successData) {
        BNLog(@"信用金-还款接口--%@", successData);
        NSString *retCode = [NSString stringWithFormat:@"%@",[successData valueNotNullForKey:kRequestRetCode]];
        NSString *resultcode = [NSString stringWithFormat:@"%@",[successData valueNotNullForKey:@"resultcode"]];

        if ([retCode isEqualToString:kRequestNewSuccessCode]) {
            if ([resultcode isEqualToString:kRequestNewSuccessCode]) {
                NSDictionary *dataDict = [successData valueNotNullForKey:kRequestReturnData];
                if ([dataDict isKindOfClass:[NSDictionary class]]) {
                    NSString *order_no = [NSString stringWithFormat:@"%@", [dataDict valueWithNoDataForKey:@"order_no"]];//喜付支付订单号
                    NSString *biz_no = [NSString stringWithFormat:@"%@", [dataDict valueWithNoDataForKey:@"biz_no"]];//还款单号
                    //支付
                    BNPayModel *payModel = [[BNPayModel alloc]init];
                    payModel.order_no = order_no;
                    payModel.biz_no = biz_no;
                    [self goToPayCenterWithPayProjectType:PayProjectTypeSchoolPay
                                                 payModel:payModel
                                              returnBlockone:^(PayVCJumpType jumpType, id params) {
                                                  for (UIViewController *vc in self.navigationController.viewControllers) {
                                                      if ([vc isKindOfClass:NSClassFromString(@"BNPublicHtml5BusinessVC")]) {
                                                          NSMutableArray *array = [self.navigationController.viewControllers mutableCopy];
                                                          [array removeObject:vc]; 
                                                          self.navigationController.viewControllers = array;
                                                      }
                                                  }

                                                  [self checkVeinCreditMoneyisRepayAble];
                                                  
                                              }];
                    
                    
                    
                } else{
                    NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                    [SVProgressHUD showErrorWithStatus:retMsg];
                }

            } else{
                NSString *retMsg = [successData valueNotNullForKey:@"resultmsg"];
                [SVProgressHUD showErrorWithStatus:retMsg];
            }
            
        } else{
            NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:retMsg];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];
}

//静脉信用金-查询是否可还款接口
- (void)checkVeinCreditMoneyisRepayAble
{
    [SVProgressHUD showWithStatus:@"请稍候..."];
    [OpenCenterApi checkVeinCreditMoneyisRepayAbleWithUserid:shareAppDelegateInstance.boenUserInfo.userid
                                           success:^(NSDictionary *successData) {
                                               BNLog(@"静脉信用金-查询是否可还款接口--%@", successData);
                                               NSString *retCode = [NSString stringWithFormat:@"%@",[successData valueNotNullForKey:kRequestRetCode]];
                                               NSString *resultcode = [NSString stringWithFormat:@"%@",[successData valueNotNullForKey:@"resultcode"]];

                                               if ([retCode isEqualToString:kRequestNewSuccessCode]) {
                                                   if ([resultcode isEqualToString:kRequestNewSuccessCode]) {
                                                       [SVProgressHUD dismiss];
                                                       NSDictionary *dataDict = [successData valueNotNullForKey:kRequestReturnData];
                                                       if ([dataDict isKindOfClass:[NSDictionary class]]) {
                                                           NSString *is_repay = [NSString stringWithFormat:@"%@", [dataDict valueWithNoDataForKey:@"is_repay"]];
                                                           NSString *repay_amount = [NSString stringWithFormat:@"%@", [dataDict valueWithNoDataForKey:@"repay_amount"]];
                                                           if ([is_repay integerValue] == 1) {
                                                               //可还款
                                                               _is_repay = [is_repay integerValue];
                                                               _repayAmount = repay_amount;
                                                           } else {
                                                               //不可还款，一般是正在还款中。
                                                               _is_repay = [is_repay integerValue];
                                                           }
                                                           [self refreshOKButton];
                                                       }
                                                   }else{
                                                       NSString *retMsg = [successData valueNotNullForKey:@"resultmsg"];
                                                       [SVProgressHUD showErrorWithStatus:retMsg];
                                                   }
                                               }else{
                                                   NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                                   [SVProgressHUD showErrorWithStatus:retMsg];
                                               }
                                           } failure:^(NSError *error) {
                                               [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                           }];
}
//获取静脉信用金额度
- (void)getVeinCreditAmout
{
    __weak typeof(self) weekSelf = self;
    [NewPayOrderCenterApi veinInfo_getVeinCreditAmoutWithXifuID:shareAppDelegateInstance.boenUserInfo.userid success:^(NSDictionary *successData) {
        BNLog(@"查询静脉信用金额度 --%@", successData);
        NSString *retCode = [NSString stringWithFormat:@"%@",[successData valueNotNullForKey:kRequestRetCode]];
        
        if ([retCode isEqualToString:kRequestNewSuccessCode]) {
            NSDictionary *dataDict = [successData valueNotNullForKey:kRequestReturnData];
            if ([dataDict isKindOfClass:[NSDictionary class]]) {
                NSString *available = [NSString stringWithFormat:@"%@", [dataDict valueWithNoDataForKey:@"credit_amount_available"]];
                NSString *used = [NSString stringWithFormat:@"%@", [dataDict valueWithNoDataForKey:@"credit_amount_used"]];
                weekSelf.availableMoneyLbl.text = available;//可用信用金
                weekSelf.usedMoneyLbl.text = used;    //已用信用金
            }
            
        }else{
            NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:retMsg];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];
    
}

- (void)refreshOKButton
{
    
    if (_is_repay == 1 && [_repayAmount floatValue] > 0) {
        //可还款
        _okButton.enabled = YES;
    } else if ((_is_repay == 0) && [_repayAmount floatValue] > 0) {
        //正在还款中
        _okButton.enabled = NO;
        [_okButton setTitle:@"自动还款中..." forState:UIControlStateNormal];
    } else {
        //额度满的，不用还款
        _okButton.enabled = NO;
        [_okButton setTitle:@"立即还款" forState:UIControlStateNormal];

    }
}
//信用账单
- (void)rightItemBtnClick
{
    //友盟事件点击
    [MobClick event:@"BNVeinInfoViewController_Button_gotoBNVeinCreditOrderListVC"];
    
    BNVeinCreditOrderListVC *viewController = [[BNVeinCreditOrderListVC alloc] init];
    [self pushViewController:viewController animated:YES];
}

- (void)blueBGViewTaped
{
    BNCommonWebViewController *cardWebView = [[BNCommonWebViewController alloc] init];
    cardWebView.urlString = [NSString stringWithFormat:@"%@/static/web_app/h5/activity/veinPayH5.html",BASE_URL];
    [self pushViewController:cardWebView animated:YES];

}
@end
