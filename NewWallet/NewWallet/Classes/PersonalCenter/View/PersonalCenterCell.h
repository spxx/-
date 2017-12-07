//
//  PersonalCenterCell.h
//  Wallet
//
//  Created by mac1 on 15/2/4.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPersonal_Cell_Icon @"icon"

#define kPersonal_Cell_Title @"title"

#define kPersonal_Cell_SubTitle @"subTitle"

#define kPersonal_Cell_Arrow @"arrow"

#define kPersonalCellHeight 80

@interface PersonalCenterCell : UITableViewCell

- (void)setupDataForCell:(NSDictionary *) cellInfo isShowLine:(BOOL) isShow;

@end
