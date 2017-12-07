//
//  BNSideMenuView.h
//  Wallet
//
//  Created by 陈荣雄 on 2016/12/27.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNSideMenuViewController.h"

@interface BNSideMenuView : UIView

@property (weak, nonatomic) id<SideMenuDelegate> delegate;

- (void)setMenu:(NSArray *)menus;

- (void)show;
- (void)dismiss;

@end
