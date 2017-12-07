//
//  AppDelegate.h
//  NewWallet
//
//  Created by mac1 on 14-10-21.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNUserInfo.h"
#import "Classes/Model/BNXiaoDaiBorrowMoneyInfo.h"
#import "GesturePasswordController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>

typedef NS_ENUM(NSInteger, LoadDataStatusStyle) {
    LoadDataStatusStyleSuccess,           //加载数据返回成功，并且有数据
    LoadDataStatusStyleSuccessButNothing, //加载数据返回成功，但是没有任何数据
    LoadDataStatusStyleReturnFailed,             //加载数据失败
    LoadDataStatusStyleNetworkError
};
typedef NS_ENUM(NSInteger, RecievedNewMesageType) {
    //收到推送消息，处理类型
    RecievedNewMesageType_None,    //未收到消息时。
    RecievedNewMesageType_AppHaveNotLaunch_NeedPushToMsgCenter,        //APP处于未启动状态
    RecievedNewMesageType_AppLaunched_NeedPresentToMsgCenter,          //APP处于已启动状态
};


@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate>{
    BMKMapManager *map_manager;
}
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) BNUserInfo *boenUserInfo;
@property (strong, nonatomic) BNXiaoDaiBorrowMoneyInfo *xiaodaiBorrowInfo;

@property (assign, nonatomic) BOOL haveGetPrefile;
@property (assign, nonatomic) BOOL haveKwdsToAutoLogIn;//用于判断是否弹出“未登录页面”

@property (strong, nonatomic) NSString *popToViewController;
@property (strong, nonatomic) NSString *tempUserId;

@property (strong, nonatomic) NSString *schoolIdForBaiDuTag;  //百度推送tag
@property (strong, nonatomic) NSString *baiDuUserId;          //百度userId
@property (strong, nonatomic) NSString *baiDuChannelId;       //百度ChannelId
@property (strong, nonatomic) UIAlertView *alertView;
@property (strong, nonatomic) NSMutableDictionary *xiaoDaiInfoDict;
@property (strong, nonatomic) NSDictionary *collectFeesData;

@property (assign, nonatomic) BOOL isShowTiXianRealNameAlertView; //用于判断是否弹出过提现实名认证AlertView
@property (assign, nonatomic) BOOL appLaunch_RecievedNewMesage_needPushToMsgCenter;
@property (assign, nonatomic) BOOL appActived_RecievedNewMesage_needPresentToMsgCenter;
@property (assign, nonatomic) RecievedNewMesageType recievedNewMesageType;  //收到推送消息，处理类型

@property (assign ,nonatomic) GesturePasswordController *gestureVC;

- (void)refreshPersonProfile;
- (void)presentGesturePswVC;
- (void)getAndRefreshNewsData;
- (void)refreshServiceCenterAfter10Seconds;

//- (void)checkSchoolListFromServer;//后台获取学校列表

@end

extern AppDelegate *shareAppDelegateInstance;
