//
//  BNGesturePWDTableViewCell.h
//  Wallet
//
//  Created by mac1 on 16/1/29.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kGesturePWD_Cell_Title @"title"
#define kGesturePWD_Cell_right @"right"
#define kGesturePWD_Cell_SwitchIsOn @"switch"

@interface BNGesturePWDTableViewCell : UITableViewCell

@property (weak, nonatomic) UISwitch *theSwitch;

- (void)setupCellWithDictonary:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath;

@end
