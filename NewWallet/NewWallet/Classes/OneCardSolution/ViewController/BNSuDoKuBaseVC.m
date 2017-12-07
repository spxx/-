//
//  BNSuDoKuBaseVC.m
//  Wallet
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "BNSuDoKuBaseVC.h"
#import "CustomButton.h"
#import "BNYKTRechargeHomeVC.h"
#import "BNMobileRechargeVC.h"
#import "BNPublicHtml5BusinessVC.h"
#import "ElectricChargeMainNewVC.h"
#import "ElectricChargeMainVC.h"
#import "BNBindYKTViewController.h"
#import "BNXiaoDaiExplainViewController.h"
#import "BNPayFeesExplainViewController.h"
#import "BNNetFeesHomeViewController.h"
#import "BNPersonalInfoViewController.h"
#import "BNRealNameReviewResultVC.h"
#import "BNXiHaDaiHomeViewController.h"
#import "BNXiaoDaiReadServiceAgreementVC.h"
#import "BNCollectFeesListVC.h"

#import "BNNewXiaodaiRealNameInfo.h"

#import "BannerApi.h"
#import "NewElectricFeesApi.h"
#import "XiaoDaiApi.h"
#import "BNAllProjectVC.h"
#import "LDMainViewController.h"

#import "BNBorrowMoneyViewController.h"
#import "ScanViewController.h"
#import "ScanToPayIntroViewController.h"
#import "TraineeHomeViewController.h"
#import "BNAllPayBillViewController.h"

//#import "BNScanedByShopVC.h"
#import "BNMonthlyBillViewController.h"

@interface BNSuDoKuBaseVC ()< BNXiaoDaiExplainViewControllerDelegate, UIAlertViewDelegate>
@property (nonatomic) CustomButton *button;

@end

@implementation BNSuDoKuBaseVC
-(void)viewDidLoad
{
    [super viewDidLoad];
}
- (void)suDoKuButtonAction:(CustomButton *)button
{
    _button = button;
    if (button.biz_name && [button.biz_name isEqualToString:@"更多"]) {
        //更多-所有应用
        BNAllProjectVC *allProjectVC = [[BNAllProjectVC alloc]init];
        allProjectVC.useTypes = UseTypeHomeProject;
        [self pushViewController:allProjectVC animated:YES];
        return;
    }
    
    //友盟事件点击
    [MobClick event:button.biz_id];

    //同步请求java的checkService，检查服务可用性。
    if (button.biz_id && button.biz_id.length > 0) {
        [SVProgressHUD showWithStatus:@"请稍候"];
        [BannerApi checkServiceAsynchronousStatus:shareAppDelegateInstance.boenUserInfo.userid busiId:button.biz_id success:^(NSDictionary *successData) {
            NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
            if ([retCode isEqualToString:kRequestNewSuccessCode]) {
                NSDictionary *retData = [successData valueForKey:kRequestReturnData];
                NSString *biz_open_flag = [NSString stringWithFormat:@"%@", [retData valueWithNoDataForKey:@"biz_open_flag"]];
                if ([biz_open_flag integerValue] == 1) {
                    [SVProgressHUD dismiss];
                    button.needStuempno = [NSString stringWithFormat:@"%@", [retData valueWithNoDataForKey:@"needStuempno"]];
                    [self gotoJumpWithButton:button dict:successData];
                    
                } else {
                    [SVProgressHUD showErrorWithStatus:@"业务暂未开通，敬请期待！"];
                }
            } else {
                [SVProgressHUD showErrorWithStatus:[successData valueNotNullForKey:kRequestRetMessage]];
            }
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:kSystemErrorMsg];
        }];

    } else if (button.biz_h5_url && button.biz_h5_url.length > 0) {
        [SVProgressHUD showWithStatus:@"请稍候"];
        [BannerApi urlCheckServiceAsynchronousStatus:shareAppDelegateInstance.boenUserInfo.userid busiUrl:button.biz_h5_url success:^(NSDictionary *successData) {
            NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
            if ([retCode isEqualToString:kRequestNewSuccessCode]) {
                NSDictionary *retData = [successData valueForKey:kRequestReturnData];
                NSString *biz_open_flag = [NSString stringWithFormat:@"%@", [retData valueWithNoDataForKey:@"biz_open_flag"]];
                if ([biz_open_flag integerValue] == 1) {
                    [SVProgressHUD dismiss];
                    button.needStuempno = [NSString stringWithFormat:@"%@", [retData valueWithNoDataForKey:@"needStuempno"]];
                    [self gotoJumpWithButton:button dict:successData];
                    
                } else {
                    [SVProgressHUD showErrorWithStatus:@"业务暂未开通，敬请期待！"];
                }
            } else {
                [SVProgressHUD showErrorWithStatus:[successData valueNotNullForKey:kRequestRetMessage]];
            }
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:kSystemErrorMsg];
        }];
    }
    
}
- (void)gotoJumpWithButton:(CustomButton *)button dict:(NSDictionary *)backDict
{
    if(shareAppDelegateInstance.boenUserInfo.studentno.length <= 0 && ([button.needStuempno integerValue] == 1))
    {
        //未绑定学号
        shareAppDelegateInstance.alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"使用此功能需要绑定学号，确认绑定吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去绑定", nil];
        shareAppDelegateInstance.alertView.tag = 101;
        [shareAppDelegateInstance.alertView show];
        return;
    }
    NSString *jumpUrl = [[backDict valueForKey:@"data"] valueWithNoDataForKey:@"biz_h5_url"];
    if (!jumpUrl || jumpUrl.length <= 0) {
        jumpUrl = button.biz_h5_url;
    }
    if ((jumpUrl.length > 0 && [jumpUrl hasPrefix:@"xifu://"]) || jumpUrl.length == 0) {
        //原生-页面
        if ([button.biz_id isEqualToString:@""] || button.biz_id.length <= 0) {
            //页面，不是业务。
            if ([jumpUrl isEqualToString:@"xifu://page_redirect/user_page/intern_page"]) {
                //喜付实习生
                TraineeHomeViewController *trainneHomeVC = [[TraineeHomeViewController alloc] init];
                [self pushViewController:trainneHomeVC animated:YES];
                
            } else if ([jumpUrl isEqualToString:@"xifu://page_redirect/user_page/wallet_page"]) {
                //喜付钱包--已废弃
                //            BNBalanceViewController *balanceVC = [[BNBalanceViewController alloc] init];
                //            [self pushViewController:balanceVC animated:YES];
            } else if ([jumpUrl isEqualToString:@"xifu://page_redirect/user_page/bankcard_page"]) {
                //银行卡列表
                if (shareAppDelegateInstance.boenUserInfo.userid.length > 0 && shareAppDelegateInstance.haveGetPrefile == YES) {
                    
                    [self gotoYJPayBankCardList];//易极付银行卡管理
                } else {
                    [SVProgressHUD showErrorWithStatus:kHomeLoadingMsg];
                }
            } else if ([jumpUrl isEqualToString:@"xifu://page_redirect/biz_page/xifu_service_center"]) {
                //喜付服务中心
                BNNetFeesHomeViewController *netFeesHomeVC = [[BNNetFeesHomeViewController alloc] init];
                [self pushViewController:netFeesHomeVC animated:YES];
                
            } else if ([jumpUrl isEqualToString:@"xifu://page_redirect/biz_page/school_service_center"]) {
                //一卡通服务中心
                BNNetFeesHomeViewController *netFeesHomeVC = [[BNNetFeesHomeViewController alloc] init];
                [self pushViewController:netFeesHomeVC animated:YES];
                
            }
            else if ([jumpUrl isEqualToString:@"xifu://page_redirect/user_page/bill_center_page"]) {
                //账单中心
                BNAllPayBillViewController *billVC = [[BNAllPayBillViewController alloc] init];
                [self pushViewController:billVC animated:YES];
                
            }
            return;
        }
        //原生-业务
        switch ([button.biz_id integerValue]) {
            case 1: {
                //一卡通1
                BNYKTRechargeHomeVC  *oneCardHomeVC = [[BNYKTRechargeHomeVC alloc]init];
                oneCardHomeVC.biz_id = button.biz_id;
                [self pushViewController:oneCardHomeVC animated:YES];
                
                break;
            }
            case 3: {
                //手机充值3
//                if(shareAppDelegateInstance.boenUserInfo.studentno.length <= 0)
//                {
//                    //未绑定学号
//                    shareAppDelegateInstance.alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"使用此功能需要绑定学号，确认绑定吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去绑定", nil];
//                    [shareAppDelegateInstance.alertView show];
//                }else{
                    BNMobileRechargeVC *mobileRecharge = [[BNMobileRechargeVC alloc] init];
                    mobileRecharge.biz_id = button.biz_id;
                    [self pushViewController:mobileRecharge animated:YES];
//                }
                
                break;
            }
            case 5: {
                //电费充值5
                //查询电费类型 - 1 预充值、2 账单缴费
                [SVProgressHUD showWithStatus:@"请稍候"];
                [NewElectricFeesApi getqueryEleTypeSuccess:^(NSDictionary *returnData){
                    BNLog(@"getqueryEleTypeSuccess  %@",returnData);
                    NSString *retCode = returnData[kRequestRetCode];
                    NSDictionary *dataDic = returnData[kRequestReturnData];
                    if ([retCode isEqualToString:kRequestNewSuccessCode]) {
                        [SVProgressHUD dismiss];
                        //"type": "1",  // 1 预充值、2 账单缴费
                        if ([dataDic[@"type"] integerValue] == 1) {
                            // 1 预充值
                            ElectricChargeMainVC *vc = [[ElectricChargeMainVC alloc] init];
                            vc.biz_id = button.biz_id;
                            [self pushViewController:vc animated:YES];
                        } else{
                            //2 账单缴费
                            ElectricChargeMainNewVC  *vc = [[ElectricChargeMainNewVC alloc] init];
                            vc.biz_id = button.biz_id;
                            [self pushViewController:vc animated:YES];
                        }
                    } else {
                        [SVProgressHUD showErrorWithStatus:returnData[kRequestRetMessage]];
                    }
                    
                }
                                                   failure:^(NSError *error){
                                                       [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                                   }];
                
                break;
            }
            case 21:{
                [MobClick event:@"1001"];
                BNMonthlyBillViewController *billVC = [[BNMonthlyBillViewController alloc] init];
                [self pushViewController:billVC animated:YES];
                break;
            }
            case 102: {
                //嘻哈贷102
                [self enterPettyLoan];
                break;
            }
            case 101: {
                //费用领取101
//                if(shareAppDelegateInstance.boenUserInfo.studentno.length <= 0)
//                {
//                    //未绑定学号
//                    shareAppDelegateInstance.alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"使用此功能需要绑定学号，确认绑定吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去绑定", nil];
//                    [shareAppDelegateInstance.alertView show];
//                }
//                else
//                {
                    BNCollectFeesListVC *feesList = [[BNCollectFeesListVC alloc] init];
                    [self pushViewController:feesList animated:YES];
//                }
                
                break;
            }
            case 7: {
                // 学校费用缴纳-H5
                break;
            }
            case 8: {
                //网费充值8
                BNNetFeesHomeViewController *netFeesHomeVC = [[BNNetFeesHomeViewController alloc] init];
                netFeesHomeVC.biz_id = button.biz_id;
                [self pushViewController:netFeesHomeVC animated:YES];
                
                break;
            }
            case 9: {
                //扫码支付9
                BOOL hadRead = [[[NSUserDefaults standardUserDefaults] valueForKey:kScanToPayIntroHadRead] boolValue];
                if (hadRead) {
                    ScanViewController *scanVC = [[ScanViewController alloc] init];
                    [self pushViewController:scanVC animated:YES];
                } else {
                    ScanToPayIntroViewController *scanIntroVC = [[ScanToPayIntroViewController alloc] init];
                    [self pushViewController:scanIntroVC animated:YES];
                }
                
                break;
            }
            case 10: {
                //喜付学车10
                LDMainViewController *ldMainVC = [[LDMainViewController alloc] init];
                [self pushViewController:ldMainVC animated:YES];
                
                break;
            }
            case 20: {
                //付款码页面20
                [self QR_CheckIfBindedVein];
                
                break;
            }
                
            default:
                break;
        }
        return;
    }
    
    if (jumpUrl.length > 0 && [jumpUrl hasPrefix:@"http"]) {
        //H5业务
        switch ([button.biz_id integerValue]) {
                
            case 5: {
                //电费充值
                //查询电费类型 - 1 预充值、2 账单缴费
                BNPublicHtml5BusinessVC *schoolFeesVC = [[BNPublicHtml5BusinessVC alloc] init];
                schoolFeesVC.businessType = Html5BusinessType_ThirdPartyBusiness;
                schoolFeesVC.url = jumpUrl;
                [self pushViewController:schoolFeesVC animated:YES];
                break;
            }
            case 101: {
                //费用领取
//                if(shareAppDelegateInstance.boenUserInfo.studentno.length <= 0)
//                {
//                    //未绑定学号
//                    shareAppDelegateInstance.alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"使用此功能需要绑定学号，确认绑定吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去绑定", nil];
//                    [shareAppDelegateInstance.alertView show];
//                }
//                else
//                {
                    BNPublicHtml5BusinessVC *publicHtmlVC = [[BNPublicHtml5BusinessVC alloc] init];
                    publicHtmlVC.businessType = Html5BusinessType_ThirdPartyBusiness;
                    publicHtmlVC.url = jumpUrl;
                    [self pushViewController:publicHtmlVC animated:YES];
//                }
                
                break;
            }
            case 7: {
                //学校费用缴纳
                if (shareAppDelegateInstance.haveGetPrefile == NO) {
                    [SVProgressHUD showErrorWithStatus:kHomeLoadingMsg];
                    return;
                }
                if ([Tools ifHasShowPaySchoolFeesExplain:shareAppDelegateInstance.boenUserInfo.userid] == YES && shareAppDelegateInstance.boenUserInfo.studentno.length > 0) {
                    
                    BNPublicHtml5BusinessVC *publicHtmlVC = [[BNPublicHtml5BusinessVC alloc] init];
                    publicHtmlVC.businessType = Html5BusinessType_ThirdPartyBusiness;
                    publicHtmlVC.url = jumpUrl;
                    [self pushViewController:publicHtmlVC animated:YES];
                    
                }else{
                    BNPayFeesExplainViewController *explainVC = [[BNPayFeesExplainViewController alloc] init];
                    explainVC.h5Url = jumpUrl;
                    explainVC.bindStumpData = button;
                    [self pushViewController:explainVC animated:YES];
                }
                break;
            }
            case 17: {
                ////报名缴费
//                if(shareAppDelegateInstance.boenUserInfo.studentno.length <= 0)
//                {
//                    //未绑定学号
//                    shareAppDelegateInstance.alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"使用此功能需要绑定学号，确认绑定吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去绑定", nil];
//                    [shareAppDelegateInstance.alertView show];
//                }
//                else
//                {
                    BNPublicHtml5BusinessVC *publicHtmlVC = [[BNPublicHtml5BusinessVC alloc] init];
                    publicHtmlVC.businessType = Html5BusinessType_ThirdPartyBusiness;
                    publicHtmlVC.url = jumpUrl;
                    [self pushViewController:publicHtmlVC animated:YES];
//                }
                
                break;
            }
            default: {
                if (button.fromHomeScan == YES) {
                    //来自首页-相机扫描二维码。控制它绑定结束不跳到业务里面。
                    if ([jumpUrl hasSuffix:@"scene=canteen"]) {
                        //扫描的是食堂二维码
                        button.fromCanteen = YES;

                        BNPublicHtml5BusinessVC *publicHtmlVC = [[BNPublicHtml5BusinessVC alloc] init];
                        publicHtmlVC.businessType = Html5BusinessType_NativeBusiness;
                        publicHtmlVC.url = jumpUrl;
                        publicHtmlVC.bindStumpData = button;
                        [self pushViewController:publicHtmlVC animated:YES];
                    } else {
                        //其他的H5，直接跳转。
                        BNPublicHtml5BusinessVC *publicHtmlVC = [[BNPublicHtml5BusinessVC alloc] init];
                        publicHtmlVC.businessType = Html5BusinessType_NativeBusiness;
                        publicHtmlVC.url = jumpUrl;
                        [self pushViewController:publicHtmlVC animated:YES];
                    }

                } else {
                    //其他的H5，直接跳转。
                    BNPublicHtml5BusinessVC *publicHtmlVC = [[BNPublicHtml5BusinessVC alloc] init];
                    publicHtmlVC.businessType = Html5BusinessType_NativeBusiness;
                    publicHtmlVC.url = jumpUrl;
                    [self pushViewController:publicHtmlVC animated:YES];
                }
                
                break;
            }
        }
        
    }
}
-(void)enterPettyLoan
{
    // -----http环境测试暂时去掉绑定学号-----
//    if(shareAppDelegateInstance.boenUserInfo.studentno.length <= 0)
//    {
//        //未绑定学号
//        shareAppDelegateInstance.alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"使用此功能需要绑定学号，确认绑定吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去绑定", nil];
//        [shareAppDelegateInstance.alertView show];
//    }else{
        if ([BNXiaoDaiInfoRecordTool ifHasShowXiaoDaiExplain]){ //显示过小贷介绍页查询实名认证状态
            [self checkRealnameStatus];
        } else {
            //未显示介绍页,跳转到介绍页
            BNXiaoDaiExplainViewController *explainVC = [[BNXiaoDaiExplainViewController alloc]init];
            explainVC.delegate = self;
            [self pushViewController:explainVC animated:YES];
        }
//    }
    
}
- (void)checkRealnameStatus
{
    [SVProgressHUD showWithStatus:@"请稍候..."];
    __weak typeof(self) weakSelf = self;
    [XiaoDaiApi newCertifyStatusQuerySuccess:^(NSDictionary *successData) {
        BNLog(@"小额贷----认证进度查询>>>>%@",successData);
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
                            BNLog(@"额度查询---->>>>>>%@",successData);
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

#pragma mark -UIAlertViewDelegate
#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101) {
        if (buttonIndex == 1) {
            //绑定一卡通，改为H5页面
            BNPublicHtml5BusinessVC *bindOneCardVCVC = [[BNPublicHtml5BusinessVC alloc] init];
            bindOneCardVCVC.businessType = Html5BusinessType_NativeBusiness;
            bindOneCardVCVC.url = kBindStumpH5Url;
            bindOneCardVCVC.bindStumpData = _button;
            [self pushViewController:bindOneCardVCVC animated:YES];

        }
    } else if (alertView.tag == 107) {
        if (buttonIndex == 1) {
            BNPublicHtml5BusinessVC *bankVC = [[BNPublicHtml5BusinessVC alloc] init];
            bankVC.businessType = Html5BusinessType_NativeBusiness;
            bankVC.url = KUserCenter_VeinInfo_H5BindVC;
            bankVC.backBlock = ^(NSDictionary *dict){
                //静脉信息已绑定-进入二维码页面
//                BNScanedByShopVC *scanedByShopVC = [[BNScanedByShopVC alloc]init];
//                [self pushViewController:scanedByShopVC animated:YES];
            };
            [self pushViewController:bankVC animated:YES];
        }
    }
    
}


////绑定学号完成
//- (void)bindXueHaoBack:(NSNotification *)noti
//{
//    CustomButton *button = [[CustomButton alloc]init];
//    button.biz_id = _tempBizId;
//    [self suDoKuButtonAction:button];
//    
////    NSDictionary *userInfo = noti.userInfo;
////    NSString *useType = userInfo[kBindXueHaoUseTypeKey];
////    if ([useType isEqualToString:@"BNBindYKTUseTypeXiaodai"]) { // 小额贷绑定学号完成---->>>>
////        if ([BNXiaoDaiInfoRecordTool ifHasShowXiaoDaiExplain]) {
////            [self checkRealnameStatus];
////        } else {
////            BNXiaoDaiExplainViewController *explainVC = [[BNXiaoDaiExplainViewController alloc]init];
////            explainVC.delegate = self;
////            [self pushViewController:explainVC animated:YES];
////        }
////        return;
////    }
////    if([useType isEqualToString:@"BNBindYKTUseTypeMobileRecharge"]) // 手机充值绑定学号完成 ---->>>>
////    {
////        BNMobileRechargeVC *mobileRecharge = [[BNMobileRechargeVC alloc] init];
////        [self pushViewController:mobileRecharge animated:YES];
////        return;
////    }
////    if ([useType isEqualToString:@"BNBindYKTUseTypePaySchoolFees"]) { // 学校费用缴纳绑定学号完成---->>>>
////       
////    }
//}

#pragma mark -BNXiaoDaiExplainViewControllerDelegate
- (void)BNXiaoDaiExplainViewControllerDelegatePopPush
{
    [self checkRealnameStatus];
}

- (void)QR_CheckIfBindedVein
{
    [SVProgressHUD showWithStatus:@"请稍候..."];
    [NewPayOrderCenterApi veinInfo_checkIfBindedVeinWithSuccess:^(NSDictionary *returnData) {
        BNLog(@"查询是否已绑定静脉--->>>>%@",returnData);
        //返回值："is_bound": 0 // 0-未绑定 1-已绑定*/
        if ([[returnData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestNewSuccessCode]) {
            [SVProgressHUD dismiss];
            NSDictionary *datas = [returnData valueWithNoDataForKey:kRequestReturnData];
            NSString *is_bound = [datas valueWithNoDataForKey:@"is_bound"];
            if ([is_bound integerValue] == 0) {
                //静脉信息-未绑定，H5页面绑定
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"使用二维码付款功能\n需要绑定静脉信息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"马上绑定", nil];
                alert.tag = 107;
                shareAppDelegateInstance.alertView = alert;
                [alert show];
                
            } else {
                //静脉信息已绑定-进入二维码页面
//                BNScanedByShopVC *scanedByShopVC = [[BNScanedByShopVC alloc]init];
//                [self pushViewController:scanedByShopVC animated:YES];
                
            }
        }else{
            NSString *msg = [returnData valueNotNullForKey:kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:msg];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];
    
    
}
@end
