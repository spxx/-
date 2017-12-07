//
//  ChargeResultVC.m
//  Wallet
//
//  Created by mac1 on 15/8/4.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "ChargeResultVC.h"
#import "ElectricChargeMainVC.h"
#import "BNBlackHUD.h"
#import "BNElectricChargeResultInfo.h"

@interface ChargeResultVC ()

@end

@implementation ChargeResultVC

NSString *resonStr = @"[电费充值失败]。如有疑问，请联系客服：028-61831329";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"充值结果";
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self setupSubViews];
    
}

- (void)setupSubViews
{
   
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge )];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, scrollView.frame.size.height + 1);
    [self.view addSubview:scrollView];
   
    
    
    UIButton *headButton = [UIButton buttonWithType:UIButtonTypeCustom];
    headButton.frame = CGRectMake(0, 0, SCREEN_WIDTH, 90 * BILI_WIDTH);
    headButton.userInteractionEnabled = NO;
    [headButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [headButton setBackgroundImage:[Tools imageWithColor:UIColor_Gray_BG andSize:headButton.frame.size] forState:UIControlStateNormal];
    [headButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [headButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [scrollView addSubview:headButton];
    
    
    CGFloat topMargin = 0.0;
   
    if (self.status == ElectricChargeStatusSucceed)
    {
        //充值成功
        [SVProgressHUD dismiss];

        [headButton setImage:[UIImage imageNamed:@"submit_fee_success"] forState:UIControlStateNormal];
        [headButton setTitle:@"充值成功" forState:UIControlStateNormal];
        topMargin = CGRectGetMaxY(headButton.frame) + 26 * BILI_WIDTH;
    }
    else if(self.status == ElectricChargeStatusUnderWay)
    {
        //充值进行中
        [SVProgressHUD dismiss];

        [headButton setImage:[UIImage imageNamed:@"Lives_Mobile_Pay_Depositing"] forState:UIControlStateNormal];
        [headButton setTitle:@"充值中..." forState:UIControlStateNormal];
        
        UIView *middleView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headButton.frame), scrollView.frame.size.width, 60 * BILI_WIDTH)];
        middleView.layer.borderColor = UIColor_GrayLine.CGColor;
        middleView.layer.borderWidth = 0.5;
        [scrollView addSubview:middleView];
        

        NSString *string = @"正在充值，请稍候查看电费余额。";
        UILabel *middleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * BILI_WIDTH, 0, middleView.frame.size.width - 2 * 20 *BILI_WIDTH, middleView.frame.size.height)];
        middleLabel.textColor = [UIColor colorWithRed:144/ 255.0 green:144 / 255.0 blue:144 / 255.0 alpha:1.f];
        middleLabel.text = string;
        middleLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
        [middleView addSubview:middleLabel];
        
        topMargin = CGRectGetMaxY(middleView.frame) + 26 * BILI_WIDTH;
    }
    else
    {
        //充值失败
        [headButton setImage:[UIImage imageNamed:@"Lives_Mobile_Pay_Faile"] forState:UIControlStateNormal];
        [headButton setTitle:@"充值失败" forState:UIControlStateNormal];
        
        NSString *errorMsg = [BNElectricChargeResultInfo sharedBNElectricChargeResultInfo].retMsg;
        if (errorMsg.length > 0) {
            resonStr = [NSString stringWithFormat:@"[%@]如有疑问，请联系客服：028-61831329\n\n", errorMsg];
        }
        UILabel *resonLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * BILI_WIDTH, CGRectGetMaxY(headButton.frame) + 10*BILI_WIDTH, SCREEN_WIDTH - 40 * BILI_WIDTH, 75 * BILI_WIDTH)];
        resonLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
        resonLabel.textColor = UIColor_Gray_Text;
        resonLabel.backgroundColor = [UIColor whiteColor];
        resonLabel.text = resonStr;
        resonLabel.numberOfLines = 0;
        resonLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [scrollView addSubview:resonLabel];
        
       
        if (self.type == chargeResultUseTypeCharge)//从充值页面过来
        {
            UIButton *finishedButton = [UIButton buttonWithType:UIButtonTypeCustom];
            finishedButton.frame = CGRectMake(10, CGRectGetMaxY(resonLabel.frame) + 50 * BILI_WIDTH, SCREEN_WIDTH - 20, 40 * BILI_WIDTH);
            [finishedButton setupTitle:@"确定" enable:YES];
            [finishedButton addTarget:self action:@selector(finishButtonAction) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:finishedButton];
            self.backButton.hidden = YES;
            
            [SVProgressHUD showErrorWithStatus:errorMsg];
        }
        return;
    }
    [SVProgressHUD dismiss];

    
    NSInteger count = 4;
    NSArray *titleArray = @[@"交易商品:",@"交易时间:",@"支付渠道:",@"支付金额:"];
    NSString *value1 = [NSString stringWithFormat:@"电费充值-%@(%@元)",_roomStr,_moneyStr];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [dateFormatter dateFromString:_timeStr];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *value2 = [dateFormatter stringFromDate:date];
    NSString *value3 = _channelStr;
    NSString *value4 = [NSString stringWithFormat:@"%@元",_moneyStr];
    NSArray *contentArray = @[value1,value2,value3,value4];
    for (int i = 0; i < count ; i ++)
    {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(19 * BILI_WIDTH,topMargin + (13 + 20) * i * BILI_WIDTH, 70 * BILI_WIDTH, 13 * BILI_WIDTH)];
        titleLabel.text = titleArray[i];
        titleLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
        titleLabel.tag = i;
        titleLabel.textColor = [UIColor colorWithRed:144/ 255.0 green:144 / 255.0 blue:144 / 255.0 alpha:1.f];
        [scrollView addSubview:titleLabel];
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame) + 3 * BILI_WIDTH, titleLabel.frame.origin.y, 200 * BILI_WIDTH, CGRectGetHeight(titleLabel.frame))];
        contentLabel.text = contentArray[i];
        contentLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
        contentLabel.textColor = [UIColor blackColor];
        [scrollView addSubview:contentLabel];
    }
    
    if (self.type == chargeResultUseTypeCharge)//从充值页面过来
    {
        UILabel *label = (UILabel *)[scrollView viewWithTag:2];
        UIButton *finishedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        finishedButton.frame = CGRectMake(10, CGRectGetMaxY(label.frame) + 50 * BILI_WIDTH, SCREEN_WIDTH - 20, 40 * BILI_WIDTH);
        [finishedButton setupTitle:@"完成" enable:YES];
        [finishedButton addTarget:self action:@selector(finishButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:finishedButton];
        
        self.backButton.hidden = YES;

    }
    else//从订单中心过来
    {
        //do nothing
    }
}




- (void)finishButtonAction
{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[ElectricChargeMainVC class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
