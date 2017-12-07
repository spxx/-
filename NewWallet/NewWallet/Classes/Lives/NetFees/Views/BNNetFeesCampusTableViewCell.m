//
//  BNNetFeesCampusTableViewCell.m
//  Wallet
//
//  Created by mac1 on 16/2/16.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "BNNetFeesCampusTableViewCell.h"

@interface BNNetFeesCampusTableViewCell ()

@property (weak, nonatomic) UILabel *nameLabel;
@property (weak, nonatomic) UIImageView *selectImgV;
@end

@implementation BNNetFeesCampusTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel *campusName = [[UILabel alloc] initWithFrame:CGRectMake(15 * NEW_BILI, (CGRectGetHeight(self.contentView.frame) - 20 * NEW_BILI)/2.0, 150 * NEW_BILI, 20 * NEW_BILI)];
        [self.contentView addSubview:campusName];
        _nameLabel = campusName;
        
        
        UIImageView *selectImgV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 10*BILI_WIDTH - 20, (CGRectGetHeight(self.contentView.frame)-15*BILI_WIDTH)/2, 15*BILI_WIDTH, 15*BILI_WIDTH)];
        selectImgV.image = [UIImage imageNamed:@"Select_Bank_card"];
        [self.contentView addSubview:selectImgV];
        _selectImgV = selectImgV;
    }
    
    return self;
}

- (void)setupCellSubViewsWithDictionary:(NSDictionary *)dic index:(NSInteger )index selectIndex:(NSInteger)selectIndex;
{
    _nameLabel.text = [dic valueNotNullForKey:@"campus_name"];
    _selectImgV.hidden = index != selectIndex;
}

@end
