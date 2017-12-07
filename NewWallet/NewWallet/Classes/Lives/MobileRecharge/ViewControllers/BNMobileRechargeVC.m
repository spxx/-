//
//  BNMobileRechargeVC.m
//  Wallet
//
//  Created by mac on 14-12-31.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNMobileRechargeVC.h"

#import "BNMobileRechargeRecordListVC.h"

#import "BNPickerBoard.h"

#import <AddressBook/AddressBook.h>

#import <AddressBookUI/AddressBookUI.h>

#import "RechargePhoneNumer.h"

#import "MobileRechargeApi.h"

#import "SelectItemView.h"

#import "BannerApi.h"

#import "CustomIOS7AlertView.h"

#import "BNMobileRechargeResaultVC.h"

#import "Tools.h"

#import "UIButton+BNNextStepButton.h"

#import "RechargePhoneNumer.h"

#import "TopTabBar.h"
#import "RechargeGridView.h"

@interface BNMobileRechargeVC ()<UITextFieldDelegate, ABPeoplePickerNavigationControllerDelegate, ABPersonViewControllerDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate, TopTabBarDelegate, RechargeGridViewDelegate>

@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) UITextField  *phoneTextField;

@property (weak, nonatomic) UIButton *addressBookButton;
@property (weak, nonatomic) UIButton *rechargeButton;

@property (strong, nonatomic) UILabel *phoneDescription;
@property (weak, nonatomic) UILabel *amountLabel;
@property (weak, nonatomic) UILabel *favorPriceLabel;

@property (weak, nonatomic) UIView *mobileBK;

@property (strong, nonatomic) NSString *rechargePhoneNumber;
@property (strong, nonatomic) NSString *mobileServerName;
@property (strong, nonatomic) NSString *rechargeAmount;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *bndk_amount;
@property (strong, nonatomic) NSString *sp_amount;
@property (strong, nonatomic) NSString *pid;

@property (strong, nonatomic) SelectItemView *selectItemView;

@property (nonatomic) BNMobileRechargeRasultInfo *resultInfo;
@property (nonatomic) BOOL openRechage;  //是否开放了手机充值。

@property (strong, nonatomic) NSArray *rechargeItems;
@property (strong, nonatomic) NSDictionary *rechargeFlowItems;
@property (strong, nonatomic) TopTabBar *topTabBar;
@property (strong, nonatomic) RechargeGridView *gridView;
@property (strong, nonatomic) RechargeItem *selectedItem;

@property (nonatomic) UILabel *nullLabel;//手机流量充值：业务调整，敬请期待

@end

@implementation BNMobileRechargeVC

#pragma mark - set and get
- (void)setMobileServerName:(NSString *)name
{
    _mobileServerName = name;
    if ([self.rechargePhoneNumber isEqualToString:shareAppDelegateInstance.boenUserInfo.phoneNumber]) {
        self.phoneDescription.text = [NSString stringWithFormat:@"用户绑定号码 %@", name];
    }
    else {
        self.phoneDescription.text = name;
    }
}

- (void)setRechargeAmount:(NSString *)amount
{
    _rechargeAmount = amount;
    _amountLabel.text = [amount length] > 0 ? [amount stringByAppendingString:@"元"] : @"";
    _favorPriceLabel.attributedText = nil;
}

- (void)setRechargePhoneNumber:(NSString *)number
{
    _rechargePhoneNumber = number;
    self.phoneTextField.text = number;
    _selectItemView.hidden = YES;
    if ([number isEqualToString:shareAppDelegateInstance.boenUserInfo.phoneNumber]) {
        _phoneTextField.backgroundColor = [UIColor clearColor];
    }else{
        _phoneTextField.backgroundColor = [UIColor whiteColor];
    }
    if ([number length] == 11) {
        if ([number hasPrefix:@"1"]) {
            [self checkPhoneNumberAddress:number];
        }else{
            self.phoneDescription.textColor = [UIColor redColor];
            self.phoneDescription.text = @"号码格式错误";
            _rechargeButton.enabled = NO;
            _favorPriceLabel.attributedText = nil;
        }
        
    }else{
        self.phoneDescription.textColor = [UIColor redColor];
        self.phoneDescription.text = @"号码格式错误";
        _rechargeButton.enabled = NO;
        _favorPriceLabel.attributedText = nil;
    }
}
- (void)setPrice:(NSString *)thePrice
{
    _price = thePrice;
    self.rechargeButton.enabled = YES;
    self.favorPriceLabel.attributedText = [self packageThePriceString:thePrice];
}

- (NSAttributedString *)packageThePriceString:(NSString *)str
{
    NSMutableAttributedString *attStr = nil;
    if ([str length] > 0) {
        attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"优惠价：%@元", str]];
        [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 4)];
        [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4, [attStr length] - 4)];
        [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, [attStr length])];
    }
    
    return attStr;
}

#pragma mark - load view
- (void)setupLoadedView
{
    self.navigationTitle = @"手机充值";
    
    self.view.backgroundColor = UIColor_Gray_BG;
    
    UIScrollView *theScollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT)];
    theScollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge + 1);
    [self.view addSubview:theScollView];
    self.scrollView = theScollView;
    
    self.topTabBar = [[TopTabBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50) titles:@[@"话费充值", @"流量充值"] style:HintStyle_EqualWidth];
    self.topTabBar.delegate = self;
    [self.scrollView addSubview:self.topTabBar];

    UIView *mobileBKView = [[UIView alloc] initWithFrame:CGRectMake(0, kSectionHeight+50, SCREEN_WIDTH, self.scrollView.heightValue-kSectionHeight-50)];
    mobileBKView.backgroundColor = [UIColor whiteColor];
    self.mobileBK = mobileBKView;
    
    UIButton *addressBookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addressBookBtn.frame = CGRectMake(SCREEN_WIDTH - 50, 19, 48, 38);
    [addressBookBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 5)];
    addressBookBtn.backgroundColor = [UIColor whiteColor];
    [addressBookBtn setImage:[UIImage imageNamed:@"address_book_unclicked"] forState:UIControlStateNormal];
    [addressBookBtn setImage:[UIImage imageNamed:@"address_book_clicked"] forState:UIControlStateNormal];
    [addressBookBtn addTarget:self action:@selector(showAddressBook:) forControlEvents:UIControlEventTouchUpInside];
    self.addressBookButton = addressBookBtn;
    [mobileBKView addSubview:addressBookBtn];
    
    UITextField *phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 15, mobileBKView.frame.size.width - 50, 45.0)];
    phoneTF.placeholder = @"请输入充值手机号";
    phoneTF.tag = 21;
    phoneTF.font = [UIFont systemFontOfSize:18];
    phoneTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneTF.borderStyle = UITextBorderStyleNone;
    phoneTF.keyboardType = UIKeyboardTypePhonePad;
    phoneTF.delegate = self;
    phoneTF.text = shareAppDelegateInstance.boenUserInfo.phoneNumber;
    self.phoneTextField = phoneTF;
    [phoneTF addTarget:self action:@selector(rechargeNumberChange:) forControlEvents:UIControlEventEditingChanged];
    [phoneTF addTarget:self action:@selector(benginChangeNumber:) forControlEvents:UIControlEventEditingDidBegin];
    [phoneTF addTarget:self action:@selector(endChangeNumber:) forControlEvents:UIControlEventEditingDidEnd];

    [mobileBKView addSubview:phoneTF];
    
    self.phoneDescription = [[UILabel alloc] initWithFrame:CGRectMake(10, 59, 200, 11)];
    self.phoneDescription.text = @"用户绑定号码";
    self.phoneDescription.textAlignment = NSTextAlignmentLeft;
    self.phoneDescription.font = [UIFont systemFontOfSize:11];
    self.phoneDescription.textColor = [UIColor lightGrayColor];
    
    [mobileBKView addSubview:self.phoneDescription];
    
    self.gridView = [[RechargeGridView alloc] initWithFrame:CGRectMake(0, self.phoneDescription.bottomValue+16.5, SCREEN_WIDTH, 100)];
    self.gridView.delegate = self;
    [mobileBKView addSubview:self.gridView];
    
    [_scrollView addSubview:mobileBKView];
    
    self.nullLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.phoneDescription.bottomValue+16.5 + 100, SCREEN_WIDTH, 16*NEW_BILI)];
    self.nullLabel.textAlignment = NSTextAlignmentCenter;
    self.nullLabel.textColor = UIColorFromRGB(0xc2ccd0);
    self.nullLabel.font = [UIFont systemFontOfSize:14*NEW_BILI];
    self.nullLabel.text = @"业务调整，敬请期待";
    [mobileBKView addSubview:self.nullLabel];
    _nullLabel.hidden = YES;
    
    _selectItemView = [[SelectItemView alloc] initWithRelateView:mobileBKView style:SelectItemViewUseStyleSelectMobileRechrgeNum delegate:self];
    [_scrollView addSubview:_selectItemView];
    _selectItemView.hidden = YES;
    
    UITapGestureRecognizer *cancelKeyboardTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelKeyboard:)];
    cancelKeyboardTap.delegate = self;
    [self.scrollView addGestureRecognizer:cancelKeyboardTap];
    
    //记录充值成功地手机号到数据库
    NSArray *rechargePhoneSorted = [RechargePhoneNumer MR_findByAttribute:@"phoneNumber" withValue:@"13444446666"];
    if ([rechargePhoneSorted count] == 0) {//没有在数据库中找到添加到数据库
        RechargePhoneNumer *rgPhone = [RechargePhoneNumer MR_createEntity];
        rgPhone.phoneNumber = @"13444446666";
        [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfAndWait];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupLoadedView];
    _rechargeAmount = @"0";//默认充值100
    _openRechage = YES;
    
    BNLog(@"sh %@",shareAppDelegateInstance.boenUserInfo.phoneNumber);
    self.rechargePhoneNumber = shareAppDelegateInstance.boenUserInfo.phoneNumber;
    
    [self loadData];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}


- (void)cancelKeyboard:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
    self.addressBookButton.hidden = NO;
}

#pragma mark - text field changed
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.text.length > 0) {
        [_selectItemView loadMobileRechargeData];
        _selectItemView.hidden = YES;
    }else{
        _selectItemView.hidden = NO;
    }
    return YES;
}

- (void)rechargeNumberChange:(UITextField *) tf
{
    
    if (tf.text.length > 0) {
        [_selectItemView loadMobileRechargeData];
        _selectItemView.hidden = YES;
    }else{
        _selectItemView.hidden = NO;
        self.addressBookButton.hidden = NO;
    }
    
    if ([tf.text isEqualToString:shareAppDelegateInstance.boenUserInfo.phoneNumber]) {
        tf.backgroundColor = [UIColor clearColor];
    }else{
        tf.backgroundColor = [UIColor whiteColor];
    }
    
    if ([tf.text length] >= 11) {
        
        NSString *number = tf.text;
        number = [number substringWithRange:NSMakeRange(0, 11)];
        tf.text = number;
        _rechargePhoneNumber = number;
        
        [tf resignFirstResponder];
        
        if ([number hasPrefix:@"1"]) {
            [self checkPhoneNumberAddress:tf.text];
        }else{
            _rechargeButton.enabled = NO;
            self.phoneDescription.textColor = [UIColor redColor];
            self.phoneDescription.text = @"号码格式错误";
            _favorPriceLabel.attributedText = nil;
        }
    }else{
        self.phoneDescription.text = @"";
        _favorPriceLabel.attributedText = nil;
        _rechargeButton.enabled = NO;
        [self.gridView setEnable:NO];
    }
    
}

- (void)benginChangeNumber:(UITextField *)tf
{
    self.addressBookButton.hidden = YES;
}

- (void)endChangeNumber:(UITextField *)tf
{
    self.addressBookButton.hidden = NO;
}

#pragma mark - button action

- (void)gotoMobilePayResaultVCWithMsg:(PayResaultType)payResaultType
{
    BNMobileRechargeResaultVC *resaultVC = [[BNMobileRechargeResaultVC alloc] init];
    resaultVC.payResaultType = payResaultType;
    resaultVC.resultInfo = _resultInfo;
    [self pushViewController:resaultVC animated:YES];
    
}

- (void)showAddressBook:(UIButton *)btn
{
    ABAddressBookRef tmpAddressBook = nil;
    ABAddressBookRequestAccessWithCompletion(tmpAddressBook, ^(bool greanted, CFErrorRef error){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (greanted) { 
                ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
                picker.topViewController.navigationController.navigationBar.tintColor = [UIColor redColor];
                picker.peoplePickerDelegate = self;
                
                picker.navigationBar.tintColor = [UIColor redColor];
                picker.modalPresentationStyle = UIModalPresentationCurrentContext;
                picker.modalInPopover = YES;
                picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                
                NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty], nil];
                picker.displayedProperties = displayedItems;
                
                [self presentViewController:picker animated:YES completion:^{
                    UIApplication *application = [UIApplication sharedApplication];
                    application.statusBarStyle = UIStatusBarStyleDefault;
                }];

            } else {
                [Tools showMessageWithTitle:@"提示" message:@"要启用通讯录，请先进入手机的“设置->隐私->通讯录->开启授权。”" btnTitle:@"知道了"];
            }
        });

    });
    
    
}

- (void)mobileRechargeAction
{
    if ( _openRechage == NO) {
        //未开放手机话费充值，则提示网络错误。禁止下一步操作。
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
        return;
    }
    
    //请求checkService，检查服务可用性。
    [SVProgressHUD show];
    [BannerApi pythonCheckService:shareAppDelegateInstance.boenUserInfo.userid
                           busiId:_biz_id  //一卡通业务
                          success:^(NSDictionary *successData) {
                              BNLog(@"一卡通pythonCheckService--%@", successData);
                              
                              NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                              
                              if ([retCode isEqualToString:kRequestSuccessCode]) {
                                  
                                  NSDictionary *retData = [successData valueForKey:kRequestReturnData];
                                  NSString *busiStatus = [retData valueNotNullForKey:@"busi_status"];
                                  NSString *payStatus = [retData valueNotNullForKey:@"pay_status"];
                                  NSString *systemStatus = [retData valueNotNullForKey:@"system_status"];
                                  
                                  if ([payStatus isEqualToString:@"no"] && [busiStatus isEqualToString:@"no"] && [systemStatus isEqualToString:@"no"]) {
                                      [SVProgressHUD dismiss];
                                      if ([_rechargePhoneNumber length] > 0 && [_rechargeAmount length] > 0) {
                                          __weak __typeof(self) weakSelf = self;
                                          [MobileRechargeApi getSalePriceWithMobile:_rechargePhoneNumber
                                                                             amount:_rechargeAmount
                                                                            success:^(NSDictionary *successData) {
                                                                                
                                                                                BNLog(@"getSalePriceWithMobile--%@", successData);
                                                                                NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                                                                                if ([retCode isEqualToString:kRequestSuccessCode]) {
                                                                                    
                                                                                    NSDictionary *priceInfo = [successData valueNotNullForKey:kRequestReturnData];
                                                                                    
                                                                                    weakSelf.price = [NSString stringWithFormat:@"%@",[priceInfo valueNotNullForKey:@"sale_amount"]];
                                                                                    weakSelf.bndk_amount = [NSString stringWithFormat:@"%@",[priceInfo valueNotNullForKey:@"bndk_amount"]];
                                                                                    weakSelf.sp_amount = [NSString stringWithFormat:@"%@",[priceInfo valueNotNullForKey:@"sp_amount"]];
                                                                                    weakSelf.pid = [NSString stringWithFormat:@"%@",[priceInfo valueNotNullForKey:@"pid"]];
                                                                                    [weakSelf.gridView setEnable:YES];
                                                                                    
                                                                                    [weakSelf goToPay];
                                                                                    
                                                                                }else{
                                                                                    NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                                                                    weakSelf.rechargeButton.enabled = NO;
                                                                                    [SVProgressHUD showErrorWithStatus:retMsg];
                                                                                }
                                                                                
                                                                            } failure:^(NSError *error) {
                                                                                [weakSelf.gridView setEnable:NO];
                                                                                [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                                                            }];
                                      }
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

- (void)mobileRechargeFlow:(RechargeItem *)item
{
    if ( _openRechage == NO) {
        //未开放手机话费充值，则提示网络错误。禁止下一步操作。
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
        return;
    }
    [SVProgressHUD show];
    [BannerApi pythonCheckService:shareAppDelegateInstance.boenUserInfo.userid
                           busiId:_biz_id  //一卡通业务
                          success:^(NSDictionary *successData) {
                              BNLog(@"一卡通pythonCheckService--%@", successData);
                              
                              NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                              
                              if ([retCode isEqualToString:kRequestSuccessCode]) {
                                  
                                NSDictionary *retData = [successData valueForKey:kRequestReturnData];
                                NSString *busiStatus = [retData valueNotNullForKey:@"busi_status"];
                                NSString *payStatus = [retData valueNotNullForKey:@"pay_status"];
                                NSString *systemStatus = [retData valueNotNullForKey:@"system_status"];

                                if ([payStatus isEqualToString:@"no"] && [busiStatus isEqualToString:@"no"] && [systemStatus isEqualToString:@"no"]) {
                                    [SVProgressHUD dismiss];
                                    if ([_rechargePhoneNumber length] > 0 && item) {
                                        [self goToPayFlow:item];
                                    }
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

#pragma mark - address book
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker;
{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ios8用此代理方法
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier NS_AVAILABLE_IOS(8_0)
{
    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);

    NSMutableArray *phones = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < ABMultiValueGetCount(phoneMulti); i++) {
        NSString *aPhone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneMulti, i);
        [phones addObject:aPhone];
    }
//    NSString *phone = @"";
//    if (phones.count > 0) {
//        phone = [phones objectAtIndex:0];
//    }
    if([phones count] > 0)
    {
        NSString *number = nil;
        if([phones count] > identifier)
        {
            number = [phones objectAtIndex:identifier];
        }else{
            number = [phones objectAtIndex:0];
        }
        number = [[number componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""];
        if([number hasPrefix:@"86"])
        {
            number = [number substringWithRange:NSMakeRange(2, ([number length] - 2))];
        }
        if([self checkRightPhoneNumber:number])
        {
            self.rechargePhoneNumber = number;
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [Tools showMessageWithTitle:@"提示" message:@"选择的号码格式不正确" btnTitle:@"我知道了"];
            });
        }
        
    }
}


- (BOOL)checkRightPhoneNumber:(NSString *)num
{
//    NSRegularExpression *regularExp =[[NSRegularExpression alloc] initWithPattern:@"(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}" options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators error:nil];
//    NSArray* chunks = [regularExp matchesInString:num
//                                          options:0
//                                            range:NSMakeRange(0, [num length])];
//    NSString *number = nil;
//    
//    if([chunks count] > 0)
//    {
//        if([num hasPrefix:@"86"])
//        {
//            number = [num substringWithRange:NSMakeRange(2, [num length] - 2)];
//        }else if([num hasPrefix:@"0"]){
//            number = [num substringWithRange:NSMakeRange(1, [num length] - 1)];
//        }else if([num hasPrefix:@"17951"]){
//            number = [num substringWithRange:NSMakeRange(5, [num length] - 5)];
//        }else{
//            NSTextCheckingResult *result = [chunks objectAtIndex:0];
//            NSRange resultRange = result.range;
//            number = [num substringWithRange:resultRange];
//        }
//    }else{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [Tools showMessageWithTitle:@"提示" message:@"选择的号码格式不正确" btnTitle:@"我知道了"];
//        });
//
//    }
    BOOL isPhoneNum = NO;
    if ([num length] == 11 && [num hasPrefix:@"1"]) {
        isPhoneNum = YES;
    }else{
        isPhoneNum = NO;

    }
    
    return isPhoneNum;
    

}
#pragma mark ios8以下用此代理方法
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person NS_DEPRECATED_IOS(2_0, 8_0)
{
    return YES;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier NS_DEPRECATED_IOS(2_0, 8_0)
{
    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    //    NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    //    if (firstName==nil) {
    //        firstName = @" ";
    //    }
    //    NSString *lastName=(__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    //    if (lastName==nil) {
    //        lastName = @" ";
    //    }
    //    NSDictionary *dic = @{@"fullname": [NSString stringWithFormat:@"%@%@", firstName, lastName]
    //                          ,@"phone" : phone};
    
    NSMutableArray *phones = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < ABMultiValueGetCount(phoneMulti); i++) {
        NSString *aPhone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneMulti, i);
        [phones addObject:aPhone];
    }
    if([phones count] > 0)
    {
        NSString *number = nil;
        if([phones count] > identifier)
        {
            number = [phones objectAtIndex:identifier];
        }else{
            number = [phones objectAtIndex:0];
        }
        number = [[number componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""];
        
        if([self checkRightPhoneNumber:number])
        {
            self.rechargePhoneNumber = number;
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [Tools showMessageWithTitle:@"提示" message:@"选择的号码格式不正确" btnTitle:@"我知道了"];
            });
        }
    }
    
    return NO;
}


- (void)savePhoneNumber:(NSString *)phoneNum
{
    NSArray *accountSorted = [RechargePhoneNumer MR_findByAttribute:@"phoneNumber" withValue:phoneNum];
    if ([accountSorted count] == 0) {//没有在数据库中找到添加到数据库
        RechargePhoneNumer *phoneNum = [RechargePhoneNumer MR_createEntity];
        phoneNum.phoneNumber = _rechargePhoneNumber;
        [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfAndWait];
    }

}

#pragma mark - loaded data from server

- (void)loadData
{
    __weak typeof(self) weakSelf = self;
    
    [MobileRechargeApi getAllRechargeItems:^(NSDictionary *data) {
        
        BNLog(@"get recharge amount list: %@", data);
        
        if ([[data valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
            NSArray *amountList = [[data objectForKey:kRequestReturnData] objectForKey:@"mobile_recharge_amount_list"];
            NSMutableArray *items = [NSMutableArray arrayWithCapacity:amountList.count];
            for (NSDictionary *aItem in amountList) {
                RechargeItem *item = [[RechargeItem alloc] init];
                item.productName = [NSString stringWithFormat:@"%.f元", [aItem[@"parprice"] floatValue]];
                item.parprice = [aItem[@"parprice"] floatValue];
                item.salePrice = [aItem[@"sale_price"] floatValue];
                [items addObject:item];
            }
            weakSelf.rechargeItems = items;
            if (weakSelf.topTabBar.selectedIndex == 0) {
                [weakSelf updateGridView];
            }
        }
        
    } failure:^(NSError *error) {

    }];
    
    [MobileRechargeApi getAllRechargeFlowItems:^(NSDictionary *data) {
        
        BNLog(@"get flow products list: %@", data);
        
        if ([[data valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
            NSArray *productsList = [[data objectForKey:kRequestReturnData] objectForKey:@"flow_products_list"];
            NSMutableDictionary *flowItems = [NSMutableDictionary dictionaryWithCapacity:3];
            for (NSDictionary *products in productsList) {
                NSArray *priceList = [products objectForKey:@"price_list"];
                NSMutableArray *items = [NSMutableArray arrayWithCapacity:priceList.count];
                for (NSDictionary *price in priceList) {
                    RechargeItem *item = [[RechargeItem alloc] init];
                    item.productID = [NSString stringWithFormat:@"%@", price[@"product_id"]];
                    item.productName = price[@"flow_amount"];
                    item.parprice = [price[@"parprice"] floatValue];
                    item.salePrice = [price[@"sale_price"] floatValue];
                    [items addObject:item];
                }
                [flowItems setObject:items forKey:products[@"product_type"]];
            }
            weakSelf.rechargeFlowItems = flowItems;
            if (weakSelf.topTabBar.selectedIndex == 1) {
                [weakSelf updateGridView];
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}



- (void)checkPhoneNumberAddress:(NSString *)phoneNum
{
    __weak typeof(self) weakSelf = self;
    if ([phoneNum length] > 0) {
        [SVProgressHUD showWithStatus:@"请稍候..."];
        [MobileRechargeApi getNameWithMobile:phoneNum
                                     success:^(NSDictionary *successData) {
                                         _openRechage = YES;

                                         BNLog(@"getNameWithMobile--%@", successData);
                                         NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                                         if ([retCode isEqualToString:kRequestSuccessCode]) {
                                             NSDictionary *retData = [successData valueForKey:kRequestReturnData];
                                             NSString *mobileServer = [retData valueForKey:@"name"];
                                             weakSelf.mobileServerName = mobileServer;
                                             [weakSelf.gridView setEnable:YES];
                                             [weakSelf updateGridView];
                                             [SVProgressHUD dismiss];
                                         }else{
                                             NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                             weakSelf.phoneDescription.text = @"";
                                             weakSelf.favorPriceLabel.attributedText = nil;
                                             [weakSelf.gridView setEnable:NO];
                                             [SVProgressHUD showErrorWithStatus:retMsg];
                                         }

        } failure:^(NSError *error) {
             [SVProgressHUD showErrorWithStatus:@"手机充值服务维护中"];
            [weakSelf.rechargeButton setEnabled:false];
            [weakSelf.gridView setEnable:NO];
            _openRechage = NO;
        }];
    }
    
}

- (void)goToPay
{
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD show];

    [MobileRechargeApi mobileCreateOrder:self.pid
                             phoneNumber:self.rechargePhoneNumber
                                  amount:self.rechargeAmount
                              saleAmount:self.price
                                spAmount:self.sp_amount
                              bndkAmount:self.bndk_amount success:^(NSDictionary *successData) {

                                  NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                                  
                                  if ([retCode isEqualToString:kRequestNewSuccessCode]) {
                                      [SVProgressHUD dismiss];
                                      
                                      NSDictionary *data = [successData valueForKey:kRequestReturnData];
                                      
                                      BNPayModel *payModel = [[BNPayModel alloc]init];
                                      payModel.order_no = [data valueNotNullForKey:@"order_no"];
                                      payModel.biz_no = [data valueNotNullForKey:@"biz_no"];
                                      [weakSelf goToPayCenterWithPayProjectType:PayProjectTypeMobileRecharge
                                                                   payModel:payModel
                                                                returnBlockone:^(PayVCJumpType jumpType, id params) {
                                                                    if (jumpType == PayVCJumpType_PayCompletedBackHomeVC) {
                                                                        [self.navigationController popToRootViewControllerAnimated:YES];
                                                                    }
                                                                }];
                                      
                                  } else {
                                      NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                      [SVProgressHUD showErrorWithStatus:retMsg];
                                  }
                                  
                              } failure:^(NSError *error) {
                                  [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                              }];
}

- (void)goToPayFlow:(RechargeItem *)item
{
    __weak typeof(self) weakSelf = self;
    
    [SVProgressHUD show];
    //友盟事件点击
    [MobClick event:@"MobileRecharge_FlowAmount" label:[NSString stringWithFormat:@"%.f", item.parprice]];

    [MobileRechargeApi mobileFlowCreateOrder:item.productID
                                 phoneNumber:self.rechargePhoneNumber
                                      amount:[NSString stringWithFormat:@"%.2f", item.salePrice]
                                     success:^(NSDictionary *successData) {
                                         
                                         NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                                         
                                         if ([retCode isEqualToString:kRequestNewSuccessCode]) {
                                             [SVProgressHUD dismiss];
                                             
                                             NSDictionary *data = [successData valueForKey:kRequestReturnData];
                                             
                                             BNPayModel *payModel = [[BNPayModel alloc]init];
                                             payModel.order_no = [data valueNotNullForKey:@"order_no"];
                                             payModel.biz_no = [data valueNotNullForKey:@"biz_no"];
                                             [weakSelf goToPayCenterWithPayProjectType:PayProjectTypeMobileFlowRecharge
                                                                              payModel:payModel
                                                                           returnBlockone:^(PayVCJumpType jumpType, id params) {
                                                                               if (jumpType == PayVCJumpType_PayCompletedBackHomeVC) {
                                                                                   [self.navigationController popToRootViewControllerAnimated:YES];
                                                                               }
                                                                           }];
                                             
                                         } else {
                                             NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                             [SVProgressHUD showErrorWithStatus:retMsg];
                                         }

                                         
                                     } failure:^(NSError *error) {
                                         [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                     }];
}

- (void)willPresentAlertView:(UIAlertView *)alertView
{
    int intFlg = 0 ;
    NSArray *viewArray = alertView.subviews;
    
    for( UIView * view in viewArray){
        if( [view isKindOfClass:[UILabel class]] ){
            UILabel* label = (UILabel*) view;
            if(intFlg == 1){
                label.textAlignment = NSTextAlignmentLeft;
            }
            break;
        }
        
    }
}

#pragma mark - selectItem delegate
- (void)selectMobileRechargeNumber:(NSString *)num
{
    self.rechargePhoneNumber = num;
    _selectItemView.hidden = YES;
    [self.phoneTextField resignFirstResponder];
}

#pragma mark - TopTabBar Delegate

- (void)tabBarItemSelected:(NSInteger)index {
    [self updateGridView];
}

- (void)rechargeItemSelected:(RechargeItem *)item {
    self.selectedItem = item;
    
    if (self.topTabBar.selectedIndex == 0) {
        self.rechargeAmount = [NSString stringWithFormat:@"%.f", item.parprice];
        self.price = [NSString stringWithFormat:@"%f", item.salePrice];
        
        [self mobileRechargeAction];
        //友盟事件点击
        [MobClick event:@"MobileRecharge_FeeAmount" label:[NSString stringWithFormat:@"%.f", item.parprice]];
    }
    else {
        [self mobileRechargeFlow:item];
        __weak __typeof(self) weakSelf = self;
        // 延迟一秒再取消选中，让用户看到点击效果
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.gridView setEnable:YES];
        });
    }
}

- (void)updateGridView {
    if (self.topTabBar.selectedIndex == 0) {
        _nullLabel.hidden = YES;

        if (!self.rechargeItems) {
            [self.gridView setItems:nil];
            return;
        }
        //友盟事件点击
        [MobClick event:@"MobileRecharge_Channel" label:@"话费充值按钮"];
        
        [self.gridView setItems:self.rechargeItems];
    }
    else {
        if (!self.rechargeFlowItems) {
            [self.gridView setItems:nil];
            return;
        }
        //友盟事件点击
        [MobClick event:@"MobileRecharge_Channel" label:@"流量充值按钮"];
        
        _nullLabel.hidden = NO;

        BOOL isContained = NO;
        for (NSString *serverName in self.rechargeFlowItems.allKeys) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", serverName];
            if ([predicate evaluateWithObject:self.mobileServerName]) {
                isContained = YES;
                [self.gridView setItems:self.rechargeFlowItems[serverName]];
            }
        }
        if (!isContained) {
            [self.gridView setItems:nil];
        }
    }
}

@end
