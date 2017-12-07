//
//  BNNewsTableCell.h
//  NewWallet
//
//  Created by cyjjkz1 on 14-11-10.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>




#define NewsCardContentWidth (SCREEN_WIDTH - 50)

#define TitleHeight @"titleHeight"

#define SubTitleHeight @"subTitleHeight"

#define CellHeight @"cellHeight"
//NSDictionary *heightDic = @{@"titleHeight":   @(titleHeight),
//                            @"subTitleHeight":@(subTitleHeight),
//                            @"cellHeight":    @(cellHeight)};
@class NSManagedObject;

@interface BNNewsTableCell : UITableViewCell

@property (strong, nonatomic) UIView *newsBodyBackgroundView;

- (void)drawDataWithInfo:(NSManagedObject *)newInfo withHeightDic:(NSDictionary *)heightInfo;
@end
