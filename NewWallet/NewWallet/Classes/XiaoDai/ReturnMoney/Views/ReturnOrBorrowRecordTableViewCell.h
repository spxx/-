//
//  ReturnOrBorrowRecordTableViewCell.h
//  Wallet
//
//  Created by cyjjkz1 on 15/5/6.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReturnOrBorrowRecordViewController.h"


@interface ReturnOrBorrowRecordTableViewCell : UITableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier viewController:(ReturnOrBorrowRecordViewController *)viewController;


- (void)drawDataWithDict:(NSDictionary *)dict returnOrBorrow:(BOOL)returnOrBorrow;

@end
