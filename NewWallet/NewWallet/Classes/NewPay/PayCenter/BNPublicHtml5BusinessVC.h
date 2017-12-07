//
//  BNPublicHtml5BusinessVC.h
//  Wallet
//
//  Created by mac on 16/5/31.
//  Copyright © 2016年 BNDK. All rights reserved.
//
//支付页面跳转类型
typedef NS_ENUM(NSInteger, Html5BusinessType) {
    Html5BusinessType_ThirdPartyBusiness,           //第三方业务
    Html5BusinessType_NativeBusiness,               //自主业务

};
#import "BNBusinessFinishedBaseVC.h"
#import "CustomButton.h"

typedef void (^H5BackBlock)(NSDictionary *dict);
typedef void (^AsReaultVCBackBtnBlock)(PayVCJumpType jumpType);

@interface BNPublicHtml5BusinessVC : BNBusinessFinishedBaseVC

@property (copy, nonatomic) H5BackBlock backBlock;
@property (copy, nonatomic) AsReaultVCBackBtnBlock backBtnBlock; //作为支付结果H5页面，点击返回按钮时。

@property (nonatomic) NSDictionary *params;
@property (nonatomic) CustomButton *bindStumpData;

@property (nonatomic) BOOL hideNavigationbar;
@property (copy, nonatomic) NSString *url;
@property (assign, nonatomic) Html5BusinessType businessType;

@property (nonatomic) BOOL useToBNScanedByShopVC;

@end
