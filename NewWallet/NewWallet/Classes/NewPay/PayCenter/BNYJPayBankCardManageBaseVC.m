//
//  BNYJPayBankCardManageBaseVC.m
//  Wallet
//
//  Created by mac on 16/6/15.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "BNYJPayBankCardManageBaseVC.h"
#import "NewYJFPayApi.h"
#import "BNBindYKTViewController.h"

@interface BNYJPayBankCardManageBaseVC ()<UIAlertViewDelegate>

@end

@implementation BNYJPayBankCardManageBaseVC

#pragma - YJPay
- (void)gotoYJPayBankCardList
{
    [self getYJFBindid];
}
- (void)getYJFBindid
{
    [NewYJFPayApi getYJFBindidWithSuccess:^(NSDictionary *successData) {
        BNLog(@"getYJFBindidWithSuccess -- %@", successData);
        NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
        if ([retCode isEqualToString:kRequestSuccessCode]) {
            [SVProgressHUD dismiss];
            NSDictionary *dataDict = [successData valueNotNullForKey:kRequestReturnData];
            NSString *realName = [NSString stringWithFormat:@"%@", [dataDict valueWithNoDataForKey:@"real_name"]];
            NSString *yjf_bind_id = [NSString stringWithFormat:@"%@", [dataDict valueWithNoDataForKey:@"yjf_bind_id"]];
            
            NSString *userid = yjf_bind_id;
            NSDictionary *init = @{kYJPayServer:YJPayServerType, kYJPayPartnerId:YJPayPartnerid, kYJPaySecurityKey: YJPaySecKey}; [YJPayService initEnvironment:init error:nil];
            NSDictionary *info;
            if (realName && realName.length > 0) {
                YJExtraParams *extraParams = [[YJExtraParams alloc] init];
                YJExtraObject *realNmae = [YJExtraObject extObjWith:realName stable:YES];//(YES:不可修改[默认], NO:可修改)
                extraParams.realName = realNmae;
                
                info = @{kYJPayUserId: userid,
                                       kYJPayUserType: MEMBER_TYPE_YIJI,
                                       kYJPayExtraParams:extraParams,//绑卡参数，非必传
                                       };
            } else {
                info = @{kYJPayUserId: userid,
                                       kYJPayUserType: MEMBER_TYPE_YIJI,
                                       };
            }

            [YJPayService startBindCardList:info delegate:nil error:nil];//

        } else {
            NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:retMsg];
//            //没有姓名，要先去绑定一卡通---不走下面绑一卡通了（改了，没有名字也不用去绑一卡通了，因为融智学院根本没接入一卡通。所以改成不绑学号也可以绑银行卡了）
//            shareAppDelegateInstance.alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"使用此功能需要绑定学号，确认绑定吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"绑定", nil];
//            [shareAppDelegateInstance.alertView show];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];
}

//#pragma - UIAlertViewDelegate
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 1) {
//        BNBindYKTViewController *bindXueHaoVC = [[BNBindYKTViewController alloc] init];
//        bindXueHaoVC.bindType = BindTypeXueHao;
//        bindXueHaoVC.useType = BNBindYKTUseTypePaySchoolFees;
//        bindXueHaoVC.yktType = shareAppDelegateInstance.boenUserInfo.yktType;
//        [self pushViewController:bindXueHaoVC animated:YES];
//    }
//}

@end
