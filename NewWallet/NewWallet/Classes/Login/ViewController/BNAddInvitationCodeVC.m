//
//  BNAddInvitationCodeVC.m
//  Wallet
//
//  Created by mac1 on 15/12/22.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import "BNAddInvitationCodeVC.h"
#import "LoginApi.h"

@interface BNAddInvitationCodeVC ()<UITextFieldDelegate>

@property (weak, nonatomic) UITextField *textField;
@property (weak, nonatomic) UIButton *confirmButton;

@end

@implementation BNAddInvitationCodeVC

static NSString *const descStr = @"邀请码从哪里获得？\n\n可以关注喜付运营活动，参与送二维码。也可以从朋友的邀请处获得哦";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"添加邀请码";
    [self setupLoadedView];
}

- (void)setupLoadedView
{
    [super setupLoadedView];
    self.view.backgroundColor = UIColor_Gray_BG;
    UIView *phoneBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 11 * NEW_BILI, SCREEN_WIDTH, 45*BILI_WIDTH)];
    phoneBackgroundView.backgroundColor = [UIColor whiteColor];
    [self.baseScrollView addSubview:phoneBackgroundView];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    line1.backgroundColor = UIColor_GrayLine;
    [phoneBackgroundView addSubview:line1];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, phoneBackgroundView.frame.size.height-1, SCREEN_WIDTH, 1)];
    line2.backgroundColor = UIColor_GrayLine;
    [phoneBackgroundView addSubview:line2];
    
    UITextField *phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, phoneBackgroundView.frame.size.width - 20, phoneBackgroundView.frame.size.height)];
    phoneTF.placeholder = @"填写邀请码";
    phoneTF.font = [UIFont systemFontOfSize:[BNTools sizeFit:16 six:18 sixPlus:20]];
    phoneTF.clearButtonMode = UITextFieldViewModeAlways;
    phoneTF.borderStyle = UITextBorderStyleNone;
    phoneTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    phoneTF.delegate = self;
    [phoneTF addTarget:self action:@selector(textFieldEditingChangedValue:) forControlEvents:UIControlEventEditingChanged];
    [phoneBackgroundView addSubview:phoneTF];
    _textField = phoneTF;

    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = CGRectMake(10, CGRectGetMaxY(phoneTF.frame) + 22.5*NEW_BILI, SCREEN_WIDTH - 10 *2, 41*NEW_BILI);
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton setupTitle:@"提交" enable:NO];
    [self.baseScrollView addSubview:confirmButton];
    _confirmButton = confirmButton;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(confirmButton.frame.origin.x, CGRectGetMaxY(confirmButton.frame) + 18 * NEW_BILI, 15, 15)];
    imageView.image = [UIImage imageNamed:@"ionc_InvitaionCode"];
    [self.baseScrollView addSubview:imageView];
    
    
    NSAttributedString *desAtts = [[NSAttributedString alloc] initWithString:descStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    CGFloat labelHeight = [descStr boundingRectWithSize:CGSizeMake(314 * NEW_BILI, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
    UILabel *desLabel = [[UILabel alloc] initWithFrame:CGRectMake(33 * NEW_BILI, CGRectGetMinY(imageView.frame), 314 * NEW_BILI, labelHeight)];
    desLabel.attributedText = desAtts;
    desLabel.numberOfLines = 0;
    desLabel.textColor = [UIColor colorWithRed:164/255.0 green:180/255.0 blue:187/255.0 alpha:1.f];
    [self.baseScrollView addSubview:desLabel];
    
    [self.backButton setImage:[UIImage imageNamed:@"Main_Back_btn"] forState:UIControlStateNormal];
}

#pragma mark - UITextFieldTarget
- (void)textFieldEditingChangedValue:(UITextField *)textField
{
    self.confirmButton.enabled = textField.text.length > 0;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length == 0) {
        return YES;   //退格删除
    }
    NSRange theRange = [@"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLIMNOPQRSTUVWXYZ.-_=+@$#%*~|[]^" rangeOfString:string];
    if (theRange.length > 0) {
        return YES;
    } else {
        return NO;
    }
    
    return YES;
}

- (void)confirmButtonClick
{
    [SVProgressHUD showWithStatus:@"正在校验邀请码..."];
    [LoginApi verifyInvitationCodeWithIvt_code:_textField.text.uppercaseString Success:^(NSDictionary *data) {
        if ([[data valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
            [SVProgressHUD showSuccessWithStatus:@"校验成功"];
            shareAppDelegateInstance.boenUserInfo.invitedCode = _textField.text.uppercaseString;//保存一下邀请码；
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [SVProgressHUD showErrorWithStatus:[data valueNotNullForKey:kRequestRetMessage]];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];
}

#pragma mark - backButton
- (void)backButtonClicked:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
