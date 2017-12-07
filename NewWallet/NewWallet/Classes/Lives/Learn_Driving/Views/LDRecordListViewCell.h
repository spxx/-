//
//  LDRecordListViewCell.h
//  Wallet
//
//  Created by 陈荣雄 on 16/6/3.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *recordCellIdentifier = @"LDRecordListViewCell";

@interface LDRecordListViewCell : UITableViewCell

- (void)setData:(NSDictionary *)data;

@end
