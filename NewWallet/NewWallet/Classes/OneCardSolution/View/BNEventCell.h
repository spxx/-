//
//  BNEventCell.h
//  Wallet
//
//  Created by 陈荣雄 on 16/7/4.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *eventCellIdentifier = @"EventCell";

@protocol EventCheckDelegate <NSObject>

- (void)eventCheck:(id)data;

@end

@interface BNEventCell : UITableViewCell

@property (strong, nonatomic) id data;

@property (weak, nonatomic) id<EventCheckDelegate> delegate;

- (void)setCheckMode:(BOOL)mode;

@end
