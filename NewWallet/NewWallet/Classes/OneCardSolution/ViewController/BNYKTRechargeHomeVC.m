//
//  BNYKTRechargeHomeVC.m
//  Wallet
//
//  Created by mac1 on 15/3/4.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNYKTRechargeHomeVC.h"

#import "SelectItemView.h"

#import "BannerApi.h"
#import "CustomButton.h"
#import "BNBillViewController.h"
#import "BNReportLossVC.h"
#import "BNExplainViewController.h"
#import "BNBindYKTViewController.h"
#import "BNYKTHomeListCell.h"
#import "BNYKTRechargeViewController.h"
#import "BNBorderLineButton.h"
#import "BNPublicHtml5BusinessVC.h"
#import "NewSchoolFeesApi.h"

@interface BNYKTRechargeHomeVC ()<UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) BNBorderLineButton *rechargeBtn;

@property (weak, nonatomic) UILabel *sysTipsLabel;

@property (assign, nonatomic) NSInteger dayLimite;
@property (assign, nonatomic) NSInteger transLimite;
@property (nonatomic) BOOL systemError; //维护中
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataAry;

@end

@implementation BNYKTRechargeHomeVC
static NSString *cardTypeName;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataAry = [@[] mutableCopy];
    _systemError = NO;
    
    [self setupLoadedView];

    [self pythonCheckService];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self addResponseKeyboardAction];
}

- (void)setupLoadedView
{
    self.sixtyFourPixelsView.backgroundColor = [UIColor whiteColor];
    UILabel *lineLbl = (UILabel *)[self.customNavigationBar viewWithTag:10001];
    lineLbl.hidden = YES;
    
    self.navigationTitle = @"一卡通充值";
    
    self.view.backgroundColor = UIColor_Gray_BG;
    cardTypeName = [shareAppDelegateInstance.boenUserInfo.yktType isEqualToString:@"1"] ? @"学号" : @"一卡通号";

    UIScrollView *theScollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT- self.sixtyFourPixelsView.viewBottomEdge)];
    theScollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge);
    [self.view addSubview:theScollView];
    
    CGFloat buttonHeight = 70*BILI_WIDTH;
    
    UIView *bglView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, buttonHeight)];
    bglView.backgroundColor = [UIColor whiteColor];
    [theScollView addSubview:bglView];
    
    NSArray *btnImgAry = @[[UIImage imageNamed:@"OneCard_BillList_Btn"],
                           [UIImage imageNamed:@"OneCard_ReportLose_Btn"],
                           [UIImage imageNamed:@"OneCard_Info_Btn"],
                           [UIImage imageNamed:@"OneCard_RefundFee_Btn"]];
    NSArray *btnTitleAry = @[@"账单", @"挂失", @"说明", @"销卡退费"];
    
    CGFloat originY = 0;
    CGFloat btnWidth = SCREEN_WIDTH/4;
    //4个按钮
    for (int i=0; i < 4; i++) {
        CustomButton *customBtn = [CustomButton buttonWithType:UIButtonTypeCustom];
        customBtn.tag = 101+i;
        [customBtn setUpWithImgTopY:10*BILI_WIDTH imgHeight:30*BILI_WIDTH textBottomY:11*BILI_WIDTH];
        customBtn.frame = CGRectMake(i*btnWidth, originY, btnWidth, buttonHeight);
        UIImage *image1 = [Tools imageWithColor:[UIColor whiteColor] andSize:customBtn.frame.size];
        UIImage *image2 = [Tools imageWithColor:[UIColor groupTableViewBackgroundColor] andSize:customBtn.frame.size];
        [customBtn setBackgroundImage:image1 forState:UIControlStateNormal];
        [customBtn setBackgroundImage:image2 forState:UIControlStateHighlighted];
        [customBtn setImage:btnImgAry[i] forState:UIControlStateNormal];
        [customBtn setTitle:btnTitleAry[i] forState:UIControlStateNormal];
        [customBtn setTitleColor:UIColorFromRGB(0xb0bec5) forState:UIControlStateNormal];
        [customBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [theScollView addSubview:customBtn];
    }
    originY += buttonHeight /*+ 10*BILI_WIDTH*/;
    
    UILabel *systemErrorTipsLab = [[UILabel alloc] initWithFrame:CGRectMake(10*BILI_WIDTH, originY, SCREEN_WIDTH - 2*10*BILI_WIDTH, 30*BILI_WIDTH)];
    systemErrorTipsLab.textColor = [UIColor redColor];
    systemErrorTipsLab.alpha = 0.0;
    systemErrorTipsLab.hidden = YES;
    systemErrorTipsLab.font  = [UIFont systemFontOfSize:14*BILI_WIDTH];
    systemErrorTipsLab.text = @"系统维护中, 暂不可用!";
    _sysTipsLabel = systemErrorTipsLab;
    _sysTipsLabel.hidden = YES;

    [theScollView addSubview:systemErrorTipsLab];
    
    originY += 10*BILI_WIDTH;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge - originY) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = UIColor_Gray_BG;
    [_tableView registerClass:[BNYKTHomeListCell class] forCellReuseIdentifier:@"BNYKTHomeListCell"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [theScollView addSubview:_tableView];
    
    
    [self getYKTListData];
}
- (void)getYKTListData
{
    [SVProgressHUD showWithStatus:@"请稍候..."];
    [NewCardApi newPay_getYKTListWithSuccess:^(NSDictionary *successData) {
        BNLog(@"newPay_getYKTListWithSuccess--%@", successData);
        NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
        if ([retCode isEqualToString:kRequestNewSuccessCode]) {
            [SVProgressHUD dismiss];
            NSArray *retArray = [successData valueForKey:kRequestReturnData];
            _dataAry = [retArray mutableCopy];
            [self.tableView reloadData];
            
        }else{
            NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:retMsg];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];

}
#pragma mark - UITableViewDataSource, UITableViewDelegate
-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataAry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68*BILI_WIDTH;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_dataAry.count <= 0) {
        return (120+68)*BILI_WIDTH;
    }
    return 68*BILI_WIDTH;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    CGFloat totalFooterHeight = 68*BILI_WIDTH;

    if (_dataAry.count <= 0) {
        totalFooterHeight = (120+68)*BILI_WIDTH;
    }
    UIView *views = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, totalFooterHeight)];
    views.backgroundColor = UIColor_GrayLine;
    
    UIView *whiteviews = [[UIView alloc]initWithFrame:CGRectMake(0, 0.5, SCREEN_WIDTH, totalFooterHeight-1.5)];
    whiteviews.backgroundColor = [UIColor whiteColor];
    [views addSubview:whiteviews];

    CGFloat originY = 15*BILI_WIDTH;
    if (_dataAry.count <= 0) {
        CGFloat iconWidth = 52*BILI_WIDTH;

        UIImageView *cardIcon = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-iconWidth)/2, (135*BILI_WIDTH-iconWidth)/2, iconWidth, iconWidth)];
        cardIcon.image = [UIImage imageNamed:@"RechargeHomeVC_cardIcon"];
        [views addSubview:cardIcon];
        cardIcon.userInteractionEnabled = NO;

        originY += 120*BILI_WIDTH;
    }
    
    self.rechargeBtn = [BNBorderLineButton buttonWithType:UIButtonTypeCustom];
    _rechargeBtn.frame = CGRectMake(15*BILI_WIDTH, originY, SCREEN_WIDTH-2*15*BILI_WIDTH, 38 * BILI_WIDTH);
    [_rechargeBtn setupBlueBorderLineBtnTitle:@"新卡充值" enable:YES];
    _rechargeBtn.enableLayerColor = UIColor_BlueBorderBtn_Normal.CGColor;
    _rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:14*BILI_WIDTH];
    _rechargeBtn.layer.cornerRadius = 3*BILI_WIDTH;
    [_rechargeBtn addTarget:self action:@selector(rechargeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [views addSubview:_rechargeBtn];
    _rechargeBtn.enabled = !_systemError;

    return views;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"BNYKTHomeListCell";
    BNYKTHomeListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [cell drawData:[_dataAry objectAtIndex:indexPath.row] systemError:_systemError cellBtnTapBlock:^(NSDictionary *dict) {
        BNLog(@"dict--%@", dict);
        BNYKTRechargeViewController *rechargeVC = [[BNYKTRechargeViewController alloc]init];
        rechargeVC.yktInfo = dict;
        rechargeVC.dayLimite = _dayLimite;
        rechargeVC.transLimite = _transLimite;
        [self pushViewController:rechargeVC animated:YES];
    }];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [_dataAry objectAtIndex:indexPath.row];
    NSString *recharge_stuempno = [NSString stringWithFormat:@"%@", [dict valueNotNullForKey:@"recharge_stuempno"]];
    NSString *school_id = [NSString stringWithFormat:@"%@", [dict valueNotNullForKey:@"recharge_school_id"]];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [SVProgressHUD showWithStatus:@"请稍候..."];
        [NewCardApi newPay_Delete_ykt_recordWithRecharge_stuempno:recharge_stuempno
                                                        school_id:school_id
                                                          success:^(NSDictionary *successData) {
                                                              BNLog(@"newPay_getYKTListWithSuccess--%@", successData);
                                                              NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                                                              if ([retCode isEqualToString:kRequestNewSuccessCode]) {
                                                                  [SVProgressHUD dismiss];
                                                                  [_dataAry removeObjectAtIndex:indexPath.row];
//                                                                  [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                                                                  [_tableView reloadData];
                                                              }else{
                                                                  NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                                                  [SVProgressHUD showErrorWithStatus:retMsg];
                                                              }
                                                              
                                                          } failure:^(NSError *error) {
                                                              [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                                          }];
    }
}
- (void)pythonCheckService
{
    NSString *userID = [shareAppDelegateInstance.boenUserInfo.userid copy];
    
    [SVProgressHUD showWithStatus:@"请稍候..."];
    
    __weak typeof(self) weakSelf = self;
    [BannerApi pythonCheckService:userID
                       busiId:_biz_id  //一卡通业务
                        success:^(NSDictionary *successData) {
                            BNLog(@"一卡通pythonCheckService--%@", successData);
                            
                            NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                            
                            if ([retCode isEqualToString:kRequestSuccessCode]) {
                                [SVProgressHUD dismiss];
                                NSDictionary *retData = [successData valueForKey:kRequestReturnData];
                                weakSelf.dayLimite = [[retData valueNotNullForKey:@"day_quota"] integerValue];
                                weakSelf.transLimite = [[retData valueNotNullForKey:@"trans_quota"] integerValue] > 0 ? [[retData valueNotNullForKey:@"trans_quota"] integerValue] : 1000;
                                NSString *busiStatus = [retData valueNotNullForKey:@"busi_status"];
                                NSString *payStatus = [retData valueNotNullForKey:@"pay_status"];
                                NSString *systemStatus = [retData valueNotNullForKey:@"system_status"];

                                if ([payStatus isEqualToString:@"no"] && [busiStatus isEqualToString:@"no"] && [systemStatus isEqualToString:@"no"])
                                {
                                   //服务可用
                                } else {
                                    _systemError = YES;
                                    [weakSelf systemMaintenance];
                                    [weakSelf.tableView reloadData];
                                    
                                }

                            }else{
                                NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                [SVProgressHUD showErrorWithStatus:retMsg];
                            }
                            
                        } failure:^(NSError *error) {
                            [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                        }];
}

- (void)systemMaintenance
{
    __weak typeof(self) weakSelf = self;
    CGRect tableViewRect = weakSelf.tableView.frame;
    _sysTipsLabel.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.tableView.frame = CGRectMake(0, tableViewRect.origin.y + 20*BILI_WIDTH, SCREEN_WIDTH, tableViewRect.size.height);
        weakSelf.sysTipsLabel.alpha = 1.0;
    }];
}

- (void)buttonAction:(UIButton *)button
{
    if (shareAppDelegateInstance.haveGetPrefile == NO) {
        [SVProgressHUD showErrorWithStatus:kHomeLoadingMsg];
        return;
    }
    if (button.tag != 103) {
        //除了充值和说明，其他的账单和挂失需要先绑定一卡通
        if (shareAppDelegateInstance.boenUserInfo.stuempno.length <= 0) {
            //未绑定一卡通
            NSString *btnStr = button.tag == 101 ? @"查看账单" : button.tag == 102 ? @"充值" : @"在线挂失";
            NSString *msgStr = @"使用此功能需要绑定学号，确认绑定吗?";
            shareAppDelegateInstance.alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:msgStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [shareAppDelegateInstance.alertView show];
            
            return ;
        }
    }
    switch (button.tag) {
        case 101: {
            //友盟统计事件流点击
            [MobClick event:@"YTKRecharge_billButton"];
            // 账单
            BNBillViewController *billVC = [[BNBillViewController alloc]init];
            billVC.hidesBottomBarWhenPushed = YES;
            [self pushViewController:billVC animated:YES];
            break;
        }

        case 102: {
            //友盟统计事件流点击
            [MobClick event:@"YTKRecharge_reportLostButton"];
            // 挂失
            BNReportLossVC *lossVC = [[BNReportLossVC alloc]init];
            [self pushViewController:lossVC animated:YES];
            
            break;
        }
        case 103: {
            //友盟统计事件流点击
            [MobClick event:@"YTKRecharge_introductionsButton"];
            // 说明
            BNExplainViewController *explainVC = [[BNExplainViewController alloc] init];
            explainVC.useStyle = ExplainStyleUse;
            [self pushViewController:explainVC animated:YES];
            break;
        }
        case 104: {
            //友盟统计事件流点击
            [MobClick event:@"YTKRecharge_refundButton"];
            // 退费
            BNPublicHtml5BusinessVC *schoolFeesVC = [[BNPublicHtml5BusinessVC alloc] init];
            schoolFeesVC.businessType = Html5BusinessType_ThirdPartyBusiness;
            schoolFeesVC.url = krefundFeesH5Url;
            [self pushViewController:schoolFeesVC animated:YES];

            break;
        }
    }
    
}

- (void)rechargeBtnAction
{
    BNYKTRechargeViewController *rechargeVC = [[BNYKTRechargeViewController alloc]init];
    rechargeVC.dayLimite = _dayLimite;
    rechargeVC.transLimite = _transLimite;
    [self pushViewController:rechargeVC animated:YES];

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
