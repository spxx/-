//
//  ElectricChargeMainVC.m
//  Wallet
//
//  Created by mac1 on 15/8/4.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "ElectricChargeMainVC.h"
#import "BindRoomViewController.h"
#import "ElectricChargeVC.h"
#import "LineProgressView.h"
#import "UICountingLabel.h"
#import "BannerApi.h"

#import "NewElectricFeesApi.h"

@interface ElectricChargeMainVC ()

@property (nonatomic, strong) LineProgressView *lineProgressView;
@property (nonatomic, strong) UILabel *roomRightLab;
@property (nonatomic, strong) UIButton *chargeBtn;
@property (nonatomic, strong) UICountingLabel *remainElectric;
@property (nonatomic, strong) UICountingLabel *remainMoney;

@property (nonatomic, copy) NSString *remainEleStr;
@property (nonatomic, copy) NSString *remainMonStr;

@property (nonatomic, strong) UIView *whiteBGView1;
@property (nonatomic, strong) UIView *whiteBGView2;

@property (nonatomic, strong) UIButton *reloadButton;


@end

@implementation ElectricChargeMainVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationTitle = @"电费";
    [self setupSubViews];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self queryElectric];
}


- (void)setupSubViews
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge)];
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height + 1);
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];
    
    UIView *roomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55 * BILI_WIDTH)];
    roomView.backgroundColor = [UIColor whiteColor];
    roomView.layer.borderColor = [UIColor colorWithRed:235/255.0 green:236/255.0 blue:235/255.0 alpha:1.f].CGColor;
    roomView.layer.borderWidth = 8 * BILI_WIDTH;
    roomView.layer.cornerRadius = 2 * BILI_WIDTH;
    [scrollView addSubview:roomView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectRoom:)];
    [roomView addGestureRecognizer:tap];
    
    UIButton *roomLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    roomLeft.frame = CGRectMake(10 * BILI_WIDTH, 2.5*BILI_WIDTH, 90 * BILI_WIDTH, 50 * BILI_WIDTH);
    roomLeft.userInteractionEnabled = NO;
    [roomLeft setTitle:@"我的房间" forState:UIControlStateNormal];
    roomLeft.titleLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
    [roomLeft setTitleColor:UIColorFromRGB(0x64808e) forState:UIControlStateNormal];
    [roomLeft setImage:[UIImage imageNamed:@"electricRoom"] forState:UIControlStateNormal];
    [roomLeft setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [roomLeft setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [roomView addSubview:roomLeft];
    
    self.roomRightLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 200 * BILI_WIDTH, 2.5*BILI_WIDTH, 170*BILI_WIDTH, CGRectGetHeight(roomLeft.frame))];
    _roomRightLab.text = @"选择房间号";
    _roomRightLab.textColor = UIColorFromRGB(0x64808e);
    _roomRightLab.textAlignment = NSTextAlignmentRight;
    _roomRightLab.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
    _roomRightLab.userInteractionEnabled = NO;
    [roomView addSubview:_roomRightLab];
    
    UIImageView *rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 30*BILI_WIDTH, 20*BILI_WIDTH, 16*BILI_WIDTH, 16*BILI_WIDTH)];
    rightArrow.image = [UIImage imageNamed:@"right_arrow"];
    [roomView addSubview:rightArrow];
    
    
    self.lineProgressView = [[LineProgressView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-207.0 * BILI_WIDTH)/2.0, CGRectGetMaxY(roomView.frame) + [BNTools sizeFitfour:10 five:30 six:35 sixPlus:39], 207.0 * BILI_WIDTH,207.0 * BILI_WIDTH)];
    _lineProgressView.total = 50;//线的条数
    _lineProgressView.radius = (207/2.0) * BILI_WIDTH;//外圆的半径
    _lineProgressView.innerRadius = (207/2.0 - 18) * BILI_WIDTH;//内圆半径
    _lineProgressView.startAngle = 0.8 *  M_PI;//0.73773 * M_PI ;
    _lineProgressView.endAngle = 2.24 * M_PI;
    _lineProgressView.animationDuration = 1;//动画时间
    _lineProgressView.layer.shouldRasterize = YES;
    [_lineProgressView.layer setNeedsDisplay];
    [scrollView addSubview:_lineProgressView];
    [self.view bringSubviewToFront:_lineProgressView];
    
    
    UIImageView *middleImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 127 * BILI_WIDTH)/2.0, _lineProgressView.frame.origin.y + 40 * BILI_WIDTH, 127 * BILI_WIDTH, 127 * BILI_WIDTH)];
    middleImageView.backgroundColor = [UIColor clearColor];
    middleImageView.image = [UIImage imageNamed:@"electricMainMiddle"];
    [scrollView addSubview:middleImageView];

    
    UILabel *zeroLabel = [[UILabel alloc] initWithFrame:CGRectMake(34 * BILI_WIDTH, 167 * BILI_WIDTH, 35 * BILI_WIDTH , 15 * BILI_WIDTH)];
    zeroLabel.text = @"0(度)";
    zeroLabel.textColor = UIColorFromRGB(0x64808e);
    zeroLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:13 six:15 sixPlus:17]];
    [_lineProgressView addSubview:zeroLabel];
    
    UILabel *maxLabel = [[UILabel alloc] initWithFrame:CGRectMake(143 * BILI_WIDTH, zeroLabel.frame.origin.y, CGRectGetWidth(zeroLabel.frame), CGRectGetHeight(zeroLabel.frame))];
    maxLabel.text = @"100+";
    maxLabel.textColor = UIColorFromRGB(0x64808e);
    maxLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:13 six:15 sixPlus:17]];
    [_lineProgressView addSubview:maxLabel];
    
    UILabel *remindLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(38 * BILI_WIDTH, CGRectGetMaxY(_lineProgressView.frame) + [BNTools sizeFitfour:0 five:20 six:40 sixPlus:50], 75 * BILI_WIDTH, 17 * BILI_WIDTH)];
    remindLabel1.text = @"剩余电量(度)";
    remindLabel1.textColor = UIColorFromRGB(0x64808e);
    remindLabel1.font = [UIFont systemFontOfSize:[BNTools sizeFit:13 six:15 sixPlus:17]];
    [scrollView addSubview:remindLabel1];
    
    UILabel *remindLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 113*BILI_WIDTH,remindLabel1.frame.origin.y , CGRectGetWidth(remindLabel1.frame), CGRectGetHeight(remindLabel1.frame))];
    remindLabel2.text = @"剩余电费(元)";
    remindLabel2.textColor = UIColorFromRGB(0x64808e);
    remindLabel2.font = [UIFont systemFontOfSize:[BNTools sizeFit:13 six:15 sixPlus:17]];
    [scrollView addSubview:remindLabel2];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 0.25, remindLabel1.frame.origin.y, 0.5, 55 * BILI_WIDTH)];
    lineV.backgroundColor = UIColor_GrayLine;
    [scrollView addSubview:lineV];
    
    self.reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _reloadButton.frame = CGRectMake((SCREEN_WIDTH - 126* BILI_WIDTH)/2.0, CGRectGetMaxY(lineV.frame) + [BNTools sizeFitfour:10 five:26 six:26 * 1.174 sixPlus:26 * 1.296], 126 * BILI_WIDTH, 26 * BILI_WIDTH);
    _reloadButton.layer.cornerRadius = _reloadButton.frame.size.height / 2;
    _reloadButton.layer.masksToBounds = YES;
    _reloadButton.layer.borderWidth = 1;
    _reloadButton.layer.borderColor = UIColor_GrayLine.CGColor;
    _reloadButton.hidden = YES;
    [_reloadButton setTitleColor:UIColorFromRGB(0x2b89ed) forState:UIControlStateNormal];
    [_reloadButton setTitle:@"有错误，点击重新加载" forState:UIControlStateNormal];
    [_reloadButton.titleLabel setFont:[UIFont systemFontOfSize:[BNTools sizeFit:11 six:13 sixPlus:15]]];
    [_reloadButton addTarget:self action:@selector(reloadButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview: _reloadButton];
    
    //剩余电量
    self.remainElectric = [[UICountingLabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(remindLabel1.frame) + 10 *BILI_WIDTH, 151 * BILI_WIDTH, 35 * BILI_WIDTH)];
    _remainElectric.textColor = [UIColor blackColor];
    _remainElectric.textAlignment = NSTextAlignmentCenter;
    _remainElectric.font = [UIFont systemFontOfSize:[BNTools sizeFit:30 six:32 sixPlus:34]];
    _remainElectric.format = @"%.2f";
    _remainElectric.method = UILabelCountingMethodLinear;//匀速
    _remainElectric.hidden = YES;
    [scrollView addSubview:_remainElectric];
    
    //剩余电费
    self.remainMoney = [[UICountingLabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 151*BILI_WIDTH, _remainElectric.frame.origin.y, CGRectGetWidth(_remainElectric.frame), CGRectGetHeight(_remainElectric.frame))];
    _remainMoney.textColor = [UIColor blackColor];
    _remainMoney.textAlignment = NSTextAlignmentCenter;
    _remainMoney.font = [UIFont systemFontOfSize:[BNTools sizeFit:30 six:32 sixPlus:34]];
    _remainMoney.format = @"%.2f";
    _remainMoney.hidden = YES;
    _remainMoney.method = UILabelCountingMethodLinear;
    [scrollView addSubview:_remainMoney];
    
    
    
    self.whiteBGView1 = [[UIView alloc] init];
    _whiteBGView1.frame = CGRectMake(40 * BILI_WIDTH, CGRectGetMaxY(remindLabel1.frame) + 30 * BILI_WIDTH, 30 * BILI_WIDTH, 2*BILI_WIDTH);
    _whiteBGView1.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:_whiteBGView1];
    
    self.whiteBGView2 = [[UIView alloc] initWithFrame:CGRectMake(253 * BILI_WIDTH,_whiteBGView1.frame.origin.y, CGRectGetWidth(_whiteBGView1.frame), CGRectGetHeight(_whiteBGView1.frame))];
    [scrollView addSubview:_whiteBGView2];
    [_whiteBGView2 setBackgroundColor:[UIColor whiteColor]];

    //下面那4个黑色的View;
    NSInteger beginX = 0;
    for (int i = 0 ; i < 4; i ++) {
        if (i < 2) {
            beginX = 40 * BILI_WIDTH;
            UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(16*BILI_WIDTH * (i%2),0, 12*BILI_WIDTH, 2 * BILI_WIDTH)];
            blackView.backgroundColor = [UIColor blackColor];
            [_whiteBGView1 addSubview:blackView];
        }
        else
        {
            beginX = 253 * BILI_WIDTH;
            UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(16*BILI_WIDTH * (i%2),0, 12*BILI_WIDTH, 2 * BILI_WIDTH)];
            blackView.backgroundColor = [UIColor blackColor];
            [_whiteBGView2 addSubview:blackView];
        }
    }
  
    
    self.chargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_chargeBtn setupTitle:@"电费充值" enable:YES];
    _chargeBtn.frame = CGRectMake(0, CGRectGetHeight(scrollView.frame) - 50 * BILI_WIDTH, scrollView.frame.size.width, 50 * BILI_WIDTH);
    [_chargeBtn addTarget:self action:@selector(chargeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:_chargeBtn];
    
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
    [self animationStartWithLayer:_whiteBGView2.layer];
    __weak typeof(self)weakSelf = self;
    [SVProgressHUD showWithStatus:@"请稍候"];
    [NewElectricFeesApi getRoomIdAndEletricSuccess:^(NSDictionary *returnData){
                                    BNLog(@"getRoomIdAndEletricSuccess  %@",returnData);
                                    NSString *retCode = returnData[kRequestRetCode];
                                    NSDictionary *dataDic = returnData[kRequestReturnData];
                                    if ([retCode isEqualToString:kRequestNewSuccessCode]) {
                                        [SVProgressHUD dismiss];
                                        
                                        _remainEleStr = [NSString stringWithFormat:@"%@", [dataDic valueWithNoDataForKey:@"ele_quantity"]];
                                        _remainMonStr = [NSString stringWithFormat:@"%@", [dataDic valueWithNoDataForKey:@"ele_balance"]];
                                        _roomStr = [NSString stringWithFormat:@"%@", [dataDic valueWithNoDataForKey:@"room_id"]];
                                        [weakSelf hideBlackViewBegainAnimation];

                                        if (_roomStr == nil) {
                                            //首次进入，未绑定房间号不执行下面代码
                                            return;
                                        }
                                        _roomRightLab.text = _roomStr;

                                    }
                                    else
                                    {
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
    _whiteBGView2.hidden = YES;
    
    _remainMoney.hidden = NO;
    _remainElectric.hidden = NO;
    
    NSInteger completedCount = _remainEleStr.integerValue >100 ? 100:_remainEleStr.integerValue;
    if (_lineProgressView)
    {
        [_lineProgressView setCompleted:completedCount/2.0 animated:YES];//设置动画
    }
    
    [self startDisplayLinAnimation];
}


#pragma 动画
// 数字增长动画
- (void)startDisplayLinAnimation
{
    [_remainElectric countFrom:0.0 to:_remainEleStr.floatValue  withDuration:1.f];
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
- (void)selectRoom:(UITapGestureRecognizer *)tap
{
    BindRoomViewController *roomVC = [BindRoomViewController new];
    roomVC.defaultRoomStr = _roomStr;
    [self pushViewController:roomVC animated:YES];
}

- (void)chargeButtonAction:(UIButton *)button
{
    ElectricChargeVC *eVC = [[ElectricChargeVC alloc] init];
    eVC.roomStr = _roomStr;
    [self pushViewController:eVC animated:YES];

}

- (void)reloadButtonAction:(UIButton *)button
{
    button.hidden = YES;
    if (_whiteBGView1.hidden == NO && _whiteBGView2.hidden == NO) {
        [self animationStartWithLayer:_whiteBGView1.layer];
        [self animationStartWithLayer:_whiteBGView2.layer];
    }
    [self queryElectric];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
