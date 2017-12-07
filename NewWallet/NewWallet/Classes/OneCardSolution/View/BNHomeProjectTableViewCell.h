//
//  BNHomeProjectTableViewCell.h
//  NewWallet
//
//  Created by mac on 16-12-26.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNHomeProjectTableViewCell : UITableViewCell

- (void)drawData:(NSDictionary *)dict animation:(BOOL)animation oneCardAmount:(NSString *)oneCardAmount electricAmount:(NSString *)electricAmount
;


@end
