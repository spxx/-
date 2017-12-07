//
//  BNPayResultVC.m
//  Wallet
//
//  Created by mac on 15/12/24.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import "BNPayResultVC.h"
#import "BNAllPayBillViewController.h"

@implementation BNPayResultVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationTitle = @"充值结果";
    self.backButton.hidden = YES;
    self.view.backgroundColor = UIColor_Gray_BG;
    
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge+7*BILI_WIDTH, SCREEN_WIDTH, 325*BILI_WIDTH)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    
    UIImage *btnImg = [UIImage imageNamed:@"PayCenter_payResault_success"];
    if (![[_dict valueNotNullForKey:@"pay_status"] isEqualToString:@"SUCCESS"]) {
        btnImg = [UIImage imageNamed:@"PayCenter_payResault_failed"];
    }
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-70*BILI_WIDTH)/2, 90*BILI_WIDTH, 70*BILI_WIDTH, 70*BILI_WIDTH)];
    imgView.image = btnImg;
    [whiteView addSubview:imgView];
    
    UILabel *descriptionLbl = [[UILabel alloc]initWithFrame:CGRectMake(15*BILI_WIDTH, CGRectGetMaxY(imgView.frame)+10*BILI_WIDTH, SCREEN_WIDTH-2*15*BILI_WIDTH, 20*BILI_WIDTH)];
    descriptionLbl.font = [UIFont systemFontOfSize:14*BILI_WIDTH];
    descriptionLbl.textAlignment = NSTextAlignmentCenter;
    descriptionLbl.textColor = [UIColor blackColor];
    [whiteView addSubview:descriptionLbl];
    descriptionLbl.text = [_dict valueNotNullForKey:@"memo"];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(whiteView.frame)-58*BILI_WIDTH, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = UIColor_GrayLine;
    [whiteView addSubview:line];
    
    UIButton *detailOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    detailOrderBtn.tag = 101;
    detailOrderBtn.frame = CGRectMake(15*BILI_WIDTH, CGRectGetHeight(whiteView.frame)-(36+11)*BILI_WIDTH, 120*BILI_WIDTH, 36*BILI_WIDTH);
    [detailOrderBtn setupTitle:@"查看订单" enable:YES];
    [whiteView addSubview:detailOrderBtn];
    [detailOrderBtn addTarget:self action:@selector(detailOrderBtnAction) forControlEvents:UIControlEventTouchUpInside];

    UIButton *backHomeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backHomeBtn.tag = 102;
    backHomeBtn.frame = CGRectMake(SCREEN_WIDTH- (15+120)*BILI_WIDTH, CGRectGetMinY(detailOrderBtn.frame), 120*BILI_WIDTH, 36*BILI_WIDTH);
    [backHomeBtn setupTitle:@"返回首页" enable:YES];
    [whiteView addSubview:backHomeBtn];
    [backHomeBtn addTarget:self action:@selector(backHomeBtnAction) forControlEvents:UIControlEventTouchUpInside];
}
- (void)detailOrderBtnAction
{
    //detailOrderBtn
    BNAllPayBillViewController *billVC = [[BNAllPayBillViewController alloc] init];
    billVC.returnsBlock = ^(){
        [self backHomeBtnAction];
    };
    [self pushViewController:billVC animated:YES];
}
- (void)backHomeBtnAction
{
    //backHomeBtn
    PayResultVCBackType payResultVCBackType = PayResultVCBackType_BackHomeVC;
    self.backBolck(payResultVCBackType);
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
