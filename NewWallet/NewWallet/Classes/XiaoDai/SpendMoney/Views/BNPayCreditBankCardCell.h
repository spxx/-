//
//  BNPayCreditBankCardCell.h
//  Wallet
//
//  Created by mac1 on 15/5/4.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNPayCreditBankCardCell : UITableViewCell

- (void)drawData:(NSDictionary *)dict selectCardNoStr:(NSString *)selectCardNoStr;

@end
