//
//  BNBorrowMoneyViewController.m
//  Wallet
//
//  Created by mac1 on 15/4/30.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNBorrowMoneyViewController.h"

#import "BNBorrowMoneyBankCardVC.h"

#import "BNReturnWayViewController.h"

#import "BNUploadTools.h"

#import "ReturnOrBorrowRecordViewController.h"

#import "XiaoDaiApi.h"

#import "BNReturnWayViewController.h"
#import "CardApi.h"

@interface BNBorrowMoneyViewController () <BNBorrowMoneyBankCardVCDelegate,UITextFieldDelegate>
@property (nonatomic) UITextField *moneyAmountTF;
@property (nonatomic) UILabel *bankCardLabel;
@property (nonatomic) UIButton *sureButton;
@property (nonatomic) NSString *selectCardNoStr;
@property (nonatomic) UILabel *noRemainAmountLab;

@end
@implementation BNBorrowMoneyViewController

-(void)removeMiddleVC
{
    NSMutableArray *array = [self.navigationController.viewControllers mutableCopy];
    Class class = NSClassFromString(@"BNReturnMoneyListVC");
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    
    for (UIViewController *obj in viewControllers) {
        if ([obj isKindOfClass:class]) {
            [array removeObject:obj];
            [self.navigationController setViewControllers:array];
            break;
        }
    }
    
}

- (void)setupLoadedView
{
    [super setupLoadedView];
    
    self.navigationTitle = @"我要用钱";
    self.view.backgroundColor = UIColor_Gray_BG;
    if (self.loanRemainAmount > 0 && _overduedLoanCount <=0) {
        UIView *moneyAndBankCardBK = [[UIView alloc] initWithFrame:CGRectMake(-1, kSectionHeight, SCREEN_WIDTH + 2, 2 * 45 * BILI_WIDTH)];
        moneyAndBankCardBK.backgroundColor = [UIColor whiteColor];
        moneyAndBankCardBK.layer.borderColor = UIColor_GrayLine.CGColor;
        moneyAndBankCardBK.layer.borderWidth = 1.0;
        [self.baseScrollView addSubview:moneyAndBankCardBK];
        
        UIView *centerLine = [[UIView alloc] initWithFrame:CGRectMake(10 * BILI_WIDTH, 45 * BILI_WIDTH, SCREEN_WIDTH - 10 * BILI_WIDTH, 0.5)];
        centerLine.backgroundColor = UIColor_GrayLine;
        [moneyAndBankCardBK addSubview:centerLine];
        
        UILabel *moneyTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 45 * BILI_WIDTH)];
        moneyTitle.backgroundColor = [UIColor clearColor];
        moneyTitle.textColor = [UIColor blackColor];
        moneyTitle.textAlignment = NSTextAlignmentLeft;
        moneyTitle.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
        moneyTitle.text = @"借款金额";
        
        self.moneyAmountTF = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, SCREEN_WIDTH - 110, 45 *BILI_WIDTH)];
        _moneyAmountTF.placeholder = @"请输您要借款的金额";
        _moneyAmountTF.text = @"100";
        _moneyAmountTF.delegate = self;
        _moneyAmountTF.tag = 100;
        _moneyAmountTF.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
        _moneyAmountTF.clearButtonMode = UITextFieldViewModeAlways;
        _moneyAmountTF.borderStyle = UITextBorderStyleNone;
        _moneyAmountTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _moneyAmountTF.keyboardType = UIKeyboardTypeDecimalPad;
        [_moneyAmountTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        
        
        UILabel *accountTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 45 * BILI_WIDTH, 100, 45 * BILI_WIDTH)];
        accountTitle.backgroundColor = [UIColor clearColor];
        accountTitle.textColor = [UIColor blackColor];
        accountTitle.textAlignment = NSTextAlignmentLeft;
        accountTitle.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
        accountTitle.text = @"到款账户";
        
        self.bankCardLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 45 * BILI_WIDTH, SCREEN_WIDTH - 100 - 16 - 10 * BILI_WIDTH, 45 * BILI_WIDTH)];
        _bankCardLabel.backgroundColor = [UIColor clearColor];
        _bankCardLabel.textColor = UIColorFromRGB(0x006da5);
        _bankCardLabel.text = @"选择到账银行卡";
        _bankCardLabel.textAlignment = NSTextAlignmentLeft;
        _bankCardLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
        
        UIImageView *arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 16 - 10 * BILI_WIDTH, 45 * BILI_WIDTH + (45 * BILI_WIDTH - 16)/2.0, 16, 16)];
        [arrowImg setImage:[UIImage imageNamed:@"right_arrow"]];
        arrowImg.backgroundColor = [UIColor clearColor];
        
        
        UIButton *selectBankCard = [UIButton buttonWithType:UIButtonTypeCustom];
        selectBankCard.frame = CGRectMake(0, 45 * BILI_WIDTH, SCREEN_WIDTH, 45 * BILI_WIDTH);
        selectBankCard.backgroundColor = [UIColor clearColor];
        [selectBankCard addTarget:self action:@selector(selectBankCardAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [moneyAndBankCardBK addSubview:_bankCardLabel];
        [moneyAndBankCardBK addSubview:arrowImg];
        [moneyAndBankCardBK addSubview:moneyTitle];
        [moneyAndBankCardBK addSubview:accountTitle];
        [moneyAndBankCardBK addSubview:_moneyAmountTF];
        [moneyAndBankCardBK addSubview:selectBankCard];
        
        UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * BILI_WIDTH, CGRectGetMaxY(moneyAndBankCardBK.frame), SCREEN_WIDTH - 2 *10 *BILI_WIDTH, 45 * BILI_WIDTH)];
        tipsLabel.backgroundColor = [UIColor clearColor];
        tipsLabel.textColor = UIColorFromRGB(0xD93112);
        tipsLabel.textAlignment = NSTextAlignmentLeft;
        tipsLabel.numberOfLines = 0;
        tipsLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
        tipsLabel.text = [NSString stringWithFormat:@"*借款最低金额100元，不超过最高[%.2f]元", self.loanRemainAmount];
        [self.baseScrollView addSubview:tipsLabel];
        
        self.sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.frame = CGRectMake(10 * BILI_WIDTH, CGRectGetMaxY(tipsLabel.frame) + kSectionHeight, SCREEN_WIDTH - 2 *10*BILI_WIDTH, 40 *BILI_WIDTH);
        [_sureButton setupRedBtnTitle:@"确 定" enable:YES];
        [_sureButton addTarget:self action:@selector(sureBorrowMoney:) forControlEvents:UIControlEventTouchUpInside];
        [self.baseScrollView addSubview:_sureButton];
        _sureButton.enabled = NO;

    }else{
        self.noRemainAmountLab = [[UILabel alloc] init];
        if (_loanRemainAmount <= 0)
        {
            UILabel *noLeftLoanTitle = [[UILabel alloc]initWithFrame:CGRectMake(10*BILI_WIDTH, 19*BILI_WIDTH, SCREEN_WIDTH-2*20*BILI_WIDTH, 13*BILI_WIDTH)];
            noLeftLoanTitle.textColor = UIColor_DarkGray_Text;
            noLeftLoanTitle.backgroundColor = [UIColor clearColor];
            noLeftLoanTitle.textAlignment = NSTextAlignmentLeft;
            noLeftLoanTitle.font = [UIFont systemFontOfSize:[BNTools sizeFit:13 six:15 sixPlus:17]];
            noLeftLoanTitle.text = @"您的授信额度已全部借款，无法借款更多金额！";
            _noRemainAmountLab = noLeftLoanTitle;
            [self.baseScrollView addSubview:noLeftLoanTitle];
        }
        UILabel *noLeftLoanTipsTitle = [[UILabel alloc] initWithFrame:CGRectMake(10 * BILI_WIDTH, CGRectGetMaxY(_noRemainAmountLab.frame), SCREEN_WIDTH - 2 * 10 *BILI_WIDTH, 45 * BILI_WIDTH)];
        noLeftLoanTipsTitle.backgroundColor = [UIColor clearColor];
        noLeftLoanTipsTitle.textColor = UIColorFromRGB(0xD93718);
        noLeftLoanTipsTitle.numberOfLines = 0;
        noLeftLoanTipsTitle.textAlignment = NSTextAlignmentLeft;
        noLeftLoanTipsTitle.font = [UIFont systemFontOfSize:[BNTools sizeFit:13 six:15 sixPlus:17]];
        [self.baseScrollView addSubview:noLeftLoanTipsTitle];

        if (_overduedLoanCount > 0) {
            noLeftLoanTipsTitle.text = [NSString stringWithFormat:@"您有%ld笔逾期未还借款, 还清后才能再次借款!",(long)_overduedLoanCount];
        }
        
        
        self.sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.frame = CGRectMake(10 * BILI_WIDTH, CGRectGetMaxY(noLeftLoanTipsTitle.frame) + 45 * BILI_WIDTH, SCREEN_WIDTH - 2 *10*BILI_WIDTH, 40 *BILI_WIDTH);
        [_sureButton setupRedBtnTitle:@"我要还钱" enable:YES];
        [_sureButton addTarget:self action:@selector(sureReturnMoney:) forControlEvents:UIControlEventTouchUpInside];
        [self.baseScrollView addSubview:_sureButton];

    }

}

- (void)setupRightBarButton
{
    UIButton *rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItem.frame = CGRectMake(SCREEN_WIDTH - 70*BILI_WIDTH, 0, 70*BILI_WIDTH, 44);
    [rightItem setTitle:@"借款记录" forState:UIControlStateNormal];
    [rightItem setTitleColor:[UIColor colorWithRed:103/255.0 green:103/255.0 blue:103/255.0 alpha:1.0] forState:UIControlStateNormal];
    rightItem.titleLabel.font = [UIFont systemFontOfSize:14*BILI_WIDTH];
    rightItem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightItem setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 12*BILI_WIDTH)];
    [rightItem addTarget:self action:@selector(rightItemBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavigationBar addSubview:rightItem];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self removeMiddleVC];
    [self setupRightBarButton];
    [self setupLoadedView];
    NSDictionary *bankCardInfo = [_bankListArray objectAtIndex:0];
    _selectCardNoStr = [bankCardInfo valueNotNullForKey:@"bankCardNo"];
    
//    [self selectPayBankBorrowMoneyBankCardVCWithBankInfo:bankCardInfo];  //刚进入时，改为不显示默认银行卡，让用户自己去选银行卡，因为默认可能银行卡不是4要素的。所以屏蔽此处。
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelKeyboard:)];
    [self.view addGestureRecognizer:tap];
}

- (void)cancelKeyboard:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}
#pragma mark - button action
- (void)sureReturnMoney:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(BNBorrowMoneyViewControllerDelegatePopPush)]) {
        [_delegate BNBorrowMoneyViewControllerDelegatePopPush];
    }
}
- (void)sureBorrowMoney:(UIButton *)btn
{
    if ([_moneyAmountTF.text floatValue] < 100.0) {
        _moneyAmountTF.text = @"";
        [SVProgressHUD showErrorWithStatus:@"借款最低金额100元,请重新输入！"];
        return;
    }
    __weak typeof(self) weakSelf = self;
    
    [SVProgressHUD showWithStatus:@"请稍候..."];
    [XiaoDaiApi simulateRepaymentPlanWithGrade:@"3"
                                   applyAmount:_moneyAmountTF.text
                                 repaymentType:@"SCHEDULED"
                                  installments:@"3"
                                       success:^(NSDictionary *returnData) {
                                           BNLog(@"还款计划试算simulateRepaymentPlanWithGrade %@", returnData);
                                           if ([[returnData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode])
                                           {
                                               [SVProgressHUD dismiss];
                                               NSDictionary *dataInfo = [returnData objectForKey:kRequestReturnData];
                                               
                                               BNReturnWayViewController *returnWayContontroller = [[BNReturnWayViewController alloc] init];
                                               returnWayContontroller.dataDictionary = dataInfo;
                                               shareAppDelegateInstance.xiaodaiBorrowInfo.cardId = weakSelf.selectCardNoStr;
                                               shareAppDelegateInstance.xiaodaiBorrowInfo.amount = _moneyAmountTF.text;
                                               [self pushViewController:returnWayContontroller animated:YES];
                                           }
                                           else
                                           {
                                               NSString *retMessage = returnData[kRequestRetMessage];
                                               [SVProgressHUD showErrorWithStatus:retMessage];
                                           }
                                       } failure:^(NSError *error) {
                                           [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                       }];
    

}
- (void)rightItemBtnClick:(id)sender
{
    ReturnOrBorrowRecordViewController *borrowRecordVC = [[ReturnOrBorrowRecordViewController alloc] initWithReturnOrBorrow:NO];
    [self pushViewController:borrowRecordVC animated:YES];
}

- (void)selectBankCardAction:(UIButton *)btn
{
    BNBorrowMoneyBankCardVC *cardVC = [[BNBorrowMoneyBankCardVC alloc] init];
    cardVC.delegate = self;
    cardVC.useStyle = bankCardViewControllerUseStyleXiaoDai;
    cardVC.selectCardNoStr = _selectCardNoStr;
    [self pushViewController:cardVC animated:YES];
    
   
}
#pragma mark - BNBorrowMoneyBankCardVCDelegate
-(void)selectPayBankBorrowMoneyBankCardVCWithBankInfo:(NSDictionary *)dict
{
    NSString *bankCardNo = dict[@"bankCardNo"];

    if (bankCardNo != nil && bankCardNo.length > 4) {
        bankCardNo = [NSString stringWithFormat:@"（尾号：%@）", [bankCardNo substringWithRange:NSMakeRange(bankCardNo.length - 4 , 4)]];
    }
    _bankCardLabel.text = [NSString stringWithFormat:@"%@%@", dict[@"bank_name"], bankCardNo];
    
  //  _bankCardLabel.text = @"喜付钱包"; 12月1日 需求更改，必须绑卡才能借钱
    [self refreshBtnEnableStatus];
}

- (void)refreshBtnEnableStatus
{
    if ([_moneyAmountTF.text doubleValue] > 0 && _bankCardLabel.text.length > 0 && ![_bankCardLabel.text isEqualToString:@"选择到账银行卡"]) {
        _sureButton.enabled = YES;
    } else {
        _sureButton.enabled = NO;
    }
    
}
#pragma mark - 限制输入框问题
- (void)textFieldChanged:(UITextField *)textField
{
    switch (textField.tag) {
        case 100:
        {
            NSString *amout = _moneyAmountTF.text;
            if ([amout hasPrefix:@"0"] && amout.length == 2) {
                amout = [NSString stringWithFormat:@"%ld",(long)amout.integerValue];
                textField.text = amout;
            }
            
            if (amout.length > 0) {
                CGFloat loanAmount = [amout doubleValue];
                if (loanAmount > self.loanRemainAmount) {
                    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"支取金额需小于等于[%.2f]元", _loanRemainAmount]];
                    textField.text = @"";
                }
                
            } else if (amout.length < 100) {
                [SVProgressHUD showErrorWithStatus:@"支取金额需大于等于100元"];
                textField.text = @"";
            }
        }
            break;
            
        default:
            break;
    }
    
    [self refreshBtnEnableStatus];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length == 0) {
        return YES;
    }
    if([string isEqualToString:@" "]){
        return NO;
    }
    if (textField.tag == 100) {
        NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
        [futureString  insertString:string atIndex:range.location];
        
        NSInteger flag=0;
        
        const NSInteger limited = 2;//小数点后需要限制的个数
        
        
        for (int i = futureString.length - 1; i >= 0; i --)
        {
            if ([futureString characterAtIndex:i] == '.')
            {
                if (flag > limited)
                {
                    [textField resignFirstResponder];
                    return NO;
                }
                break;
            }
            flag ++;
        }

    }
        return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}
@end
