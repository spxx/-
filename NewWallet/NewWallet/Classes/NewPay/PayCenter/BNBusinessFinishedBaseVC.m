//
//  BNBusinessFinishedBaseVC.m
//  Wallet
//
//  Created by mac on 16/1/12.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "BNBusinessFinishedBaseVC.h"
#import "BNPayResultShareH5VC.h"

@interface BNBusinessFinishedBaseVC ()

@property (nonatomic) BNPayModel *basePayModel;
@property (nonatomic) PayProjectType payProjectType;

@end

@implementation BNBusinessFinishedBaseVC

- (void)goToPayCenterWithPayProjectType:(PayProjectType)payProjectType payModel:(BNPayModel *)payModel returnBlockone:(ReturnBlock)returnBlock
{
    _payProjectType = payProjectType;
    _basePayModel = payModel;
    [SVProgressHUD showWithStatus:@"请稍候..."];

    [NewPayOrderCenterApi newPay_QueryOrderInfoWithOrder_no:_basePayModel.order_no
                                                     biz_no:_basePayModel.biz_no
                                                    success:^(NSDictionary *successData) {
                                                        BNLog(@"订单中心-获取订单详情 --%@", successData);
                                                        NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                                                        if ([retCode isEqualToString:kRequestNewSuccessCode]) {
                                                            [SVProgressHUD dismiss];
                                                            NSDictionary *dataDict = [successData valueNotNullForKey:kRequestReturnData];
                                                            
                                                            _basePayModel.order_no = [dataDict valueNotNullForKey:@"order_no"];
                                                            _basePayModel.biz_no = [dataDict valueNotNullForKey:@"biz_no"];
                                                            _basePayModel.biz_type = [dataDict valueForKey:@"biz_type"];

                                                            _basePayModel.salePrice = [dataDict valueNotNullForKey:@"pay_amount"];
                                                            _basePayModel.goodsName = [dataDict valueNotNullForKey:@"goods_name"];
                                                            _basePayModel.sellerName = [dataDict valueNotNullForKey:@"seller_name"];
                                                            _basePayModel.pay_type_list = [dataDict valueForKey:@"pay_type_list"];
                                                            
                                                            _basePayModel.discount_amount = [dataDict valueForKey:@"discount_amount"];
                                                            _basePayModel.coupon_name = [dataDict valueForKey:@"coupon_name"];
                                                            
                                                            //弹出半透明模态UINavigationController
                                                            BNPayCenterHomeVC *payVC = [[BNPayCenterHomeVC alloc] init];
                                                            payVC.payProjectType = _payProjectType;
                                                            payVC.payModel = _basePayModel;
                                                            payVC.returnBlock = ^(PayVCJumpType jumpType, id params) {
                                                                if (jumpType == PayVCJumpType_PayCompletedBackHomeVC) {
                                                                    returnBlock(PayVCJumpType_PayCompletedBackHomeVC,params);
 
                                                                } else {
                                                                    //跳转H5结果页面
                                                                    NSString *resultUrl = [NSString stringWithFormat:@"%@?order_no=%@", kPayResultH5Url, _basePayModel.order_no];
                                                                    BNPayResultShareH5VC *webViewController = [[BNPayResultShareH5VC alloc] init];
                                                                    webViewController.url = resultUrl;
                                                                    webViewController.backBtnBlock = ^(PayVCJumpType jumpType){
                                                                        returnBlock(jumpType, @{});
                                                                    };
                                                                    [self pushViewController:webViewController animated:NO];
                                                                }
                                                            };
                                                            self.definesPresentationContext = YES;
                                                            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:payVC];
                                                            nav.navigationBarHidden = YES;
                                                            nav.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                                                            nav.view.backgroundColor = [UIColor clearColor];
                                                            [self presentViewController:nav animated:NO completion:nil];
                                                        }else{
                                                            NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                                            [SVProgressHUD showErrorWithStatus:retMsg];
                                                        }
                                                    } failure:^(NSError *error) {
                                                        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                                    }];
    
}




@end
