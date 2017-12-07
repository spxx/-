//
//  BNReturnWayViewController.m
//  Wallet
//
//  Created by mac1 on 15/5/4.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNReturnWayViewController.h"

#import "UIButton+BNNextStepButton.h"

#import "BNInterestTableViewCell.h"

#import "BNBorrowMoneyDetialsVC.h"

#import "XiaoDaiApi.h"

#import "BNVerifySMSCodeViewController.h"

@interface BNReturnWayViewController ()<UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak,  nonatomic) UIView *returnBKView;

@property (strong,  nonatomic) UIView *returnWayView;

@property (weak,    nonatomic) UIButton *nextStepBtn;

@property (nonatomic) NSMutableArray *dataArray;

@property (nonatomic) UITableView *tableView;

@property (assign, nonatomic) NSInteger selectedIndex;

@property (weak, nonatomic) UILabel *wayNameLabel;
@end

@implementation BNReturnWayViewController

 - (void)setupLoadedView
{
    [super setupLoadedView];
    
    self.view.backgroundColor = UIColor_Gray_BG;
    
    UILabel *selectWayTipsLab = [[UILabel alloc] initWithFrame:CGRectMake(10 * BILI_WIDTH, kSectionHeight, SCREEN_WIDTH - 10 *BILI_WIDTH * 2, 24)];
    selectWayTipsLab.textColor = [UIColor lightGrayColor];
    selectWayTipsLab.backgroundColor = [UIColor clearColor];
    selectWayTipsLab.textAlignment = NSTextAlignmentLeft;
    selectWayTipsLab.font = [UIFont systemFontOfSize:[BNTools sizeFit:13 six:15 sixPlus:17]];
    selectWayTipsLab.text = @"请选择还款方式";
    [self.baseScrollView addSubview:selectWayTipsLab];
    
    UIView *returnBKView = [[UIView alloc] initWithFrame:CGRectMake(-1, CGRectGetMaxY(selectWayTipsLab.frame) + 5.0, SCREEN_WIDTH + 2, 45 * BILI_WIDTH)];
    returnBKView.backgroundColor = [UIColor whiteColor];
    returnBKView.layer.borderColor = UIColorFromRGB(0xcacaca).CGColor;
    returnBKView.layer.borderWidth = 1.0;
    _returnBKView = returnBKView;
    [self.baseScrollView addSubview:returnBKView];
    
    UILabel *wayTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*BILI_WIDTH, 0, SCREEN_WIDTH - 10 * BILI_WIDTH, 45 * BILI_WIDTH)];
    wayTitleLabel.backgroundColor = [UIColor clearColor];
    wayTitleLabel.textColor = [UIColor blackColor];
    wayTitleLabel.textAlignment = NSTextAlignmentLeft;
    wayTitleLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
    wayTitleLabel.text = @"还款方式";
    
    UILabel *wayNameLab = [[UILabel alloc] initWithFrame:CGRectMake(10*BILI_WIDTH, 0, SCREEN_WIDTH - 10 *BILI_WIDTH *2 - 20, 45 * BILI_WIDTH)];
    wayNameLab.backgroundColor = [UIColor clearColor];
    wayNameLab.textColor = [UIColor blackColor];
    wayNameLab.tag = 10000;
    wayNameLab.textAlignment = NSTextAlignmentRight;
    wayNameLab.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
    wayNameLab.text = @"随时还";
    _wayNameLabel = wayNameLab;
    shareAppDelegateInstance.xiaodaiBorrowInfo.repaymentType = @"SCHEDULED";
    
    UIImageView *arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 16 - 10 * BILI_WIDTH, (45 * BILI_WIDTH - 16)/2.0, 16, 16)];
    [arrowImg setImage:[UIImage imageNamed:@"right_arrow"]];
    arrowImg.backgroundColor = [UIColor clearColor];
    
    [returnBKView addSubview:wayTitleLabel];
    [returnBKView addSubview:wayNameLab];
    [returnBKView addSubview:arrowImg];
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45 *BILI_WIDTH);
    selectBtn.backgroundColor = [UIColor clearColor];
    [selectBtn addTarget:self action:@selector(showSelectReturnWay:) forControlEvents:UIControlEventTouchUpInside];
    [returnBKView addSubview:selectBtn];
    
    self.returnWayView = [self returnMoneyAnyTime];
    [self.baseScrollView addSubview:_returnWayView];
    
   UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(10 *BILI_WIDTH, CGRectGetMaxY(_returnWayView.frame)+kSectionHeight, SCREEN_WIDTH - 10 * BILI_WIDTH * 2, 40 * BILI_WIDTH);
    [nextButton setupLightBlueBtnTitle:@"下一步" enable:YES];
    [nextButton addTarget:self action:@selector(borrowNextStepAction:) forControlEvents:UIControlEventTouchUpInside];
    _nextStepBtn = nextButton;
    [self.baseScrollView addSubview:nextButton];
}


//随时还UI
- (UIView *)returnMoneyAnyTime
{
    UIView *returnView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_returnBKView.frame) + kSectionHeight, SCREEN_WIDTH, 60 *BILI_WIDTH)];
    returnView.backgroundColor = [UIColor clearColor];
    
    NSString *liLvString = self.dataDictionary[@"interest_rate"];
    float liLv = [liLvString floatValue];
    UILabel *interestLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*BILI_WIDTH, 0, SCREEN_WIDTH - 10 * BILI_WIDTH, 30 * BILI_WIDTH)];
    interestLabel.backgroundColor = [UIColor clearColor];
    interestLabel.textColor = UIColorFromRGB(0xD81B05);
    interestLabel.textAlignment = NSTextAlignmentLeft;
    interestLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
    interestLabel.text = [NSString stringWithFormat:@"利息: 100元本金每天利息%.2f元",liLv];
    [returnView addSubview:interestLabel];
    
    NSString *timeString = self.dataDictionary[@"repay_date"];
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*BILI_WIDTH, 30 * BILI_WIDTH, SCREEN_WIDTH - 10 * BILI_WIDTH, 30 * BILI_WIDTH)];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.textColor = UIColorFromRGB(0xD81B05);
    dateLabel.textAlignment = NSTextAlignmentLeft;
    dateLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
    dateLabel.text = [NSString stringWithFormat:@"最晚还款时间:%@",timeString];
    [returnView addSubview:dateLabel];
    
    _nextStepBtn.frame = CGRectMake(10 *BILI_WIDTH, CGRectGetMaxY(returnView.frame)+kSectionHeight, SCREEN_WIDTH - 10 * BILI_WIDTH * 2, 40 * BILI_WIDTH);
    return returnView;
    
}

//分期还还UI
- (UIView *)returnMoneyByStages
{
    UIView *returnView = [[UIView alloc] initWithFrame:CGRectMake(-1, CGRectGetMaxY(_returnBKView.frame) + kSectionHeight, SCREEN_WIDTH + 2, 4*40 *BILI_WIDTH+2)];
    returnView.backgroundColor = [UIColor whiteColor];
    returnView.layer.borderColor = UIColorFromRGB(0xcacaca).CGColor;
    returnView.layer.borderWidth = 1.0;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, SCREEN_WIDTH, 4*40 *BILI_WIDTH) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 40 * BILI_WIDTH;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[BNInterestTableViewCell class] forCellReuseIdentifier:@"StagesCell"];
    
    _selectedIndex = 0;
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    footView.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = footView;
    [returnView addSubview:_tableView];
    
    _nextStepBtn.frame = CGRectMake(10 *BILI_WIDTH, CGRectGetMaxY(returnView.frame)+2*kSectionHeight, SCREEN_WIDTH - 10 * BILI_WIDTH * 2, 40 * BILI_WIDTH);
    return returnView;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationTitle = @"我要用钱";
    _dataArray = [[NSMutableArray alloc] init];
    
    shareAppDelegateInstance.xiaodaiBorrowInfo.installments = @"3";
    [self setupLoadedView];
}
#pragma mark -initDataSource
- (void)initDataSourceWithRepaymentType:(NSString *)repaymentType
{
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"请稍候..."];
    [XiaoDaiApi simulateRepaymentPlanWithGrade:@"3"
                                   applyAmount:shareAppDelegateInstance.xiaodaiBorrowInfo.amount
                                 repaymentType:repaymentType
                                  installments:@"3"
                                       success:^(NSDictionary *returnData) {
                                           BNLog(@"loan check pay password %@", returnData);
                                           if ([[returnData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                                               [SVProgressHUD dismiss];
                                               
//                                               , 随时还=SCHEDULED, 分期=INSTALLMENT.
                                               if ([repaymentType isEqualToString:@"SCHEDULED"]) {
                                                   [weakSelf.returnWayView removeFromSuperview];
                                                   weakSelf.returnWayView = nil;
                                                   
                                                   shareAppDelegateInstance.xiaodaiBorrowInfo.repaymentType = @"SCHEDULED";
                                                   weakSelf.dataDictionary = [returnData valueForKey:kRequestReturnData];
                                                   
                                                   weakSelf.returnWayView = [self returnMoneyAnyTime];
                                                   [weakSelf.baseScrollView addSubview:_returnWayView];

                                               }else{
                                                   [weakSelf.returnWayView removeFromSuperview];
                                                   weakSelf.returnWayView = nil;
                                                   
                                                   shareAppDelegateInstance.xiaodaiBorrowInfo.repaymentType = @"INSTALLMENT";
                                                   NSDictionary *dataInfo = [returnData valueForKey:kRequestReturnData];
                                                   NSArray *plans = [dataInfo valueForKey:@"plans"];
                                                   [weakSelf.dataArray removeAllObjects];
                                                   
                                                   [weakSelf.dataArray addObjectsFromArray:plans];
                                                   
                                                   weakSelf.returnWayView = [self returnMoneyByStages];
                                                   [weakSelf.baseScrollView addSubview:_returnWayView];
                                                   UILabel *lab = (UILabel *)[weakSelf.returnBKView viewWithTag:10000];
                                                   lab.text = @"分期还";

                                               }
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


#pragma mark - action sheet
- (void)showSelectReturnWay:(UIButton *)btn
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择还款方式" delegate:self cancelButtonTitle:@"取 消" destructiveButtonTitle:@"随时还" otherButtonTitles:@"分期还", nil];
    
    [actionSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
        {
            _wayNameLabel.text = @"随时还";
            [self initDataSourceWithRepaymentType:@"SCHEDULED"];
            
        }
            break;
        case 1:
        {
            [self initDataSourceWithRepaymentType:@"INSTALLMENT"];
            _wayNameLabel.text = @"分期还";
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - datasource and delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNInterestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StagesCell" forIndexPath:indexPath];
    NSDictionary *dic = [_dataArray objectAtIndex:indexPath.row];
    BOOL isSelected = indexPath.row == _selectedIndex;
    [cell drawDataWithDict:dic isSelected:isSelected];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectedIndex = indexPath.row;
    [tableView reloadData];
    
}

#pragma mark - button aciton
- (void)borrowNextStepAction:(UIButton *)btn
{
    BNPayModel *paymodel = [[BNPayModel alloc]init];
    paymodel.bindCardInfoModel.personalBankPhone = shareAppDelegateInstance.boenUserInfo.phoneNumber;
    
    shareAppDelegateInstance.xiaodaiBorrowInfo.installments = [NSString stringWithFormat:@"%ld", (_selectedIndex + 1) * 3];
    BNVerifySMSCodeViewController *smsVC = [[BNVerifySMSCodeViewController alloc] init];
    smsVC.useStyle = ViewControllerUseStyleXiaoDai;
    smsVC.payModel = paymodel;
    smsVC.phoneNumber = shareAppDelegateInstance.boenUserInfo.phoneNumber;
    [self pushViewController:smsVC animated:YES];
    
}

@end
