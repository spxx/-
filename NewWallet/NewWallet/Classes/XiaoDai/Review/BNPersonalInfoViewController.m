//
//  BNPersonalInfoViewController.m
//  Wallet
//
//  Created by crx on 15/10/27.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import "BNPersonalInfoViewController.h"
#import "BNNewXiaodaiRealNameInfo.h"
#import "MMDegreeSelectedView.h"
#import "MMPickerActionSheet.h"
#import "MMPopupWindow.h"
#import "XiaoDaiApi.h"
//#import "LDVideoViewController.h"
#import "BNRealNameReviewResultVC.h"

@interface BNPersonalInfoViewController () <DegreeSelectedDelegate, PickerActionSheetDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UITextField *nameTextField;
@property (strong, nonatomic) UITextField *idNumberTextField;
@property (strong, nonatomic) BNNewXiaodaiRealNameInfo *realNameInfo;

@property (strong, nonatomic) UILabel *degreeSelectedLabel;
@property (strong, nonatomic) UILabel *enrollYearSelectedLabel;

@property (strong, nonatomic) NSArray *enrollYearList;

@property (copy, nonatomic) NSString *degreeCode;
@property (copy, nonatomic) NSString *enrollYear;

@property (weak, nonatomic) UIButton *nextButton;

@end

@implementation BNPersonalInfoViewController

static NSString *const IDInfoNotCorrectStr = @"你填写的身份信息有误，请使用本人身份进行申请！";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLoadedView];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self checkNextButtonCanClick];
}

- (void)setupLoadedView
{
    [super setupLoadedView];
    
    self.navigationTitle = @"填写个人信息";
    
    self.view.backgroundColor = UIColor_Gray_BG;
    _realNameInfo = [BNNewXiaodaiRealNameInfo sharedBNNewXiaodaiRealNameInfo];
    
    UILabel *sectionTitle1 = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 90, 30)];
    sectionTitle1.textColor = [UIColor lightGrayColor];
    sectionTitle1.textAlignment = NSTextAlignmentLeft;
    sectionTitle1.font = [UIFont systemFontOfSize:[BNTools sizeFit:12 six:12 sixPlus:14]];
    sectionTitle1.text = @"身份信息";
    [self.baseScrollView addSubview:sectionTitle1];
    
    UIView *bgView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 45 *BILI_WIDTH*2)];
    bgView1.backgroundColor = [UIColor whiteColor];
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    topLine.backgroundColor = UIColor_GrayLine;
    [bgView1 addSubview:topLine];
    
    UIView *middleLine = [[UIView alloc] initWithFrame:CGRectMake(10, 45 *BILI_WIDTH, SCREEN_WIDTH, 0.5)];
    middleLine.backgroundColor = UIColor_GrayLine;
    [bgView1 addSubview:middleLine];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, bgView1.bounds.size.height-0.5, SCREEN_WIDTH, 0.5)];
    bottomLine.backgroundColor = UIColor_GrayLine;
    [bgView1 addSubview:bottomLine];
    
    UILabel *studentNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 90, 45 *BILI_WIDTH)];
    studentNameLabel.textColor = [UIColor blackColor];
    studentNameLabel.textAlignment = NSTextAlignmentLeft;
    studentNameLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
    studentNameLabel.text = @"姓名";
    [bgView1 addSubview:studentNameLabel];
    
    UILabel *studentNoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 45 *BILI_WIDTH, 90, 45 *BILI_WIDTH)];
    studentNoLabel.textColor = [UIColor blackColor];
    studentNoLabel.textAlignment = NSTextAlignmentLeft;
    studentNoLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
    studentNoLabel.text = @"身份证";
    [bgView1 addSubview:studentNoLabel];
    

    self.nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(80, 0, SCREEN_WIDTH - 120, 45 *BILI_WIDTH)];
    self.nameTextField.placeholder = @"请输入本人真实姓名";
    self.nameTextField.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
    self.nameTextField.clearButtonMode = UITextFieldViewModeAlways;
    self.nameTextField.borderStyle = UITextBorderStyleNone;
    self.nameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.nameTextField.text = _realNameInfo.realNameInfoOfName;
    [self.nameTextField addTarget:self action:@selector(nameTextFieldChanged:) forControlEvents:UIControlEventAllEditingEvents];
    [bgView1 addSubview:self.nameTextField];
    
    self.idNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(80, 45*BILI_WIDTH, SCREEN_WIDTH - 120, 45 *BILI_WIDTH)];
    self.idNumberTextField.placeholder = @"请输入本人身份证号";
    self.idNumberTextField.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
    self.idNumberTextField.clearButtonMode = UITextFieldViewModeAlways;
    self.idNumberTextField.borderStyle = UITextBorderStyleNone;
    self.idNumberTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.idNumberTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.idNumberTextField.text = _realNameInfo.realNameInfoOfIdentity;
    [self.idNumberTextField addTarget:self action:@selector(idNumberTextFieldChanged:) forControlEvents:UIControlEventAllEditingEvents];
    [bgView1 addSubview:self.idNumberTextField];
    
    [self.baseScrollView addSubview:bgView1];
    
    UILabel *sectionTitle2 = [[UILabel alloc] initWithFrame:CGRectMake(12, bgView1.bottomValue+22, 90, 15)];
    sectionTitle2.textColor = [UIColor lightGrayColor];
    sectionTitle2.textAlignment = NSTextAlignmentLeft;
    sectionTitle2.font = [UIFont systemFontOfSize:[BNTools sizeFit:12 six:12 sixPlus:14]];
    sectionTitle2.text = @"学籍信息";
    [self.baseScrollView addSubview:sectionTitle2];
    
    UIView *bgView2 = [[UIView alloc] initWithFrame:CGRectMake(0, sectionTitle2.bottomValue+9, SCREEN_WIDTH, 45 *BILI_WIDTH*2)];
    bgView2.backgroundColor = [UIColor whiteColor];
    
    UIView *topLine2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    topLine2.backgroundColor = UIColor_GrayLine;
    [bgView2 addSubview:topLine2];
    
    UIView *middleLine2 = [[UIView alloc] initWithFrame:CGRectMake(10, 45 *BILI_WIDTH, SCREEN_WIDTH, 0.5)];
    middleLine2.backgroundColor = UIColor_GrayLine;
    [bgView2 addSubview:middleLine2];
    
    UIView *bottomLine2 = [[UIView alloc] initWithFrame:CGRectMake(0, bgView1.bounds.size.height-0.5, SCREEN_WIDTH, 0.5)];
    bottomLine2.backgroundColor = UIColor_GrayLine;
    [bgView2 addSubview:bottomLine2];
    
    UILabel *degreeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 120, 45 *BILI_WIDTH)];
    degreeLabel.textColor = [UIColor blackColor];
    degreeLabel.textAlignment = NSTextAlignmentLeft;
    degreeLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
    degreeLabel.text = @"学历和年级";
    [bgView2 addSubview:degreeLabel];
    
    self.degreeSelectedLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-15-16-120, 0, 120, 45 *BILI_WIDTH)];
    self.degreeSelectedLabel.textColor = [UIColor grayColor];
    self.degreeSelectedLabel.textAlignment = NSTextAlignmentRight;
    self.degreeSelectedLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
    self.degreeSelectedLabel.text = _realNameInfo.realNameInfoOfGradeString;
    [bgView2 addSubview:self.degreeSelectedLabel];
    
    UILabel *enrollYearLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 45 *BILI_WIDTH, 90, 45 *BILI_WIDTH)];
    enrollYearLabel.textColor = [UIColor blackColor];
    enrollYearLabel.textAlignment = NSTextAlignmentLeft;
    enrollYearLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
    enrollYearLabel.text = @"入学年份";
    [bgView2 addSubview:enrollYearLabel];
    
    self.enrollYearSelectedLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-15-16-90, 45 *BILI_WIDTH, 90, 45 *BILI_WIDTH)];
    self.enrollYearSelectedLabel.textColor = [UIColor grayColor];
    self.enrollYearSelectedLabel.textAlignment = NSTextAlignmentRight;
    self.enrollYearSelectedLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
    self.enrollYearSelectedLabel.text = _realNameInfo.realNameInfoOfEnrollYear;
    [bgView2 addSubview:self.enrollYearSelectedLabel];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_arrow"]];
    arrowView.frame = CGRectMake(SCREEN_WIDTH-15-16, 0, 16, 16);
    arrowView.centerYValue = bgView2.heightValue/4;
    [bgView2 addSubview:arrowView];
    
    arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_arrow"]];
    arrowView.frame = CGRectMake(SCREEN_WIDTH-15-16, 0, 16, 16);
    arrowView.centerYValue = bgView2.heightValue*3/4;
    [bgView2 addSubview:arrowView];
    
    UIButton *degreeActionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    degreeActionButton.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40 * BILI_WIDTH);
    [degreeActionButton addTarget:self action:@selector(degreeSelectAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView2 addSubview:degreeActionButton];
    
    UIButton *enrollYearActionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    enrollYearActionButton.frame = CGRectMake(0, 40 * BILI_WIDTH, SCREEN_WIDTH, 40 * BILI_WIDTH);
    [enrollYearActionButton addTarget:self action:@selector(enrollYearAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView2 addSubview:enrollYearActionButton];
    
    [self.baseScrollView addSubview:bgView2];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10*BILI_WIDTH, bgView2.bottomValue+38, SCREEN_WIDTH - 20*BILI_WIDTH, 40 * BILI_WIDTH);
    [button setupRedBtnTitle:@"下一步" enable:NO];
    [button addTarget:self action:@selector(nextStepAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:button];
    _nextButton = button;
    
    self.baseScrollView.scrollEnabled = NO;
    
    __weak __typeof(self) weakSelf = self;
    [self.view setTapActionWithBlock:^{
        [weakSelf.nameTextField resignFirstResponder];
        [weakSelf.idNumberTextField resignFirstResponder];
    }];
    
    [XiaoDaiApi getEnrollYearList:^(NSDictionary *successData) {
        BNLog(@"enroll year list--%@", successData);
        NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
        
        if ([retCode isEqualToString:kRequestSuccessCode]) {
            NSDictionary *dataDic = [successData valueForKey:kRequestReturnData];
            weakSelf.enrollYearList = [dataDic valueForKey:@"enroll_year_list"];
        }
    } failure:^(NSError *error) {
        
    }];
    
    [[MMPopupWindow sharedWindow] cacheWindow];
    [MMPopupWindow sharedWindow].touchWildToHide = YES;
}

- (void)degreeSelectAction {
    [self.view endEditing:YES];
    MMDegreeSelectedView *selectedView = [MMDegreeSelectedView new];
    if (self.degreeSelectedLabel.text.length > 0) {
        [selectedView setDefaultSelected:self.degreeSelectedLabel.text];
    }
    selectedView.delegate = self;
    [selectedView show];
}

- (void)enrollYearAction {
     [self.view endEditing:YES];
    if (self.enrollYearList) {
        MMPickerActionSheet *pickerAS = [MMPickerActionSheet new];
        [pickerAS setComponents:@[self.enrollYearList]];
        if (self.enrollYear) {
            [pickerAS setDefaultSelect:@[@(self.enrollYear.integerValue)]];
        }
        pickerAS.delegate = self;
        [pickerAS show];
    }
}

#pragma mark - TextFieldChanged
- (void)nameTextFieldChanged:(UITextField *)textField
{
    self.realNameInfo.realNameInfoOfName = textField.text;
    [self checkNextButtonCanClick];
}
- (void)idNumberTextFieldChanged:(UITextField *)textField
{
    self.realNameInfo.realNameInfoOfIdentity = textField.text;
    [self checkNextButtonCanClick];
}

- (void)nextStepAction:(UIButton *)sender{
    // -----http环境测试暂时去掉绑定学号-----
    if (![shareAppDelegateInstance.boenUserInfo.name isEqualToString:_nameTextField.text]) {
        [SVProgressHUD showErrorWithStatus:IDInfoNotCorrectStr];
        return;
    }
    shareAppDelegateInstance.alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"为了资金借贷安全 你需要进行人脸识别过后才能进行交易!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去认证", nil];
    [shareAppDelegateInstance.alertView show];
}

- (void)checkNextButtonCanClick
{
    _nextButton.enabled = [_realNameInfo checkAllPropertyValues];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //跳转人脸识别界面
        NSArray *faceImages = [Tools getLivenessDetectionImages:shareAppDelegateInstance.boenUserInfo.userid];
        if (faceImages && faceImages.count == 4) {
            BNRealNameReviewResultVC *resultVC = [[BNRealNameReviewResultVC alloc] init];
            resultVC.reviewResult = RealNameReviewResult_UploadFailed;
            [self pushViewController:resultVC animated:YES];
           
        } else {
            //人脸识别
//            LDVideoViewController *takeVC = [[LDVideoViewController alloc] initWithNibName:@"LDVideoViewController" bundle:nil];
//            [self pushViewController:takeVC animated:YES];
        }

    }
}

#pragma mark - 学历年级选择代理方法
- (void)selectedTitle:(NSString *)title code:(NSNumber *)code {
    self.degreeSelectedLabel.text = title;
    self.degreeCode = [NSString stringWithFormat:@"%@",code];
    self.realNameInfo.realNameInfoOfGradeCode = [NSString stringWithFormat:@"%@",code];
    self.realNameInfo.realNameInfoOfGradeString = title;
    [self checkNextButtonCanClick];
}

#pragma mark - 入学年份选择代理方法
- (void)selectedTitles:(NSArray *)titles {
    NSString *year = titles.firstObject;
    self.enrollYearSelectedLabel.text = year;
    self.enrollYear = year;
    self.realNameInfo.realNameInfoOfEnrollYear = year;
    [self checkNextButtonCanClick];
}

#pragma mark - backButtonAction
- (void)backButtonClicked:(UIButton *)sender
{
    if (self.navigationController.viewControllers.count > 1) {
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:NSClassFromString(@"BNHomeViewController")]) {
                [self.navigationController popToViewController:vc animated:YES];
                break;
            }
        }
    }
}

@end
