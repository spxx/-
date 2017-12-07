//
//  LDProgressCell.h
//  Wallet
//
//  Created by 陈荣雄 on 5/30/16.
//  Copyright © 2016 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PayFeeDelegate <NSObject>

- (void)pay;

@end

static NSString *progressCellIdentifier = @"LDProgressCell";

@interface LDProgressCell : UITableViewCell

@property (weak, nonatomic) id<PayFeeDelegate> payDelegate;

- (void)setData:(NSDictionary *)data;
- (void)setPayState:(BOOL)payable;

@end
