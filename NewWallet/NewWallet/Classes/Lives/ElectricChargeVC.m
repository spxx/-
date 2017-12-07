//
//  ElectricChargeVC.m
//  Wallet
//
//  Created by mac1 on 15/8/4.oo
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "ElectricChargeVC.h"
#import "CardApi.h"
#import "NewElectricFeesApi.h"

@interface ElectricChargeVC ()<UIAlertViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITextField *roomRightTf;

@end

@implementation ElectricChargeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"充值电费";
    [self setupSubViews];
    self.cardArray = [[NSArray alloc] init];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)setupSubViews
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge)];
    scrollView.backgroundColor = UIColor_Gray_BG;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height + 1);
    [self.view addSubview:scrollView];
    
    
    UIView *whiteBKView = [[UIView alloc] initWithFrame:CGRectMake(0, 12 * BILI_WIDTH, SCREEN_WIDTH, [BNTools sizeFitfour:76.9 five:91 six:106.8 sixPlus:118])];
    whiteBKView.backgroundColor = [UIColor whiteColor];
    whiteBKView.layer.borderColor = UIColor_GrayLine.CGColor;
    whiteBKView.layer.borderWidth = 0.5;
    [scrollView addSubview:whiteBKView];
    
    
    UILabel *roomLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 * BILI_WIDTH, 0, 70 * BILI_WIDTH, whiteBKView.frame.size.height/2.0)];
    roomLeftLabel.text = @"房间号码";
    roomLeftLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:16 six:18 sixPlus:20]];
    roomLeftLabel.textColor = [UIColor blackColor];
    [whiteBKView addSubview:roomLeftLabel];
    
    self.roomRightTf = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(roomLeftLabel.frame) + 20 * BILI_WIDTH, roomLeftLabel.frame.origin.y, 215 * BILI_WIDTH, CGRectGetHeight(roomLeftLabel.frame))];
    _roomRightTf.text = _roomStr;
    _roomRightTf.placeholder = @"请输入要充值的房间号";
    _roomRightTf.delegate = self;
    _roomRightTf.clearButtonMode = UITextFieldViewModeAlways;
    _roomRightTf.font = [UIFont systemFontOfSize:[BNTools sizeFit:16 six:18 sixPlus:20]];
    _roomRightTf.textColor = [UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1.0f];
    [_roomRightTf addTarget:self action:@selector(roomTextFieldChaged) forControlEvents:UIControlEventAllEditingEvents];
    [whiteBKView addSubview:_roomRightTf];
    
    UIView *middleLine = [[UIView alloc] initWithFrame:CGRectMake(roomLeftLabel.frame.origin.x, CGRectGetMaxY(roomLeftLabel.frame), SCREEN_WIDTH - 15 * BILI_WIDTH, 0.5)];
    middleLine.backgroundColor = UIColor_GrayLine;
    [whiteBKView addSubview:middleLine];
    
    UILabel *jinELabel = [[UILabel alloc] initWithFrame:CGRectMake(roomLeftLabel.frame.origin.x, CGRectGetMaxY(middleLine.frame), CGRectGetWidth(roomLeftLabel.frame), CGRectGetHeight(roomLeftLabel.frame) - 0.5)];
    jinELabel.text = @"充值金额";
    jinELabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:16 six:18 sixPlus:20]];
    jinELabel.textColor = [UIColor blackColor];
    [whiteBKView addSubview:jinELabel];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(_roomRightTf.frame.origin.x, CGRectGetMaxY(middleLine.frame), CGRectGetWidth(_roomRightTf.frame), CGRectGetHeight(_roomRightTf.frame) - 0.5)];
    _textField.textColor = [UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1.0f];
    _textField.placeholder = @"请输入充值金额";
    _textField.delegate = self;
    _textField.keyboardType = UIKeyboardTypeDecimalPad;
    [_textField addTarget:self action:@selector(textFieldChage) forControlEvents:UIControlEventAllEditingEvents];
    [whiteBKView addSubview:_textField];
    
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmButton.frame = CGRectMake(10 * BILI_WIDTH, CGRectGetMaxY(whiteBKView.frame) + 35 * BILI_WIDTH, SCREEN_WIDTH - 20 * BILI_WIDTH, 40 * BILI_WIDTH);
    [_confirmButton setupTitle:@"确认充值" enable:NO];
    _confirmButton.layer.cornerRadius = 2;
    [_confirmButton addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:_confirmButton];
}

#pragma mark  确认充值按钮
- (void)confirmButtonAction
{
    [self.view endEditing:YES];
    [self createEelectricOrderbill];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (string.length == 0) {
        return YES;   //退格删除
    }
    if (textField == _roomRightTf) {
        NSRange range = [@"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLIMNOPQRSTUVWXYZ.-_=+@$#%*~|[]^" rangeOfString:string];
        if (range.length > 0) {
            return YES;
        } else {
            return NO;
        }
    }else if (textField == _textField) {
        NSString *strVar = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if ([strVar length] > 6) {
            return NO; //最多可以输6位。
        }
    }
    
    return YES;
}

- (void)roomTextFieldChaged
{
    if (_textField.text.length > 0 && _roomRightTf.text.length > 0 && _textField.text.floatValue >= ElectricRechargeMiniAmount && _textField.text.floatValue <= ElectricRechargeMaxAmount) {
        _confirmButton.enabled = YES;
    }
    else{
        _confirmButton.enabled = NO;
    }
    
}

- (void)textFieldChage
{
    if (_textField.text.length > 0 && _roomRightTf.text.length > 0  && _textField.text.floatValue >= ElectricRechargeMiniAmount && _textField.text.floatValue <= ElectricRechargeMaxAmount) {
        _confirmButton.enabled = YES;
    }
    else{
        _confirmButton.enabled = NO;
    }
    // 输入框限制
    NSString *str = _textField.text;
    if (!isRechargeTest && ([str isEqualToString:@"0"] || [str isEqualToString:@"."])) {
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
    _textField.text = str;
    
}

- (void)createEelectricOrderbill
{
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"请稍候"];
    [NewElectricFeesApi newPay_Electric_Create_orderWithSchool_id:shareAppDelegateInstance.boenUserInfo.schoolId
                                                           amount:_textField.text
                                                          room_id:_roomRightTf.text
                                                          bill_id:nil
                                                          success:^(NSDictionary *successData) {
                                                              BNLog(@"新电费--->>>>>%@",successData);
                                                              if ([successData[kRequestRetCode] isEqualToString:kRequestNewSuccessCode]) {
                                                                  [SVProgressHUD dismiss];
                                                                  NSDictionary *dataDic = [successData valueNotNullForKey:kRequestReturnData];
                                                                  //
                                                                  BNPayModel *payModel = [[BNPayModel alloc] init];
                                                                  payModel.goodsName = @"电费充值";
                                                                  payModel.userName = [dataDic valueNotNullForKey:@"buyer_name"];
                                                                  payModel.goodsNumber = [dataDic valueNotNullForKey:@"room_id"];
                                                                  payModel.salePrice = _textField.text;
                                                                  payModel.order_no = [dataDic valueNotNullForKey:@"order_no"];
                                                                  payModel.biz_no = [dataDic valueNotNullForKey:@"biz_no"];
                                                                  [weakSelf goToPayCenterWithPayProjectType:PayProjectTypeDianFei
                                                                                               payModel:payModel
                                                                                            returnBlockone:^(PayVCJumpType jumpType, id params) {
                                                                                                if (jumpType == PayVCJumpType_PayCompletedBackHomeVC) {
                                                                                                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                                                                                                }
                                                                                            }];
                                                              } else {
                                                                  [SVProgressHUD showErrorWithStatus:[successData valueNotNullForKey:kRequestRetMessage]];
                                                              }
                                                              
                                                          }
                                                          failure:^(NSError *error) {
                                                              [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                                              BNLog(@"新电费error---->>>>>%@",error.description);
                                                          }];

}

- (void)tapHandle
{
    [self.view endEditing:YES];
}

@end
