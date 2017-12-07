//
//  BNSettingCell.m
//  Wallet
//
//  Created by mac1 on 15/3/3.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNSettingCell.h"

@implementation BNSettingCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *cellTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 44 * BILI_WIDTH)];
        cellTitleLabel.textColor = UIColor_BlackBlue_Text;
        cellTitleLabel.textAlignment = NSTextAlignmentLeft;
        cellTitleLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:16 sixPlus:18]];
        _cellTitleLab = cellTitleLabel;
        
        
        UIImageView *rightArrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 26, (44 * BILI_WIDTH - 16.0)/2.0, 16, 16)];
        [rightArrowImg setImage:[UIImage imageNamed:@"right_arrow"]];
        _arrowImg = rightArrowImg;
        
        [self.contentView addSubview:cellTitleLabel];
        [self.contentView addSubview:rightArrowImg];
        
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 44.0 * BILI_WIDTH - 0.5, SCREEN_WIDTH - 10, 0.5)];
        line.backgroundColor = UIColor_GrayLine;
        _sepLine = line;
        [self.contentView addSubview:line];
        
    }
    return self;
}

@end
