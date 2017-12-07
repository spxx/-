//
//  BNGesturePWDTableViewCell.m
//  Wallet
//
//  Created by mac1 on 16/1/29.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "BNGesturePWDTableViewCell.h"

@interface BNGesturePWDTableViewCell ()

@property (weak, nonatomic) UILabel *cellTitleLab;
@property (weak, nonatomic) UIImageView *arrowImg;
@property (weak, nonatomic) UIView *sepLine;

@end

@implementation BNGesturePWDTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *cellTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 36, 45 * BILI_WIDTH)];
        cellTitleLabel.textColor = UIColor_BlackBlue_Text;
        cellTitleLabel.textAlignment = NSTextAlignmentLeft;
        cellTitleLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:16 sixPlus:18]];
        _cellTitleLab = cellTitleLabel;
        
        
        UIImageView *rightArrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 26, (45 * BILI_WIDTH - 16.0)/2.0, 16, 16)];
        [rightArrowImg setImage:[UIImage imageNamed:@"right_arrow"]];
        _arrowImg = rightArrowImg;
        
        UISwitch *theSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 61, (CGRectGetHeight(self.contentView.frame) - 31)/2.0, 51, 31)];
        _theSwitch = theSwitch;
        
        [self.contentView addSubview:cellTitleLabel];
        [self.contentView addSubview:rightArrowImg];
        [self.contentView addSubview:theSwitch];
        
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 44.0 * BILI_WIDTH - 0.5, SCREEN_WIDTH - 10, 0.5)];
        line.backgroundColor = UIColor_GrayLine;
        _sepLine = line;
        [self.contentView addSubview:line];
        
    }
    return self;
}
- (void)setupCellWithDictonary:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath
{
    _cellTitleLab.text = [dic objectForKey:kGesturePWD_Cell_Title];
    _sepLine.hidden = indexPath.row == 1;
    _theSwitch.on = [[dic objectForKey:kGesturePWD_Cell_SwitchIsOn] isEqualToString:@"YES"];
    if ([[dic objectForKey:kGesturePWD_Cell_right] isEqualToString:@"switch"]) {
        _arrowImg.hidden = YES;
        _theSwitch.hidden = NO;
    }else{
        _theSwitch.hidden = YES;
        _arrowImg.hidden = NO;
    }
}


@end
