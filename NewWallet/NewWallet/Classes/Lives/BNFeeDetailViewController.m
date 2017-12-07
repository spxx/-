//
//  BNFeeDetailViewController.m
//  Wallet
//
//  Created by crx on 15/8/31.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import "BNFeeDetailViewController.h"
#import "CollectFeesApi.h"
#import "TiXianApi.h"
#import "BNFeesCheckCardSuccessedVC.h"
#import "BNCollectFeesResultViewController.h"

@interface BNFeeDetailViewController ()<UIAlertViewDelegate>

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UILabel *fundTitle;
@property (strong, nonatomic) UILabel *fundState;
@property (strong, nonatomic) UILabel *amountLabel;
@property (strong, nonatomic) UILabel *receiptWay;
@property (strong, nonatomic) UILabel *introductionLabel;
@property (strong, nonatomic) UILabel *introductionContentLabel;
@property (strong, nonatomic) UILabel *deadlineLabel;
@property (strong, nonatomic) UIButton *getButton;


@property (assign, nonatomic) CGFloat textAlignX;

@end

@implementation BNFeeDetailViewController

#pragma mark - lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methosd

- (void)setupViews {
    [super setupLoadedView];
    
    self.navigationTitle = @"费用领取";
    
    BNLog(@"dataDic--->>>%@",self.dataDic);
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160*BILI_WIDTH)];
    self.headerView.backgroundColor = UIColorFromRGB(0xf8ab07);
    [self.baseScrollView addSubview:self.headerView];

    self.fundTitle = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, SCREEN_WIDTH-24, 20)];
    self.fundTitle.text = @"奖学金";
    self.fundTitle.textColor = [UIColor whiteColor];
    self.fundTitle.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
    self.fundTitle.numberOfLines = 0;
    [self.headerView addSubview:self.fundTitle];


    UIImageView *wayImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"way"]];
    wayImageView.frame = CGRectMake(12, self.headerView.bottomValue+30, 16*BILI_WIDTH, 16*BILI_WIDTH);
    [self.baseScrollView addSubview:wayImageView];
    
    self.amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(wayImageView.frame) + 12, 40, SCREEN_WIDTH-40*2, 120)];
    self.amountLabel.text = @"00.00";
    self.amountLabel.font = [UIFont systemFontOfSize:50];
    self.amountLabel.textColor = [UIColor whiteColor];
    [self.baseScrollView addSubview:self.amountLabel];
    
    self.textAlignX = wayImageView.rightValue+12*BILI_WIDTH;
    self.amountLabel.frame = CGRectMake(self.textAlignX, self.fundTitle.bottomValue-5, SCREEN_WIDTH-self.textAlignX, self.headerView.frame.size.height-self.fundTitle.frame.size.height-12);
    
    self.receiptWay = [[UILabel alloc] initWithFrame:CGRectMake(self.textAlignX, self.headerView.bottomValue+30, SCREEN_WIDTH-self.textAlignX, 20)];
    self.receiptWay.text = @"领取至喜付钱包";
    self.receiptWay.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
    self.receiptWay.textColor = [UIColor darkGrayColor];
    [self.baseScrollView addSubview:self.receiptWay];
    
    self.fundState = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, self.headerView.bottomValue+28, 70, 24)];
    self.fundState.layer.borderColor = UIColorFromRGB(0xfef2d9).CGColor;
    self.fundState.layer.borderWidth = 0.5;
    self.fundState.layer.cornerRadius = 10;
    self.fundState.text = @"";
    self.fundState.textColor = UIColorFromRGB(0xf8ab07);
    self.fundState.font = [UIFont systemFontOfSize:[BNTools sizeFit:13 six:15 sixPlus:17]];
    self.fundState.textAlignment = NSTextAlignmentCenter;
    [self.baseScrollView addSubview:self.fundState];

    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(46, self.receiptWay.bottomValue+20, SCREEN_WIDTH-46-10, 0.5)];
    line.backgroundColor = UIColorFromRGB(0xececec);
    [self.baseScrollView addSubview:line];
    
    UIImageView *introductionImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"introduction"]];
    introductionImageView.frame = CGRectMake(12, line.bottomValue+21, 16*BILI_WIDTH, 16*BILI_WIDTH);
    [self.baseScrollView addSubview:introductionImageView];
    
    self.introductionLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(introductionImageView.frame) + 12, line.bottomValue+20, SCREEN_WIDTH-46, 20)];
    self.introductionLabel.text = @"项目简介";
    self.introductionLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
    self.introductionLabel.textColor = [UIColor darkGrayColor];
    [self.baseScrollView addSubview:self.introductionLabel];
    
    
    NSString *introduction = @"";
    CGSize labelSize = [introduction sizeWithFont:[UIFont systemFontOfSize:14 * BILI_WIDTH] constrainedToSize:CGSizeMake(SCREEN_WIDTH-56, MAXFLOAT)];
    self.introductionContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(46, self.introductionLabel.bottomValue+10, SCREEN_WIDTH-56, labelSize.height)];
    self.introductionContentLabel.text = @"";
    self.introductionContentLabel.textColor = [UIColor lightGrayColor];
    self.introductionContentLabel.font = [UIFont systemFontOfSize:14 * BILI_WIDTH];
    self.introductionContentLabel.numberOfLines = 0;
    [self.baseScrollView addSubview:self.introductionContentLabel];
    
    self.deadlineLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.textAlignX, self.introductionContentLabel.bottomValue+10, SCREEN_WIDTH-self.textAlignX, 20)];
    self.deadlineLabel.textColor = [UIColor lightGrayColor];
    self.deadlineLabel.font = [UIFont systemFontOfSize:14 * BILI_WIDTH];
    [self.baseScrollView addSubview:self.deadlineLabel];
    
    self.getButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.getButton.frame = CGRectMake(10, SCREEN_HEIGHT-23.5-40, SCREEN_WIDTH - 20, 40 * BILI_WIDTH);
    [self.getButton setupTitle:@"确认领取" enable:YES];
    [self.getButton addTarget:self action:@selector(getAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.getButton];
    
    self.baseScrollView.contentInset = UIEdgeInsetsMake(0, 0, 63.5, 0);
}

- (void)loadData {

    self.amountLabel.text = [self.dataDic valueNotNullForKey:@"amount"];
    self.fundTitle.text = [NSString stringWithFormat:@"%@",[self.dataDic valueNotNullForKey:@"prj_name"]];
    CGSize size = [self.fundTitle.text sizeWithFont:[UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]] constrainedToSize:CGSizeMake(SCREEN_WIDTH-24, MAXFLOAT)];
    if (size.height > 20) {
        self.fundTitle.frame = CGRectMake(12, 12, SCREEN_WIDTH-24, size.height);
        self.amountLabel.frame = CGRectMake(self.textAlignX, self.fundTitle.bottomValue, SCREEN_WIDTH-self.textAlignX, self.headerView.frame.size.height-self.fundTitle.frame.size.height-12);
    }
    
    

    NSInteger status = [[self.dataDic valueNotNullForKey:@"status"] integerValue];
    NSInteger prjStatus = [[self.dataDic valueNotNullForKey:@"prj_status"] integerValue];
    switch (status) {
        case 1:
        case 4:
        {
            self.fundState.text = @"待领取";
            [self.getButton setTitle:@"确认领取" forState:UIControlStateNormal];
            [self setHeaderState:YES];
            
            if (prjStatus == 4||prjStatus == 5) {
                self.fundState.text = @"已结束";
                [self.getButton setTitle:@"已结束" forState:UIControlStateNormal];
                [self setHeaderState:NO];
            }
        }
            break;
        case 2:
        {
            self.fundState.text = @"领取中";
            [self.getButton setTitle:@"领取中" forState:UIControlStateNormal];
            [self setHeaderState:NO];

            if (prjStatus == 4||prjStatus == 5) {
                self.fundState.text = @"已结束";
                [self.getButton setTitle:@"已结束" forState:UIControlStateNormal];
                [self setHeaderState:NO];

            }
            
        }
            break;
        case 3:
        {
            self.fundState.text = @"已领取";
            [self.getButton setTitle:@"已领取" forState:UIControlStateNormal];
            [self setHeaderState:NO];

        }
            break;
            
        default:
            break;
    }
    
    
    self.introductionContentLabel.text = [self.dataDic valueNotNullForKey:@"prj_introduction"];
    

    CGSize labelSize = [self.introductionContentLabel.text sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(SCREEN_WIDTH-self.textAlignX-10, MAXFLOAT)];
    self.introductionContentLabel.frame = CGRectMake(self.textAlignX, self.introductionLabel.bottomValue+10, SCREEN_WIDTH-self.textAlignX-10, labelSize.height);
    
    self.deadlineLabel.frame = CGRectMake(self.textAlignX, self.introductionContentLabel.bottomValue+10, SCREEN_WIDTH-self.textAlignX, 20);
    //截止日期
    NSString *dateStr = [self.dataDic valueNotNullForKey:@"prj_end_time"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [dateFormatter dateFromString:dateStr];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [dateFormatter stringFromDate:date];
    self.deadlineLabel.text = [NSString stringWithFormat:@"截止日期：%@", dateString];
    
    self.baseScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.deadlineLabel.bottomValue+10);
}

- (void)setHeaderState:(BOOL)enable {
    if (!enable) {
        self.headerView.backgroundColor = [UIColor colorWithRed:207/255.0 green:216/255.0 blue:220/255.0 alpha:1.9];
        self.getButton.enabled = NO;
        self.fundState.textColor = [UIColor darkGrayColor];
        self.fundState.layer.borderColor = [UIColor clearColor].CGColor;
    }
    else {
        self.headerView.backgroundColor = UIColorFromRGB(0xf8ab07);
        self.getButton.enabled = YES;
        self.fundState.textColor = UIColorFromRGB(0xf8ab07);
        self.fundState.layer.borderColor = UIColorFromRGB(0xfef2d9).CGColor;
    }
}

- (void)getAction:(UIButton *)sender {
   
    //实名认证
    shareAppDelegateInstance.collectFeesData = self.dataDic;
    
    /*
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"请稍候..."];
    [TiXianApi realnameCertifyQuerySuccess:^(NSDictionary *returnData) {
        BNLog(@"费用领取实名认证--->>> %@",returnData);
        if ([[returnData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode])
        {
            NSDictionary *returnDic = [returnData valueForKey:kRequestReturnData];
            NSString *applyedStr = returnDic[@"applyed"];
            NSString *status = returnDic[@"status"];
            if (applyedStr.integerValue == 1)//申请过实名认证
            {
                self.realNameStatus = status;
                if ([status isEqualToString:@"NOA"])
                {
                    //未认证
//                    [SVProgressHUD dismiss];
                    [weakSelf enterAddBankCardViewControll];
                    
                }
                else if ([status isEqualToString:@"AUT"])
                {
                    //认证中
//                    [SVProgressHUD dismiss];
                   
                }
                else if([status isEqualToString:@"ATP"])
                {
            //审核通过 TODO:验证信息成功,调费用领取接口
//                    [SVProgressHUD dismiss];
                    
                }
                else if([status isEqualToString:@"ATN"] || [status isEqualToString:@"UPF"])
                {
                    //审核失败了
                    self.errorMsg = returnDic[@"result_message"];
                    [weakSelf enterAddBankCardViewControll];
                }
            }
            else
            {
                //没有申请过实名认证，
                [weakSelf enterAddBankCardViewControll];
            }
        }
        else
        {
            [weakSelf enterAddBankCardViewControll];
        }
        
    } failure:^(NSError *error) {
         [weakSelf enterAddBankCardViewControll];
    }];
     */
    
    
    //走绑卡流程,干掉实名认证
     [self enterAddBankCardViewControll];
   
}

- (void)enterAddBankCardViewControll
{
    if (![shareAppDelegateInstance.boenUserInfo.isCert isEqualToString:@"yes"]) {//未绑定银行卡
        [SVProgressHUD dismiss];
        shareAppDelegateInstance.alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"为了保障资金安全，需要验证您的银行卡信息！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"验证", nil];
        [shareAppDelegateInstance.alertView show];
    }else//绑定过银行卡,调费用领取接口
    {
        [self startCollectFees];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        shareAppDelegateInstance.popToViewController = @"BNCollectFeesListVC";
        
        [self gotoYJPayBankCardList];
    }
}


//费用领取接口
- (void)startCollectFees
{
    __weak typeof(self) weakSelf = self;
//    [SVProgressHUD showWithStatus:@"请稍候..."];
    NSString *projectKey = [self.dataDic valueNotNullForKey:@"prj_key"];
    [CollectFeesApi confirmPayeeWithProjectKey:projectKey Success:^(NSDictionary *returnData) {
        BNLog(@"费用领取确认--->>>%@",returnData);
    
        [SVProgressHUD dismiss];
        if ([[returnData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
            [shareAppDelegateInstance refreshPersonProfile];
            NSDictionary *dataDic = [returnData valueForKey:@"data"];
            BNCollectFeesResultViewController *resultViewController = [[BNCollectFeesResultViewController alloc] init];
            resultViewController.projectName = [dataDic valueNotNullForKey:@"prj_name"];
            resultViewController.receiptTime = [dataDic valueNotNullForKey:@"confirm_time"];
            resultViewController.receiptWay = [dataDic valueNotNullForKey:@"confirm_type"];
            resultViewController.amount = [dataDic valueNotNullForKey:@"amount"];
            resultViewController.isSucceed = YES;
            resultViewController.useType = CollectFeesResultUseTypeFromDetail;
            [weakSelf pushViewController:resultViewController animated:YES];
        }
        else {
            BNCollectFeesResultViewController *resultViewController = [[BNCollectFeesResultViewController alloc] init];
            resultViewController.isSucceed = NO;
            resultViewController.useType = CollectFeesResultUseTypeFromDetail;
            [weakSelf pushViewController:resultViewController animated:YES];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];
}


@end
