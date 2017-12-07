//
//  LDClassCell.h
//  Wallet
//
//  Created by mac1 on 16/6/1.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrivingClass.h"

@protocol LDClassCellDelegate <NSObject>

@optional
- (void)applyButtonClick:(UIButton *)button;

@end

@interface LDClassCell : UITableViewCell

@property (strong, nonatomic)DrivingClass *model;

@property (nonatomic, weak) id<LDClassCellDelegate> delegate;


@end
