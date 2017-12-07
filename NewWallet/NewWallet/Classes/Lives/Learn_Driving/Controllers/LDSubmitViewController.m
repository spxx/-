//
//  LDSubmitViewController.m
//  Wallet
//
//  Created by 陈荣雄 on 5/30/16.
//  Copyright © 2016 BNDK. All rights reserved.
//

#import "LDSubmitViewController.h"
#import "LearnDrivingApi.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "NSString+Extension.h"

@interface LDSubmitViewController () <UITextFieldDelegate>

@property (weak, nonatomic) UITextField *nameField;
@property (weak, nonatomic) UITextField *phoneField;
@property (weak, nonatomic) UITextField *couponField;

@end

@implementation LDSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupLoadedView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupLoadedView {
    UIScrollView *theScollView = [[TPKeyboardAvoidingScrollView alloc]initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT- self.sixtyFourPixelsView.viewBottomEdge)];
    theScollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge + 1);
    theScollView.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:theScollView belowSubview:self.sixtyFourPixelsView];
    
    self.baseScrollView = theScollView;
    
    self.navigationTitle = @"报名信息";
    
    self.view.backgroundColor = UIColor_Gray_BG;
    
    UIView *whiteBg = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 80)];
    whiteBg.backgroundColor = [UIColor whiteColor];
    [self.baseScrollView addSubview:whiteBg];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-10-100, 40)];
    label.text = [self.classInfo valueForKey:@"class_name"];
    label.font = [UIFont systemFontOfSize:14];
    [whiteBg addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, 0, 100, 40)];
    label.text = [NSString stringWithFormat:@"¥%@", self.payType.integerValue==1 ? [self.classInfo valueForKey:@"class_total_fee"] : [self.classInfo valueForKey:@"first_pay_fee"]];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = RGB(198, 0, 14);
    label.textAlignment = NSTextAlignmentCenter;
    [whiteBg addSubview:label];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = UIColor_GrayLine;
    [whiteBg addSubview:line];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, SCREEN_WIDTH-10*2, 40)];
    label.text = self.payType.integerValue==1 ? [self.classInfo valueForKey:@"once_pay_desc"] : [self.classInfo valueForKey:@"installment_pay_desc"];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = RGB(126, 147, 158);
    [whiteBg addSubview:label];
    
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, whiteBg.bottomValue+10, 100, 20)];
    label.text = @"学员信息";
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = RGB(126, 147, 158);
    [self.baseScrollView addSubview:label];
    
    whiteBg = [[UIView alloc] initWithFrame:CGRectMake(0, label.bottomValue+5, SCREEN_WIDTH, 80)];
    whiteBg.backgroundColor = [UIColor whiteColor];
    [self.baseScrollView addSubview:whiteBg];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 40)];
    label.text = @"姓名";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = RGB(126, 147, 158);
    [whiteBg addSubview:label];
    
    UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(80, 0, SCREEN_WIDTH-100, 40)];
    field.borderStyle = UITextBorderStyleNone;
    field.font = [UIFont systemFontOfSize:14];
    field.placeholder = @"请输入报名人的姓名";
    field.delegate = self;
    [whiteBg addSubview:field];
    self.nameField = field;
    
    line = [[UIView alloc] initWithFrame:CGRectMake(80, 40, SCREEN_WIDTH-80, 0.5)];
    line.backgroundColor = UIColor_GrayLine;
    [whiteBg addSubview:line];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 100, 40)];
    label.text = @"手机号";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = RGB(126, 147, 158);
    [whiteBg addSubview:label];
    
    field = [[UITextField alloc] initWithFrame:CGRectMake(80, 40, SCREEN_WIDTH-100, 40)];
    field.borderStyle = UITextBorderStyleNone;
    field.keyboardType = UIKeyboardTypePhonePad;
    field.font = [UIFont systemFontOfSize:14];
    field.placeholder = @"请输入报名人的手机号";
    field.delegate = self;
    [whiteBg addSubview:field];
    self.phoneField = field;
    
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, whiteBg.bottomValue+10, 100, 20)];
    label.text = @"优惠活动";
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = RGB(126, 147, 158);
    [self.baseScrollView addSubview:label];
    
    
    whiteBg = [[UIView alloc] initWithFrame:CGRectMake(0, label.bottomValue+5, SCREEN_WIDTH, 40)];
    whiteBg.backgroundColor = [UIColor whiteColor];
    [self.baseScrollView addSubview:whiteBg];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 40)];
    label.text = @"推荐人手机号";
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = RGB(126, 147, 158);
    [whiteBg addSubview:label];
    
    field = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, SCREEN_WIDTH-100, 40)];
    field.borderStyle = UITextBorderStyleNone;
    field.keyboardType = UIKeyboardTypePhonePad;
    field.font = [UIFont systemFontOfSize:13];
    field.placeholder = @"请输入推荐人手机号，享受喜付优惠";
    field.delegate = self;
    [whiteBg addSubview:field];
    self.couponField = field;
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.frame = CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50);
    [commitButton setupTitle:@"提交报名" enable:YES];
    [commitButton setBackgroundImage:[Tools imageWithColor:RGB(54, 113, 255) andSize:CGSizeMake(SCREEN_WIDTH, 50)] forState:UIControlStateNormal];
    commitButton.layer.cornerRadius = 0;
    [commitButton addTarget:self action:@selector(commitTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitButton];
    
    __weak __typeof(self) weakSelf = self;
    [self.view setTapActionWithBlock:^{
        [weakSelf.nameField resignFirstResponder];
        [weakSelf.phoneField resignFirstResponder];
        [weakSelf.couponField resignFirstResponder];
    }];
}

- (void)commitTapped:(UIButton *)button {
    if (![self.nameField.text isChineseUserName]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的姓名"];
        return;
    }
    
    if (![self.phoneField.text isMobilePhone]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
    
    if (self.couponField.text.length > 0 && ![self.couponField.text isMobilePhone]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的推荐人手机号"];
        return;
    }
    
    [SVProgressHUD show];
    
    __weak __typeof(self) weakSelf = self;
    id amount = self.payType.integerValue==1 ? [self.classInfo valueNotNullForKey:@"class_total_fee"] : [self.classInfo valueNotNullForKey:@"first_pay_fee"];
    [LearnDrivingApi submit:[self.classInfo valueNotNullForKey:@"class_key"]
                    payType:self.payType
                  payAmount:amount
                   realName:self.nameField.text
              contactMobile:self.phoneField.text
                redeem_code:self.couponField.text
                    succeed:^(NSDictionary *returnData) {
        
                        BNLog(@"submit: %@", returnData);
                        
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

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    if (self.nameField == textField) {
        /*if ([string isEqualToString:@""]) {
            return YES;
        }
        
        if (![string isChinese]) {
            return NO;
        }*/
    }
    
    if (self.phoneField == textField || self.couponField == textField) {
        if ([string isEqualToString:@""]) {
            return YES;
        }
        
        if ((textField.text.length+string.length) > 11) {
            return NO;
        }
        
        if (textField.text.length == 0 && ![string isEqualToString:@"1"]) {
            return NO;
        }
        
        BOOL isValid = YES;
        for(int i=0; i< [string length];i++)
        {
            int a =[string characterAtIndex:i];
            if( a < 48 || a > 57){
                isValid = NO;
                break;
            }
        }
        return isValid;
    }

    return YES;
}

@end
