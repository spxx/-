//
//  BNBorrowMoneyBankCardVC.m
//  Wallet
//
//  Created by mac1 on 15/4/30.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNBorrowMoneyBankCardVC.h"

#import "BNPayCreditBankCardCell.h"
#import "CardApi.h"
#import "BNXiFuWalletCell.h"

#define kBank_CMB_alertStr @"目前暂不支持放款到招商银行卡！"
#define kBank_OtherBank3Verify_alertStr @"由于喜付安全等级升级，您现在需要在“我 - 银行卡”里面将此银行卡解绑然后重新用新的安全绑定方式进行绑卡即可借款！"

static NSString *const kSelectedBankCardAlertStr = @"由于银行相关规定，目前借款暂时只支持发到“银行卡”。";

@interface BNBorrowMoneyBankCardVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UITableView *tableView;


@end

@implementation BNBorrowMoneyBankCardVC
- (void)setupLoadedView
{
    self.view.backgroundColor = UIColor_Gray_BG;
    
//    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0 , SCREEN_WIDTH, 80)];
//    footerView.backgroundColor = UIColor_Gray_BG;
//    
//    UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
//    button.frame = CGRectMake(20*BILI_WIDTH, 0, SCREEN_WIDTH - 20*BILI_WIDTH * 2, 79);
//    [button setTitle:@"添加银行卡" forState:UIControlStateNormal];
//    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//    [button setTitleColor:UIColor_Blue_BarItemText forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
//    [footerView addSubview:button];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 80.0;
//    _tableView.tableFooterView = footerView;
    _tableView.backgroundColor = UIColor_Gray_BG;
    [_tableView registerClass:[BNPayCreditBankCardCell class] forCellReuseIdentifier:@"PayCardCell"];
    [self.view addSubview:_tableView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationTitle = @"银行卡列表";
        
    [self setupLoadedView];
    [self refreshBankList];
}

#pragma mark - datasource and delegate  12月1日 需求更改，必须绑卡才能借钱
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _bankCardsListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(self.useStyle == bankCardViewControllerUseStyleXiaoDai)
//    {
//        if (indexPath.row == 0) {
//       
//            BNXiFuWalletCell *xifuCell = [tableView dequeueReusableCellWithIdentifier:@"xifuCell"];
//        
//            if (!xifuCell) {
//            xifuCell = [[BNXiFuWalletCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"xifuCell"];
//        
//            }
//            return xifuCell;
//        }
//        BNPayCreditBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayCardCell" forIndexPath:indexPath];
//        [cell drawData:[_bankCardsListArray objectAtIndex:indexPath.row - 1] selectCardNoStr:_selectCardNoStr];
//        return cell;
//    }
//    else
//    {
        BNPayCreditBankCardCell *theCell = [tableView dequeueReusableCellWithIdentifier:@"PayCardCell" forIndexPath:indexPath];
        [theCell drawData:[_bankCardsListArray objectAtIndex:indexPath.row] selectCardNoStr:_selectCardNoStr];
        return theCell;
//    }

    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 以前选择银行卡的逻辑----->>>>>>  提现使用，12月1日 需求更改，必须绑卡才能借钱
    NSDictionary *backBankDict;
    NSDictionary *bankCardInfo = [self.bankCardsListArray objectAtIndex:indexPath.row];
    NSString *bankMainTain = [bankCardInfo valueNotNullForKey:@"maintain_bank"];
    NSString *bankVerifyType = [NSString stringWithFormat:@"%@",[bankCardInfo valueNotNullForKey:@"verifyType"]];
    
    //maintain_bank = yes 表示维护中，no表示可用
    //verifyType = 3 表示3要素验证，4表示4要素验证
    
    if ([bankMainTain isEqualToString:@"yes"]) {
        [SVProgressHUD showErrorWithStatus:@"银行维护中"];
    } else if ([bankVerifyType isEqualToString:@"3"]) {
        if ([[bankCardInfo valueNotNullForKey:@"bankType"] isEqualToString:@"CMB"]) {
            //招商银行，则直接提示不支持。
            [SVProgressHUD showErrorWithStatus:kBank_CMB_alertStr];
        } else {
            [SVProgressHUD showErrorWithStatus:kBank_OtherBank3Verify_alertStr];
        }
    } else {
        _selectCardNoStr = [NSString stringWithFormat:@"%@",[bankCardInfo valueNotNullForKey:@"bankCardNo"]];
        backBankDict = bankCardInfo;
        
        [self.tableView reloadData];
        
        [self performSelector:@selector(goToDelegateAndPop:) withObject:backBankDict afterDelay:.2];
    }
    
}
- (void)goToDelegateAndPop:(NSDictionary *)backBankDict
{
    if ([self.delegate respondsToSelector:@selector(selectPayBankBorrowMoneyBankCardVCWithBankInfo:)]) {
        [_delegate selectPayBankBorrowMoneyBankCardVCWithBankInfo:backBankDict];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

////添加银行卡按钮
//- (void)buttonAction
//{
//    [self gotoYJPayBankCardList];
//}

- (void)refreshBankList
{
    [SVProgressHUD showWithStatus:@"请稍候..."];
    [CardApi CardListWithUser:shareAppDelegateInstance.boenUserInfo.userid success:^(NSDictionary *successData) {
        BNLog(@"successData--%@",successData);
        NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
        
        if ([retCode isEqualToString:kRequestSuccessCode]) {
            [SVProgressHUD dismiss];
            
            NSDictionary *data = [successData valueForKey:kRequestReturnData];
            if (data[@"binded_cards"]) {
                NSArray *bindedOnlineArray = data[@"binded_cards"];
                if (bindedOnlineArray.count > 0) {
                    self.bankCardsListArray = bindedOnlineArray;
                    NSDictionary *bankCardInfo = [bindedOnlineArray objectAtIndex:0];
                    _selectCardNoStr = [bankCardInfo valueNotNullForKey:@"bankCardNo"];
                    [self.tableView reloadData];
                }
            }
        } else {
            NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:retMsg];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];
}

@end
