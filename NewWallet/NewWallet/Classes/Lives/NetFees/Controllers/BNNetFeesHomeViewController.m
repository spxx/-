//
//  BNNetFeesHomeViewController.m
//  Wallet
//
//  Created by mac1 on 16/2/16.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "BNNetFeesHomeViewController.h"
#import "NetFeesApi.h"
#import "BNNetFeesSelectCampusVC.h"
#import "BNNetRemainFeesViewController.h"
#import "SelectItemView.h"
#import "RechargeNetId.h"
#import "RechargeNetId+CoreDataProperties.h"
#import "BannerApi.h"

@interface BNNetFeesHomeViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) UIView *toastBGView;
@property (weak, nonatomic) UITextField *netIdTextField;
@property (weak, nonatomic) UITextField *moneyTf;
@property (weak, nonatomic) UILabel *campusRightLabel;
@property (weak, nonatomic) UIView *middleBGView;
@property (weak, nonatomic) UIButton *rechargeButton;
@property (strong, nonatomic) SelectItemView *selectItemView;

@property (strong, nonatomic) NSArray *campusDatas;
@property (copy, nonatomic) NSString *selectedCampusId;
@property (copy, nonatomic) NSString *remarkStr;
@property (assign, nonatomic) NSInteger selectedIndex;




@end

@implementation BNNetFeesHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"网费充值";
    [self setupLoadedView];
    [self getCampusInfo];
    
    //监听键盘消失
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    [self pythonCheckService];
}

- (void)pythonCheckService
{
    //请求checkService，检查服务可用性。
    [SVProgressHUD show];
    [BannerApi pythonCheckService:shareAppDelegateInstance.boenUserInfo.userid
                           busiId:_biz_id
                          success:^(NSDictionary *successData) {
                              BNLog(@"pythonCheckService--%@", successData);
                              
                              NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                              
                              if ([retCode isEqualToString:kRequestSuccessCode]) {
                                  
                                  NSDictionary *retData = [successData valueForKey:kRequestReturnData];
                                  NSString *busiStatus = [retData valueNotNullForKey:@"busi_status"];
                                  NSString *payStatus = [retData valueNotNullForKey:@"pay_status"];
                                  NSString *systemStatus = [retData valueNotNullForKey:@"system_status"];
                                  
                                  if ([payStatus isEqualToString:@"no"] && [busiStatus isEqualToString:@"no"] && [systemStatus isEqualToString:@"no"]) {
                                      [SVProgressHUD dismiss];
                                  } else {
                                      [SVProgressHUD showErrorWithStatus:kSystemErrorMsg];
                                  }
                                  
                              }else{
                                  NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                  [SVProgressHUD showErrorWithStatus:retMsg];
                              }
                              
                          } failure:^(NSError *error) {
                              [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                          }];
    
    
}

- (void)setupLoadedView
{
    //余额查询按钮
    UIButton *rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItem.frame = CGRectMake(SCREEN_WIDTH - 70*BILI_WIDTH, 0, 70*BILI_WIDTH, 44);
    [rightItem setTitle:@"余额查询" forState:UIControlStateNormal];
    [rightItem setTitleColor:[UIColor colorWithRed:103/255.0 green:103/255.0 blue:103/255.0 alpha:1.0] forState:UIControlStateNormal];
    [rightItem setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    rightItem.titleLabel.font = [UIFont systemFontOfSize:14*BILI_WIDTH];
    rightItem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightItem setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 12*BILI_WIDTH)];
    [rightItem addTarget:self action:@selector(rightItemBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavigationBar addSubview:rightItem];

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge)];
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height + 1);
    scrollView.backgroundColor = [UIColor colorWithRed:239/255.0 green:243/255.0 blue:245/255.0 alpha:1];
    scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    
    //上
    UIView *iconBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 8 * NEW_BILI, SCREEN_WIDTH, 90 * NEW_BILI)];
    iconBGView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:iconBGView];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15 * NEW_BILI, 18 * NEW_BILI, 54 * NEW_BILI, 54 * NEW_BILI)];
    iconImageView.image = [UIImage imageNamed:@"netFees_icon"];
    [iconBGView addSubview:iconImageView];
    
    UITextField *netIdTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame) + 20 * NEW_BILI, 30 * NEW_BILI, SCREEN_WIDTH - 104*NEW_BILI, 30 * NEW_BILI)];
    netIdTextField.placeholder = @"请输入宽带账号";
    netIdTextField.clearButtonMode = UITextFieldViewModeAlways;
    netIdTextField.font = [UIFont systemFontOfSize:15 * NEW_BILI];
    netIdTextField.textColor = UIColorFromRGB(0x263238);
    netIdTextField.textAlignment = NSTextAlignmentLeft;
    netIdTextField.delegate = self;
    [netIdTextField addTarget:self action:@selector(textAction:) forControlEvents:UIControlEventEditingChanged];
    [iconBGView addSubview:netIdTextField];
    _netIdTextField = netIdTextField;
    
    
    
    
    //中
    UIView *middleBGView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(iconBGView.frame) + 8 * NEW_BILI, SCREEN_WIDTH, 102.5 * NEW_BILI)];
    middleBGView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:middleBGView];
    _middleBGView = middleBGView;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15 * NEW_BILI, 51 * NEW_BILI, SCREEN_WIDTH - 15 * NEW_BILI, 0.5)];
    lineView.backgroundColor = UIColor_GrayLine;
    [middleBGView addSubview:lineView];
    
    UILabel *campusLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 * NEW_BILI, 18 * NEW_BILI, 80 * NEW_BILI, 15 * NEW_BILI)];
    campusLabel.text = @"校区";
    campusLabel.font = [UIFont systemFontOfSize:15 * NEW_BILI];
    campusLabel.textColor = UIColorFromRGB(0x455a64);
    [middleBGView addSubview:campusLabel];
    
    
    UIImageView *rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 27.5,(51*NEW_BILI - 12.5)*0.5, 12.5, 12.5)];
    rightArrow.image = [UIImage imageNamed:@"netFees_right_arrow"];
    [middleBGView addSubview:rightArrow];
    
    
    NSAttributedString *campusStr = [[NSAttributedString alloc] initWithString:@"请选择" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15 * NEW_BILI], NSForegroundColorAttributeName:UIColorFromRGB(0x455a64)}];
    UILabel *campusRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 35 - campusStr.size.width, (51*NEW_BILI - campusStr.size.height)*0.5, campusStr.size.width, campusStr.size.height)];
    campusRightLabel.attributedText = campusStr;
    [middleBGView addSubview:campusRightLabel];
    _campusRightLabel = campusRightLabel;
    
    UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 51 * NEW_BILI)];
    coverView.backgroundColor = [UIColor clearColor];
    [middleBGView addSubview:coverView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle)];
    [coverView addGestureRecognizer:tapGesture];
    
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(campusLabel.frame), CGRectGetMaxY(lineView.frame) + 18 * NEW_BILI, 100, 15 * NEW_BILI)];
    moneyLabel.text = @"充值金额";
    moneyLabel.font = [UIFont systemFontOfSize:15 * NEW_BILI];
    moneyLabel.textColor = UIColorFromRGB(0x455a64);
    [middleBGView addSubview:moneyLabel];
    
    UITextField *moneyTf = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 215,  CGRectGetMinY(moneyLabel.frame), 200, 15 * NEW_BILI)];
    moneyTf.placeholder = @"请输入充值金额";
    moneyTf.textAlignment = NSTextAlignmentRight;
    moneyTf.font = [UIFont systemFontOfSize:15 * NEW_BILI];
    moneyTf.textColor = UIColorFromRGB(0xb0bec5);
    moneyTf.keyboardType = UIKeyboardTypeDecimalPad;
    moneyTf.delegate = self;
    [moneyTf addTarget:self action:@selector(textAction:) forControlEvents:UIControlEventEditingChanged];
    [middleBGView addSubview:moneyTf];
    _moneyTf = moneyTf;
    
   
    //充值按钮
    UIButton *rechargeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rechargeButton.frame = CGRectMake(18 * NEW_BILI, CGRectGetMaxY(middleBGView.frame) + 27 * NEW_BILI, SCREEN_WIDTH - 36 * NEW_BILI, 40 * NEW_BILI);
    [rechargeButton setupLightBlueBtnTitle:@"充值" enable:NO];
    [rechargeButton addTarget:self action:@selector(rechargeButtonAciton:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:rechargeButton];
    _rechargeButton = rechargeButton;

    self.selectItemView = [[SelectItemView alloc] initWithRelateView:iconBGView style:SelectItemViewUseStyleSelectNetFees delegate:self];
    [scrollView addSubview:_selectItemView];
    _selectItemView.hidden = YES;
}

//充值按钮上面有个温馨提示
- (void)setupToastView
{
    if(!_remarkStr.length >0 || [_remarkStr isEqualToString:@"null"]){
        _toastBGView.backgroundColor = [UIColor redColor];
        [_toastBGView removeFromSuperview];
        _rechargeButton.frame = CGRectMake(18 * NEW_BILI, CGRectGetMaxY(_middleBGView.frame) + 27 * NEW_BILI, SCREEN_WIDTH - 36 * NEW_BILI, 40 * NEW_BILI);
        return;
    }
    
    UIView *toastBGView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_middleBGView.frame) + 8 * NEW_BILI, SCREEN_WIDTH, 100)];
    toastBGView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:toastBGView];
    _toastBGView = toastBGView;
    
   
    //拼接字符串
    NSString *string = [NSString stringWithFormat:@"温馨提示\n\n%@",_remarkStr];
    //计算文字高度
    CGFloat h = [Tools caleNewsCellHeightWithTitle:string font:[UIFont systemFontOfSize:12 * NEW_BILI] width:SCREEN_WIDTH - 30 * NEW_BILI];
    
    //让label的高度与文字高度一致
    UILabel *toastLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 * NEW_BILI, 20 * NEW_BILI, SCREEN_WIDTH - 30 * NEW_BILI, h)];
    toastLabel.numberOfLines = 0;
    toastLabel.lineBreakMode = NSLineBreakByWordWrapping;
    toastLabel.text = string;
    toastLabel.font = [UIFont systemFontOfSize:12 * NEW_BILI];
    toastLabel.textColor = UIColorFromRGB(0x90a4ae);
    [toastBGView addSubview:toastLabel];
    
    //重新对背景view设置frame
    toastBGView.frame = CGRectMake(0, CGRectGetMaxY(_middleBGView.frame) + 18 * NEW_BILI, SCREEN_WIDTH, toastLabel.size.height + 44 * NEW_BILI);
    
    //设置充值按钮frame
    _rechargeButton.frame = CGRectMake(18 * NEW_BILI, CGRectGetMaxY(toastBGView.frame) + 27 * NEW_BILI, SCREEN_WIDTH - 36 * NEW_BILI, 40 * NEW_BILI);
}

- (void)getCampusInfo
{
    [NetFeesApi getCampusesInfoSuccess:^(NSDictionary *successData) {
        BNLog(@"网费获取校园信息---->>>>> %@",successData);
        if ([successData[kRequestRetCode] isEqualToString:kRequestNewSuccessCode]) {
            
            NSDictionary *datas = [successData valueNotNullForKey:kRequestReturnData];
            self.campusDatas = [[NSArray alloc] initWithArray:[datas valueNotNullForKey:@"campuses"]];
           
            //显示上次充值的校区
            NSString *defaultCampusId = [NSString stringWithFormat:@"%@",[datas valueNotNullForKey:@"default_campus_id"]];
            NSMutableDictionary *defaultDic = [NSMutableDictionary dictionary];
            if (![defaultCampusId isEqualToString:@"-1"]) {
                //遍历数据源,用defaultDic存放上一次充值的校区信息
                for (NSDictionary *dic in self.campusDatas) {
                    NSString *netId = [NSString stringWithFormat:@"%@",[dic valueNotNullForKey:@"campus_id"]];
                    if ([netId isEqualToString:defaultCampusId]) {
                        [defaultDic setObject:netId forKey:@"default_id"];
                        [defaultDic setObject:[dic valueNotNullForKey:@"campus_name"] forKey:@"default_name"];
                        [defaultDic setObject:[dic valueNotNullForKey:@"remark"] forKey:@"default_remark"];
                    }
                }
                //显示上次充值成功的校区(从服务端获取)
                NSAttributedString *campusStr = [[NSAttributedString alloc] initWithString:[defaultDic valueNotNullForKey:@"default_name"] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15 * NEW_BILI], NSForegroundColorAttributeName:UIColorFromRGB(0x455a64)}];
                _campusRightLabel.frame = CGRectMake(SCREEN_WIDTH - 35 - campusStr.size.width, (51*NEW_BILI - campusStr.size.height)*0.5, campusStr.size.width , campusStr.size.height);
                _campusRightLabel.attributedText = campusStr;
                
                //显示上次充值成功的宽带Id（从服务端获取）
                _netIdTextField.text = [datas valueForKey:@"default_account_name"];
                
                _selectedCampusId = defaultCampusId;
                _remarkStr = [defaultDic valueNotNullForKey:@"default_remark"];
                [self setupToastView];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:successData[kRequestRetMessage]];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];
}

#pragma mark - Action
//余额查询按钮
- (void)rightItemBtnAction:(UIButton *)button
{
    [self.view endEditing:YES];
    if (!(_selectedCampusId.length > 0)) {
        [SVProgressHUD showErrorWithStatus:@"请选择校区"];
    }else if(!(_netIdTextField.text.length > 0)){
        [SVProgressHUD showErrorWithStatus:@"请输入宽带账号"];
    }else{
        [SVProgressHUD showWithStatus:@"请稍候..."];
        [NetFeesApi getNetBalanceWithNet_account:_netIdTextField.text
                                       campus_id:_selectedCampusId
                                         success:^(NSDictionary *successData) {
                                             BNLog(@"网费查询余额--->>>> %@",successData);
                                             if ([successData[kRequestRetCode] isEqualToString:kRequestNewSuccessCode]) {
                                                 [SVProgressHUD dismiss];
                                                 NSDictionary *datas = [successData valueNotNullForKey:kRequestReturnData];
                                                 BNNetRemainFeesViewController *remainVC = [[BNNetRemainFeesViewController alloc] init];
                                                 remainVC.datas = datas;
                                                 [self pushViewController:remainVC animated:YES];
                                             }else{
                                                 [SVProgressHUD showErrorWithStatus:successData[kRequestRetMessage]];
                                             }
                                         }
                                         failure:^(NSError *error) {
                                             [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                         }];
    }

}

//充值按钮
- (void)rechargeButtonAciton:(UIButton *)button
{
    [SVProgressHUD showWithStatus:@"请稍候..."];
    __weak typeof(self) weakSelf = self;
    [NetFeesApi create_netfee_orderWithCampus_id:_selectedCampusId
                                 recharge_amount:_moneyTf.text
                                     net_account:_netIdTextField.text
                                         success:^(NSDictionary *successData) {
                                             BNLog(@"网费充值创建订单 ---->>>> %@",successData);
                                             if ([successData[@"retcode"] isEqualToString:kRequestNewSuccessCode]) {
                                                 
                                                 //记录充值过的账号到数据库
                                                 NSArray *rechargednetIds = [RechargeNetId MR_findByAttribute:@"netId" withValue:_netIdTextField.text];
                                                 if ([rechargednetIds count] == 0) {//没有在数据库中找到添加到数据库
                                                     RechargeNetId *netId = [RechargeNetId MR_createEntity];
                                                     netId.netId = _netIdTextField.text;
                                                     [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfAndWait];
                                                 }
                                                 
                                                 //跳转喜付收银台
                                                 NSDictionary *datas = [successData valueNotNullForKey:kRequestReturnData];
                                                 BNPayModel *payModel = [[BNPayModel alloc]init];
                                                 payModel.order_no = [datas valueNotNullForKey:@"order_no"];
                                                 payModel.biz_no = [datas valueNotNullForKey:@"biz_no"];
                                                 [weakSelf goToPayCenterWithPayProjectType:PayProjectTypeNetFees
                                                                                  payModel:payModel
                                                                               returnBlockone:^(PayVCJumpType jumpType, id params) {
                                                                                   if (jumpType == PayVCJumpType_PayCompletedBackHomeVC) {
                                                                                       [self.navigationController popToRootViewControllerAnimated:YES];
                                                                                   }
                                                                               }];

                                                 
                                             }else{
                                                 [SVProgressHUD showErrorWithStatus:successData[kRequestRetMessage]];
                                             }
                                         }
                                         failure:^(NSError *error) {
                                             [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                         }];
    
    
}

- (void)tapHandle
{
    [self.view endEditing:YES];
    BNNetFeesSelectCampusVC *selectCampus = [[BNNetFeesSelectCampusVC alloc] init];
    selectCampus.campuses = self.campusDatas;
    selectCampus.selectedIndex = _selectedIndex;
    
    //选择校区完成
    selectCampus.selectedCampusFinished = ^(NSDictionary *selectedCampusData, NSInteger lastSelectedIndex){
        
        NSString *selectedCampusName = [selectedCampusData valueNotNullForKey:@"campus_name"];
        NSString *selectedCampusId = [NSString stringWithFormat:@"%@",[selectedCampusData valueNotNullForKey:@"campus_id"]];
        NSString *remark = [selectedCampusData valueNotNullForKey:@"remark"];
        
        //刷新UI
         NSAttributedString *campusStr = [[NSAttributedString alloc] initWithString:selectedCampusName attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15 * NEW_BILI], NSForegroundColorAttributeName:UIColorFromRGB(0x455a64)}];
        _campusRightLabel.frame = CGRectMake(SCREEN_WIDTH - 35 - campusStr.size.width, (51*NEW_BILI - campusStr.size.height)*0.5, campusStr.size.width, campusStr.size.height);
        _campusRightLabel.attributedText = campusStr;
      
        //加载提示信息
        _remarkStr = remark;
        [self setupToastView];
       
        //选择校区的Id赋值
        _selectedCampusId = selectedCampusId;
        _selectedIndex = lastSelectedIndex;//用_selectedIndex保存了一下上一次选择的校区的index，保证push过去被选择的校区打勾
        
        [self checkRechargeButtonCanUse];

    };
    [self pushViewController:selectCampus animated:YES];
}


- (void)checkRechargeButtonCanUse
{
    if (_netIdTextField.text.length > 0 && _selectedCampusId.length > 0 && _moneyTf.text.length > 0) {
        _rechargeButton.enabled = YES;
    }else{
        _rechargeButton.enabled = NO;
    }
}

#pragma mark - TextField
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _moneyTf) {
        return YES;
    }
    if (textField.text.length > 0) {
        _selectItemView.hidden = YES;
    }else{
//        if (_selectItemView.hidden == YES) {
            [_selectItemView loadNetFeesRechargeData];
//        }
        _selectItemView.hidden = NO;
    }
    
    
    return YES;
}

- (void)textAction:(UITextField *)textField
{
    [self checkRechargeButtonCanUse];
    if (textField == _moneyTf) {
        // 输入框限制
        NSString *str = textField.text;
        if ([str isEqualToString:@"."])
        {
            str = @"";
        }
        else if([str hasPrefix:@"0"] && str.length ==2 )
        {
            if ([str isEqualToString:@"0."])
            {
                return;
            }
            str = [NSString stringWithFormat:@"%ld",(long)[str integerValue]];
        }
        
        else {
            NSString *findStr = @".";
            NSRange foundObj=[str rangeOfString:findStr options:NSCaseInsensitiveSearch];
            if(foundObj.length>0)
            {
                if (str.length > foundObj.location + 3)
                {
                    str = [str substringWithRange:NSMakeRange(0, foundObj.location + 3)];
                }
            }
            NSInteger pointCount = [[str componentsSeparatedByString:@"."] count]-1;
            //pointCount为str中“.“的个数。
            if(pointCount > 1) {
                str = [str substringWithRange:NSMakeRange(0, str.length-1)];
            }
        }
        textField.text = str;
    }else{
        if (textField.text.length > 0) {
            _selectItemView.hidden = YES;
        }else{
            _selectItemView.hidden = NO;
        }
    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

#pragma mark -SelectItemViewDelegate
- (void)selectRechargedNetId:(NSString *)netId
{
    _netIdTextField.text = netId;
    BNLog(@"选择了宽带账号:%@",netId);
}

//监听键盘消失
- (void)keyboardWillHidden:(NSNotification *)noti
{
    if (_selectItemView.hidden == NO) {
        _selectItemView.hidden = YES;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
