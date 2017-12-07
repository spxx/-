//
//  BNScanedByShopChangePayListCell.h
//  Wallet
//
//  Created by mac on 2017/2/21.
//  Copyright © 2017年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNScanedByShopChangePayListCell : UITableViewCell

@property (weak, nonatomic) UILabel *titleLabel;

- (void)drawData:(NSDictionary *)cellInfo;

@end
