//
//  BNLivesViewController.m
//  Wallet
//
//  Created by mac on 14-12-31.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNLivesViewController.h"
#import "BNLivesTableViewCell.h"
#import "BNMobileRechargeResaultVC.h"
#import "BannerApi.h"
#import "BNMobileRechargeVC.h"
#import "BNPayFeesExplainViewController.h"
#import "BNSchoolFeesListViewController.h"
#import "BNReturnMoneyListVC.h"
#import "BNXiHaDaiHomeViewController.h"
#import "BNXiaoDaiExplainViewController.h"
#import "XiaoDaiApi.h"
#import "ElectricChargeMainVC.h"
#import "BNBindYKTViewController.h"
#import "BNCollectFeesListVC.h"
#import "CollectFeesApi.h"
#import "BNPersonalInfoViewController.h"
#import "BNXiaoDaiReadServiceAgreementVC.h"
#import "BNRealNameReviewResultVC.h"
#import "BNNewXiaodaiRealNameInfo.h"




@interface BNLivesViewController ()<UITableViewDataSource, UITableViewDelegate, BNXiaoDaiExplainViewControllerDelegate,UIAlertViewDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic, assign ,getter=isHasNoCollectFees) BOOL hasNoCollectFees;

@end

@implementation BNLivesViewController
static CGFloat  headViewHeight;
static CGFloat  totalRows = 5;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self isHasNotDrawFees];//是否有未领取费用
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationTitle = @"生活";
    self.view.backgroundColor = UIColor_Gray_BG;
    headViewHeight = 40*BILI_WIDTH;
    self.backButton.hidden = YES;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge + 1) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 50 * BILI_WIDTH;
    _tableView.backgroundColor = UIColor_Gray_BG;
    _tableView.backgroundView = [[UIView alloc] initWithFrame:_tableView.frame];
    _tableView.backgroundView.backgroundColor = UIColor_Gray_BG;
    [_tableView registerClass:[BNLivesTableViewCell class] forCellReuseIdentifier:@"BNLivesTableViewCell"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
}

#pragma mark - NSNotification
- (void)bindXueHaoBack:(NSNotification *)noti
{
    NSDictionary *userInfo = noti.userInfo;
    NSString *useType = userInfo[kBindXueHaoUseTypeKey];
    if ([useType isEqualToString:@"BNBindYKTUseTypeXiaodai"]) { // 小额贷绑定学号完成---->>>>
        if ([BNXiaoDaiInfoRecordTool ifHasShowXiaoDaiExplain]) {
            [self checkRealnameStatus];
        } else {
            BNXiaoDaiExplainViewController *explainVC = [[BNXiaoDaiExplainViewController alloc]init];
            explainVC.delegate = self;
            [self pushViewController:explainVC animated:YES];
        }
        return;
    }
    if([useType isEqualToString:@"BNBindYKTUseTypeMobileRecharge"]) // 手机充值绑定学号完成 ---->>>>
    {
        BNMobileRechargeVC *mobileRecharge = [[BNMobileRechargeVC alloc] init];
        [self pushViewController:mobileRecharge animated:YES];
        return;
    }
    if ([useType isEqualToString:@"BNBindYKTUseTypePaySchoolFees"]) { // 学校费用缴纳绑定学号完成---->>>>
        BNSchoolFeesListViewController *schoolFeesVC = [[BNSchoolFeesListViewController alloc] init];
        [self pushViewController:schoolFeesVC animated:YES];
    }
 
}

#pragma mark - delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return totalRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"BNLivesTableViewCell";
    BNLivesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    BOOL isLast = (indexPath.row == totalRows-1) ? YES : NO;
    switch (indexPath.row) {
        case 0:
            [cell drawDataWithType:LivesTypeMobileRecharge isLastLine:isLast];
            break;
        case 1:
            [cell drawDataWithType:LivesTypeDianFei isLastLine:isLast];
            break;
        case 2:
            [cell drawDataWithType:LivesTypeCollectFees isLastLine:isLast isHasNotCollectFees:_hasNoCollectFees];
            break;
        case 3:
            [cell drawDataWithType:LivesTypePaySchoolFees isLastLine:isLast];
            break;
        case 4:
            [cell drawDataWithType:LivesTypeXiaoDai isLastLine:isLast];
            break;
        default:
            break;
    }
   
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return headViewHeight;
}

// 自定义区头
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headViewHeight)];
    headView.backgroundColor = UIColor_Gray_BG;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, headViewHeight - 1, SCREEN_WIDTH, 1)];
    line.backgroundColor = UIColorFromRGB(0xcfcfcf);
    [headView addSubview:line];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*BILI_WIDTH, headViewHeight/2-5*BILI_WIDTH, 200, [BNTools sizeFit:14 six:16 sixPlus:18])];
    titleLabel.text = @"生活服务";
    titleLabel.contentMode = UIViewContentModeBottomLeft;
    titleLabel.textColor = UIColorFromRGB(0xa2a2a2);
    titleLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
    titleLabel.backgroundColor = [UIColor clearColor];
    [headView addSubview:titleLabel];
    
    return headView;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (shareAppDelegateInstance.haveGetPrefile == YES) {
        switch (indexPath.row) {
            case 0:
            {
                if(shareAppDelegateInstance.boenUserInfo.studentno.length <= 0)
                {
                    //未绑定学号
                    shareAppDelegateInstance.alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"使用此功能需要绑定学号，确认绑定吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去绑定", nil];
                    shareAppDelegateInstance.alertView.tag = 101;
                    [shareAppDelegateInstance.alertView show];
                }else{
                    BNMobileRechargeVC *mobileRecharge = [[BNMobileRechargeVC alloc] init];
                    
                    [self pushViewController:mobileRecharge animated:YES];
                }
            }
                break;
            case 1:
            {
                //电费充值入口
                //同步请求checkService，检查服务可用性。
                __block NSDictionary *backDict = nil;
                [BannerApi checkServiceSynchronousStatus:shareAppDelegateInstance.boenUserInfo.userid busiId:@"5" success:^(NSDictionary *successDict) {
                    backDict = successDict;
                    
                } failure:^(NSString *errorMsg) {
                    [SVProgressHUD showErrorWithStatus:errorMsg];
                }];
                if (!backDict) {
                    return ;
                }
                
                [self enterElectricCharge];
            }
                break;
            case 2:
            {
                //费用领取入口
                //同步请求checkService，检查服务可用性。
                __block NSDictionary *backDict = nil;
                [BannerApi checkServiceSynchronousStatus:shareAppDelegateInstance.boenUserInfo.userid busiId:@"6" success:^(NSDictionary *successDict) {
                    backDict = successDict;
                    
                } failure:^(NSString *errorMsg) {
                    [SVProgressHUD showErrorWithStatus:errorMsg];
                }];
                if (!backDict) {
                    return ;
                }
                [self enterCollectFees];
            }
                break;
            case 3:
            {
                //学校费用缴纳
                //同步请求checkService，检查服务可用性。
                __block NSDictionary *backDict = nil;
                [BannerApi checkServiceSynchronousStatus:shareAppDelegateInstance.boenUserInfo.userid busiId:@"1001" success:^(NSDictionary *successDict) {
                    backDict = successDict;
                    
                } failure:^(NSString *errorMsg) {
                    [SVProgressHUD showErrorWithStatus:errorMsg];
                }];
                if (!backDict) {
                    return ;
                }
                
                if ([Tools ifHasShowPaySchoolFeesExplain:shareAppDelegateInstance.boenUserInfo.userid] == YES && shareAppDelegateInstance.boenUserInfo.studentno.length > 0) {
                    BNSchoolFeesListViewController *schoolFeesVC = [[BNSchoolFeesListViewController alloc] init];
                    [self pushViewController:schoolFeesVC animated:YES];
                }else{
                    BNPayFeesExplainViewController *explainVC = [[BNPayFeesExplainViewController alloc] init];
                    [self pushViewController:explainVC animated:YES];
                }
            }
                break;
            case 4:
            {
                //小额贷入口
                //同步请求checkService，检查服务可用性。
                __block NSDictionary *backDict = nil;
                [BannerApi checkServiceSynchronousStatus:shareAppDelegateInstance.boenUserInfo.userid busiId:@"7" success:^(NSDictionary *successDict) {
                    backDict = successDict;
                    
                } failure:^(NSString *errorMsg) {
                    [SVProgressHUD showErrorWithStatus:errorMsg];
                }];
                if (!backDict) {
                    return ;
                }

                [self enterPettyLoan];
            }
                break;
            default:
                break;
        }
    }else{
        [SVProgressHUD showErrorWithStatus:kHomeLoadingMsg];
        return ;
    }
    
}

-(void)enterPettyLoan
{
    // -----http环境测试暂时去掉绑定学号-----
    if(shareAppDelegateInstance.boenUserInfo.studentno.length <= 0)
    {
        //未绑定学号
        shareAppDelegateInstance.alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"使用此功能需要绑定学号，确认绑定吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去绑定", nil];
        shareAppDelegateInstance.alertView.tag = 102;
        [shareAppDelegateInstance.alertView show];
    }else{
        if ([BNXiaoDaiInfoRecordTool ifHasShowXiaoDaiExplain]){ //显示过小贷介绍页查询实名认证状态
            [self checkRealnameStatus];
        } else {
            //未显示介绍页,跳转到介绍页
            BNXiaoDaiExplainViewController *explainVC = [[BNXiaoDaiExplainViewController alloc]init];
            explainVC.delegate = self;
            [self pushViewController:explainVC animated:YES];
        }
    }

}

- (void)enterElectricCharge
{
    ElectricChargeMainVC *vc = [[ElectricChargeMainVC alloc] init];
    [self pushViewController:vc animated:YES];
}

- (void)enterCollectFees
{
    if(shareAppDelegateInstance.boenUserInfo.studentno.length <= 0)
    {
        //未绑定学号，进入绑定学号界面
        BNBindYKTViewController *bindYKTVC = [[BNBindYKTViewController alloc] init];
        bindYKTVC.bindType = BindTypeXueHao;
        bindYKTVC.useType = BNBindYKTUseTypeCollectFees;
        bindYKTVC.yktType = shareAppDelegateInstance.boenUserInfo.yktType;

        [self pushViewController:bindYKTVC animated:YES];
    }
    else
    {
        BNCollectFeesListVC *feesList = [[BNCollectFeesListVC alloc] init];
        [self pushViewController:feesList animated:YES];
    }
}

- (void)checkRealnameStatus
{
    [SVProgressHUD showWithStatus:@"请稍候..."];
    __weak typeof(self) weakSelf = self;
    [XiaoDaiApi newCertifyStatusQuerySuccess:^(NSDictionary *successData) {
        BNLog(@"小额贷---->>>>%@",successData);
        if ([successData[kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
            NSDictionary *dataDic = [successData valueNotNullForKey:kRequestReturnData];
            NSDictionary *applyDic = [dataDic valueNotNullForKey:@"credit_amount_apply"];
            NSString *certifyStatus = [applyDic valueNotNullForKey:@"status"];
            if ([certifyStatus isEqualToString:@"INIT"])
            {//初始,
                [SVProgressHUD dismiss];
                BNPersonalInfoViewController *personalInfoVC = [[BNPersonalInfoViewController alloc] init];
                [weakSelf pushViewController:personalInfoVC animated:YES];
                
            }
            else if ([certifyStatus isEqualToString:@"FALSE"])
            {
                [SVProgressHUD dismiss];
                 BNRealNameReviewResultVC *resultVC = [[BNRealNameReviewResultVC alloc] init];
                NSArray *faceImages = [Tools getLivenessDetectionImages:shareAppDelegateInstance.boenUserInfo.userid];
                if([[BNNewXiaodaiRealNameInfo sharedBNNewXiaodaiRealNameInfo] checkAllPropertyValues] && faceImages.count == 4){//个人信息在内存中存在，且沙盒中有4张图片，跳转到上传失败界面
                    resultVC.reviewResult = RealNameReviewResult_UploadFailed;
                }else{
                    resultVC.reviewResult = RealNameReviewResult_Failed;
                }
                [weakSelf pushViewController:resultVC animated:YES];
            }
            else if ([certifyStatus isEqualToString:@"AUDING"])
            {//审核中
                [SVProgressHUD dismiss];
                BNRealNameReviewResultVC *resultVC = [[BNRealNameReviewResultVC alloc] init];
                resultVC.reviewResult = RealNameReviewResult_Reviewing;
                [weakSelf pushViewController:resultVC animated:YES];
            }
            else
            {//申请成功
                NSString *agreeService = [applyDic valueNotNullForKey:@"agree"];
                if ([agreeService isEqualToString:@"yes"]) { //同意协议，跳转到主页
                    [SVProgressHUD showWithStatus:@"请稍候..."];
                    [XiaoDaiApi newAmoutQuerySuccess:^(NSDictionary *successData) {
                        if ([[successData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                            BNLog(@"额度申请---->>>>>>%@",successData);
                            [SVProgressHUD dismiss];
                            NSDictionary *dataInfo = [successData valueNotNullForKey:kRequestReturnData];
                            BNXiHaDaiHomeViewController *xiaoDaiHome = [[BNXiHaDaiHomeViewController alloc] init];
                            xiaoDaiHome.creditLoanAmount = [[NSString stringWithFormat:@"%@", [dataInfo valueForKey:@"credit_amount"]]doubleValue];
                            xiaoDaiHome.loanRemainAmount = [[NSString stringWithFormat:@"%@", [dataInfo valueForKey:@"remain_amount"]]doubleValue];
                            xiaoDaiHome.overduedLoanCount = [[NSString stringWithFormat:@"%@", [dataInfo valueForKey:@"overdued_loan_count"]]integerValue];
                            xiaoDaiHome.closeReturnCount = [[NSString stringWithFormat:@"%@", [dataInfo valueForKey:@"almost_overdued_loan_count"]]integerValue];
                            [weakSelf pushViewController:xiaoDaiHome animated:YES];

                        }else{
                            NSString *retMsg = [successData valueForKey:kRequestRetMessage];
                            [SVProgressHUD showErrorWithStatus:retMsg];
                        }
                    } failure:^(NSError *error) {
                         [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                        
                    }];
                }
                else//未同意协议，跳转到协议界面.
                {
                    [SVProgressHUD dismiss];
                    NSString *econtract = [applyDic valueNotNullForKey:@"econtract"];
                    BNXiaoDaiReadServiceAgreementVC *readServiceVC = [[BNXiaoDaiReadServiceAgreementVC alloc] init];
                    readServiceVC.protocalType = XiaoDaiProtocalTypeService;
                    readServiceVC.econtractProtocol = econtract;
                    [weakSelf pushViewController:readServiceVC animated:YES];
                }
            }

        }else{
            NSString *retMsg = successData[kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:retMsg];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];
}

/**
 *  是否有未领取的费用
 */
- (void)isHasNotDrawFees
{
    [CollectFeesApi haveNoDrawFeesSuccess:^(NSDictionary *returnData) {
        if ([returnData[kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
            BNLog(@"是否有未领取费用--->>>%@",returnData);
            NSDictionary *returnDic = returnData[kRequestReturnData];
            NSInteger status = [returnDic[@"have_not_draw"] integerValue];
            if (status == 1) {
                _hasNoCollectFees = YES;
            }else{
                _hasNoCollectFees = NO;
            }
            [_tableView reloadData];
        }
        else
        {
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        BNBindYKTViewController *bindYKTVC = [[BNBindYKTViewController alloc] init];
        bindYKTVC.bindType = BindTypeXueHao;
        bindYKTVC.yktType = shareAppDelegateInstance.boenUserInfo.yktType;
        if (alertView.tag == 101) {
            bindYKTVC.useType = BNBindYKTUseTypeMobileRecharge;
        } else if (alertView.tag == 102) {
            bindYKTVC.useType = BNBindYKTUseTypeXiaodai;
        }
        
        [self pushViewController:bindYKTVC animated:YES];
    }
}

#pragma mark - BNXiaoDaiExplainViewControllerDelegatePopPush
-(void)BNXiaoDaiExplainViewControllerDelegatePopPush
{
    [self checkRealnameStatus];
}

@end
