//
//  BNReturnMoneyListCell.h
//  Wallet
//
//  Created by mac on 15/4/30.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BNReturnMoneyListCellDelegate <NSObject>

- (void)BNReturnMoneyListCellDelegateReturnBtnAction:(NSDictionary *)dict;

@end

@interface BNReturnMoneyListCell : UITableViewCell

@property (weak, nonatomic) id <BNReturnMoneyListCellDelegate> delegate;

- (void)drawDataWithDict:(NSDictionary *)dict;

@end
