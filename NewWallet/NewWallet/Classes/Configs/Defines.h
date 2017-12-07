//
//  Defines.h
//  NewWallet
//
//  Created by mac on 14-10-27.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#ifndef NewWallet_Defines_h
#define NewWallet_Defines_h



//导航和状态栏高度
#define NAVIGATION_STATUSBAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height

//屏幕宽度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
//屏幕高度
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
//不同屏幕相对320的比例
#define BILI_WIDTH ([UIScreen mainScreen].bounds.size.width/320.0)

//不同屏幕相对375的比例
#define NEW_BILI ([UIScreen mainScreen].bounds.size.width/375.0)

// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define BNColorRGB(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.f]

//常用颜色值
#define UIColor_NewBlueColor UIColorFromRGB(0xbec6e2)//0x448aff

#define UIColor_Gray_BG           UIColorFromRGB(0xf4f4f4)//0xececec 0xf0f4f6
#define UIColor_Button_Disable    UIColorFromRGB(0xe6e6e6)//0xcfd8dc
#define UIColor_Button_Normal       UIColorFromRGB(0xbec6e2)//0x448aff
#define UIColor_Button_HighLight    UIColorFromRGB(0x9ca9d7)//0x2073fe
#define UIColor_Blue_BarItemText  UIColorFromRGB(0x1178e7)
#define UIColor_Gray_Text           UIColorFromRGB(0xc6c6c6)
#define UIColor_DarkGray_Text           UIColorFromRGB(0x8f8f8f)
#define UIColor_XiaoDaiCellGray_Text           UIColorFromRGB(0x979797)
#define UIColor_RedButtonBGNormal           UIColorFromRGB(0xf96969)
#define UIColor_RedButtonBGHighLight           UIColorFromRGB(0xff5e5e)
#define UIColor_LightBlueButtonBGNormal           UIColorFromRGB(0x19cbeb)
#define UIColor_LightBlueButtonBGHighLight           UIColorFromRGB(0x18d2f4)
#define UIColor_BlackBlue_Text           UIColorFromRGB(0x455a64)
#define UIColor_BlueBorderBtn_Normal           UIColorFromRGB(0x448aff)
#define UIColor_BlueBorderBtn_HighLight           UIColorFromRGB(0x246acf)
#define UIColor_Black_Text           UIColorFromRGB(0x263238)
#define UIColor_NewBlack_Text           UIColorFromRGB(0x37474f)
#define UIColor_NewIconColor           UIColorFromRGB(0xbec6e2)
#define UIColor_NewLightTextColor           UIColorFromRGB(0x90a4ae)

#define UIColor_NavBarBGColor           UIColorFromRGB(0xf9f9f9)//导航栏背景色

//灰色分割线
#define UIColor_GrayLine           UIColorFromRGB(0xececec)

//特殊字符
#define SpecialCharacters     @"\\[]{}#%^*+=\"|~<>.,?!'/:;()$&@€£¥_-• "
//数字
#define NUM @"0123456789"
//数字和小数点
#define NumAndDecimal @"0123456789."

//字母
#define ALPHA @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
//数字和字母
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

//应用程序版本号
#define APP_VERSION ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])
//ios系统版本号
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

//空字符处理
#define HLStringNotNull(stringValue) [NSString stringWithFormat:@"%@",([stringValue isEqual:[NSNull null]] ? @"" : stringValue)]



//KeyChainGroupName钥匙串分组
//企业证书发布
//#define kKeyChainAccessGroup_Gesture [NSString stringWithUTF8String:"9KWBX68VRJ.com.Boen.Gesture"]
//#define kKeyChainAccessGroup_LastLoginUserId [NSString stringWithUTF8String:"9KWBX68VRJ.com.Boen.LastLoginUserId"]
//AppStore发布
#define kKeyChainAccessGroup_Gesture [NSString stringWithUTF8String:"JPGCM9SPH7.com.Boen.Gesture"]
#define kKeyChainAccessGroup_LastLoginUserId [NSString stringWithUTF8String:"JPGCM9SPH7.com.Boen.LastLoginUserId"]

#define kRequestReturnData  @"data"   //返回的数据
#define kRequestMessage     @"msg"    //返回的消息
#define kRequestRetCode     @"retcode"//返回的错误码
#define kRequestRetMessage  @"retmsg" //返回的错误消息


#define kRequestSuccessCode @"0000" //请求处理成功的返回码
#define kRequestNewSuccessCode @"000000" //请求处理成功的返回码（新）

#define kBoenUserID         @"BNUserID"
#define kBaseUrl         @"kBaseUrl"
#define kIsAppStoreTest         @"kIsAppStoreTest"
#define kUserIDArrayContain         @"kUserIDArrayContain"
#define KXifuNewsUpdateBefore422         @"KXifuNewsUpdateBefore422"
#define KXifuNewsUpdateBefore500         @"KXifuNewsUpdateBefore500"

#define kUnReadNumber         @"UnReadNumber"

#define kGlobalLoginStatus  @"GlobalLoginStatus"

#define kRechargeOneCardSolutionNo    @"OneCardSolutionNo"
#define kRechargeProjectName          @"ProjectName"
#define kRechargeAmountOfMoney        @"AmountOfMoney"
#define kRechargeDisplayOfMoney       @"DisplayOfMoney"
#define kMobileRechargebndk_amount    @"bndk_amount"
#define kMobileRechargesp_amount      @"sp_amount"
#define kMobileRechargepid            @"pid"
#define kMobileFlowRecharge           @"FlowRecharge"
#define kNoticeMobilePhone            @"NoticeMobilePhone"
#define kNetworkErrorMsg              @"网络错误，请稍后再试"
#define kHomeLoadingMsg               @"获取数据中，请稍候..."
#define kNetworkErrorMsgWhenPay               @"当前网络异常，无法确认交易状态，请稍后到“订单中心”查看此笔交易是否成功"
#define kSystemErrorMsg               @"系统维护中，请稍后再试。"


//通知名
#define kNotification_RefreshLoveDenote                  @"kNotification_RefreshLoveDenote"
#define kNotification_RefreshUnReadNumber                @"kNotification_RefreshUnReadNumber"
//#define kNotification_RefreshOneCardHomeInfo             @"kNotification_RefreshOneCardHomeInfo"
#define kNotification_RefreshOneCardHomeInfoAndProfile   @"kNotification_RefreshOneCardHomeInfoAndProfile"
#define kNotification_SetTabBarTo0                       @"kNotification_SetTabBarTo0"
#define kNotification_RefreshPersonalCenterDetail @"kNotification_RefreshPersonalCenterDetail"
#define kNotification_RefreshBanner @"kNotification_RefreshBanner"
#define kNotification_RefreshHomeSudokuItems @"kNotification_RefreshHomeSudokuItems"
#define kNotification_RefreshHomeActivityList @"kNotification_RefreshHomeActivityList"
#define kNotification_RefreshHomeEventList @"kNotification_RefreshHomeEventList"

#define kNotification_BindStumpH5Success_GotoBiz @"kNotification_BindStumpH5Success_GotoBiz"

//银联支付完成
#define kNotification_YJPayCompleted @"kNotification_YJPayCompleted"

//收到推送消息时，发送的通知
#define kNotification_RecievedMessage_AppHaveNotLaunch_PushToMsgCenterList                 @"kNotification_RecievedMessage_AppHaveNotLaunch_PushToMsgCenterList"
#define kNotification_RecievedMessage_AppLaunched_PresentToMsgCenterList                 @"kNotification_RecievedMessage_AppLaunched_PresentToMsgCenterList"

///消息中心数据请求完成
#define kNotification_Message_HadLoaded @"kNotification_Message_HadLoaded"

#define kNotification_showHomeADView                  @"kNotification_showHomeADView"

//NSUserdefault的关键字
#define kUserDefaults [NSUserDefaults standardUserDefaults]

#define kBundleKey @"CFBundleShortVersionString"  //版本

#define kHasShowedActivityView @"kHasShowedActivityView"

#define KHasShowScanedByShopFirstIntroduce @"KHasShowScanedByShopFirstIntroduce"
#define kHasShowPaySchoolFeesExplain @"PaySchoolFeesExplainIsShow"
#define kHasShowHomeFirstGuidView @"kHasShowHomeFirstGuidView"
#define kHasSavedLivenessDetectionImages @"kHasSavedLivenessDetectionImages"

#define kScanToPayIntroHadRead @"kScanToPayIntroHadRead"
#define kEventHadChecked @"kEventHadChecked"


#define kSectionHeight [BNTools sizeFit:10 six:14 sixPlus:18]

#define kBankCardListCellHeight 63*BILI_WIDTH
#define kHomeProjectCellHeight 128*NEW_BILI
#define kHomeMessageCellHeight 145*NEW_BILI
#define kBNPersonalMessageCellHeight 200
#define kISOpenTouchIDKEY @"kISOpenTouchIDKEY"

#define kBannerCache @"BannerCache"


//易手富SDK的配置参数
#ifdef SERVER_114
//114测试环境
#define YJPayPartnerid  @"20160226020000706766"
#define YJPaySecKey  @"bc077045c0da3409112fa336b45ebb7d"
#define YJPayServerType   ENV_SERVER_SNET   //易极付联调环境

#else
#define YJPayPartnerid  @"20140730020001144381"
#define YJPaySecKey  @"e3aa7441155615ec5c6d1de88b959fd3"
#define YJPayServerType   ENV_SERVER_RELEASE   //易极付正式环境
#endif

//消息中心每页条数
#define MCItemsPerPage 10

#endif
