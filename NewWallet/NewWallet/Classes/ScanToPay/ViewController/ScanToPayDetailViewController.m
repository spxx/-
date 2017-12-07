//
//  ScanToPayDetailViewController.m
//  Wallet
//
//  Created by 陈荣雄 on 5/11/16.
//  Copyright © 2016 BNDK. All rights reserved.
//

#import "ScanToPayDetailViewController.h"
#import "PlaceholderCenterTextField.h"
#import "ScanToPayApi.h"

@interface ScanToPayDetailViewController () <UITextFieldDelegate>

@property (weak, nonatomic) UILabel *shopName;
@property (weak, nonatomic) UILabel *masterNameAndPhone;
@property (weak, nonatomic) UITextField *amountField;

@end

@implementation ScanToPayDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView {
    self.navigationTitle = @"扫码支付";
    
    UIImageView *shopIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, self.sixtyFourPixelsView.viewBottomEdge+15, 40, 40)];
    shopIcon.image = [UIImage imageNamed:@"shop_icon"];
    [self.view addSubview:shopIcon];
    
    UILabel *shopName = [[UILabel alloc] initWithFrame:CGRectMake(15+40+25, self.sixtyFourPixelsView.viewBottomEdge+25, SCREEN_WIDTH-15+40+25, 20)];
    shopName.font = [UIFont systemFontOfSize:15];
    shopName.textColor = [UIColor string2Color:@"#263238"];
    shopName.text = [self.shopInfo valueNotNullForKey:@"shop_name"];
    [self.view addSubview:shopName];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(15+40+20, shopName.bottomValue+25, SCREEN_WIDTH-15+40+20, 0.5)];
    line1.backgroundColor = UIColor_GrayLine;
    [self.view addSubview:line1];
    
    UILabel *masterLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, line1.bottomValue+11, 50, 20)];
    masterLabel.text = @"店主";
    masterLabel.textColor = [UIColor string2Color:@"#b0bec5"];
    masterLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:masterLabel];
    
    UILabel *masterNameAndPhone = [[UILabel alloc] initWithFrame:CGRectMake(15+40+25, line1.bottomValue+11, SCREEN_WIDTH-15+40+25, 20)];
    masterNameAndPhone.font = [UIFont systemFontOfSize:14];
    masterNameAndPhone.textColor = [UIColor string2Color:@"#263238"];
    masterNameAndPhone.text = [NSString stringWithFormat:@"%@  %@", [self.shopInfo valueNotNullForKey:@"shop_master_name"], [self.shopInfo valueNotNullForKey:@"shop_mobile"]];
    self.masterNameAndPhone = masterNameAndPhone;
    [self.view addSubview:masterNameAndPhone];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(15, masterNameAndPhone.bottomValue+11, 0, 0.5)];
    line2.backgroundColor = UIColor_GrayLine;
    [self.view addSubview:line2];
    
    UILabel *amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, line2.bottomValue+18, 50, 20)];
    amountLabel.text = @"付款";
    amountLabel.textColor = [UIColor string2Color:@"#b0bec5"];
    amountLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:amountLabel];
    
    UIView *fieldBg = [[UIView alloc] initWithFrame:CGRectMake(22, amountLabel.bottomValue+17, SCREEN_WIDTH-22*2, 44)];
    fieldBg.layer.borderColor = UIColor_GrayLine.CGColor;
    fieldBg.layer.borderWidth = 1;
    fieldBg.layer.cornerRadius = 3;
    [self.view addSubview:fieldBg];
    
    PlaceholderCenterTextField *amountField = [[PlaceholderCenterTextField alloc] initWithFrame:CGRectInset(fieldBg.frame, 5, 5)];
    amountField.placeholder = @"询问服务员后进行输入付款金额";
    amountField.borderStyle = UITextBorderStyleNone;
    //[amountField setValue:[UIColor string2Color:@"#b0bec5"] forKeyPath:@"_placeholderLabel.textColor"];
    //[amountField setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    amountField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    amountField.keyboardType = UIKeyboardTypeDecimalPad;
    amountField.delegate = self;
    self.amountField = amountField;
    [self.view addSubview:amountField];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, amountField.bottomValue+63, SCREEN_WIDTH - 40, 44);
    [button setupTitle:@"付款" enable:YES];
    [button addTarget:self action:@selector(payTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)setShopInfo:(NSDictionary *)shopInfo {
    _shopInfo = shopInfo;
    
    self.shopName.text = shopInfo[@"shop_name"];
    self.masterNameAndPhone.text = [NSString stringWithFormat:@"%@  %@", shopInfo[@"shop_master_name"], shopInfo[@"shop_mobile"]];
}

- (void)backButtonClicked:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)payTapped:(id)sender {
    
    BNLog(@"Info: %@", self.shopInfo);
    
    CGFloat amount = self.amountField.text.floatValue;
    
    NSString *amountString = [NSString stringWithFormat:@"%.2f", amount];
    /*if ([amountString hasSuffix:@".00"]) {
        amountString = [amountString substringToIndex:amountString.length-3];
    }*/
    
    if (amount > 0) {
        [SVProgressHUD show];
        
        __weak typeof(self) weakSelf = self;
        [ScanToPayApi createOrder:amountString
                       shopKey:[self.shopInfo valueForKey:@"shop_key"]
                        cashierKey:[self.shopInfo valueForKey:@"cashier_key"]
                         qrCodeKey:[self.shopInfo valueForKey:@"qr_code_key"]
                          succeed:^(NSDictionary *returnData) {
                              
                              NSString *retCode = [returnData valueNotNullForKey:kRequestRetCode];
                              if ([retCode isEqualToString:@"000000"]) {
                                  [SVProgressHUD dismiss];
                                  
                                  NSDictionary *data = [returnData valueForKey:kRequestReturnData];
                                  
                                  BNPayModel *payModel = [[BNPayModel alloc]init];
                                  payModel.order_no = [data valueNotNullForKey:@"order_no"];
                                  payModel.biz_no = [data valueNotNullForKey:@"biz_no"];
                                  [weakSelf goToPayCenterWithPayProjectType:PayProjectTypeScanToPay
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
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.amountField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    if ([string isEqualToString:@""]) {
        return YES;
    }
    NSArray *digis = [textField.text componentsSeparatedByString:@"."];
    if (digis.count == 2) {
        if ([digis[1] length] == 2) {
            return NO;
        }
    }
    return YES;
}

@end
