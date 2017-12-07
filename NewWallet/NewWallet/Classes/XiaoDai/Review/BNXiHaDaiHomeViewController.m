//
//  BNXiHaDaiHomeViewController.m
//  Wallet
//
//  Created by mac1 on 15/4/30.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNXiHaDaiHomeViewController.h"

#import "BNXiHaDaiHeadView.h"

#import "BNBorrowMoneyViewController.h"
#import "BNReturnMoneyListVC.h"
#import "CardApi.h"
#import "BNXiaoDaiAboutVC.h"
#import "XiaoDaiApi.h"

@interface BNXiHaDaiHomeViewController ()<BNXiHaDaiHeadDelegate, BNReturnMoneyListVCDelegate, BNBorrowMoneyViewControllerDelegate ,UIAlertViewDelegate>

@property (weak,  nonatomic) BNXiHaDaiHeadView *xiaoDaiHeadView;
@property (nonatomic) NSArray *bankListArray;

@end

@implementation BNXiHaDaiHomeViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [SVProgressHUD dismiss];
    NSMutableArray *array = [self.navigationController.viewControllers mutableCopy];
    Class class = NSClassFromString(@"BNXiaoDaiExplainViewController");
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    
    for (UIViewController *obj in viewControllers) {
        if ([obj isKindOfClass:class]) {
            [array removeObject:obj];
            [self.navigationController setViewControllers:array];
            break;
        }
    }
    if (_isPop) {
        [self refreshXiaoDaiInfo];
    }
    _isPop = NO;
}

- (void)backButtonClicked:(UIButton *)sender
{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:NSClassFromString(@"BNHomeViewController")]) {
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
    }
}

- (void)setupLoadedView
{
    [super setupLoadedView];
    
    self.view.backgroundColor = UIColorFromRGB(0xc43439);
    self.bankListArray = [@[] copy];
    
    self.navigationTitle = @"嘻哈贷";
    
    UIButton *rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItem.frame = CGRectMake(SCREEN_WIDTH - 50, 0, 50, 44);
    [rightItem setImage:[UIImage imageNamed:@"SchoolFees_info_HeighLight"] forState:UIControlStateHighlighted];
    [rightItem setImage:[UIImage imageNamed:@"SchoolFees_info"] forState:UIControlStateNormal];
    [rightItem addTarget:self action:@selector(aboutAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavigationBar addSubview:rightItem];

    
    UIView *amountBKView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(self.baseScrollView.frame) * KViewBiLi)];
    amountBKView.backgroundColor = [UIColor whiteColor];
    [self.baseScrollView addSubview:amountBKView];
    
    UIView *criditAmountBKView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(amountBKView.frame) * kInfoBiLi)];
    criditAmountBKView.backgroundColor = UIColorFromRGB(0xc43439);
    [amountBKView addSubview:criditAmountBKView];
    
    BNXiHaDaiHeadView *headView = [[BNXiHaDaiHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(amountBKView.frame)) amount:self.creditLoanAmount hasSpend:(self.creditLoanAmount - self.loanRemainAmount)<=0 ? .0 : (self.creditLoanAmount - self.loanRemainAmount) leftAmount:self.loanRemainAmount];
    headView.delegate = self;
    _xiaoDaiHeadView = headView;
    
    headView.backgroundColor = [UIColor clearColor];
    [amountBKView addSubview:headView];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(amountBKView.frame), SCREEN_WIDTH, 1000)];
    footView.backgroundColor = UIColor_Gray_BG;
    [self.baseScrollView addSubview:footView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(amountBKView.frame) + kSectionHeight, SCREEN_WIDTH - 40, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
    label.text = @"本业务由哈尔滨银行支持运营";
    [self.baseScrollView addSubview:label];
    
    UIButton *spendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    spendBtn.frame = CGRectMake(10 * BILI_WIDTH, CGRectGetHeight(self.baseScrollView.frame) - (3 * 40 *BILI_WIDTH + kSectionHeight), SCREEN_WIDTH - 2 *10 *BILI_WIDTH, 40 *BILI_WIDTH);
    [spendBtn setupRedBtnTitle:@"我要用钱" enable:YES];
    [spendBtn addTarget:self action:@selector(spendMoneyAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(10 * BILI_WIDTH, CGRectGetMaxY(spendBtn.frame) + kSectionHeight, SCREEN_WIDTH - 2 *10 *BILI_WIDTH, 40 *BILI_WIDTH);
    [returnBtn setupLightBlueBtnTitle:@"我要还钱" enable:YES];
    [returnBtn addTarget:self action:@selector(returnMoneyAction) forControlEvents:UIControlEventTouchUpInside];

    [self.baseScrollView addSubview:spendBtn];
    [self.baseScrollView addSubview:returnBtn];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupLoadedView];
    [_xiaoDaiHeadView startAnimition];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [SVProgressHUD dismiss];
}

#pragma mark - button action
- (void)spendMoneyAction
{
    [SVProgressHUD showErrorWithStatus:@"根据相关政策，借款业务已关闭"];
    return;
    /* 12月1日 需求更改，必须绑卡才能借钱
      if ([shareAppDelegateInstance.boenUserInfo.isCert isEqualToString:@"yes"]) {//已经首次绑卡，表示有易极付账户
          BNBorrowMoneyViewController *borrow = [[BNBorrowMoneyViewController alloc] init];
          borrow.delegate = self;
          borrow.bankListArray = bandCardsArray;
          borrow.creditLoanAmount = self.creditLoanAmount;
          borrow.overduedLoanCount = self.overduedLoanCount;
          borrow.loanRemainAmount = self.loanRemainAmount;
          [self pushViewController:borrow animated:YES];

          
      }else{//没有进行过首次绑卡，表示没有极付账户
          shareAppDelegateInstance.alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未绑定银行卡，现在去绑定吧！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
          [shareAppDelegateInstance.alertView show];
      }
     */
     __weak typeof(self) weakSelf = self;
    [Tools checkUserBindCardArrayWithResult:^(NSArray *bindCardArray) {
        BNBorrowMoneyViewController *borrow = [[BNBorrowMoneyViewController alloc] init];
        borrow.delegate = self;
        borrow.bankListArray = bindCardArray;
        borrow.creditLoanAmount = weakSelf.creditLoanAmount;
        borrow.overduedLoanCount = weakSelf.overduedLoanCount;
        borrow.loanRemainAmount = weakSelf.loanRemainAmount;
        [weakSelf pushViewController:borrow animated:YES];
    } notBind:^{
        shareAppDelegateInstance.alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未绑定银行卡，现在去绑定吧！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [shareAppDelegateInstance.alertView show];
    }];
    
}
#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self gotoYJPayBankCardList];

//        shareAppDelegateInstance.popToViewController = @"BNXiHaDaiHomeViewController";
//        BNPayModel *payModel = [[BNPayModel alloc]init];
//        BNAddBankCardViewController *addBankCardVC = [[BNAddBankCardViewController alloc] init];
//        addBankCardVC.useStyle = AddBankCardViewControllerUseStyleBindCardNormal;
//        [addBankCardVC rechargeWithInfo:payModel popToViewController:@"BNXiHaDaiHomeViewController"];
//        [self pushViewController:addBankCardVC animated:YES];
    }
}

- (void)returnMoneyAction
{
    __weak typeof(self) weakSelf = self;
    [Tools checkUserBindCardArrayWithResult:^(NSArray *bindCardArray) {
        BNReturnMoneyListVC *returnVC = [[BNReturnMoneyListVC alloc] init];
        returnVC.delegate = self;
        returnVC.creditLoanAmount = weakSelf.creditLoanAmount;
        returnVC.overduedLoanCount = weakSelf.overduedLoanCount;
        returnVC.loanRemainAmount = weakSelf.loanRemainAmount;
        [weakSelf pushViewController:returnVC animated:YES];
        
    } notBind:^{
        shareAppDelegateInstance.alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未绑定银行卡，现在去绑定吧！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [shareAppDelegateInstance.alertView show];
    }];
}
- (void)aboutAction:(UIButton *)btn
{
    BNXiaoDaiAboutVC *aboutVC = [[BNXiaoDaiAboutVC alloc] init];
    [self pushViewController:aboutVC animated:YES];

}
#pragma mark - BNReturnMoneyListVCDelegate
-(void)BNReturnMoneyListVCDelegatePopPush
{
    [self spendMoneyAction];
}
#pragma mark - BNXiHaDaiHeadDelegate
#pragma mark - BNBorrowMoneyViewControllerDelegate
-(void)BNBorrowMoneyViewControllerDelegatePopPush
{
    [self returnMoneyAction];
}
- (void)xiHaDaiHeadAnimitionStoped
{
    UIView *tipsView = [self getOverduedTipsView];
    __weak typeof(self) weakSelf = self;
    
    if (tipsView == nil) {
        return;
    }
    [UIView animateWithDuration:1.0
                     animations:^{
                         tipsView.frame = CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, CGRectGetHeight(tipsView.frame));
                         weakSelf.baseScrollView.frame = CGRectMake(0, CGRectGetMaxY(tipsView.frame), SCREEN_WIDTH, CGRectGetHeight(weakSelf.baseScrollView.frame));
                     }
                     completion:^(BOOL finished) {
                         [weakSelf performSelector:@selector(hiddenTipsView:) withObject:tipsView afterDelay:3];
                         
                     }];
}
- (void)hiddenTipsView:(UIView *)tipsView
{
     __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:2.0
                     animations:^{
                         tipsView.frame = CGRectMake(0,  self.sixtyFourPixelsView.viewBottomEdge-60*BILI_WIDTH, SCREEN_WIDTH, CGRectGetHeight(tipsView.frame));
                         weakSelf.baseScrollView.frame = CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, CGRectGetHeight(weakSelf.baseScrollView.frame));
                     }];

}
- (UIView *)getOverduedTipsView
{
    CGFloat tipsHeight = 60*BILI_WIDTH;
    NSString *tipsString = nil;
    UIView *tipsView = nil;
    if (self.overduedLoanCount > 0 && self.closeReturnCount > 0) {
        tipsString = [NSString stringWithFormat:@"您有%li笔借款已经逾期，%li笔借款快要到期，可在\"我要还钱\"查看详情，请尽快还款!", (long)self.overduedLoanCount, (long)self.closeReturnCount];
    }else if(self.overduedLoanCount > 0 || self.closeReturnCount > 0){
        if (self.overduedLoanCount > 0) {
            tipsString = [NSString stringWithFormat:@"您有%li笔借款已经逾期，可在\"我要还钱\"查看详情，请尽快还款!", (long)self.overduedLoanCount];
        }
        
        if (self.closeReturnCount > 0) {
            tipsString = [NSString stringWithFormat:@"您有%li笔借款快要到期，可在\"我要还钱\"查看详情, 请尽快还款!", (long)self.closeReturnCount];
        }
        tipsView = [[UIView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge-60*BILI_WIDTH, SCREEN_WIDTH, tipsHeight)];
        tipsView.backgroundColor = UIColorFromRGB(0xFBCB0E);
        UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, SCREEN_WIDTH - 10, tipsHeight)];
        tipsLabel.backgroundColor = [UIColor clearColor];
        tipsLabel.textColor = UIColorFromRGB(0xe25258);
        tipsLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
        tipsLabel.text = tipsString;
        tipsLabel.numberOfLines = 0;
        [tipsView addSubview:tipsLabel];
        [self.view insertSubview:tipsView belowSubview:self.sixtyFourPixelsView];
    }
    
    
    return tipsView;
}

- (void)refreshXiaoDaiInfo
{
    //额度申请接口
    __weak typeof (self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"请稍候..."];
    [XiaoDaiApi newAmoutQuerySuccess:^(NSDictionary *successData) {
        if ([[successData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
            BNLog(@"额度申请---->>>>>>%@",successData);
            [SVProgressHUD dismiss];
            NSDictionary *dataInfo = [successData valueNotNullForKey:kRequestReturnData];
            weakSelf.creditLoanAmount = [[NSString stringWithFormat:@"%@", [dataInfo valueForKey:@"credit_amount"]]doubleValue];
            weakSelf.loanRemainAmount = [[NSString stringWithFormat:@"%@", [dataInfo valueForKey:@"remain_amount"]]doubleValue];
            weakSelf.overduedLoanCount = [[NSString stringWithFormat:@"%@", [dataInfo valueForKey:@"overdued_loan_count"]]integerValue];
            weakSelf.closeReturnCount = [[NSString stringWithFormat:@"%@", [dataInfo valueForKey:@"almost_overdued_loan_count"]]integerValue];
            _xiaoDaiHeadView.amount = self.creditLoanAmount;
            _xiaoDaiHeadView.spend = (self.creditLoanAmount - self.loanRemainAmount)<=0 ? .0 : (self.creditLoanAmount - self.loanRemainAmount);
            _xiaoDaiHeadView.left = self.loanRemainAmount;
            
            [_xiaoDaiHeadView startAnimition];
        }else{
            NSString *retMsg = [successData valueForKey:kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:retMsg];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
        
    }];
    
   
    
}
@end
