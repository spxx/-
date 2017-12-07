//
//  BNHomeEventTableViewCell.h
//  NewWallet
//
//  Created by mac on 16-12-26.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNHomeMessageModel.h"

@interface BNHomeEventTableViewCell : UITableViewCell

- (void)drawMessageData:(BNHomeMessageModel *)model;


@end
