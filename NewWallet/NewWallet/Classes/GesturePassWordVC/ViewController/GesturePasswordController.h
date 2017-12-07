//
//  GesturePasswordController.h
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "TentacleView.h"
#import "GesturePasswordView.h"
#import "BNBaseViewController.h"
#import "BNHomeViewController.h"


typedef NS_ENUM(NSInteger, VcType) {
    VcTypeFirstSetPsw = 0,
    VcTypeReSetPsw    = 1,
    VcTypeVerifyPsw   = 2,
};
@interface GesturePasswordController : BNBaseViewController <VerificationDelegate,ResetDelegate,GesturePasswordDelegate>

@property (copy ,nonatomic) NSString *nameOfRootPushVC;

@property (nonatomic) VcType vcType;

@property (strong ,nonatomic) BNHomeViewController *homeVC;

-(void)refreshHeadAndTitle;

- (void)clear;

@end
