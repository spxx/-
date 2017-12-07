//
//  BNSideMenuCell.h
//  Wallet
//
//  Created by 陈荣雄 on 2016/12/23.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *sideMenuCellIdentifier = @"BNSideMenuCell";

@interface BNSideMenuCell : UITableViewCell

- (void)setData:(NSDictionary *)data;

@end
