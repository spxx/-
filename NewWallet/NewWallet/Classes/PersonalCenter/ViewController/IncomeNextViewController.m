//
//  IncomeNextViewController.m
//  Wallet
//
//  Created by cyjjkz1 on 15/6/3.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "IncomeNextViewController.h"

@interface IncomeNextViewController ()
@property (nonatomic) UIScrollView *scrollView;

@end

@implementation IncomeNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationTitle = _navigationTitleString;
    [self initStatus];
    [self setupLoadedViews];
}

- (void)initStatus
{
    NSString *status = _dataDic[@"status"];
    if (status.integerValue == 9)
    {
        self.incomeSpendstatus = IncomeSpendStatusProcessing;
    }
    else if (status.integerValue == 10)
    {
        self.incomeSpendstatus = IncomeSpendStatusSucceed;
    }
    else
    {
        self.incomeSpendstatus = IncomeSpendStatusFailed;
    }
}

- (void)setupLoadedViews
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge)];
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height + 1);
    [self.view addSubview:_scrollView];
    
    //上面的按钮
    UIButton *headButton = [UIButton buttonWithType:UIButtonTypeCustom];
    headButton.userInteractionEnabled = NO;
    headButton.frame = CGRectMake(0, 0, _scrollView.frame.size.width, 90 * BILI_WIDTH);
    headButton.backgroundColor = [UIColor colorWithRed:236/255.0 green:237/255.0 blue:236/255.0 alpha:1.0f];
    [headButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [headButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    [headButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [headButton.titleLabel setFont:[UIFont systemFontOfSize:20*BILI_WIDTH]];
    [_scrollView addSubview:headButton];


    // 再搞几个label
    NSString *type = _dataDic[@"busi_type"];
    if (type.integerValue == 4)
    {
        type = @"钱包提现";
    }
    else
    {
        type = @"其他交易";
    }
    NSString *amount = _dataDic[@"amount"];
    amount = [NSString stringWithFormat:@"%.2f",amount.floatValue];
    if (amount.length >= 1 && amount.floatValue < 0)
    {
        amount = [amount substringWithRange:NSMakeRange(1, amount.length - 1)];
    }
    amount = [NSString stringWithFormat:@"%@元",amount];
    
    NSString *remindAmount = _dataDic[@"bndk_amount"];
    remindAmount = [NSString stringWithFormat:@"%.2f元",remindAmount.floatValue];
    
    NSArray *titleArr = @[@"交易类型：",@"交易时间：",@"交易渠道：",@"交易金额：",@"钱包余额："];
    NSArray*contentArr = @[type,_dataDic[@"create_time"],_dataDic[@"bank_name"],amount,remindAmount];
    
    for (int i = 0; i < 5; i ++)
    {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.tag = 100 + i;
        titleLabel.text = titleArr[i];
        titleLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.f];
        titleLabel.font = [UIFont systemFontOfSize:15 * BILI_WIDTH];
        [_scrollView addSubview:titleLabel];
        
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.text = contentArr[i];
        contentLabel.tag = 200 + i;
        contentLabel.font = [UIFont systemFontOfSize:15 * BILI_WIDTH];
        [_scrollView addSubview:contentLabel];
    }
    
    if (self.incomeSpendstatus == IncomeSpendStatusSucceed)//提现成功
    {
        
        [headButton setImage:[UIImage imageNamed:@"submit_fee_success"] forState:UIControlStateNormal];
        [headButton setTitle:@"交易成功" forState:UIControlStateNormal];
        
        /*
        UIView *circle1 = [[UIView alloc] initWithFrame:CGRectMake(20 * BILI_WIDTH, CGRectGetMaxY(headButton.frame) + 17 * BILI_WIDTH, 15*BILI_WIDTH, 15*BILI_WIDTH)];
        circle1.backgroundColor = [UIColor clearColor];
        circle1.layer.cornerRadius = 7.5 * BILI_WIDTH;
        circle1.layer.borderColor = [UIColor greenColor].CGColor;
        circle1.layer.borderWidth = 3.0 ;
        [_scrollView addSubview:circle1];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(circle1.frame.origin.x + circle1.frame.size.width/2.0 - 0.5, CGRectGetMaxY(circle1.frame), 1.0, 23 * BILI_WIDTH)];
        lineView.backgroundColor = [UIColor colorWithRed:254/255.0 green:221/255.0 blue:227/255.0 alpha:1.f];
        [_scrollView addSubview:lineView];
        
        UIView *circle2 = [[UIView alloc] initWithFrame:CGRectMake(circle1.frame.origin.x, CGRectGetMaxY(circle1.frame) + 23 * BILI_WIDTH, 15 * BILI_WIDTH, 15 *BILI_WIDTH)];
        circle2.backgroundColor = [UIColor clearColor];
        circle2.layer.cornerRadius = 7.5 * BILI_WIDTH;
        circle2.layer.borderColor = [UIColor colorWithRed:253/255.0 green:150/255.0 blue:7/255.0 alpha:1.0f].CGColor;
        circle2.layer.borderWidth = 3.0 ;
        [_scrollView addSubview:circle2];
        
        UILabel *successLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(circle1.frame) + 6 * BILI_WIDTH, circle1.frame.origin.y, 200 * BILI_WIDTH, circle1.frame.size.height)];
        successLabel.text = @"钱包提现成功";
        successLabel.textColor = [UIColor greenColor];
        successLabel.font = [UIFont systemFontOfSize:15 * BILI_WIDTH];
        [_scrollView addSubview:successLabel];
        
        UILabel *downLabel = [[UILabel alloc] initWithFrame:CGRectMake(successLabel.frame.origin.x, circle2.frame.origin.y, 200 * BILI_WIDTH, successLabel.frame.size.height)];
        downLabel.text = @"预计24小时以内到账";
        downLabel.textColor = [UIColor colorWithRed:253/255.0 green:150/255.0 blue:7/255.0 alpha:1.0f];
        downLabel.font = [UIFont systemFontOfSize:15 * BILI_WIDTH];
        [_scrollView addSubview:downLabel];
         */
        
//        找到公用的label设置其frame
        for (int i = 0; i < 5; i ++)
        {
            UILabel *titleLabel = (UILabel *)[_scrollView viewWithTag:100 + i];
            UILabel *contentLabel = (UILabel *)[_scrollView viewWithTag:200 + i];
            titleLabel.frame = CGRectMake(20 * BILI_WIDTH, CGRectGetMaxY(headButton.frame) +34 + (15 +  18) * i, 75 * BILI_WIDTH, 15 * BILI_WIDTH);
            
            contentLabel.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame) + 2 * BILI_WIDTH, titleLabel.frame.origin.y, 220 * BILI_WIDTH, CGRectGetHeight(titleLabel.frame));
            
        }
      
    }
    else//提现不成功
    {
        //先搞一个label
        UILabel *reasonLabel = [[UILabel alloc] initWithFrame:CGRectMake(18 * BILI_WIDTH, CGRectGetMaxY(headButton.frame) + 26 * BILI_WIDTH, SCREEN_WIDTH - 2 * 18 *BILI_WIDTH, 50 *BILI_WIDTH)];
        reasonLabel.textColor = [UIColor colorWithRed:168/255.0 green:163/255.0 blue:163/255.0 alpha:1.f];
        reasonLabel.numberOfLines = 0;
        reasonLabel.font = [UIFont systemFontOfSize:13 * BILI_WIDTH];
        [_scrollView addSubview:reasonLabel];
        
        if (self.incomeSpendstatus == IncomeSpendStatusProcessing) {
            [headButton setImage:[UIImage imageNamed:@"Lives_Mobile_Pay_Depositing"] forState:UIControlStateNormal];
            [headButton setTitle:@"交易中..." forState:UIControlStateNormal];
            reasonLabel.text = @"由于银行系统繁忙，目前交易正在进行中。请稍后查 看关注最新结果。";

        }
        else
        {
            [headButton setImage:[UIImage imageNamed:@"Lives_Mobile_Pay_Faile"] forState:UIControlStateNormal];
            [headButton setTitle:@"交易失败" forState:UIControlStateNormal];
            NSString *retmessage = _dataDic[kRequestRetMessage];
            reasonLabel.text = [NSString stringWithFormat:@"[%@]银行扣款已返还至您的喜付钱包余额，本次交易失败。",retmessage];
        }
        
//       找到公用的label设置其frame
        for (int i = 0; i < 5; i ++)
        {
            UILabel *titleLabel = (UILabel *)[_scrollView viewWithTag:100 + i];
            UILabel *contentLabel = (UILabel *)[_scrollView viewWithTag:200 + i];
            titleLabel.frame = CGRectMake(reasonLabel.frame.origin.x, CGRectGetMaxY(reasonLabel.frame) +34 + (15 +  18) * i, 75 * BILI_WIDTH, 15 * BILI_WIDTH);
            
            contentLabel.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame) + 2 * BILI_WIDTH, titleLabel.frame.origin.y, 220 * BILI_WIDTH, CGRectGetHeight(titleLabel.frame));
            
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
