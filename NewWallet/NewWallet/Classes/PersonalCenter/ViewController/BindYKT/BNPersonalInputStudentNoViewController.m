//
//  BNPersonalInputStudentNoViewController.m
//  
//
//  Created by crx on 15/8/13.
//
//

#import "BNPersonalInputStudentNoViewController.h"
#import "BNVerifySMSCodeViewController.h"
#import "CardApi.h"

@interface BNPersonalInputStudentNoViewController ()

@property (strong, nonatomic) UITextField *nameTextField;
@property (strong, nonatomic) UITextField *studentNoTextField;

@end

@implementation BNPersonalInputStudentNoViewController

#pragma mark - lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupLoadedView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods

- (void)setupLoadedView {
    [super setupLoadedView];
    
    self.navigationTitle = @"修改学号";
    
    self.view.backgroundColor = UIColor_Gray_BG;
    
    UIView *studentNoBGView = [[UIView alloc] initWithFrame:CGRectMake(0, kSectionHeight, SCREEN_WIDTH, 45 *BILI_WIDTH*2)];
    studentNoBGView.backgroundColor = [UIColor whiteColor];
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    topLine.backgroundColor = UIColor_GrayLine;
    [studentNoBGView addSubview:topLine];
    
    UIView *middleLine = [[UIView alloc] initWithFrame:CGRectMake(10, 45 *BILI_WIDTH, SCREEN_WIDTH, 0.5)];
    middleLine.backgroundColor = UIColor_GrayLine;
    [studentNoBGView addSubview:middleLine];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, studentNoBGView.bounds.size.height-0.5, SCREEN_WIDTH, 0.5)];
    bottomLine.backgroundColor = UIColor_GrayLine;
    [studentNoBGView addSubview:bottomLine];
    
    UILabel *studentNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 90, 45 *BILI_WIDTH)];
    studentNameLabel.textColor = [UIColor blackColor];
    studentNameLabel.textAlignment = NSTextAlignmentLeft;
    studentNameLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
    studentNameLabel.text = @"姓  名";
    [studentNoBGView addSubview:studentNameLabel];
    
    UILabel *studentNoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 45 *BILI_WIDTH, 90, 45 *BILI_WIDTH)];
    studentNoLabel.textColor = [UIColor blackColor];
    studentNoLabel.textAlignment = NSTextAlignmentLeft;
    studentNoLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
    studentNoLabel.text = @"学工号";
    [studentNoBGView addSubview:studentNoLabel];
    
    self.nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, SCREEN_WIDTH - 150, 45 *BILI_WIDTH)];
    self.nameTextField.placeholder = @"请输入姓名";
    self.nameTextField.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
    self.nameTextField.clearButtonMode = UITextFieldViewModeAlways;
    self.nameTextField.borderStyle = UITextBorderStyleNone;
    self.nameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [studentNoBGView addSubview:self.nameTextField];
    
    self.studentNoTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 45*BILI_WIDTH, SCREEN_WIDTH - 150, 45 *BILI_WIDTH)];
    self.studentNoTextField.placeholder = @"请输入新学号";
    self.studentNoTextField.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
    self.studentNoTextField.clearButtonMode = UITextFieldViewModeAlways;
    self.studentNoTextField.borderStyle = UITextBorderStyleNone;
    self.studentNoTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.studentNoTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [studentNoBGView addSubview:self.studentNoTextField];
    
    [self.baseScrollView addSubview:studentNoBGView];
    
    UIButton *modButton = [UIButton buttonWithType:UIButtonTypeCustom];
    modButton.frame = CGRectMake(10, studentNoBGView.frame.origin.y + studentNoBGView.frame.size.height + 30 * BILI_WIDTH, SCREEN_WIDTH - 20, 40 * BILI_WIDTH);
    [modButton setupTitle:@"修改学号" enable:YES];
    [modButton addTarget:self action:@selector(modAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:modButton];
}

#pragma mark - event response

- (void)modAction:(UIButton *)sender
{
    [self.view endEditing:YES];

    if (self.nameTextField.text.length < 2 || ![self.nameTextField.text isEqualToString:shareAppDelegateInstance.boenUserInfo.name]) {
        [SVProgressHUD showErrorWithStatus:@"姓名不对，只能修改成自己的学号"];
        return;
    }
    
    if (self.studentNoTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入学号"];
        return;
    }
    
    //一卡通状态
    [SVProgressHUD showWithStatus:@"请稍候..."];
    
    [CardApi oneCardStususWithUserid:shareAppDelegateInstance.boenUserInfo.userid
                            stuempno:_studentNoTextField.text
                            schoolID:shareAppDelegateInstance.boenUserInfo.schoolId
                             success:^(NSDictionary *successData) {
                                 BNLog(@"一卡通状态--%@", successData);
                                 NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                                 
                                 if ([retCode isEqualToString:kRequestSuccessCode]) {
                                     
                                     NSDictionary *retData = [successData valueForKey:kRequestReturnData];
                                     NSString *status = [NSString stringWithFormat:@"%@", [retData valueNotNullForKey:@"status"]];
                                     
                                     if ([status isEqualToString:@"正常"]) {
                                         
                                         NSString *custnameStr = retData[@"custname"];
                                         if (![self.nameTextField.text isEqualToString:shareAppDelegateInstance.boenUserInfo.name] || ![self.nameTextField.text isEqualToString:custnameStr]) {
                                             [SVProgressHUD showErrorWithStatus:@"姓名不对，只能修改成自己的学号"];
                                             return ;
                                         }
                                         NSString *studentNoStr = retData[@"stuempno"];
                                         if ([studentNoStr isEqualToString:shareAppDelegateInstance.boenUserInfo.stuempno]) {
                                             [SVProgressHUD showErrorWithStatus:@"新旧学号不能一样！"];
                                             return ;
                                         }
                                         [SVProgressHUD dismiss];

                                         BNVerifySMSCodeViewController *smsCodeVC = [[BNVerifySMSCodeViewController alloc] init];
                                         smsCodeVC.useStyle = ViewControllerUseStyleModifyStudentNumber;
                                         smsCodeVC.phoneNumber = shareAppDelegateInstance.boenUserInfo.phoneNumber;
                                         smsCodeVC.studentNumber = self.studentNoTextField.text;
                                         [self pushViewController:smsCodeVC animated:YES];
                                     }else{
                                         NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                         [SVProgressHUD showErrorWithStatus:retMsg];                                     }
                                     
                                 }else{
                                     NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                     [SVProgressHUD showErrorWithStatus:retMsg];
                                 }
                             } failure:^(NSError *error) {
                                 [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                             }];

  
}

@end
