//
//  ElectricChargeMainNewVC.m
//  Wallet
//
//  Created by mac1 on 15/8/4.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "ElectricChargeMainNewVC.h"
#import "BNFeesWebViewExplainVC.h"
#import "UICountingLabel.h"

#import "NewElectricFeesApi.h"
#import "BannerApi.h"

@interface ElectricChargeMainNewVC ()<UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextField *roomTF;
@property (nonatomic, strong) UIButton *chargeBtn;
@property (nonatomic, strong) UICountingLabel *remainMoney;

@property (nonatomic, copy) NSString *remainMonStr;

@property (nonatomic, strong) UIView *whiteBGView1;

@property (nonatomic, strong) UIButton *reloadButton;
@property (nonatomic, strong) UIButton *modifyBtn;
@property (copy, nonatomic) NSString *biilIdStr;

@property (nonatomic) BOOL firstHaveNotBindRoomId;  //进入页面，就发现未绑定房间号，默认YES，已绑定则设为NO，输入框才可用。
@property (nonatomic) BOOL textFieldEnabled;

@end

@implementation ElectricChargeMainNewVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    _firstHaveNotBindRoomId = YES;
    _textFieldEnabled = NO;
    self.navigationTitle = @"电费充值";
    [self setupSubViews];
    [self queryElectric];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
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
- (void)setupSubViews
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge)];
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height + 1);
    _scrollView.backgroundColor = UIColor_Gray_BG;
    [self.view addSubview:_scrollView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgtaped:)];
    [_scrollView addGestureRecognizer:tap];
    
    CGFloat originY = 21*BILI_WIDTH;
    
    UIImageView *bottomBlueView = [[UIImageView alloc]initWithFrame:CGRectMake(21*BILI_WIDTH, originY, SCREEN_WIDTH-2*21*BILI_WIDTH, 284*BILI_WIDTH)];
    bottomBlueView.userInteractionEnabled = YES;
    UIImage *bgImg = [[UIImage imageNamed:@"electricRoom_BlueBG"] resizableImageWithCapInsets:UIEdgeInsetsMake(284*BILI_WIDTH, [BNTools sizeFit:11 six:11 sixPlus:17], 0, [BNTools sizeFit:12 six:12 sixPlus:19])];
    bottomBlueView.image = bgImg;
    bottomBlueView.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:bottomBlueView];

    UIButton *ruleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ruleBtn.frame = CGRectMake((CGRectGetWidth(bottomBlueView.frame)-62*BILI_WIDTH), 0*BILI_WIDTH, 62 * BILI_WIDTH, 35 * BILI_WIDTH);
    [ruleBtn setTitle:@"规则" forState:UIControlStateNormal];
    ruleBtn.titleLabel.font = [UIFont systemFontOfSize:11*BILI_WIDTH];
    [ruleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ruleBtn setTitleColor:UIColor_Gray_Text forState:UIControlStateHighlighted];
    [ruleBtn setImage:[UIImage imageNamed:@"electricRoom_ruleBtn"] forState:UIControlStateNormal];
    [ruleBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    [ruleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [bottomBlueView addSubview:ruleBtn];
    [ruleBtn addTarget:self action:@selector(ruleBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *popView = [[UIImageView alloc]initWithFrame:CGRectMake((CGRectGetWidth(bottomBlueView.frame)-100*BILI_WIDTH)/2, 75*BILI_WIDTH, 100*BILI_WIDTH, 109*BILI_WIDTH)];
    popView.image = [UIImage imageNamed:@"electricRoom_icon"];
    popView.backgroundColor = [UIColor clearColor];
    [bottomBlueView addSubview:popView];

    UILabel *remindLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 196*BILI_WIDTH, bottomBlueView.frame.size.width, 15 * BILI_WIDTH)];
    remindLabel1.text = @"你已欠费(元)";
    remindLabel1.textAlignment = NSTextAlignmentCenter;
    remindLabel1.textColor = [UIColor whiteColor];
    remindLabel1.font = [UIFont systemFontOfSize:13*BILI_WIDTH];
    [bottomBlueView addSubview:remindLabel1];

    //剩余电费
    self.remainMoney = [[UICountingLabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(remindLabel1.frame)+ 10*BILI_WIDTH, bottomBlueView.frame.size.width, 22 * BILI_WIDTH)];
    _remainMoney.textColor = [UIColor whiteColor];
    _remainMoney.textAlignment = NSTextAlignmentCenter;
    _remainMoney.font = [UIFont systemFontOfSize:20*BILI_WIDTH];
    _remainMoney.format = @"%.2f";
    _remainMoney.hidden = YES;
    _remainMoney.method = UILabelCountingMethodLinear;
    [bottomBlueView addSubview:_remainMoney];
    
    self.whiteBGView1 = [[UIView alloc] init];
    _whiteBGView1.frame = CGRectMake((CGRectGetWidth(bottomBlueView.frame)-30*BILI_WIDTH)/2, CGRectGetMaxY(remindLabel1.frame) + 30 * BILI_WIDTH, 30 * BILI_WIDTH, 2*BILI_WIDTH);
    _whiteBGView1.backgroundColor = [UIColor clearColor];
    [bottomBlueView addSubview:_whiteBGView1];
    
    //下面那4个黑色的View;
    NSInteger beginX = 0;
    for (int i = 0 ; i < 2; i ++) {
        if (i < 2) {
            beginX = 40 * BILI_WIDTH;
            UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(16*BILI_WIDTH * (i%2),0, 12*BILI_WIDTH, 2 * BILI_WIDTH)];
            blackView.backgroundColor = [UIColor whiteColor];
            [_whiteBGView1 addSubview:blackView];
        }
    }

    self.reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _reloadButton.frame = CGRectMake((CGRectGetWidth(bottomBlueView.frame)-126*BILI_WIDTH)/2.0, CGRectGetMaxY(_remainMoney.frame) + 5*BILI_WIDTH, 126 * BILI_WIDTH, 26 * BILI_WIDTH);
    _reloadButton.layer.cornerRadius = _reloadButton.frame.size.height / 2;
    _reloadButton.layer.masksToBounds = YES;
    _reloadButton.layer.borderWidth = 1;
    _reloadButton.layer.borderColor = UIColor_GrayLine.CGColor;
    [_reloadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_reloadButton setTitle:@"有错误，点击重新加载" forState:UIControlStateNormal];
    [_reloadButton.titleLabel setFont:[UIFont systemFontOfSize:[BNTools sizeFit:11 six:13 sixPlus:15]]];
    [_reloadButton addTarget:self action:@selector(reloadButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBlueView addSubview: _reloadButton];
    _reloadButton.hidden = YES;

    originY += CGRectGetHeight(bottomBlueView.frame);
    
    
    UIView *roomView = [[UIView alloc] initWithFrame:CGRectMake(21*BILI_WIDTH, originY, SCREEN_WIDTH-2*21*BILI_WIDTH, 50 * BILI_WIDTH)];
    roomView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:roomView];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:roomView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(13, 13)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame =roomView.bounds;
    maskLayer.path = maskPath.CGPath;
    roomView.layer.mask = maskLayer;

    originY += CGRectGetHeight(roomView.frame);

    self.roomTF = [[UITextField alloc]initWithFrame:CGRectMake(10*BILI_WIDTH, 0, CGRectGetWidth(roomView.frame)-72*BILI_WIDTH, CGRectGetHeight(roomView.frame))];
    _roomTF.textColor = UIColor_Black_Text;
    _roomTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _roomTF.font = [UIFont systemFontOfSize:14*BILI_WIDTH];
    _roomTF.placeholder = @"请输入房间号";
    [roomView addSubview:_roomTF];
    [_roomTF addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventAllEditingEvents];
    _roomTF.delegate = self;
//    _roomTF.enabled = NO;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(bottomBlueView.frame)-63*BILI_WIDTH), (50-13)/2 * BILI_WIDTH, 1, 13*BILI_WIDTH)];
    line.backgroundColor = UIColorFromRGB(0xa0b2bb);
    [roomView addSubview:line];

   self.modifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _modifyBtn.frame = CGRectMake((CGRectGetWidth(bottomBlueView.frame)-62*BILI_WIDTH), 0*BILI_WIDTH, 62 * BILI_WIDTH, 50 * BILI_WIDTH);
    [_modifyBtn setTitle:@"修改" forState:UIControlStateNormal];
    _modifyBtn.titleLabel.font = [UIFont systemFontOfSize:14*BILI_WIDTH];
    [_modifyBtn setTitleColor:UIColor_NewBlueColor forState:UIControlStateNormal];
    [roomView addSubview:_modifyBtn];
    [_modifyBtn addTarget:self action:@selector(modifyBtnAction) forControlEvents:UIControlEventTouchUpInside];

    
    self.chargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_chargeBtn setupTitle:@"立即缴费" enable:NO];
    _chargeBtn.frame = CGRectMake(0, CGRectGetHeight(_scrollView.frame) - 50 * BILI_WIDTH, _scrollView.frame.size.width, 50 * BILI_WIDTH);
    [_chargeBtn addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_chargeBtn];
    
    [self pythonCheckService];
    
}



- (void)pythonCheckService
{
    //请求checkService，检查服务可用性。
    [SVProgressHUD show];
    [BannerApi pythonCheckService:shareAppDelegateInstance.boenUserInfo.userid
                           busiId:_biz_id
                          success:^(NSDictionary *successData) {
                              BNLog(@"pythonCheckService--%@", successData);
                              
                              NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                              
                              if ([retCode isEqualToString:kRequestSuccessCode]) {
                                  
                                  NSDictionary *retData = [successData valueForKey:kRequestReturnData];
                                  NSString *busiStatus = [retData valueNotNullForKey:@"busi_status"];
                                  NSString *payStatus = [retData valueNotNullForKey:@"pay_status"];
                                  NSString *systemStatus = [retData valueNotNullForKey:@"system_status"];
                                  
                                  if ([payStatus isEqualToString:@"no"] && [busiStatus isEqualToString:@"no"] && [systemStatus isEqualToString:@"no"]) {
                                      [SVProgressHUD dismiss];
                                  } else {
                                      [SVProgressHUD showErrorWithStatus:kSystemErrorMsg];
                                  }
                                  
                              }else{
                                  NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                  [SVProgressHUD showErrorWithStatus:retMsg];
                              }
                              
                          } failure:^(NSError *error) {
                              [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                          }];
    
    
}


#pragma mark 请求
//查询房间号和电费查询
- (void)queryElectric
{
    [self animationStartWithLayer:_whiteBGView1.layer];
    __weak typeof(self)weakSelf = self;
    [SVProgressHUD showWithStatus:@"请稍候"];
    [NewElectricFeesApi getRoomIdAndEletricSuccess:^(NSDictionary *returnData){
        BNLog(@"getRoomIdAndEletricSuccess  %@",returnData);
        NSString *retCode = returnData[kRequestRetCode];
        NSDictionary *dataDic = returnData[kRequestReturnData];
        if ([retCode isEqualToString:kRequestNewSuccessCode]) {
            [SVProgressHUD dismiss];
            
            _remainMonStr = [NSString stringWithFormat:@"%@", [dataDic valueWithNoDataForKey:@"ele_balance"]];
            _roomStr = [NSString stringWithFormat:@"%@", [dataDic valueWithNoDataForKey:@"room_id"]];
            _biilIdStr = [NSString stringWithFormat:@"%@", [dataDic valueWithNoDataForKey:@"bill_id"]];

            [weakSelf hideBlackViewBegainAnimation];

            if (_roomStr == nil) {
                //首次进入，未绑定房间号
                _firstHaveNotBindRoomId = NO;
                _textFieldEnabled = YES;
                _roomTF.enabled = YES;
                _roomTF.textColor = UIColor_Black_Text;
                [self refreshBtnStatus];
                return;
            }
            
            _firstHaveNotBindRoomId = NO;
            _textFieldEnabled = NO;
            [self keyboardWillHidden:nil];
            _roomTF.text = _roomStr;
            
            [self refreshBtnStatus];

        } else {
            [SVProgressHUD showErrorWithStatus:returnData[kRequestRetMessage]];
        }

    }
                                           failure:^(NSError *error){
                                               [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                               _reloadButton.hidden = NO;
                                           }];
    
}


// 影藏4个黑色的view 进度条开始动画
- (void)hideBlackViewBegainAnimation
{
    _whiteBGView1.hidden = YES;
    
    _remainMoney.hidden = NO;
    
    [self startDisplayLinAnimation];
}


#pragma 动画
// 数字增长动画
- (void)startDisplayLinAnimation
{
    [_remainMoney countFrom:0.0 to:_remainMonStr.floatValue withDuration:1.f];
}



//旋转动画
- (void)animationStartWithLayer:(CALayer *)layer
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @(0);
    animation.toValue = @(2 * M_PI);
    animation.repeatCount = NSIntegerMax;
    animation.duration = 1;
    [layer addAnimation:animation forKey:@"rotationAnimation"];
}


#pragma 事件处理
- (void)bgtaped:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

- (void)reloadButtonAction:(UIButton *)button
{
    button.hidden = YES;
    if (_whiteBGView1.hidden == NO) {
        [self animationStartWithLayer:_whiteBGView1.layer];
    }
    [self queryElectric];
}


- (void)ruleBtnAction
{
    BNFeesWebViewExplainVC *explainVc = [[BNFeesWebViewExplainVC alloc] init];
    explainVc.useType = ExpainUseTypeDianFei;
    [self pushViewController:explainVc animated:YES];

}
- (void)modifyBtnAction
{
    if (_textFieldEnabled == NO) {
        [self keyboardDidShow:nil];
        [_roomTF becomeFirstResponder];
        return;
    }
    if (_roomTF.text || _roomTF.text.length > 0) {
        [SVProgressHUD showWithStatus:@"请稍候"];
        [NewElectricFeesApi bandRoomWithRoomId:_roomTF.text
                                       success:^(NSDictionary *returnData) {
                                           BNLog(@"绑定房间号%@",returnData);
                                           NSString *retCode = returnData[kRequestRetCode];
                                           if ([retCode isEqualToString:kRequestNewSuccessCode])
                                           {
                                               [SVProgressHUD showSuccessWithStatus:@"操作成功！"];
                                               [self queryElectric];

                                           }
                                           else
                                           {
                                               [SVProgressHUD showErrorWithStatus:returnData[kRequestRetMessage]];
                                           }
                                       }
                                       failure:^(NSError *error) {
                                           [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                       }];
        _roomStr = _roomTF.text;
    } else {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的房间号"];
    }
}
#pragma mark - UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        _scrollView.contentInset = UIEdgeInsetsMake(-224*BILI_WIDTH, 0, 0, 0);
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height + 1+224*BILI_WIDTH);
    }];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        _scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height + 1);
    }];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length == 0) {
        return YES;   //退格删除
    }
    if (textField == _roomTF) {
        NSRange range = [@"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLIMNOPQRSTUVWXYZ.-_=+@$#%*~|[]^" rangeOfString:string];
        if (range.length > 0) {
            return YES;
        } else {
            return NO;
        }
    }
    return YES;
}
- (void)textChanged:(UITextField *)textField
{
//    [self refreshBtnStatus];
}
- (void)refreshBtnStatus
{
    if (_roomTF.text && _roomTF.text.length > 0 && [_remainMonStr floatValue] > 0) {
        _chargeBtn.enabled = YES;
    } else {
        _chargeBtn.enabled = NO;
    }
}
#pragma mark  确认充值按钮
- (void)confirmButtonAction:(UIButton *)button
{
    [self.view endEditing:YES];

    [self createEelectricOrderbill];
}


- (void)createEelectricOrderbill
{
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"请稍候"];
    [NewElectricFeesApi newPay_Electric_Create_orderWithSchool_id:shareAppDelegateInstance.boenUserInfo.schoolId
                                                           amount:_remainMonStr
                                                          room_id:_roomTF.text
                                                          bill_id:_biilIdStr
                                                          success:^(NSDictionary *successData) {
                                                              BNLog(@"新电费--->>>>>%@",successData);
                                                              if ([successData[kRequestRetCode] isEqualToString:kRequestNewSuccessCode]) {
                                                                  [SVProgressHUD dismiss];
                                                                  NSDictionary *dataDic = [successData valueNotNullForKey:kRequestReturnData];
                                                                  //
                                                                  BNPayModel *payModel = [[BNPayModel alloc] init];
                                                                  payModel.goodsName = @"电费充值";
                                                                  payModel.userName = [dataDic valueNotNullForKey:@"buyer_name"];
                                                                  payModel.goodsNumber = [dataDic valueNotNullForKey:@"room_id"];
                                                                  payModel.salePrice = _remainMonStr;
                                                                  payModel.order_no = [dataDic valueNotNullForKey:@"order_no"];
                                                                  payModel.biz_no = [dataDic valueNotNullForKey:@"biz_no"];
                                                                  [weakSelf goToPayCenterWithPayProjectType:PayProjectTypeDianFei
                                                                                               payModel:payModel
                                                                                            returnBlockone:^(PayVCJumpType jumpType, id params) {
                                                                                                if (jumpType == PayVCJumpType_PayCompletedBackHomeVC) {
                                                                                                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                                                                                                }
                                                                                            }];
                                                              } else {
                                                                  [SVProgressHUD showErrorWithStatus:[successData valueNotNullForKey:kRequestRetMessage]];
                                                              }
                                                              
                                                          }
                                                          failure:^(NSError *error) {
                                                              [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                                              BNLog(@"新电费error---->>>>>%@",error.description);
                                                          }];
    
}

#pragma mark - keyboard
- (void)keyboardWillHidden:(NSNotification *)note
{
    if (!_textFieldEnabled) {
        [_modifyBtn setTitle:@"修改" forState:UIControlStateNormal];
        _roomTF.enabled = NO;
        _roomTF.textColor = UIColor_Gray_Text;
    }
}

- (void)keyboardDidShow:(NSNotification *)note
{
    _textFieldEnabled = YES;
    _chargeBtn.enabled = NO;
    [_modifyBtn setTitle:@"确定" forState:UIControlStateNormal];
    _roomTF.enabled = YES;
    _roomTF.textColor = UIColor_Black_Text;
    
    _remainMonStr = @"";
    _roomStr = @"";
    _biilIdStr = @"";
    [self hideBlackViewBegainAnimation];

}
@end
