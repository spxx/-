//
//  BindRoomViewController.m
//  Wallet
//
//  Created by mac1 on 15/8/4.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BindRoomViewController.h"
#import "ElectricChargeMainVC.h"
#import "NewElectricFeesApi.h"
#import "BNFeesWebViewExplainVC.h"

@interface BindRoomViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *roomTf;
@property (nonatomic, strong) UIButton *rightItem;

@end

@implementation BindRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"房间号";
    self.view.backgroundColor = [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1.0f];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
    
    [self setupSubViews];
    
}


- (void)setupSubViews
{
    self.rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightItem.frame = CGRectMake(SCREEN_WIDTH - 75*BILI_WIDTH, 0, 70*BILI_WIDTH, 44);
    [_rightItem setTitle:@"保存" forState:UIControlStateNormal];
    [_rightItem setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [_rightItem setTitleColor:UIColor_Black_Text forState:UIControlStateNormal];
    _rightItem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _rightItem.enabled = _defaultRoomStr ? YES:NO;
    [_rightItem setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 12*BILI_WIDTH)];
    [_rightItem addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavigationBar addSubview:_rightItem];
    
    
    UIView *whiteBKView = [[UIView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge + [BNTools sizeFitfour:10.6 five:12.5 six:14.7 sixPlus:16.2], SCREEN_WIDTH, 45 * BILI_WIDTH)];
    whiteBKView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteBKView];
    
    self.roomTf = [[UITextField alloc] initWithFrame:CGRectMake(20, 0 , CGRectGetWidth(whiteBKView.frame) - 20, 45 * BILI_WIDTH)];
    _roomTf.placeholder = @"请填写房间号";
    _roomTf.text = _defaultRoomStr;
    _roomTf.delegate = self;
    _roomTf.clearButtonMode = UITextFieldViewModeAlways;
    _roomTf.backgroundColor = [UIColor whiteColor];
    [_roomTf addTarget:self action:@selector(textChanged) forControlEvents:UIControlEventEditingChanged];
    [whiteBKView addSubview:_roomTf];
    
    UIButton *explainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    explainButton.frame = CGRectMake(SCREEN_WIDTH - 85 * BILI_WIDTH, CGRectGetMaxY(whiteBKView.frame) + 16 * BILI_WIDTH, 71 * BILI_WIDTH, 16 * BILI_WIDTH);
    [explainButton setTitle:@"房间号规则" forState:UIControlStateNormal];
    [explainButton.titleLabel setFont:[UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]]];
    [explainButton setTitleColor:[UIColor colorWithRed:18/255.0 green:111/255.0 blue:242/255.0 alpha:1.f] forState:UIControlStateNormal];
    explainButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [explainButton addTarget:self action:@selector(explainButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:explainButton];
    
}


- (void)saveButtonAction
{
    __weak typeof(self)weakSelf = self;
    [SVProgressHUD showWithStatus:@"请稍候"];
    [NewElectricFeesApi bandRoomWithRoomId:_roomTf.text
                                    success:^(NSDictionary *returnData) {
                               BNLog(@"绑定房间号%@",returnData);
                               NSString *retCode = returnData[kRequestRetCode];
                               if ([retCode isEqualToString:kRequestNewSuccessCode])
                               {
                                   [SVProgressHUD dismiss];
                                   for (UIViewController *vc in self.navigationController.viewControllers) {
                                       if ([vc isKindOfClass:[ElectricChargeMainVC class]])
                                       {
                                           ElectricChargeMainVC *mainVC = (ElectricChargeMainVC *)vc;
                                           [weakSelf.navigationController popToViewController:mainVC animated:YES];
                                       }
                                   }
                               }
                               else
                               {
                                   [SVProgressHUD showErrorWithStatus:returnData[kRequestRetMessage]];
                               }
                          }
                           failure:^(NSError *error) {
                               [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                           }];
    
   
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length == 0) {
        return YES;   //退格删除
    }
    if (textField == _roomTf) {
        NSRange range = [@"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLIMNOPQRSTUVWXYZ.-_=+@$#%*~|[]^" rangeOfString:string];
        if (range.length > 0) {
            return YES;
        } else {
            return NO;
        }
    }
    
    return YES;
}

- (void)textChanged
{
    if (_roomTf.text.length > 0 && ![_roomTf.text hasPrefix:@" "]) {
        _rightItem.enabled = YES;
    }
    else
    {
        _rightItem.enabled = NO;
    }
}

- (void)handleTap:(UIGestureRecognizer *)gesture
{
    [self.view endEditing:YES];
}

- (void)explainButtonAction
{
    BNFeesWebViewExplainVC *explainVc = [[BNFeesWebViewExplainVC alloc] init];
    explainVc.useType = ExpainUseTypeDianFei;
    [self pushViewController:explainVc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
