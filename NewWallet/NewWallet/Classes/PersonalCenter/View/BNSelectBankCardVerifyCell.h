//
//  BNSelectBankCardVerifyCell.h
//  NewWallet
//
//  Created by mac1 on 14-11-7.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNSelectBankCardVerifyCell : UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier width:(CGFloat) width;

- (void)drawDataWithInfo:(NSDictionary *)bankCardInfo isSelected:(BOOL )isSelected;
@end
