//
//  AppDelegate.m
//  NewWallet
//
//  Created by mac1 on 14-10-21.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "AppDelegate.h"
#import "BNNavigationController.h"
#import "BNMainViewController.h"
#import "GesturePasswordController.h"
#import "LoginApi.h"
#import "KeychainItemWrapper.h"
#import "BNNewsTool.h"
#import "ServiceCenterApi.h"
#import "OneCardNews.h"
#import "XifuNews.h"
#import "BNLoginViewController.h"
#import "BNShowActivityViewController.h"
#import <objc/runtime.h>
#import "UIView+Debug.h"
#import "XHLaunchAd.h"
#import "BNAdWebViewController.h"


#define kGlobalBlueColor [UIColor colorWithRed:24/255.0 green:183/255.0 blue:255/255.0 alpha:1]

#define kGlobalGreyColor [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1]

#import "BNGuideVC.h"

#import "BPush.h"
//#import "OpenUDID.h"
#import "BNXiaoDaiInfoRecordTool.h"

#import <CrashMaster/CrashMaster.h>
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"
//#import "JPLoader.h"
#import "BannerApi.h"
#import "QYSDK.h"

//#import "JPEngine.h"

//UnionPay
//#import "UPPaymentControl.h"
//#import "RSA.h"
//#import <CommonCrypto/CommonDigest.h>
#define SUPPORT_IOS8 1
#define USERAGENT @"Mozilla/5.0 (iPhone; CPU iPhone OS 5_1_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9B206 Safari/7534.48.3"

@interface AppDelegate ()<UIAlertViewDelegate>

@property (assign ,nonatomic) BOOL haveNewVersion;
@property (weak, nonatomic) NSTimer *adVCTimer;
@property (assign ,nonatomic) BOOL launchADImageHaveShow;
@property (nonatomic) NSDate *dismissDate;

@end

AppDelegate *shareAppDelegateInstance;

@implementation AppDelegate

@synthesize boenUserInfo = _boenUserInfo;

@synthesize popToViewController;

static NSString *const UMENG_APPKEY = @"599aae1c8630f568ad000378";



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    _haveNewVersion = NO;
    _launchADImageHaveShow = NO;
    _recievedNewMesageType = RecievedNewMesageType_None;
   
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];//样式
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];//要设置这个DefaultMaskType，用户才不能交互。
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    
//    使用SDwebImage去加载含有逗号的url 时候会无法加载，但是在浏览器上显示正常，这是因为缺少User-Agent用户代理
    [[SDWebImageDownloader sharedDownloader] setValue:USERAGENT forHTTPHeaderField:@"User-Agent"];

    self.tempUserId = @"";
    self.boenUserInfo = [[BNUserInfo alloc]init];
    self.xiaodaiBorrowInfo = [[BNXiaoDaiBorrowMoneyInfo alloc] init];
    shareAppDelegateInstance = self;
    
    map_manager = [[BMKMapManager alloc] init];
    BOOL ret = [map_manager start:@"L4Yv1ON3OQvWGbOV1Mq7fhIYsK2bwjaR"  generalDelegate:self];
    if (!ret) {
        BNLog(@"manager start failed!");
    }

    [self MagicalRecord_Config];
    [self MagicalRecord_DeleteOldSQLBefore500Version];//判断删除版本<=3.1.0的数据库，因为喜付服务中心改版，XifuNews这个Model改变了，从版本大于3.1.0开始，NSUserDefault存储一个字段“XifuNewsUpdateBefore310”，以后更新安装会自动检测是否包含次字段，没有包含，则说明版本<=3.1.0，此时就删除XifuNews，重新创建。
    //[self MagicalRecord_DeleteOldSQLBefore500Version];
    application.statusBarHidden = NO;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
	
	//网易七鱼
	[[QYSDK sharedSDK] registerAppId:@"b8630504f5c97b82c911798bb0870e78"
							 appName:@"喜付"];
   
    //友盟统计
    [MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行
//    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    UMConfigInstance.appKey = UMENG_APPKEY;
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！

    //崩溃收集，调试的时候关闭
#ifndef DEBUG
    [CrashMaster init:@"0e66d6e6d4f5818133f923211a965232" channel:@"App Store" config:[CrashMasterConfig defaultConfig]];
#endif
    
    //配置百度推送
    [BPush registerChannel:launchOptions apiKey:@"0O8j3dgKOObZhSs5GTEGKXGK" pushMode:BPushModeProduction withFirstAction:nil withSecondAction:nil withCategory:nil isDebug:YES];

    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
        BNLog(@"bindChannelWithCompleteHandler--result---%@",result);
        NSDictionary* res = [[NSDictionary alloc] initWithDictionary:result];
        NSString *userid = [res valueForKey:BPushRequestUserIdKey];
        NSString *channelid = [res valueForKey:BPushRequestChannelIdKey];
        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
        
        if (returnCode == 0) {
            // 在内存中备份，以便短时间内进入可以看到这些值，而不需要重新bind
            self.baiDuChannelId = channelid;
            self.baiDuUserId = userid;
        }
    }];

    [Tools deleteAllUploadImg];
    
#if SUPPORT_IOS8
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else
#endif
    {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }

    [self.window makeKeyAndVisible];
    
    // apn 内容获取：
    NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    [self receivedNotification:remoteNotification launching:YES];
    
    
    [self addShares];
    
    AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [afNetworkReachabilityManager startMonitoring];  //开启网络监视器；
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(afNetworkReachabilitymanagerNotification:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    [self launchAd];//启动广告
    
//    [self refreshPersonProfile];    //刷新profile
    
    return YES;
}

#if SUPPORT_IOS8
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}
#endif
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
//	NSString * deviceTokenString = [[[[deviceToken description]
//									  stringByReplacingOccurrencesOfString: @"<" withString: @""]
//									 stringByReplacingOccurrencesOfString: @">" withString: @""]
//									stringByReplacingOccurrencesOfString: @" " withString: @""];
    BNLog(@"test——deviceToken:%@", deviceToken);
    [BPush registerDeviceToken: deviceToken];
	
	[[QYSDK sharedSDK] updateApnsToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [BPush handleNotification:userInfo];

    NSString *alert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    if (application.applicationState == UIApplicationStateActive) {
        //APP处于前台
        // Nothing to do if applicationState is Inactive, the iOS already displayed an alert view.
        shareAppDelegateInstance.alertView = [[UIAlertView alloc] initWithTitle:@"收到一条通知"
                                                            message:[NSString stringWithFormat:@"%@", alert]
                                                           delegate:self
                                                  cancelButtonTitle:@"知道了"
                                                  otherButtonTitles:nil];
        [shareAppDelegateInstance.alertView show];
        
        [application setApplicationIconBadgeNumber:1];
        [application setApplicationIconBadgeNumber:0];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshHomeEventList object:nil];

    } else {
        //APP处于后台
        [self receivedNotification:userInfo launching:NO];
    }
}
- (void)receivedNotification:(NSDictionary *)userInfo launching:(BOOL)launching
{
    BNLog(@"Notification-userInfo---%@",userInfo);
    if ([[userInfo allKeys] containsObject:@"data"]) {
        userInfo = [userInfo valueForKey:@"data"];
    }
    if (launching) {
        //app处于未启动状态，从通知栏点击,重新启动app进来的
        if (userInfo) {
            NSArray *keys = [userInfo allKeys];
            if ([keys containsObject:@"count"] && [userInfo valueForKey:@"count"] && [[userInfo valueForKey:@"count"] integerValue] > 0) {
                KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:shareAppDelegateInstance.boenUserInfo.userid accessGroup:kKeyChainAccessGroup_Gesture];
                NSString *password = [keychin objectForKey:(__bridge id)kSecValueData];
                if (!password || password.length <= 0) {
                    //未设置手势密码时。什么都不做，因为启动要先登录。
                    
                } else {
                    //等输入手势密码完成后会push,到消息中心页面;
//                    _recievedNewMesageType = RecievedNewMesageType_AppHaveNotLaunch_NeedPushToMsgCenter;
                }
                
            } else {
                
                //可能会present弹出其他页面，暂时没设计。
            }
        }
    } else {
        //app本身就已经处于启动状态，从通知栏点击,进入app
        if (userInfo) {
            NSArray *keys = [userInfo allKeys];
            if ([keys containsObject:@"count"] && [userInfo valueForKey:@"count"] && [[userInfo valueForKey:@"count"] integerValue] > 0) {
                KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:shareAppDelegateInstance.boenUserInfo.userid accessGroup:kKeyChainAccessGroup_Gesture];
                NSString *password = [keychin objectForKey:(__bridge id)kSecValueData];
                if (!password || password.length <= 0) {
                    //未设置手势密码时。向BNBaseViewcontroller发送通知，present弹出BNXiFuNewsListViewController
                    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.2*NSEC_PER_SEC);
                    dispatch_after(time, dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RecievedMessage_AppLaunched_PresentToMsgCenterList object:nil];
                    });
                } else {
                    //设置了手势密码时，等输入手势密码完成后会present弹出消息中心页面；
                    _recievedNewMesageType = RecievedNewMesageType_AppLaunched_NeedPresentToMsgCenter;
                }
            } else {
                
                //可能会present弹出其他页面，暂时没设计。
            }
        }
    }
}

- (void)setupBNRootController
{
    BNMainViewController *mainVC = [[BNMainViewController alloc] init];
    self.window.rootViewController = mainVC;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    self.dismissDate = [NSDate date];

}

- (void)applicationDidEnterBackground:(UIApplication *)application {

    [self closeModalView];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    if (shareAppDelegateInstance.haveGetPrefile == YES) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshBanner object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshHomeEventList object:nil];
    }
    //计算两个时间间隔多少秒
    if (_dismissDate) {
        CGFloat seconds = [Tools intervalSecondsFromLastDate1:_dismissDate toTheDate2:[NSDate date]];
        if (seconds > 30.0) {
            //超过30秒不使用喜付，才弹出手势密码，30秒内进入则不弹出手势密码。
            [self presentGesturePswVC];     //进入前台，弹出手势密码
        }
    } else {
        [self presentGesturePswVC];     //进入前台，弹出手势密码
    }

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    


    
    //热修复--- 被苹果官方和谐了，2017-04-12
    /*
    [JPLoader run];
    NSInteger currentVersion = [JPLoader currentVersion];
    [JPLoader updateToVersion:currentVersion+1 callback:^(NSError *error) {
        NSLog(@"js patch: %@", error);
        if (!error) {
            [JPLoader run];
        }
    }];
     */
   
    //清零角标，清除通知栏的消息。
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];

//    if (shareAppDelegateInstance.boenUserInfo.userid.length > 0) {
//        KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:shareAppDelegateInstance.boenUserInfo.userid accessGroup:kKeyChainAccessGroup_Gesture];
//        NSString *password = [keychin objectForKey:(__bridge id)kSecValueData];
//        if (self.haveGetPrefile == YES && password.length <= 0) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshOneCardHomeInfoAndProfile object:nil];
//        }
//
//    }
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self MagicalRecord_CleanUp];
    //程序终止时，清除小贷申请信息。
    [BNXiaoDaiInfoRecordTool clearXiaoDaiInfo];
    
    //删除小额贷活体认证图片。
    [Tools removeLivenessDetectionImagesWithUserId:self.boenUserInfo.userid];
}

- (BOOL)application:(UIApplication *)application  handleOpenURL:(NSURL *)url
{
    [self dismissGestruePswVC];
    [YJPayService handleOpenURL:url srcApp:nil];
    [ShareSDK handleOpenURL:url wxDelegate:self];
//    [BestpaySDK processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//        BNLog(@"确保结果显示不会出错:%@",resultDic);
//    }];

    return YES;
}
//iOS9 之后
- (BOOL)application:(UIApplication*)app openURL:(NSURL*)url options:(NSDictionary<NSString*, id>*)options {
    [self dismissGestruePswVC];
    if ([url.absoluteString hasPrefix:@"comccbpay"]) {
        BNLog(@"AppDelegate---%@",url);
    }else{
        [YJPayService handleOpenURL:url srcApp:nil];
        [ShareSDK handleOpenURL:url wxDelegate:self];
//        [BestpaySDK processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            BNLog(@"确保结果显示不会出错:%@",resultDic);
//        }];
    }
    return YES;
}
//ios9之前
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    [self dismissGestruePswVC];
    if ([url.absoluteString hasPrefix:@"comccbpay"]) {
        BNLog(@"AppDelegate---%@",url);
    }else{
        [YJPayService handleOpenURL:url srcApp:sourceApplication];
        [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:self];
    }

    return YES;
//    if ([url.absoluteString hasPrefix:@"com.Boen.Wallet://"]) {
//        //UnionPay银联支付
//        
//        [YJPayService handleOpenURL:url srcApp:sourceApplication];
//        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_YJPayCompleted object:@"SUCCESS"];
//
//
//        return YES;
//
//    } else {
//        //分享
//        return [ShareSDK handleOpenURL:url
//                     sourceApplication:sourceApplication
//                            annotation:annotation
//                            wxDelegate:self];
//    }
}

// 刷新getprofile
- (void)refreshPersonProfile
{
    if (!self.boenUserInfo.userid) {
        return ;
    }
    __weak typeof(self) weakSelf = self;
    [LoginApi getProfile:weakSelf.boenUserInfo.userid
                 success:^(NSDictionary *successData) {
                     BNLog(@"appdelegate-getProfile--%@", successData);
                     [SVProgressHUD dismiss];
                     NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                     
                     if ([retCode isEqualToString:kRequestSuccessCode]) {
                         NSDictionary *retData = [successData valueNotNullForKey:kRequestReturnData];
                         [BNTools setProfileUserInfo:retData];

                         weakSelf.haveGetPrefile = YES;
                         
                         [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshOneCardHomeInfoAndProfile object:nil];
                         
                     }else{
//                         shareAppDelegateInstance.haveGetPrefile = NO;
                         NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage]; 
                         BNLog(@"%@", retMsg);
                     }
                     
                 } failure:^(NSError *error) {
//                     shareAppDelegateInstance.haveGetPrefile = NO;
                     [SVProgressHUD dismiss];
                 }];

}

//弹出手势密码界面--->>>程序进入后台的时候
- (void)presentGesturePswVC
{

    KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:shareAppDelegateInstance.boenUserInfo.userid accessGroup:kKeyChainAccessGroup_Gesture];
    NSString *password = [keychin objectForKey:(__bridge id)kSecValueData];
    
    //如果退到手机桌面，再进入app--未设置手势密码时，此时不弹出输入手势密码页面。如果设置了，则进入输入手势密码页面
    if (![password isEqualToString:@""]) {
        if (_gestureVC) {
            [_gestureVC viewWillAppear:YES];
        } else {
            BNMainViewController *mainVC = (BNMainViewController *)self.window.rootViewController;
            GesturePasswordController *gestureVC = [[GesturePasswordController alloc]init];
            gestureVC.vcType = VcTypeVerifyPsw;
            gestureVC.homeVC = mainVC.homeVC;
            BNNavigationController *navVC = [[BNNavigationController alloc]initWithRootViewController:gestureVC];
            objc_setAssociatedObject(self, @"gestureNav", navVC, OBJC_ASSOCIATION_RETAIN);
            self.gestureVC = gestureVC;
            
            [self.window.rootViewController presentViewController:navVC animated:NO completion:nil];
        }
       
    } else {
        //do nothing
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshOneCardHomeInfoAndProfile object:nil];

//        [self refreshPersonProfile];
     
    }
}

//取消手势密码界面--->>>用于从分享平台进入App，如果用户设置了手势密码则取消
- (void)dismissGestruePswVC
{
    BNNavigationController *navVC = objc_getAssociatedObject(self, @"gestureNav");
    if (navVC) {
        [self.window.rootViewController dismissViewControllerAnimated:NO completion:nil];
    }
}
- (void)getAndRefreshNewsData
{
    NSArray *xiFuNewsarray = [[BNNewsTool sharedInstance] getXifuNewsWithUserId:shareAppDelegateInstance.boenUserInfo.userid];
    XifuNews *latestNews;
    if (xiFuNewsarray && xiFuNewsarray.count > 0) {
        latestNews = xiFuNewsarray[0];
    }
    NSString *xflatestTime = nil;
    if (latestNews.create_time) {
        xflatestTime = latestNews.create_time;
    }

    [ServiceCenterApi fetchXiFuNewsWithUserID:shareAppDelegateInstance.boenUserInfo.userid
                                   begin_time:xflatestTime
                                      success:^(NSDictionary *returnData) {
                                          BNLog(@"fetchXiFuNews--%@", returnData);
                                          NSString *retCode = [returnData valueNotNullForKey:kRequestRetCode];
                                          if ([retCode isEqualToString:kRequestSuccessCode]) {
                                              
                                              id json = [returnData valueForKey:kRequestReturnData];
                                              if ([json isKindOfClass:[NSDictionary class]]) {
                                                  //NSDictionary *data = [NSJSONSerialization JSONObjectWithData:[NSData dataWithBytes:[json UTF8String] length:[json length]] options:kNilOptions error:nil];
                                                  if ([json[@"count"] unsignedIntegerValue] > 0) {
                                                      [[BNNewsTool sharedInstance] saveXifuNewsWithArray:json[@"message"]];
                                                      [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshUnReadNumber object:nil];
                                                      
                                                  }
                                                  else {
                                                      [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_Message_HadLoaded object:nil];
                                                  }
                                              }
                                              else {
                                                  [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_Message_HadLoaded object:nil];
                                              }
                                          }else{
                                              [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshUnReadNumber object:nil];
                                              [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_Message_HadLoaded object:nil];
                                          }
                                          
                                      }
                                      failure:^(NSError *error) {
                                          [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshUnReadNumber object:nil];
                                          [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_Message_HadLoaded object:nil];
                                      }];
    
    NSArray *oneCardNewsarray = [[BNNewsTool sharedInstance] getOneCardNewsWithUserId:shareAppDelegateInstance.boenUserInfo.userid];
    OneCardNews *latestYKTNews;
    if (oneCardNewsarray && oneCardNewsarray.count > 0) {
        latestYKTNews = oneCardNewsarray[0];
    }
    NSString *latestTime = nil;
    if (latestYKTNews.create_time) {
        latestTime = latestYKTNews.create_time;
    }
    BNLog(@"latestTime--%@", latestYKTNews.create_time);
    [ServiceCenterApi fetchYKTNewsWithUserID:shareAppDelegateInstance.boenUserInfo.userid
                                        type:@"1"
                                  begin_time:latestTime
                                     success:^(NSDictionary *returnData) {
                                         BNLog(@"fetchYKTNews--%@", returnData);
                                         NSString *retCode = [returnData valueNotNullForKey:kRequestRetCode];
                                         if ([retCode isEqualToString:kRequestSuccessCode]) {
                                             NSDictionary *retData = [returnData valueForKey:kRequestReturnData];
                                             NSArray *newsList = [retData valueForKey:@"service"];
                                             if ([newsList count] > 0) {
                                                 [[BNNewsTool sharedInstance] saveOneCardNewsWithArray:newsList];
                                             }
                                         }
                                         [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshUnReadNumber object:nil];
                                     }
                                     failure:^(NSError *error) {
                                         [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshUnReadNumber object:nil];
                                     }];
}

- (void)MagicalRecord_Config
{
//    [MagicalRecord setShouldAutoCreateManagedObjectModel:NO];
//    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"NewWallet" withExtension:@"momd"];
//    NSManagedObjectModel *objectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
//    [NSManagedObjectModel MR_setDefaultManagedObjectModel:objectModel];
    
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"NewWallet.sqlite"];
    
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"NewWallet.sqlite"];
}

- (void)MagicalRecord_CleanUp
{
    [MagicalRecord cleanUp];
}

- (void)MagicalRecord_DeleteOldSQLBefore500Version
{
    if (![Tools getIfXifuNewsUpdatedBefore500]) {
        [self deleteMethod];
    }
}

- (void)deleteMethod
{
    [XifuNews MR_truncateAll];
    [OneCardNews MR_truncateAll];
    [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfAndWait];
    [Tools saveXifuNewsUpdatedBefore500];

    return;
    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//
//    NSURL *url = [NSPersistentStore MR_urlForStoreName:@"NewWallet.sqlite"];
//    BNLog(@"url----%@", url);
//    NSString *pathUrl = url.absoluteString;
//    if ([pathUrl hasSuffix:@"/NewWallet.sqlite"]) {
//        pathUrl = [pathUrl stringByReplacingOccurrencesOfString:@"/NewWallet.sqlite" withString:@""];
//        if ([pathUrl hasPrefix:@"file://"]) {
//            pathUrl = [pathUrl stringByReplacingOccurrencesOfString:@"file://" withString:@""];
//        }
//        pathUrl = [pathUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        BNLog(@"pathUrl----%@", pathUrl);
//        
//        NSFileManager* fileMgr = [NSFileManager defaultManager];
//        
//        NSArray* tempArray0 = [fileMgr contentsOfDirectoryAtPath:pathUrl error:nil];
//        BNLog(@"tempArray0----%@", tempArray0);
//        
//        BOOL success = [fileManager removeItemAtPath:pathUrl error:nil];
//        if (success) {
//            [Tools saveXifuNewsUpdatedBefore310];
//            BNLog(@"remove---%@----success!", pathUrl);
//        }
//    }
}


//关闭之前弹出的alertView
- (void)closeModalView
{
    [self.alertView dismissWithClickedButtonIndex:self.alertView.cancelButtonIndex animated:NO];
}

- (void)addShares
{
    [ShareSDK registerApp:@"d8bbe87728d5"];
    
//    //微信
    [ShareSDK connectWeChatWithAppId:@"wxf280e6eda3f76c92"
                           appSecret:@"177f3e6481cbb771cb8b8490b327b1c6"
                           wechatCls:[WXApi class]];
    
    //新浪微博
    [ShareSDK  connectSinaWeiboWithAppKey:@"1548566814"
                                appSecret:@"76a35e56d0905a52b557960e90510a7f"
                              redirectUri:@"http://sns.whalecloud.com/sina2/callback"
                              weiboSDKCls:[WeiboSDK class]];
    
    //添加QQ空间
    [ShareSDK connectQZoneWithAppKey:@"1102330759"
                           appSecret:@"uJQTCBbSdaLGOPFd"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    //添加QQ
    [ShareSDK connectQQWithQZoneAppKey:@"1102330759"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    

}

#pragma mark - UnionPay
//- (NSString *) readPublicKey:(NSString *) keyName
//{
//    if (keyName == nil || [keyName isEqualToString:@""]) return nil;
//    
//    NSMutableArray *filenameChunks = [[keyName componentsSeparatedByString:@"."] mutableCopy];
//    NSString *extension = filenameChunks[[filenameChunks count] - 1];
//    [filenameChunks removeLastObject]; // remove the extension
//    NSString *filename = [filenameChunks componentsJoinedByString:@"."]; // reconstruct the filename with no extension
//    
//    NSString *keyPath = [[NSBundle mainBundle] pathForResource:filename ofType:extension];
//    
//    NSString *keyStr = [NSString stringWithContentsOfFile:keyPath encoding:NSUTF8StringEncoding error:nil];
//    
//    return keyStr;
//}
//
//-(BOOL) verify:(NSString *) resultStr {
//    
//    //从NSString转化为NSDictionary
//    NSData *resultData = [resultStr dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:resultData options:0 error:nil];
//    
//    //获取生成签名的数据
//    NSString *sign = data[@"sign"];
//    NSString *signElements = data[@"data"];
//    //NSString *pay_result = signElements[@"pay_result"];
//    //NSString *tn = signElements[@"tn"];
//    //转换服务器签名数据
//    NSData *nsdataFromBase64String = [[NSData alloc]
//                                      initWithBase64EncodedString:sign options:0];
//    //生成本地签名数据，并生成摘要
//    //    NSString *mySignBlock = [NSString stringWithFormat:@"pay_result=%@tn=%@",pay_result,tn];
//    NSData *dataOriginal = [[self sha1:signElements] dataUsingEncoding:NSUTF8StringEncoding];
//    //验证签名
//    //TODO：此处如果是正式环境需要换成public_product.key
//    NSString *pubkey =[self readPublicKey:@"public_test.key"];
//    OSStatus result=[RSA verifyData:dataOriginal sig:nsdataFromBase64String publicKey:pubkey];
//    
//    
//    
//    //签名验证成功，商户app做后续处理
//    if(result == 0) {
//        //支付成功且验签成功，展示支付成功提示
//        return YES;
//    }
//    else {
//        //验签失败，交易结果数据被篡改，商户app后台查询交易结果
//        return NO;
//    }
//    
//    return NO;
//}
//
//
//
//
//- (NSString*)sha1:(NSString *)string
//{
//    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
//    CC_SHA1_CTX context;
//    NSString *description;
//    
//    CC_SHA1_Init(&context);
//    
//    memset(digest, 0, sizeof(digest));
//    
//    description = @"";
//    
//    
//    if (string == nil)
//    {
//        return nil;
//    }
//    
//    // Convert the given 'NSString *' to 'const char *'.
//    const char *str = [string cStringUsingEncoding:NSUTF8StringEncoding];
//    
//    // Check if the conversion has succeeded.
//    if (str == NULL)
//    {
//        return nil;
//    }
//    
//    // Get the length of the C-string.
//    int len = (int)strlen(str);
//    
//    if (len == 0)
//    {
//        return nil;
//    }
//    
//    
//    if (str == NULL)
//    {
//        return nil;
//    }
//    
//    CC_SHA1_Update(&context, str, len);
//    
//    CC_SHA1_Final(digest, &context);
//    
//    description = [NSString stringWithFormat:
//                   @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
//                   digest[ 0], digest[ 1], digest[ 2], digest[ 3],
//                   digest[ 4], digest[ 5], digest[ 6], digest[ 7],
//                   digest[ 8], digest[ 9], digest[10], digest[11],
//                   digest[12], digest[13], digest[14], digest[15],
//                   digest[16], digest[17], digest[18], digest[19]];
//    
//    return description;
//}



#pragma mark - timer - 定时10s后再刷新一次消息中心
- (void)refreshServiceCenterAfter10Seconds
{
    [self performSelector:@selector(refreshServiceCenter) withObject:nil afterDelay:10.0];
}

- (void)refreshServiceCenter
{
    [self getAndRefreshNewsData];
}


- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        BNLog(@"联网成功");
    }
    else{
        BNLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        BNLog(@"授权成功");
    }
    else {
        BNLog(@"onGetPermissionState %d",iError);
    }
}

/**
 *  启动页广告
 */
-(void)launchAd
{
    _adVCTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timeOver_checkGoToMainVC) userInfo:nil repeats:NO];

    [BNTools setLastLoginCookies];
    /**
     *  1.显示启动页广告
     */
    [XHLaunchAd showWithAdFrame:CGRectMake(0, 0,self.window.bounds.size.width, self.window.bounds.size.height-95*BILI_WIDTH) setAdImage:^(XHLaunchAd *launchAd) {
        
        //未检测到广告数据,启动页停留时间,不设置默认为3,(设置2即表示:启动页显示了2s,还未检测到广告数据,就自动进入window根控制器)
        launchAd.noDataDuration = 10;//此参数是已接口返回时间为准，但我们需要图片下载完成后时间为准，故用自己的定时器_adVCTimer，把它这个设长点10秒，我们的是2秒左右。
        //获取广告数据
        [self requestImageData:^(NSString *imgUrl, NSInteger duration, NSString *openUrl) {
            /**
             *  2.设置广告数据
             */
            //定义一个weakLaunchAd
            __weak __typeof(launchAd) weakLaunchAd = launchAd;
            [launchAd setImageUrl:imgUrl duration:duration skipType:SkipTypeTimeText options:XHWebImageDefault completed:^(UIImage *image, NSURL *url) {
                //异步加载图片完成回调(若需根据图片尺寸,刷新广告frame,可在这里操作)
                //weakLaunchAd.adFrame = ...;
                if (image) {
                    _launchADImageHaveShow = YES;
                }
            } click:^{
                
                //广告点击事件
                //1.用浏览器打开
                //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:openUrl]];
                
                //2.在webview中打开
                BNAdWebViewController *VC = [[BNAdWebViewController alloc] init];
                VC.urlString = openUrl;
                VC.returnBlock = ^(){
                    
                    [XHLaunchAd cancelTimer];//执行后，showFinish会回调
                };
                [weakLaunchAd.navigationController pushViewController:VC animated:YES];
                
            }];
            
        }];
        
    } showFinish:^{
        _launchADImageHaveShow = YES;
        
        //广告展示完成回调,设置window根控制器
        [self setupBNRootController];
    }];
}
/**
*  向服务器请求广告数据
*
*  @param imageData 回调imageUrl,及停留时间,跳转链接
*/
-(void)requestImageData:(void(^)(NSString *imgUrl,NSInteger duration,NSString *openUrl))imageData{
    
    [BannerApi getLaunchADDataSuccess:^(NSDictionary *dataDict) {
            BNLog(@"getLaunchADDataSuccess--%@", dataDict);
            NSString *retCode = [dataDict valueNotNullForKey:kRequestRetCode];
            
            if ([retCode isEqualToString:kRequestNewSuccessCode]) {
                NSDictionary *retData = [dataDict valueNotNullForKey:kRequestReturnData];
                NSString *backgroundUrl = [NSString stringWithFormat:@"%@", [retData valueWithNoDataForKey:@"backgroundUrl"]];
                NSString *jumpToUrl = [NSString stringWithFormat:@"%@", [retData valueWithNoDataForKey:@"jumpToUrl"]];
                NSString *availableTime = [NSString stringWithFormat:@"%@", [retData valueWithNoDataForKey:@"availableTime"]];
                NSString *advId = [NSString stringWithFormat:@"%@", [retData valueWithNoDataForKey:@"advId"]];

                if (advId && advId.length > 0) {
                    //只要有advId，就每次都去加载广告
                    imageData(backgroundUrl,[availableTime integerValue],jumpToUrl);
                } else {
                    //跳过，不显示广告
                    [XHLaunchAd cancelTimer];//执行后，showFinish会回调
                }
               
//                NSString *oldAdvId = [BNTools getLastLaunchADid];
//                if ([oldAdvId isEqualToString:advId]) {
//                    //已经加载过此广告了。
//                    BNLog(@"已经加载过此Launch广告了");
//                    [XHLaunchAd cancelTimer];//执行后，showFinish会回调
//                    return ;
//                } else {
//                    BNLog(@"未加载过此Launch广告");
//                    [BNTools saveLaunchADid:advId];
//                    imageData(backgroundUrl,[availableTime integerValue],jumpToUrl);
//                }

            }else{
                NSString *retMsg = [dataDict valueNotNullForKey:kRequestRetMessage];
                BNLog(@"Launch-retMsg---%@", retMsg);
            }
            
        } failure:^(NSError *error) {
        }];

}
- (void)timeOver_checkGoToMainVC
{
    [_adVCTimer invalidate];
    _adVCTimer = nil;
    if (!_launchADImageHaveShow) {
        BNLog(@"------timeOver_checkGoToMainVC!!!!!!!-------");
        //时间到，广告图片还未下载完成，直接接入主页。
        [XHLaunchAd cancelTimer];//执行后，showFinish会回调

    }

    
}

- (void)afNetworkReachabilitymanagerNotification:(NSNotification *)notification
{
//    NSDictionary *dict = notification.userInfo;
//    NSDictionary *object = notification.object;
//    BNLog(@"afNetworkReachability-dict---%@",dict);
//    BNLog(@"afNetworkReachability-object---%@",dict);
////    AFNetworkReachabilityStatusUnknown          = -1,
////    AFNetworkReachabilityStatusNotReachable     = 0,
////    AFNetworkReachabilityStatusReachableViaWWAN = 1,
////    AFNetworkReachabilityStatusReachableViaWiFi = 2,
//    NSString *alertString = @"";
//    NSInteger status = [[dict valueWithNoDataForKey:@"AFNetworkingReachabilityNotificationStatusItem"] integerValue];
//    switch (status) {
//        case AFNetworkReachabilityStatusUnknown:
//        alertString = @"网络错误，请检查网络稍后再试。";
//        self.alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:alertString delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
//        [_alertView show];
//        break;
//
//        case AFNetworkReachabilityStatusNotReachable:
//        alertString = @"网络不可达，请检查网络稍后再试。";
//        self.alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:alertString delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
//        [_alertView show];
//        break;
//        
//        case AFNetworkReachabilityStatusReachableViaWWAN:
////        alertString = @"已切换为蜂窝数据网络";
//        break;
//        
//        case AFNetworkReachabilityStatusReachableViaWiFi:
////        alertString = @"已切换为WiFi网络";
//        break;
//    }

    
}
@end
