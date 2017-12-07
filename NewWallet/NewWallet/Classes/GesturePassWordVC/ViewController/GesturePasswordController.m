//
//  GesturePasswordController.m
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//

#import <Security/Security.h>
#import <CoreFoundation/CoreFoundation.h>

#import "GesturePasswordController.h"

#import "KeychainItemWrapper.h"
#import "BNLoginViewController.h"
#import "BNVerifyPhoneViewController.h"
#import "BNShowActivityViewController.h"
#import "BNMainViewController.h"
#import "BNNotLoginViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <Security/Security.h>
#import <objc/runtime.h>
#import "JavaHttpTools.h"

@interface GesturePasswordController ()<UIAlertViewDelegate, BNNotLoginViewDelegate>

@property (nonatomic,strong) GesturePasswordView * gesturePasswordView;

@end

@implementation GesturePasswordController {
    NSString * previousString;
    NSString * firstStautsString;
    NSString * password;
    NSInteger wrongTimes;
}

@synthesize gesturePasswordView;

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    previousString = [NSString string];
    
    self.view.backgroundColor = [UIColor whiteColor];
    if (_vcType == VcTypeFirstSetPsw) {
        self.showNavigationBar = NO;
//        self.navigationTitle = @"设置手势密码";
        firstStautsString = @"请绘制解锁图案";
        
        [self reset];
        
    } else if (_vcType == VcTypeReSetPsw) {
        self.showNavigationBar = YES;
        self.sixtyFourPixelsView.backgroundColor = [UIColor clearColor];
        UILabel *lineLbl = (UILabel *)[self.customNavigationBar viewWithTag:10001];
        lineLbl.backgroundColor = [UIColor clearColor];
        UILabel *navigationTitleLbl = (UILabel *)[self.customNavigationBar viewWithTag:10002];
        navigationTitleLbl.textColor = [UIColor whiteColor];
        
        self.navigationTitle = @"修改手势密码";
        firstStautsString = @"请绘制解锁图案";
        
        
        [self reset];
        
    }
    else if([[kUserDefaults objectForKey:kISOpenTouchIDKEY] isEqualToString:@"YES"])//先判断是否开启过touch id
    {
        self.showNavigationBar = NO;
        firstStautsString = @"验证指纹";

    }else{ //没有开启touch id打开手势密码
        firstStautsString = @"绘制手势密码进入应用";
        self.showNavigationBar = NO;
        wrongTimes = 0;


    }
   
    
    KeychainItemWrapper * keychinLogin = [[KeychainItemWrapper alloc]initWithIdentifier:kKeyChainAccessGroup_LastLoginUserId accessGroup:kKeyChainAccessGroup_LastLoginUserId];
   
    NSString *userID   = [keychinLogin objectForKey:(__bridge id)kSecAttrDescription];
    
    KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:userID accessGroup:kKeyChainAccessGroup_Gesture];
    password = [keychin objectForKey:(__bridge id)kSecValueData];
//    if ([password isEqualToString:@""]) {
//        
//        [self reset];
//    }
//    else {
//        [self verify];
//    }
    [self.view insertSubview:self.sixtyFourPixelsView aboveSubview:gesturePasswordView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(profileRefresh) name:kNotification_RefreshOneCardHomeInfoAndProfile object:nil];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self profileRefresh];
    
    if (_vcType == VcTypeFirstSetPsw) {
        
    } else if (_vcType == VcTypeReSetPsw) {
     
    }else if(_vcType == VcTypeVerifyPsw && self.navigationController.viewControllers.count == 1){
        if([[kUserDefaults objectForKey:kISOpenTouchIDKEY] isEqualToString:@"YES"])//先判断是否开启过touch id
        {
            [gesturePasswordView removeFromSuperview];
            self.showNavigationBar = NO;
            firstStautsString = @"验证指纹";
            [self verifyTouchID];
            
        }else{ //没有开启touch id打开手势密码
            
            firstStautsString = @"绘制手势密码进入应用";
            self.showNavigationBar = NO;
            [self verify];
        }

    }
}
- (void)profileRefresh {
    NSString *nameStr = shareAppDelegateInstance.boenUserInfo.name;
    nameStr = nameStr.length <= 0 ? nameStr : [NSString stringWithFormat:@"Hi，%@", shareAppDelegateInstance.boenUserInfo.name];
    gesturePasswordView.name.text = nameStr;
    [gesturePasswordView.imgView sd_setImageWithURL:[NSURL URLWithString:shareAppDelegateInstance.boenUserInfo.avatar] placeholderImage:[UIImage imageNamed:@"HomeVC_HeadBtn"]];
}
#pragma mark - 验证指纹解锁
- (void)verifyTouchID
{
    firstStautsString = @"验证指纹";

    //开启Touch ID
    LAContext *context = [[LAContext alloc] init];
    context.localizedFallbackTitle = @"";//设置空字符串，取消默认按钮
    NSError *error = nil;
    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {//验证Touch ID是否存在
        
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"通过验证指纹解锁喜付" reply:^(BOOL succes, NSError *error)
         {
             if (succes) {//验证touch id 成功直接进入应用
                 [self dismissViewControllerAnimated:YES completion:^{
                     shareAppDelegateInstance.gestureVC = nil;
                     
                     NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:kBundleKey];
                     NSString *saveVersion = [kUserDefaults objectForKey:kBundleKey];
                     
                     if ([version isEqualToString:saveVersion] == NO) {
                         BNMainViewController *mainVC = (BNMainViewController *)shareAppDelegateInstance.window.rootViewController;
                         
                         BNShowActivityViewController *showActivityVC = [[BNShowActivityViewController alloc] init];
                         showActivityVC.homeVC = mainVC.homeVC;
                         [shareAppDelegateInstance.window.rootViewController presentViewController:showActivityVC animated:YES completion:nil];
                     }else{
                         //处理是否接收了推送通知，有则跳转
                         [self processRecieveNotification];
                         [self.homeVC autoLogin];
                     }
                 }];
             }
             else if (error){
                 BNLog(@" error ---->>>>>%@",error);
                 switch (error.code) {
                     case LAErrorAuthenticationFailed: //认证失败
                     case LAErrorUserCancel://点击了“取消”按钮
                     case LAErrorSystemCancel://系统取消验证,比如点击了一下home键
                     case LAErrorUserFallback:{//点击了输入密码按钮
                         dispatch_async(dispatch_get_main_queue(), ^{
                             
                             firstStautsString = @"绘制手势密码进入应用";
                             self.showNavigationBar = NO;
                             [self verify];
                         });
                         
                     }
                         break;
//                     case LAErrorSystemCancel:{//系统取消验证，例如关闭屏幕电源，进入其他App等
//                         
//                     }
//                         break;
                         
                     case LAErrorTouchIDNotEnrolled: {
                         BNLog(@"LAErrorTouchIDNotEnrolled");
                         
                     }
                         break;
                         
                     case LAErrorPasscodeNotSet: {
                         BNLog(@"LAErrorPasscodeNotSet");
                     }
                         break;
                         
                     case LAErrorTouchIDNotAvailable: {
                         BNLog(@"LAErrorTouchIDNotAvailable");
                         
                     }
                         break;
                         
                     case LAErrorTouchIDLockout: {
                         
                         BNLog(@"LAErrorTouchIDLockout");
                     }
                         break;
                         
                     case LAErrorAppCancel:  {
                         
                         BNLog(@"LAErrorAppCancel");
                     }
                         break;
                         
                     case LAErrorInvalidContext: {
                         
                     }
                         break;
                 }

                 
             }
         }];
        
//        for (UIWindow *window in [UIApplication sharedApplication].windows) {
//            BNLog(@"window  --->>>> %@",window.subviews[0].subviews);
//        }
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"对不起你的手机或系统不支持Touch ID功能"];
    }

}
#pragma mark 刷新头像和名字
- (void)refreshHeadAndTitle{
    NSString *nameStr = shareAppDelegateInstance.boenUserInfo.name;
    nameStr = nameStr.length <= 0 ? nameStr : [NSString stringWithFormat:@"Hi，%@", shareAppDelegateInstance.boenUserInfo.name];
    gesturePasswordView.name.text = nameStr;
    [gesturePasswordView.imgView sd_setImageWithURL:[NSURL URLWithString:shareAppDelegateInstance.boenUserInfo.avatar] placeholderImage:[UIImage imageNamed:@"HomeVC_HeadBtn"]];
}


#pragma -mark 验证手势密码
- (void)verify{
    gesturePasswordView = [[GesturePasswordView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [gesturePasswordView.tentacleView setRerificationDelegate:self];
    [gesturePasswordView.tentacleView setStyle:1];
    NSString *nameStr = shareAppDelegateInstance.boenUserInfo.name;
    nameStr = nameStr.length <= 0 ? nameStr : [NSString stringWithFormat:@"Hi，%@", shareAppDelegateInstance.boenUserInfo.name];
    gesturePasswordView.name.text = nameStr;
    [gesturePasswordView.imgView sd_setImageWithURL:[NSURL URLWithString:shareAppDelegateInstance.boenUserInfo.avatar] placeholderImage:[UIImage imageNamed:@"HomeVC_HeadBtn"]];
    
    [gesturePasswordView setGesturePasswordDelegate:self];
    [gesturePasswordView.ignoreButton setHidden:YES];
    [self.view addSubview:gesturePasswordView];
    [gesturePasswordView.state setTextColor:[UIColor colorWithRed:255/255.f green:255/255.f blue:255/255.f alpha:1]];
    [gesturePasswordView.state setText:firstStautsString];
}

#pragma -mark 重置手势密码
- (void)reset{
    gesturePasswordView = [[GesturePasswordView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [gesturePasswordView.tentacleView setResetDelegate:self];
    [gesturePasswordView.tentacleView setStyle:2];
    [gesturePasswordView.name setHidden:YES];
    [gesturePasswordView.forgetButton setHidden:YES];
    [gesturePasswordView.lineView setHidden:YES];
    [gesturePasswordView.changeButton setHidden:YES];
    [gesturePasswordView.ignoreButton setHidden:YES];
    if (_vcType == VcTypeFirstSetPsw) {
        NSString *nameStr = shareAppDelegateInstance.boenUserInfo.name;
        nameStr = nameStr.length <= 0 ? nameStr : [NSString stringWithFormat:@"Hi，%@", shareAppDelegateInstance.boenUserInfo.name];
        gesturePasswordView.name.text = nameStr;
        [gesturePasswordView.imgView sd_setImageWithURL:[NSURL URLWithString:shareAppDelegateInstance.boenUserInfo.avatar] placeholderImage:[UIImage imageNamed:@"HomeVC_HeadBtn"]];
        [gesturePasswordView.name setHidden:NO];
        [gesturePasswordView.ignoreButton setHidden:NO];
        [gesturePasswordView setGesturePasswordDelegate:self];
    }
    [self.view addSubview:gesturePasswordView];
    [gesturePasswordView.state setTextColor:[UIColor colorWithRed:255/255.f green:255/255.f blue:255/255.f alpha:1]];
    [gesturePasswordView.state setText:firstStautsString];

}

#pragma -mark 清空记录
- (void)clear{
    KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:shareAppDelegateInstance.boenUserInfo.userid accessGroup:kKeyChainAccessGroup_Gesture];
    [keychin resetKeychainItem];
}

#pragma -mark 改变手势密码
- (void)change{
    BNLoginViewController *loginVC = [[BNLoginViewController alloc]init];
    loginVC.isFromChangeUser = YES;
    [self pushViewController:loginVC animated:YES];
}

#pragma -mark 忘记手势密码
- (void)forget{

    shareAppDelegateInstance.alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"忘记手势密码，需重新登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新登录", nil];
    [shareAppDelegateInstance.alertView show];
    
   
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        BNLoginViewController *loginVC1 = [[BNLoginViewController alloc]init];
        loginVC1.isFromChangeUser = YES;
        loginVC1.isFromForget = YES;
        [self pushViewController:loginVC1 animated:YES];

    }
}

// 连续错误5次
- (void)gotoLoginVCChangeFromNotLoginVC
{
    BNLoginViewController *loginVC1 = [[BNLoginViewController alloc]init];
    loginVC1.isFromChangeUser = YES;
    loginVC1.isFromForget = YES;
    [self pushViewController:loginVC1 animated:YES];
    
    NSMutableArray *newViewControllers = [self.navigationController.viewControllers mutableCopy];
    Class notLoginVCClass =  NSClassFromString(@"BNNotLoginViewController");
    Class passWordClass =  NSClassFromString(@"GesturePasswordController");

    BNNotLoginViewController *notLoginVC = nil;
    GesturePasswordController *passWordVC = nil;

    for (UIViewController *obj in newViewControllers) {
        if ([obj isKindOfClass:notLoginVCClass] == YES) {
            notLoginVC = (BNNotLoginViewController *)obj;
        }
        if ([obj isKindOfClass:passWordClass] == YES) {
            passWordVC = (GesturePasswordController *)obj;
        }
    }
    if (passWordVC) {
        [newViewControllers removeObject:passWordVC];
    }
    if (!notLoginVC) {
        BNNotLoginViewController *notLoginVC = [[BNNotLoginViewController alloc] init];
        notLoginVC.forGesturePswWrongToPush = YES;  //手势密码错误5次后,notLoginVC成为rootControler.
        [newViewControllers insertObject:notLoginVC atIndex:0];
        self.navigationController.viewControllers = newViewControllers;
    }
}
#pragma -mark 暂不设置手势密码
-(void)ignore
{
//    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshOneCardHomeInfoAndProfile object:nil];

    //清空手势密码
    KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:shareAppDelegateInstance.boenUserInfo.userid accessGroup:kKeyChainAccessGroup_Gesture];
    [keychin setObject:@"" forKey:(__bridge id)kSecValueData];
    
    //加入userID记录数组。
    [Tools userIDArrayAddWithUserId:shareAppDelegateInstance.boenUserInfo.userid];
    
    if (_nameOfRootPushVC) {
        NSArray *viewControllers = self.navigationController.viewControllers;
        UIViewController *skipVC = nil;
        Class tempClass =  NSClassFromString(_nameOfRootPushVC);
        for (UIViewController *obj in viewControllers) {
            if ([obj isKindOfClass:tempClass] == YES) {
                skipVC = (UIViewController *)obj;
                break;
            }
        }
        if (!skipVC) {
            if (self.presentingViewController){
                [self dismissViewControllerAnimated:YES completion:nil];
                return ;
            } else {
                return ;
            }
        }
        [self.navigationController popToViewController:skipVC animated:YES];
    } else if (self.presentingViewController){
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_showHomeADView object:nil];

}

- (BOOL)verification:(NSString *)result{

    if ([result isEqualToString:password]) {
        
        [gesturePasswordView.state setTextColor:[UIColor colorWithRed:255/255.f green:255/255.f blue:255/255.f alpha:1]];
        
        [self dismissViewControllerAnimated:YES completion:^{
            shareAppDelegateInstance.gestureVC = nil;

            NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:kBundleKey];
            
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            
            NSString *saveVersion = [userDefault objectForKey:kBundleKey];
            
            if ([version isEqualToString:saveVersion] == NO) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshHomeSudokuItems object:nil];

                BNMainViewController *mainVC = (BNMainViewController *)shareAppDelegateInstance.window.rootViewController;
                
                BNShowActivityViewController *showActivityVC = [[BNShowActivityViewController alloc] init];
                showActivityVC.homeVC = mainVC.homeVC;
                [shareAppDelegateInstance.window.rootViewController presentViewController:showActivityVC animated:YES completion:nil];
            }else{
                //处理是否接收了推送通知，有则跳转
                [self processRecieveNotification];
                
                [self.homeVC autoLogin];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_showHomeADView object:nil];

        }];
        return YES;
    } else {
        wrongTimes += 1;
    }
    if (wrongTimes < 5) {
        [gesturePasswordView.state setTextColor:[UIColor redColor]];
        [gesturePasswordView.state setText:[NSString stringWithFormat:@"密码错误,还可以输入%ld次",(long)5-wrongTimes]];
        [gesturePasswordView enterArgin];
        
     } else if (wrongTimes == 5) {
         [gesturePasswordView.state setTextColor:[UIColor redColor]];
         [gesturePasswordView.state setText:@"连续输错5次，请重新登录"];
         [gesturePasswordView enterArgin];
         
         KeychainItemWrapper * keychinLogin = [[KeychainItemWrapper alloc]initWithIdentifier:kKeyChainAccessGroup_LastLoginUserId accessGroup:kKeyChainAccessGroup_LastLoginUserId];
         [keychinLogin setObject:@"" forKey:(__bridge id)kSecAttrDescription];
         
         [self performSelector:@selector(gotoLoginVCChangeFromNotLoginVC) withObject:nil afterDelay:0.3];
         return NO;
     }
    
    return NO;
}

- (BOOL)resetPassword:(NSString *)result{
    
    if ([result length] < 4) {
        [gesturePasswordView.state setTextColor:[UIColor redColor]];
        [gesturePasswordView.state setText:@"设置手势密码至少4个点"];

        [gesturePasswordView enterArgin];
        return NO;
    }
    
    if (result.length == 0) {
        return YES;
    }
    if ([previousString isEqualToString:@""]) {
        previousString=result;
        [gesturePasswordView.tentacleView enterArgin];
        [gesturePasswordView.state setTextColor:[UIColor colorWithRed:255/255.f green:255/255.f blue:255/255.f alpha:1]];
        if (result.length > 0) {
            [gesturePasswordView.state setText:@"请再次绘制手势密码"];
        } else {
            [gesturePasswordView.state setText:firstStautsString];
        }
        return YES;
    }
    else {
        if ([result isEqualToString:previousString]) {
            KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:shareAppDelegateInstance.boenUserInfo.userid accessGroup:kKeyChainAccessGroup_Gesture];
            [keychin setObject:shareAppDelegateInstance.boenUserInfo.userid forKey:(__bridge id)kSecAttrAccount];
            [keychin setObject:result forKey:(__bridge id)kSecValueData];
            
            //加入userID记录数组。
            [Tools userIDArrayAddWithUserId:shareAppDelegateInstance.boenUserInfo.userid];
            
            [gesturePasswordView.state setTextColor:[UIColor colorWithRed:255/255.f green:255/255.f blue:255/255.f alpha:1]];
            [gesturePasswordView.state setText:@"设置手势密码成功"];
            [gesturePasswordView enterArgin];

            if (_nameOfRootPushVC) {
                NSArray *viewControllers = self.navigationController.viewControllers;
                UIViewController *skipVC = nil;
                Class tempClass =  NSClassFromString(_nameOfRootPushVC);
                for (UIViewController *obj in viewControllers) {
                    if ([obj isKindOfClass:tempClass] == YES) {
                        skipVC = (UIViewController *)obj;
                        break;
                    }
                }
                if (!skipVC) {
                    
                    return YES;
                }
                [self.navigationController popToViewController:skipVC animated:YES];

            }else if (self.presentingViewController){
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
            if (!_nameOfRootPushVC) {
            ////////*************发通知******(从后台进入前台，并切换账户时发送通知)*****
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_SetTabBarTo0 object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshOneCardHomeInfoAndProfile object:nil];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_showHomeADView object:nil];

            return YES;
        }
        else{
//            previousString =@"";   //屏蔽则为和安卓一样的流程：直到输正确为止，不清空第一次输入的内容。
            [gesturePasswordView.state setTextColor:[UIColor redColor]];
            [gesturePasswordView.state setText:@"再次绘制，请和第一次保持一致"];
            [gesturePasswordView enterArgin];
            return NO;
        }
    }
    
}

- (void)processRecieveNotification
{
    switch (shareAppDelegateInstance.recievedNewMesageType) {
        case RecievedNewMesageType_None:
            return;
            break;
        case RecievedNewMesageType_AppHaveNotLaunch_NeedPushToMsgCenter: {
            //app处于未启动状态，从通知栏点击,重新启动app进来的，push,到消息中心页面;
            
            shareAppDelegateInstance.recievedNewMesageType = RecievedNewMesageType_None;
            
            BNMainViewController *mainVC = (BNMainViewController *)shareAppDelegateInstance.window.rootViewController;
            [mainVC setSelectedIndex:1];
            
            //发送通知，让服务中心push至BNXiFuNewsListViewController
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.2*NSEC_PER_SEC);
            dispatch_after(time, dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RecievedMessage_AppHaveNotLaunch_PushToMsgCenterList object:nil];
            });
            
            break;
        }
        case RecievedNewMesageType_AppLaunched_NeedPresentToMsgCenter: {
            //app本身就已经处于启动状态，从通知栏点击,进入app,present,弹出消息中心页面;（向BNBaseViewcontroller发送通知）
            //向BNBaseViewcontroller发送通知，present弹出BNXiFuNewsListViewController
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.2*NSEC_PER_SEC);
            dispatch_after(time, dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RecievedMessage_AppLaunched_PresentToMsgCenterList object:nil];
            });

            break;
        }
        default:
            break;
    }
}


@end
