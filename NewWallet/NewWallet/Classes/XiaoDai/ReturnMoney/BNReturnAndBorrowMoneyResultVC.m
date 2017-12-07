//
//  BNReturnAndBorrowMoneyResultVC.m
//  Wallet
//
//  Created by mac on 15/5/6.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNReturnAndBorrowMoneyResultVC.h"
#import "BNXiHaDaiHomeViewController.h"
#import "XiaoDaiApi.h"

@interface BNReturnAndBorrowMoneyResultVC ()

@end

@implementation BNReturnAndBorrowMoneyResultVC

- (void)backButtonClicked:(UIButton *)sender
{
    if (self.navigationController.viewControllers.count > 1) {
        Class class = NSClassFromString(@"BNXiHaDaiHomeViewController");
        
        NSArray *viewControllers = self.navigationController.viewControllers;
        
        for (UIViewController *obj in viewControllers) {
            if ([obj isKindOfClass:class]) {
                [self.navigationController popToViewController:obj animated:YES];
                break;
            }
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (_resultStatus < 3) {
        self.navigationTitle = @"还钱结果";
    } else {
        self.navigationTitle = @"借钱结果";
    }
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT-self.sixtyFourPixelsView.viewBottomEdge)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.contentSize = CGSizeMake(0, scrollView.frame.size.height+1);
    [self.view addSubview:scrollView];
    
    CGFloat originY = 0;

    NSString *messageStr = @"";
    NSString *blueButtonTitleStr = @"我知道了";
    
    UIButton *statusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    statusBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 90*BILI_WIDTH);
    [statusBtn setBackgroundColor:UIColor_Gray_BG];
    [statusBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    statusBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20*BILI_WIDTH];
    statusBtn.userInteractionEnabled = NO;
    [statusBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [scrollView addSubview:statusBtn];
    switch (_resultStatus) {
        case XiaoDaiPayResultStatusReturnMoneySuccess: {
            //还钱成功
            [statusBtn setTitle:@"还钱成功" forState:UIControlStateNormal];
            [statusBtn setImage:[UIImage imageNamed:@"submit_fee_success"] forState:UIControlStateNormal];
            messageStr = [NSString stringWithFormat:@"恭喜你还款成功，本次还款金额：%@元",_moneyStr];
            blueButtonTitleStr = @"我知道了";
            break;
        }
        case XiaoDaiPayResultStatusReturnMoneyFailed: {
            //还钱失败
            [statusBtn setTitle:@"还钱失败" forState:UIControlStateNormal];
            [statusBtn setImage:[UIImage imageNamed:@"Lives_Mobile_Pay_Faile"] forState:UIControlStateNormal];
            messageStr = [NSString stringWithFormat:@"[%@]",_message];
            blueButtonTitleStr = @"重新还钱";
            break;
        }
        case XiaoDaiPayResultStatusReturnMoneyProcessing: {
            //处理中
            [statusBtn setTitle:@"处理中..." forState:UIControlStateNormal];
            [statusBtn setImage:[UIImage imageNamed:@"Lives_Mobile_Pay_Depositing"] forState:UIControlStateNormal];
            messageStr = @"由于银行系统繁忙，扣款还在处理，还款成功后将通过短信通知您。因还款不及时产生的利息由我们承担，请不必担心！";
            blueButtonTitleStr = @"我知道了";
            break;
        }
        case XiaoDaiPayResultStatusBorrowMoneySuccess: {
            //借钱成功
            [statusBtn setTitle:@"借钱成功" forState:UIControlStateNormal];
            [statusBtn setImage:[UIImage imageNamed:@"submit_fee_success"] forState:UIControlStateNormal];
            messageStr = @"正在放款，成功后将以短信通知您，具体到账请以银行为准！";
            blueButtonTitleStr = @"我知道了";
            break;
        }
        case XiaoDaiPayResultStatusBorrowMoneyFailed: {
            //借钱失败
            [statusBtn setTitle:@"借钱失败" forState:UIControlStateNormal];
            [statusBtn setImage:[UIImage imageNamed:@"Lives_Mobile_Pay_Faile"] forState:UIControlStateNormal];
            messageStr = [NSString stringWithFormat:@"[%@]",_message];
            blueButtonTitleStr = @"重新申请";
            break;
        }
        case XiaoDaiPayResultStatusBorrowMoneyProcessing: {
            //处理中
            [statusBtn setTitle:@"处理中..." forState:UIControlStateNormal];
            [statusBtn setImage:[UIImage imageNamed:@"Lives_Mobile_Pay_Depositing"] forState:UIControlStateNormal];
            messageStr = @"借款正在处理中，请稍后再次关注！";
            blueButtonTitleStr = @"我知道了";
            break;
        }

    }
    originY += statusBtn.frame.size.height+23*BILI_WIDTH;
    


    UILabel *messageLbl = [[UILabel alloc]initWithFrame:CGRectMake(10*BILI_WIDTH, originY, SCREEN_WIDTH-2*10*BILI_WIDTH, 1)];
    messageLbl.textColor = UIColor_DarkGray_Text;
    messageLbl.font = [UIFont systemFontOfSize:12*BILI_WIDTH];
    messageLbl.backgroundColor = [UIColor clearColor];
    messageLbl.numberOfLines = 0;
    [scrollView addSubview:messageLbl];
    messageLbl.text = messageStr;

    CGFloat labelHeight = [Tools caleNewsCellHeightWithTitle:messageStr font:messageLbl.font width:messageLbl.frame.size.width];
    messageLbl.frame = CGRectMake(10*BILI_WIDTH, originY, SCREEN_WIDTH-2*10*BILI_WIDTH, labelHeight);
    
    originY += messageLbl.frame.size.height+15*BILI_WIDTH;

    UIButton *blueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    blueButton.frame = CGRectMake(10*BILI_WIDTH, originY, SCREEN_WIDTH - 20*BILI_WIDTH, 40 * BILI_WIDTH);
    [blueButton setupLightBlueBtnTitle:blueButtonTitleStr enable:YES];
    [blueButton addTarget:self action:@selector(blueButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:blueButton];

    
}

- (void)blueButtonAction
{
    [shareAppDelegateInstance refreshPersonProfile];
    switch (_resultStatus) {
        case XiaoDaiPayResultStatusReturnMoneyFailed: {
            //重新还钱
            Class class = NSClassFromString(@"BNReturnMoneyListVC");
            Class classHome = NSClassFromString(@"BNXiHaDaiHomeViewController");

            NSArray *viewControllers = self.navigationController.viewControllers;
            
            for (UIViewController *obj in viewControllers) {
                if ([obj isKindOfClass:class]) {
                    [self.navigationController popToViewController:obj animated:YES];
                    break;
                } else if ([obj isKindOfClass:classHome]) {
                    BNXiHaDaiHomeViewController *homeVC = (BNXiHaDaiHomeViewController *)obj;
                    homeVC.isPop = YES;
                    [self.navigationController popToViewController:homeVC animated:YES];
                    break;
                }
            }
        }
            break;
        case XiaoDaiPayResultStatusReturnMoneySuccess:
        case XiaoDaiPayResultStatusReturnMoneyProcessing:
        case XiaoDaiPayResultStatusBorrowMoneySuccess:
        case XiaoDaiPayResultStatusBorrowMoneyProcessing:
        {//借钱成功、处理中
            Class class = NSClassFromString(@"BNXiHaDaiHomeViewController");
            
            NSArray *viewControllers = self.navigationController.viewControllers;
            
            for (UIViewController *obj in viewControllers) {
                if ([obj isKindOfClass:class]) {
                    BNXiHaDaiHomeViewController *homeVC = (BNXiHaDaiHomeViewController *)obj;
                    homeVC.isPop = YES;
                    [self.navigationController popToViewController:homeVC animated:YES];;
                    break;
                }
            }
        }

            break;
        case XiaoDaiPayResultStatusBorrowMoneyFailed: {
            //借钱失败
            Class class = NSClassFromString(@"BNXiHaDaiHomeViewController");
            
            NSArray *viewControllers = self.navigationController.viewControllers;
            
            for (UIViewController *obj in viewControllers) {
                if ([obj isKindOfClass:class]) {
                    BNXiHaDaiHomeViewController *homeVC = (BNXiHaDaiHomeViewController *)obj;
                    homeVC.isPop = YES;
                    [self.navigationController popToViewController:homeVC animated:YES];
                    break;
                }
            }
        }
            break;
        default:
            break;
    }
   
}

@end
