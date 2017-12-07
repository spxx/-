//
//  BNNetFeesSelectCampusVC.h
//  Wallet
//
//  Created by mac1 on 16/2/16.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "BNBaseViewController.h"

@interface BNNetFeesSelectCampusVC : BNBaseViewController

@property (strong, nonatomic) NSArray *campuses;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (copy, nonatomic) void(^selectedCampusFinished)(NSDictionary *selectedCampusData, NSInteger lastSelectedIndex);

@end
