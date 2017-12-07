//
//  BNBankCardSelectCell.h
//  NewWallet
//
//  Created by mac on 14-11-7.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNBankCardSelectCell : UITableViewCell

@property (weak, nonatomic) UILabel *defaultPayLabel;

- (void)drawData:(NSDictionary *)dict selectCardNoStr:(NSString *)selectCardNoStr chargeMoney:(NSString *)moneyStr;

@end
