//
//  BNFeesCheckCarcSuccessedVC.m
//  Wallet
//
//  Created by mac1 on 15/9/2.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#define kHeadButtonHight 90 * BILI_WIDTH

#import "BNFeesCheckCardSuccessedVC.h"
#import "CollectFeesApi.h"
#import "BNCollectFeesResultViewController.h"

@interface BNFeesCheckCardSuccessedVC ()

@end

@implementation BNFeesCheckCardSuccessedVC


- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupSubViews];
}


- (void)setupSubViews
{
    [self setupLoadedView];
    self.navigationTitle = @"验证结果";
    
    UIButton *headButton = [UIButton buttonWithType:UIButtonTypeCustom];
    headButton.frame = CGRectMake(0, 0, SCREEN_WIDTH, kHeadButtonHight);
    headButton.userInteractionEnabled = NO;
    [headButton setImage:[UIImage imageNamed:@"submit_fee_success"] forState:UIControlStateNormal];
    [headButton setTitle:@"银行卡信息验证成功" forState:UIControlStateNormal];
    [headButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [headButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [headButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [headButton setBackgroundImage:[Tools imageWithColor:UIColor_Gray_BG andSize:headButton.frame.size] forState:UIControlStateNormal];
    [self.baseScrollView addSubview:headButton];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(9 * BILI_WIDTH, kHeadButtonHight, SCREEN_WIDTH - 9 * BILI_WIDTH, 74 * BILI_WIDTH)];
    label.text = @"银行卡实名信息认证绑定成功，可进行费用领取。";
    [label setFont:[UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:17]]];
    label.textColor = UIColor_Gray_Text;
    [self.baseScrollView addSubview:label];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = CGRectMake(label.frame.origin.x, kHeadButtonHight + CGRectGetHeight(label.bounds), SCREEN_WIDTH - 18 * BILI_WIDTH, 41 * BILI_WIDTH);
    [confirmButton setupLightBlueBtnTitle:@"确认领取" enable:YES];
    [confirmButton addTarget:self action:@selector(confirmButtonAciton) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:confirmButton];
}

- (void)confirmButtonAciton
{
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"请稍候..."];
    NSString *projectKey = [shareAppDelegateInstance.collectFeesData valueNotNullForKey:@"prj_key"];
    [CollectFeesApi confirmPayeeWithProjectKey:projectKey Success:^(NSDictionary *returnData) {
        BNLog(@"费用领取确认--->>>%@",returnData);
        [SVProgressHUD dismiss];
        if ([[returnData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
            NSDictionary *dataDic = [returnData valueForKey:@"data"];
            BNCollectFeesResultViewController *resultViewController = [[BNCollectFeesResultViewController alloc] init];
            resultViewController.projectName = [dataDic valueNotNullForKey:@"prj_name"];
            resultViewController.receiptTime = [dataDic valueNotNullForKey:@"confirm_time"];
            resultViewController.receiptWay = [dataDic valueNotNullForKey:@"confirm_type"];
            resultViewController.amount = [dataDic valueNotNullForKey:@"amount"];
            resultViewController.isSucceed = YES;
            [weakSelf pushViewController:resultViewController animated:YES];
        }
        else {
            BNCollectFeesResultViewController *resultViewController = [[BNCollectFeesResultViewController alloc] init];
            resultViewController.isSucceed = NO;
            [weakSelf pushViewController:resultViewController animated:YES];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backButtonClicked:(UIButton *)sender {
    BOOL isFoundDetailVC = NO;
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:NSClassFromString(@"BNFeeDetailViewController")]) {
            isFoundDetailVC = YES;
            [self.navigationController popToViewController:viewController animated:YES];
            break;
        }
    }
    
    if (!isFoundDetailVC) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
