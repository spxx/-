//
//  BNReturnMoneyListVC.m
//  Wallet
//
//  Created by mac on 15/5/4.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNReturnMoneyListVC.h"
#import "BNReturnMoneyListCell.h"
#import "BNGoToReturnMoneyVC.h"
#import "CardApi.h"
#import "ReturnOrBorrowRecordViewController.h"
#import "XiaoDaiApi.h"
#import "BNBorrowMoneyViewController.h"
@interface BNReturnMoneyListVC ()<UITableViewDataSource, UITableViewDelegate, BNReturnMoneyListCellDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *dataArray;
@property (nonatomic) UIView *noDataBGView;
@property (nonatomic) CGFloat currentAmount;
@property (nonatomic) CGFloat remainAmount;
@property (nonatomic) NSString *orderNumber;

@property (nonatomic, weak) UIView *actionSheetBGView;
@property (nonatomic, weak) UIView *grayBGView;

@end

@implementation BNReturnMoneyListVC

- (UIView *)noDataBGView
{
    if (!_noDataBGView) {
        self.noDataBGView =[[UIView alloc]initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, 400)];
        _noDataBGView.backgroundColor = [UIColor clearColor];
        _noDataBGView.hidden = YES;
        
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10*BILI_WIDTH, 19*BILI_WIDTH, SCREEN_WIDTH-2*20*BILI_WIDTH, 13*BILI_WIDTH)];
        lbl.textColor = UIColor_DarkGray_Text;
        lbl.font = [UIFont systemFontOfSize:13*BILI_WIDTH];
        lbl.backgroundColor = [UIColor clearColor];
        [_noDataBGView addSubview:lbl];
        lbl.text = @"您没有还款项目。";
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10*BILI_WIDTH, 107*BILI_WIDTH, SCREEN_WIDTH - 20*BILI_WIDTH, 40 * BILI_WIDTH);
        [button setupRedBtnTitle:@"我要用钱" enable:YES];
        [button addTarget:self action:@selector(goToSpendMoneyBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
        [_noDataBGView addSubview:button];
        [self.view addSubview:_noDataBGView];
    }


    return _noDataBGView;

}

-(void)removeMiddleVC
{
    NSMutableArray *array = [self.navigationController.viewControllers mutableCopy];
    Class class = NSClassFromString(@"BNBorrowMoneyViewController");
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    
    for (UIViewController *obj in viewControllers) {
        if ([obj isKindOfClass:class]) {
            [array removeObject:obj];
            [self.navigationController setViewControllers:array];
            break;
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"我要还钱";
    [self removeMiddleVC];
    
    self.dataArray = [[NSMutableArray alloc] init];
    UIButton *rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItem.frame = CGRectMake(SCREEN_WIDTH - 70*BILI_WIDTH, 0, 70*BILI_WIDTH, 44);
    [rightItem setTitle:@"还钱记录" forState:UIControlStateNormal];
    [rightItem setTitleColor:[UIColor colorWithRed:103/255.0 green:103/255.0 blue:103/255.0 alpha:1.0] forState:UIControlStateNormal];
    [rightItem setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    rightItem.titleLabel.font = [UIFont systemFontOfSize:14*BILI_WIDTH];
    rightItem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightItem setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 12*BILI_WIDTH)];
    [rightItem addTarget:self action:@selector(rightItemBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavigationBar addSubview:rightItem];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT-self.sixtyFourPixelsView.viewBottomEdge) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = UIColor_Gray_BG;
    [_tableView registerClass:[BNReturnMoneyListCell class] forCellReuseIdentifier:@"BNReturnMoneyListCell"];
    [self.view addSubview:_tableView];
    
    [self requestData];
    
}
- (void)requestData
{
    //请求数据
    [SVProgressHUD showWithStatus:@"请稍候..."];
    [XiaoDaiApi loanQuerySuccess:^(NSDictionary *returnData){
        BNLog(@"loanQuerySuccess--%@",returnData);
        NSString *retCode = [returnData valueNotNullForKey:kRequestRetCode];
        
        if ([retCode isEqualToString:kRequestSuccessCode]) {
            [SVProgressHUD dismiss];
            [SVProgressHUD dismiss];
            NSArray *array = returnData[@"data"][@"loan_infos"];
            BNLog(@"array--%@",array);
            [_dataArray removeAllObjects];
            for (NSDictionary *dict in array) {
                if ([[dict valueNotNullForKey:@"status"] isEqualToString:@"SUCCESS"]) {
                    [_dataArray addObject:dict];
                }
            }
            if (_dataArray.count <= 0) {
                self.noDataBGView.hidden = NO;
            } else {
                [self.tableView reloadData];
                self.noDataBGView.hidden = YES;
            }
        } else {
            NSString *retMsg = [returnData valueNotNullForKey:kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:retMsg];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];
    
    
}

#pragma mark - UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [Tools getReturnMoneyListCellHeight:[_dataArray objectAtIndex:indexPath.row]];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"BNReturnMoneyListCell";
    BNReturnMoneyListCell *cell = (BNReturnMoneyListCell *)[tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.delegate = self;
    
    NSDictionary *dic = [_dataArray objectAtIndex:indexPath.row];
    [cell drawDataWithDict:dic];
    return cell;
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mrak - buttonAction
- (void)rightItemBtnAction:(UIButton *)button
{
    //还钱记录 需要将order_no传过去
    ReturnOrBorrowRecordViewController *returnOrBorrowVC = [[ReturnOrBorrowRecordViewController alloc] initWithReturnOrBorrow:YES];
    returnOrBorrowVC.borrowArray = self.dataArray;
    [self pushViewController:returnOrBorrowVC animated:YES];
    
}
- (void)goToSpendMoneyBtnAction
{
    [SVProgressHUD showErrorWithStatus:@"根据相关政策，借款业务已关闭"];
    return;
    if ([self.delegate respondsToSelector:@selector(BNReturnMoneyListVCDelegatePopPush)]) {
        [_delegate BNReturnMoneyListVCDelegatePopPush];
    }
}
#pragma mark - BNReturnMoneyListCellDelegate
-(void)BNReturnMoneyListCellDelegateReturnBtnAction:(NSDictionary *)dict
{
    NSString *repaymentTypeString = [NSString stringWithFormat:@"%@",[dict valueNotNullForKey:@"repayment_type"]];
    if ([repaymentTypeString isEqualToString:@"SCHEDULED"]) {
        //随时还
        BNGoToReturnMoneyVC *vc = [[BNGoToReturnMoneyVC alloc]init];
        vc.dict = dict;
        [self pushViewController:vc animated:YES];
    } else {
        //分期还  弹出actionSheet,选择只还本期，还是一次性还清。
        [self setupCustomActionSheet:dict];
    }
}


#pragma mrak - 自定义ActionSheet
- (void)setupCustomActionSheet:(NSDictionary *)dict
{
    _currentAmount = [[dict valueNotNullForKey:@"current_installment_amount"] floatValue];
    _remainAmount = [[dict valueNotNullForKey:@"remain_amount"] floatValue];// remain_amount字段目前无效
    _orderNumber = [dict valueNotNullForKey:@"order_no"];
    
    UIView *grayBGView = [[UIView alloc] initWithFrame:self.view.bounds];
    grayBGView.userInteractionEnabled = YES;
    grayBGView.alpha = 0.5;
    grayBGView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:grayBGView];
    _grayBGView = grayBGView;
    
    UIView *actionSheetBGView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 148 * BILI_WIDTH)];
    actionSheetBGView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:actionSheetBGView];
    _actionSheetBGView = actionSheetBGView;
    
    UIView *actionSheettopView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 88 * BILI_WIDTH)];
    actionSheettopView.backgroundColor = [UIColor whiteColor];
    actionSheettopView.layer.cornerRadius = 5;
    actionSheettopView.layer.masksToBounds = YES;
    [actionSheetBGView addSubview:actionSheettopView];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(0, 0, actionSheettopView.frame.size.width, 44 * BILI_WIDTH);
    button1.tag = 1;
    [button1 setTitle:[NSString stringWithFormat:@"只还本期（金额：%.2f元）", _currentAmount] forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(customActionSheetButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    button1.backgroundColor = [UIColor whiteColor];
    [actionSheettopView addSubview:button1];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(button1.frame), CGRectGetWidth(button1.frame), 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [actionSheettopView addSubview:lineView];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(0, 44 * BILI_WIDTH + 0.5, actionSheettopView.frame.size.width, 44 * BILI_WIDTH);
    button2.tag = 2;
    [button2 setTitle:@"一次还清（本期暂不支持）" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    button2.backgroundColor = [UIColor whiteColor];
    [actionSheettopView addSubview:button2];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(10, 96 * BILI_WIDTH, actionSheettopView.frame.size.width, 44 * BILI_WIDTH);
    cancelButton.tag = 3;
    cancelButton.layer.cornerRadius = 5;
    cancelButton.layer.masksToBounds = YES;
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(customActionSheetButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor whiteColor];
    [actionSheetBGView addSubview:cancelButton];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        _actionSheetBGView.frame = CGRectMake(0, SCREEN_HEIGHT - 148 * BILI_WIDTH, SCREEN_WIDTH, 148 * BILI_WIDTH);
    }];
}

#pragma mark -自定义ActionSheet buttonAction
- (void)customActionSheetButtonClick:(UIButton *)button
{
    switch (button.tag) {
        case 1:
        {
            [UIView animateWithDuration:0.3 animations:^{
                _actionSheetBGView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 148 * BILI_WIDTH);
                [_grayBGView removeFromSuperview];
            }];
            __weak typeof(self) weakSelf = self;
            [SVProgressHUD showWithStatus:@"请稍候..."];
            [CardApi CardListWithUser:shareAppDelegateInstance.boenUserInfo.userid success:^(NSDictionary *successData) {
                BNLog(@"successData--%@",successData);
                NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                
                if ([retCode isEqualToString:kRequestSuccessCode]) {
                    [SVProgressHUD dismiss];
                    [weakSelf removeResponseKeyboardAction];
                    
                    [self loanCreatOrder];
                    
//                    NSDictionary *data = [successData valueForKey:kRequestReturnData];
//                    if (data[@"binded_cards"]) {
//                        NSArray *bindedOnlineArray = data[@"binded_cards"];
//                        BNPayViewController *payVC = [[BNPayViewController alloc]init];
//                        payVC.moneyStr = [NSString stringWithFormat:@"%.2f",_currentAmount];
//                        payVC.orderNumber = _orderNumber;
//                        payVC.disPlayMoneyStr = [NSString stringWithFormat:@"%.2f",_currentAmount];
//                        payVC.repayRestInstallments = @"false";
//                        payVC.cardIdStr = @"";
//                        payVC.payProjectType = PayProjectTypeXiaoDaiReturnMoney;
//                        payVC.bindedCardsArray = bindedOnlineArray.count > 0?bindedOnlineArray:nil;
//                        payVC.noticeMobilePhone = @"";
//                        payVC.bank_name = @"喜付钱包";
//                        [weakSelf pushViewController:payVC animated:YES];
//                    }
                } else {
                    NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                    [SVProgressHUD showErrorWithStatus:retMsg];
                }
                
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
            }];
            
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            [UIView animateWithDuration:0.3 animations:^{
                _actionSheetBGView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 148 * BILI_WIDTH);
                [_grayBGView removeFromSuperview];
            }];
            
        }
            break;
            
        default:
            break;
    }
}

- (void)loanCreatOrder
{
    [SVProgressHUD showWithStatus:@"请稍候..."];
    [XiaoDaiApi loanCreatOrderWithProjectOrder_no:_orderNumber repay_amount:[NSString stringWithFormat:@"%.2f",_currentAmount] repay_rest_installments:@"false" success:^(NSDictionary *returnData) {
        BNLog(@"loanCreatOrderWithProjectOrder_no--%@",returnData);
        NSString *retCode = [returnData valueNotNullForKey:kRequestRetCode];
        
        if ([retCode isEqualToString:kRequestSuccessCode]) {
            [SVProgressHUD dismiss];
            NSDictionary *dataDic = [returnData valueForKey:kRequestReturnData];
            BNPayModel *payModel = [[BNPayModel alloc]init];
            payModel.order_no = [dataDic valueNotNullForKey:@"order_no"];
            payModel.biz_no = [dataDic valueNotNullForKey:@"biz_no"];
            
            [self goToPayCenterWithPayProjectType:PayProjectTypeSchoolPay
                                         payModel:payModel
                                      returnBlockone:^(PayVCJumpType jumpType, id params) {
                                          if (jumpType == PayVCJumpType_PayCompletedBackHomeVC) {
                                              [self.navigationController popToRootViewControllerAnimated:YES];
                                          }
                                      }];
        } else {
            NSString *retMsg = [returnData valueNotNullForKey:kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:retMsg];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];
}


@end
