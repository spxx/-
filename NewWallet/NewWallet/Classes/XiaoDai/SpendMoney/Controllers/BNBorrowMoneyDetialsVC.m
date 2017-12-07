//
//  BNBorrowMoneyDetialsVC.m
//  Wallet
//
//  Created by mac1 on 15/5/6.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNBorrowMoneyDetialsVC.h"
#import "XiaoDaiApi.h"
#import "BNXiaoDaiReadServiceAgreementVC.h"

#define kBorrowMoneyLab Tag 500

@implementation BNBorrowMoneyDetialsVC

- (void)setupLoadedView
{
    CGFloat contentSizeY = SCREEN_HEIGHT == 480 ? 500 : SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge + 1;
    UIScrollView *theScollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT- self.sixtyFourPixelsView.viewBottomEdge)];
    theScollView.contentSize = CGSizeMake(0, contentSizeY);
    [self.view addSubview:theScollView];

    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *borrowResultBKView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90 *BILI_WIDTH)];
    borrowResultBKView.backgroundColor = UIColorFromRGB(0xe9e9e9);
    [theScollView addSubview:borrowResultBKView];
    
    UIButton *resultView = [UIButton buttonWithType:UIButtonTypeCustom];
    resultView.backgroundColor = [UIColor clearColor];
    resultView.frame = CGRectMake(0, (90-40)*BILI_WIDTH/2.0, SCREEN_WIDTH, 40 * BILI_WIDTH);
    [resultView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [resultView.titleLabel setFont:[UIFont systemFontOfSize:[BNTools sizeFit:25 six:30 sixPlus:35]]];
    if (_resultStyle == BNXiaoDaiLoanStatusSucceed)
    {
        [resultView setTitle:@"借款成功 !" forState:UIControlStateNormal];
        [resultView setImage:[UIImage imageNamed:@"submit_fee_success"] forState:UIControlStateNormal];
    }
    else if(_resultStyle == BNXiaoDaiLoanStatusChuLiZhong)
    {
        [resultView setTitle:@"处理中 !" forState:UIControlStateNormal];
        [resultView setImage:[UIImage imageNamed:@"Lives_Mobile_Pay_Depositing"] forState:UIControlStateNormal];
    }
    else{
        [resultView setTitle:@"借款失败 !" forState:UIControlStateNormal];
        [resultView setImage:[UIImage imageNamed:@"Lives_Mobile_Pay_Faile"] forState:UIControlStateNormal];
    }
    [borrowResultBKView addSubview:resultView];
    
    NSMutableArray *detialsTitle = nil;
    if (_returnStyle == BNXiaoDaiReturnStyleStages) {
        detialsTitle = [@[@"业务流水号:", @"借款类型:", @"借款金额:", @"剩余还款金额:", @"剩余还款期数:",@"下期还款金额:",@"下期还款日期:",@"最终还款日期:"] mutableCopy];
    }else{
        detialsTitle = [@[@"业务流水号:", @"借款类型:", @"借款金额:", @"剩余还款金额:",@"最终还款日期:"] mutableCopy];
    }
    NSString *statusStr = [_detailDic valueNotNullForKey:@"status"];
    NSString *errorMsgStr = [NSString stringWithFormat:@"[%@]",[_detailDic valueNotNullForKey:@"result_message"]];

    if ([statusStr isEqualToString:@"FALSE"]) {
        [detialsTitle insertObject:errorMsgStr atIndex:0];
    }
    UIFont *font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
    NSAttributedString *detialTxt = [[NSAttributedString alloc] initWithString:[detialsTitle lastObject] attributes:@{NSFontAttributeName:font}];
    CGSize titleSize = [detialTxt size];
    for (int i = 0; i < [detialsTitle count]; i++) {
        UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(30 * BILI_WIDTH, CGRectGetMaxY(borrowResultBKView.frame)+2*5*BILI_WIDTH + i*40 * BILI_WIDTH, SCREEN_WIDTH-2*30*BILI_WIDTH, 40 * BILI_WIDTH)];
        tipsLabel.backgroundColor = [UIColor clearColor];
        tipsLabel.textColor = [UIColor lightGrayColor];
        tipsLabel.textAlignment = NSTextAlignmentLeft;
        tipsLabel.tag = i + 1;
        tipsLabel.font = font;
        tipsLabel.text = detialsTitle[i];
        [theScollView addSubview:tipsLabel];
    }
    
    font = [UIFont systemFontOfSize:[BNTools sizeFit:16 six:18 sixPlus:20]];
    for (int i = 0; i < [detialsTitle count]; i++) {
        UILabel *detialLabel = [[UILabel alloc] initWithFrame:CGRectMake(30 * BILI_WIDTH + 5 + titleSize.width, CGRectGetMaxY(borrowResultBKView.frame)+2 *5*BILI_WIDTH + i*40 * BILI_WIDTH, SCREEN_WIDTH - (30 * BILI_WIDTH + 5 + titleSize.width), 40 * BILI_WIDTH)];
        detialLabel.backgroundColor = [UIColor clearColor];
        detialLabel.textColor = [UIColor blackColor];
        detialLabel.textAlignment = NSTextAlignmentLeft;
        detialLabel.font = font;
        detialLabel.text = self.detailArray[i];
       [theScollView addSubview:detialLabel];
    }
    
    
    font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
    NSAttributedString *checkTxt = [[NSAttributedString alloc] initWithString:@"查看" attributes:@{NSFontAttributeName:font}];
    CGSize checkSize = [checkTxt size];
    UILabel *lab = (UILabel *)[theScollView viewWithTag:[detialsTitle count]];
    //BNLog(@"%@",NSStringFromCGRect(lab.frame));
    UILabel *checkLabel = [[UILabel alloc] initWithFrame:CGRectMake(lab.frame.origin.x, lab.frame.origin.y+40 * BILI_WIDTH , checkSize.width, 40 * BILI_WIDTH)];
    checkLabel.backgroundColor = [UIColor clearColor];
    checkLabel.textColor = [UIColor lightGrayColor];
    checkLabel.textAlignment = NSTextAlignmentLeft;
    checkLabel.font = font;
    checkLabel.text = @"查看";
   // BNLog(@"%@",NSStringFromCGRect(checkLabel.frame));
    
    NSAttributedString *protocolTxt = [[NSAttributedString alloc] initWithString:@"《嘻哈贷电子借据》" attributes:@{NSFontAttributeName:font}];
    CGSize btnSize = [protocolTxt size];
    UIButton *borrowProtocolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    borrowProtocolBtn.frame = CGRectMake(CGRectGetMaxX(checkLabel.frame) + 5, CGRectGetMinY(checkLabel.frame), SCREEN_WIDTH- CGRectGetMaxX(checkLabel.frame) + 5, 40*BILI_WIDTH);
    [borrowProtocolBtn setTitle:@"《嘻哈贷电子借据》" forState:UIControlStateNormal];
    [borrowProtocolBtn setTitleColor:UIColorFromRGB(0x0D5CEF) forState:UIControlStateNormal];
    [borrowProtocolBtn addTarget:self action:@selector(protocolButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [borrowProtocolBtn.titleLabel setFont:font];
    [borrowProtocolBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, CGRectGetWidth(borrowProtocolBtn.frame) - btnSize.width)];
    [theScollView addSubview:checkLabel];
    [theScollView addSubview:borrowProtocolBtn];
}

#pragma mark -ButtonClick
- (void)protocolButtonClick:(UIButton *)button
{
    //查看嘻哈带电子借据界面
    [SVProgressHUD showWithStatus:@"请稍候..."];
    [XiaoDaiApi queryReceiptWithOrderNumber:_detailDic[@"order_no"] success:^(NSDictionary *returnData) {
        if ([[returnData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode])
        {
            [SVProgressHUD dismiss];
            BNXiaoDaiReadServiceAgreementVC *agreeVC = [[BNXiaoDaiReadServiceAgreementVC alloc] init];
            agreeVC.protocalType = XiaoDaiProtocalTypeElectronTicketOnlyRead;
            agreeVC.econtractProtocol = returnData[@"data"][@"loan_receipt"];
            [self pushViewController:agreeVC animated:YES];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:returnData[@"retmsg"]];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];
}


- (void)viewDidLoad
{
    BNLog(@"%@",self.detailDic);
    [super viewDidLoad];
    NSString *returnType = self.detailDic[@"repayment_type"];
    self.returnStyle = [returnType isEqualToString:@"SCHEDULED"] ? BNXiaoDaiReturnStyleAnyTime:BNXiaoDaiReturnStyleStages;
    self.navigationTitle = @"借款明细";
    [self packageData];
    [self setupLoadedView];
}

- (void)packageData
{
    if (_returnStyle == BNXiaoDaiReturnStyleStages)
    {   //分期
        NSString *orderNumber = _detailDic[@"order_no"];
        NSString *type = @"分期还";
        NSString *amount = [NSString stringWithFormat:@"%@",_detailDic [@"amount"]];
        NSString *remindAmount = [NSString stringWithFormat:@"%@",_detailDic[@"remain_amount"]];
        NSString *remindQi = [NSString stringWithFormat:@"%@期",_detailDic[@"remain_installments"]];
        NSString *nextAmount = [NSString stringWithFormat:@"%@元",_detailDic[@"current_installment_amount"]];
        NSString *nextDay = [NSString stringWithFormat:@"每月%@号",_detailDic[@"current_installment_repay_date"]];
        NSString *lastTime = _detailDic[@"repay_date"];
        _detailArray = [[NSMutableArray alloc] initWithObjects:orderNumber,type,amount,remindAmount,remindQi,nextAmount,nextDay,lastTime,nil];
    }
    else
    {  //随时还
        NSString *orderNumber = _detailDic[@"order_no"];
        NSString *type = @"随时还";
        NSString *amount = [NSString stringWithFormat:@"%@",_detailDic [@"amount"]];
        NSString *remindAmount = [NSString stringWithFormat:@"%@",_detailDic[@"current_installment_amount"]];
        NSString *lastTime = _detailDic[@"repay_date"];
         _detailArray = [[NSMutableArray alloc] initWithObjects:orderNumber,type,amount,remindAmount,lastTime,nil];
    }
    NSString *statusStr = [_detailDic valueNotNullForKey:@"status"];
    if ([statusStr isEqualToString:@"FALSE"]) {
        [_detailArray insertObject:@"" atIndex:0];
    }
}
@end
