//
//  BNSideMenuViewController.h
//  Wallet
//
//  Created by 陈荣雄 on 2016/12/23.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "BNBaseViewController.h"

@protocol SideMenuDelegate <NSObject>

- (void)menuSelected:(NSDictionary *)data;

@end

@interface BNSideMenuViewController : UIView

@property (strong, nonatomic) NSArray *menus;
@property (weak, nonatomic) id<SideMenuDelegate> delegate;

- (void)reset;
- (void)reloadData;

@end
