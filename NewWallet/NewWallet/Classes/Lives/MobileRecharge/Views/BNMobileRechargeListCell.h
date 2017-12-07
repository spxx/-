//
//  BNMobileRechargeListCell.h
//  Wallet
//
//  Created by mac1 on 15-1-5.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNMobileRechargeListCell : UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier width:(CGFloat) width;

- (void)drawCellWithData:(NSDictionary *)info;
@end
