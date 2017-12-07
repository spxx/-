//
//  BNTaskListTableViewCell.h
//  Wallet
//
//  Created by mac1 on 15/12/23.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCell_Height 60 * NEW_BILI


@interface BNTaskListTableViewCell : UITableViewCell


- (void)drawCellDataWithDictionary:(NSDictionary *)dictionary;

@end
