//
//  BNBankNameCell.m
//  NewWallet
//
//  Created by mac1 on 14-11-4.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNBankNameCell.h"

@interface BNBankNameCell()
@property (weak, nonatomic) UILabel *bankNameLabel;
@property (nonatomic) UIImageView *bankLogoImgV;

@end
@implementation BNBankNameCell

static NSInteger cellHeight;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cellHeight = kBankCardListCellHeight;
        
        self.bankLogoImgV = [[UIImageView alloc]initWithFrame:CGRectMake(11*BILI_WIDTH, (cellHeight-38*BILI_WIDTH)/2, 38*BILI_WIDTH, 38*BILI_WIDTH)];
        [self.contentView addSubview:_bankLogoImgV];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60*BILI_WIDTH, (cellHeight-16*BILI_WIDTH)/2, SCREEN_WIDTH - 60*BILI_WIDTH * 2, 16*BILI_WIDTH)];
        nameLabel.font = [UIFont boldSystemFontOfSize:16*BILI_WIDTH];
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:nameLabel];
        self.bankNameLabel = nameLabel;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(60*BILI_WIDTH, cellHeight - 1, SCREEN_WIDTH - 60*BILI_WIDTH, 1)];
        line.backgroundColor = UIColor_GrayLine;
        [self.contentView addSubview:line];
    }
    return self;
}

- (void)drawData:(NSDictionary *)dict
{
    self.bankNameLabel.text = [dict valueNotNullForKey:@"bank_name"];
    [_bankLogoImgV sd_setImageWithURL:[NSURL URLWithString:[dict valueNotNullForKey:@"bank_logo"]] placeholderImage:[UIImage imageNamed:@"bank_icon_default"]];
}
@end
