//
//  BNBillDetailVC.m
//  Wallet
//
//  Created by mac on 15/12/25.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import "BNBillDetailVC.h"

@interface BNBillDetailVC ()

@property (nonatomic) UIImageView *iconImageView;

@end

@implementation BNBillDetailVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationTitle = @"订单详情";
    
    UIScrollView *theScollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge)];
    theScollView.contentSize = CGSizeMake(0, CGRectGetHeight(theScollView.frame)+1);
    theScollView.backgroundColor = UIColor_Gray_BG;
    [self.view addSubview:theScollView];
    
    CGFloat originY = 7*BILI_WIDTH;

    UIView *whiteView0 = [[UIView alloc]initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, 130*BILI_WIDTH)];
    whiteView0.backgroundColor = [UIColor whiteColor];
    [theScollView addSubview:whiteView0];
    
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15*BILI_WIDTH, originY+33*BILI_WIDTH, 47*BILI_WIDTH, 47*BILI_WIDTH)];
    [theScollView addSubview:_iconImageView];
    [self setIconImgView];
    
    originY += 20*BILI_WIDTH;
    
    UILabel *nameLbl = [[UILabel alloc]initWithFrame:CGRectMake(77*BILI_WIDTH, originY, SCREEN_WIDTH-(77+15)*BILI_WIDTH, 65*BILI_WIDTH)];
    nameLbl.font = [UIFont systemFontOfSize:14*BILI_WIDTH];
    nameLbl.backgroundColor = [UIColor clearColor];
    nameLbl.textColor = [UIColor blackColor];
    nameLbl.numberOfLines = 0;
    [theScollView addSubview:nameLbl];
    NSString *goodsName = [NSString stringWithFormat:@"%@", [_dict valueNotNullForKey:@"goods_name"]];
    nameLbl.text = goodsName;
    CGFloat nameLblHeight = [Tools caleNewsCellHeightWithTitle:goodsName font:nameLbl.font width:nameLbl.frame.size.width];
    
    nameLbl.size = CGSizeMake(SCREEN_WIDTH- (77+15)*BILI_WIDTH, nameLblHeight);
    
    originY += CGRectGetHeight(nameLbl.frame)+20*BILI_WIDTH;

    UIView *lineView0 = [[UIView alloc]initWithFrame:CGRectMake(77*BILI_WIDTH, originY, SCREEN_WIDTH-77*BILI_WIDTH, 0.5)];
    lineView0.backgroundColor = UIColor_GrayLine;
    [theScollView addSubview:lineView0];
    
    originY += 23*BILI_WIDTH;

    UILabel *statusLbl = [[UILabel alloc]initWithFrame:CGRectMake(77*BILI_WIDTH, originY, 60*BILI_WIDTH, 25*BILI_WIDTH)];
    statusLbl.font = [UIFont systemFontOfSize:14*BILI_WIDTH];
    statusLbl.backgroundColor = [UIColor clearColor];
    statusLbl.textColor = UIColorFromRGB(0x475b65);
    [theScollView addSubview:statusLbl];

    if ([[_dict valueNotNullForKey:@"pay_status"] isEqualToString:@"success"]) {
        //为success的时候展示业务状态，其他的时候展示支付状态,
        statusLbl.text = [_dict valueNotNullForKey:@"biz_desc"];
    } else{
        statusLbl.text = [_dict valueNotNullForKey:@"pay_desc"];
    }
    CGFloat statusLblWidth = [Tools getTextWidthWithText:statusLbl.text font:statusLbl.font height:statusLbl.frame.size.height];
    statusLbl.frame = CGRectMake(77*BILI_WIDTH, originY, statusLblWidth, 25*BILI_WIDTH);
    
    UILabel *moneyLbl = [[UILabel alloc]initWithFrame:CGRectMake((77+15)*BILI_WIDTH+statusLblWidth, originY, 150*BILI_WIDTH, 25*BILI_WIDTH)];
    moneyLbl.font = [UIFont systemFontOfSize:20*BILI_WIDTH];
    moneyLbl.backgroundColor = [UIColor clearColor];
    moneyLbl.textColor = UIColorFromRGB(0x899fa9);
    [theScollView addSubview:moneyLbl];

    NSString *pay_amount = [NSString stringWithFormat:@"%@元", [_dict valueNotNullForKey:@"pay_amount"]];
//    if ([pay_amount hasPrefix:@"+"] || [pay_amount hasPrefix:@"-"]) {
//        pay_amount = [pay_amount stringByReplacingOccurrencesOfString:@"+" withString:@""];
//        pay_amount = [pay_amount stringByReplacingOccurrencesOfString:@"-" withString:@""];
//    }
    moneyLbl.text = pay_amount;

    NSInteger finishstatus = [[_dict valueNotNullForKey:@"biz_finish"] integerValue];
    //为1的时候业务已经完成，为0的时候表示未完成,
    if (finishstatus == 1) {
        moneyLbl.textColor = UIColor_NewBlueColor;
    } else {
        moneyLbl.textColor = UIColorFromRGB(0xda8f0d);
    }

    originY += CGRectGetHeight(moneyLbl.frame)+23*BILI_WIDTH;
    whiteView0.size = CGSizeMake(SCREEN_WIDTH, originY-7*BILI_WIDTH);

    originY += 12*BILI_WIDTH;

    CGFloat originY1 = originY;
    UIView *whiteView1 = [[UIView alloc]initWithFrame:CGRectMake(0, originY1, SCREEN_WIDTH, 7*40*BILI_WIDTH+10*BILI_WIDTH)];
    whiteView1.backgroundColor = [UIColor whiteColor];
    [theScollView addSubview:whiteView1];
    
    NSArray *leftNameArray ;
    NSDictionary *contengDict;
    
    NSString *coupon_name =[_dict valueWithNoDataForKey:@"coupon_name"];
//    NSString *coupon_name = @"喜付通用优惠券";
    NSInteger addCoupon = 0;
    if (coupon_name && coupon_name.length > 0) {
        addCoupon = 1;
        leftNameArray = @[@"收款方", @"订单号", @"交易单号", @"支付方式",@"优惠券",  @"创建时间", @"付款时间", @"完成时间"];
        contengDict = @{leftNameArray[0] : [_dict valueWithNoDataForKey:@"seller_name"],
                        leftNameArray[1] : [_dict valueWithNoDataForKey:@"biz_no"],
                        leftNameArray[2] : [_dict valueWithNoDataForKey:@"order_no"],
                        leftNameArray[3] : [_dict valueWithNoDataForKey:@"pay_type_name"],
                        leftNameArray[4] : coupon_name,
                        leftNameArray[5] : [_dict valueWithNoDataForKey:@"create_time"],
                        leftNameArray[6] : [_dict valueWithNoDataForKey:@"pay_time"],
                        leftNameArray[7] : [_dict valueWithNoDataForKey:@"finish_time"]
                        };

    } else {
        leftNameArray = @[@"收款方", @"订单号", @"交易单号", @"支付方式", @"创建时间", @"付款时间", @"完成时间"];
        contengDict = @{leftNameArray[0] : [_dict valueWithNoDataForKey:@"seller_name"],
                        leftNameArray[1] : [_dict valueWithNoDataForKey:@"biz_no"],
                        leftNameArray[2] : [_dict valueWithNoDataForKey:@"order_no"],
                        leftNameArray[3] : [_dict valueWithNoDataForKey:@"pay_type_name"],
                        leftNameArray[4] : [_dict valueWithNoDataForKey:@"create_time"],
                        leftNameArray[5] : [_dict valueWithNoDataForKey:@"pay_time"],
                        leftNameArray[6] : [_dict valueWithNoDataForKey:@"finish_time"]
                        };

    }
       for (int i = 0; i < leftNameArray.count; i++) {
        UILabel *leftLbl = [[UILabel alloc]initWithFrame:CGRectMake(15*BILI_WIDTH, originY1, 60*BILI_WIDTH, 40*BILI_WIDTH)];
        leftLbl.font = [UIFont systemFontOfSize:14*BILI_WIDTH];
        leftLbl.backgroundColor = [UIColor clearColor];
        leftLbl.contentMode = UIViewContentModeTopLeft;
        leftLbl.textColor = UIColorFromRGB(0x9d9d9d);
        [theScollView addSubview:leftLbl];
        leftLbl.text = leftNameArray[i];

        NSString *contentText = [contengDict valueForKey:leftNameArray[i]];
        CGFloat contentTextHeight = [Tools caleNewsCellHeightWithTitle:contentText font:[UIFont systemFontOfSize:14*BILI_WIDTH] width:SCREEN_WIDTH-CGRectGetMaxX(leftLbl.frame)-2*10*BILI_WIDTH];
        UILabel *contentLbl = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftLbl.frame)+10*BILI_WIDTH, originY1, SCREEN_WIDTH-CGRectGetMaxX(leftLbl.frame)-2*10*BILI_WIDTH, contentTextHeight + 22 * BILI_WIDTH)];
        contentLbl.font = [UIFont systemFontOfSize:14*BILI_WIDTH];
        contentLbl.backgroundColor = [UIColor clearColor];
        contentLbl.contentMode = UIViewContentModeTopLeft;
        contentLbl.numberOfLines = 0;
        contentLbl.textColor = UIColorFromRGB(0x475b65);
        [theScollView addSubview:contentLbl];
        contentLbl.text = contentText;
        
        originY1 += CGRectGetHeight(contentLbl.frame);
        
        if (i == 3+addCoupon) {
            UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake(0, originY1, SCREEN_WIDTH, 7*BILI_WIDTH)];
            grayView.backgroundColor = UIColor_Gray_BG;
            [theScollView addSubview:grayView];

            originY1 += grayView.frame.size.height;
            
        } else if (i != 3+addCoupon && i != 6+addCoupon){
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, originY1, SCREEN_WIDTH, 0.5)];
            lineView.backgroundColor = UIColor_GrayLine;
            [theScollView addSubview:lineView];
        }
    }
    
    whiteView1.heightValue = originY1-originY; //这里修改一下whiteView1的高度
//    whiteView1.frame = CGRectMake(0, originY1, SCREEN_WIDTH, originY1-originY);
    
    NSString *status = [_dict valueNotNullForKey:@"pay_status"];
    if ([status isEqualToString:@"FAIL"] || [status isEqualToString:@"INIT"]) {
        originY1 += 20*BILI_WIDTH;

        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.tag = 101;
        cancelBtn.frame = CGRectMake(15*BILI_WIDTH, originY1, (SCREEN_WIDTH- 40*BILI_WIDTH)/3, 40*BILI_WIDTH);
        [cancelBtn setupRedBtnTitle:@"取消订单" enable:YES];
        [theScollView addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *backHomeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backHomeBtn.tag = 102;
        backHomeBtn.frame = CGRectMake(25*BILI_WIDTH+(SCREEN_WIDTH- 40*BILI_WIDTH)/3, originY1, (SCREEN_WIDTH- 40*BILI_WIDTH)/3*2, 40*BILI_WIDTH);
        [backHomeBtn setupTitle:[status isEqualToString:@"FAIL"] ? @"重新支付" : @"去支付" enable:YES];
        [theScollView addSubview:backHomeBtn];
        [backHomeBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        originY1 += CGRectGetHeight(backHomeBtn.frame)+30*BILI_WIDTH;
    }
    if (originY1 > theScollView.contentSize.height) {
        theScollView.contentSize = CGSizeMake(0, originY1);
    }
}


- (void)buttonAction:(UIButton *)button
{
    if (button.tag == 101) {
        //取消订单
        NSString *message = @"确定取消订单吗？";
        NSString *coupon_name =[_dict valueWithNoDataForKey:@"coupon_name"];
        if (coupon_name && coupon_name.length > 0) {
            message = @"确定取消订单吗？\n该订单所使用的优惠券将会返还到您的账户里。";
        }
        shareAppDelegateInstance.alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                        message:message
                                                                       delegate:self
                                                              cancelButtonTitle:@"放弃"
                                                              otherButtonTitles:@"确定",nil];
        [shareAppDelegateInstance.alertView show];
        
    } else {
        //支付
        BNPayModel *payModel = [[BNPayModel alloc]init];
        payModel.order_no = [_dict valueNotNullForKey:@"order_no"];
        payModel.biz_no = [_dict valueNotNullForKey:@"biz_no"];
        payModel.pay_type = [_dict valueNotNullForKey:@"pay_type"];
        
        payModel.fromHistoryBillCouponDisable = YES;
        [self goToPayCenterWithPayProjectType:PayProjectTypeOrderDetail
                                     payModel:payModel
                                  returnBlockone:^(PayVCJumpType jumpType, id params) {
                                      if (jumpType == PayVCJumpType_PayCompletedBackHomeVC) {
                                          self.returnRefreshBlock();
                                          [self.navigationController popViewControllerAnimated:YES];
                                      }
                                  }];

    }
}
#pragma mark - alert delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [SVProgressHUD showWithStatus:@"请稍候..."];
        [NewPayOrderCenterApi newPay_CancelOrderWithOrder_no:[_dict valueNotNullForKey:@"order_no"]
                                                      biz_no:[_dict valueNotNullForKey:@"biz_no"]
                                                     success:^(NSDictionary *successData) {
                                                         BNLog(@"订单中心-取消订单--%@", successData);
                                                         NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                                                         if ([retCode isEqualToString:kRequestNewSuccessCode]) {
                                                             [SVProgressHUD showSuccessWithStatus:@"操作成功！"];
                                                             self.returnRefreshBlock();
                                                             [self.navigationController popViewControllerAnimated:YES];
                                                         }else{
                                                             NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                                             [SVProgressHUD showErrorWithStatus:retMsg];
                                                         }
                                                     } failure:^(NSError *error) {
                                                         [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                                     }];

    }
}
- (void)setIconImgView
{
    NSString *busi_type = [NSString stringWithFormat:@"%@", [_dict valueNotNullForKey:@"biz_type"]];
    switch ([busi_type intValue]) {
        case 1:
        {
            //一卡通充值
            _iconImageView.image = [UIImage imageNamed:@"bill_oneCardCharge_icon"];
            break;
        }
            
        case 2:
        {
            //爱心捐助
            _iconImageView.image = [UIImage imageNamed:@"bill_default_icon"];
            break;
        }
        case 3:
        case 6:
        {
            //手机话费
            _iconImageView.image = [UIImage imageNamed:@"bill_mobileCharge_icon"];
            break;
        }
        case 100:
        {
            //钱包提现
            _iconImageView.image = [UIImage imageNamed:@"bill_fetchCash_icon"];
            break;
        }
        case 5:
        {
            //电费充值
            _iconImageView.image = [UIImage imageNamed:@"bill_ElectricCharge_icon"];
            break;
        }
        case 101:
        {
            //费用领取
            _iconImageView.image = [UIImage imageNamed:@"bill_collectFees_icon"];
            break;
        }
        case 7:
        {
            //学校费用缴纳
            _iconImageView.image = [UIImage imageNamed:@"bill_schoolFees_icon"];
            break;
        }
        case 8:
        {
            //网费缴纳
            _iconImageView.image = [UIImage imageNamed:@"netFees_icon"];
            break;
        }
        case 102:
        {
            //小额贷----借钱
            _iconImageView.image = [UIImage imageNamed:@"bill_xiaodai_icon"];
            break;
        }
        case 103:
        {
            //小额贷----还钱
            _iconImageView.image = [UIImage imageNamed:@"bill_xiaodai_icon"];
            break;
        }
        case 9:
        {
            //到店付
            _iconImageView.image = [UIImage imageNamed:@"bill_scan_icon"];
            break;
        }
        case 10:
        {
            //喜付学车
            _iconImageView.image = [UIImage imageNamed:@"billDetail_learn_driving_icon"];
            break;
        }
        case 19:
        {
            //静脉支付
            _iconImageView.image = [UIImage imageNamed:@"bill_VeinPay_icon"];
            break;
        }
        case 20:
        {
            //二维码支付
            _iconImageView.image = [UIImage imageNamed:@"bill_QRPay_icon"];
            break;
        }


        default:
            //默认图标
            _iconImageView.image = [UIImage imageNamed:@"bill_default_icon"];
            break;
    }

}
//支付状态码
//
//New = 'INIT'  # 创建订单、待支付状态
//PayFail = 'FAIL'  # 支付失败
//Paying = 'PAYING'  # 支付中
//PaySuccess = 'SUCCESS'  # 支付成功
//Refunding = 'REFUNDING'  # 退款中
//RefundFail = 'REFUND_FAIL'  # 退款失败
//RefundSuccess = 'REFUND_SUCCESS'  # 退款成功
//Close = 'CLOSE'  # 关闭订单
@end
