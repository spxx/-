//
//  BillTableViewCell.h
//  Wallet
//
//  Created by mac1 on 15/2/2.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kBillCellHeight 69 * BILI_WIDTH
@interface BillTableViewCell : UITableViewCell


- (void)setupDataTableViewCellWithInfo:(NSDictionary *)info;
@end
