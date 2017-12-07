//
//  BNPersonalDetialCell.h
//  Wallet
//
//  Created by mac1 on 15/3/3.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CellLineType) {
    CellLineTypeNormalCell, //section中
    CellLineTypeLastCell
};

@interface BNPersonalDetialCell : UITableViewCell

@property (weak, nonatomic) UILabel *cellTitleLab;
@property (weak, nonatomic) UILabel *cellSubTitleLab;
@property (weak, nonatomic) UIView *sepLine;

@property (weak, nonatomic) UIImageView *rightArrow;


- (void)setupCellViewIndexPath:(NSIndexPath *)indexPath isBind:(BOOL) isBind isRealNamed:(BOOL)isRealNamed;

@end
