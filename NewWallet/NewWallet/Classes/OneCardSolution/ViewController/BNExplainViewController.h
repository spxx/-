//
//  BNExplainViewController.h
//  Wallet
//
//  Created by mac1 on 15/3/5.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNBaseViewController.h"

typedef NS_ENUM(NSInteger, ExplainStyle) {
    ExplainStyleUse,
    ExplainStyleLimite,
    ExplainStyleMap
};

@interface BNExplainViewController : BNBaseViewController

@property (assign) ExplainStyle useStyle;
@end
