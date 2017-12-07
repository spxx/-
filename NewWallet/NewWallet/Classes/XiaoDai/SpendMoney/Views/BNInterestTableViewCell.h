//
//  BNInterestTableViewCell.h
//  Wallet
//
//  Created by mac1 on 15/5/5.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNInterestTableViewCell : UITableViewCell

- (void)drawDataWithDict:(NSDictionary *)dict isSelected:(BOOL) isSelected;

@end
