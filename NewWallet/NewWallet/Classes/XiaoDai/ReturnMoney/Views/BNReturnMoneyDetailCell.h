//
//  BNReturnMoneyDetailCell.h
//  Wallet
//
//  Created by mac on 15/4/30.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNReturnMoneyDetailCell : UITableViewCell

- (void)drawDataWithDict:(NSDictionary *)dict andIndexPath:(NSIndexPath *)indexPath cellCount:(NSInteger)count;

@end
