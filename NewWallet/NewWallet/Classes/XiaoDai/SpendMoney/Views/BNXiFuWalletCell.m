//
//  BNXiFuWalletCell.m
//  Wallet
//
//  Created by mac1 on 15/11/2.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import "BNXiFuWalletCell.h"

@implementation BNXiFuWalletCell
static NSInteger cellHeight;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
         cellHeight = kBankCardListCellHeight;
        UIImageView *logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(11*BILI_WIDTH, (cellHeight-38*BILI_WIDTH)/2, 38*BILI_WIDTH, 38*BILI_WIDTH)];
        logoImageView.image = [UIImage imageNamed:@"Me_Balence"];
        [self.contentView addSubview:logoImageView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60*BILI_WIDTH, 23.5*BILI_WIDTH, SCREEN_WIDTH - 60*BILI_WIDTH * 2, 16*BILI_WIDTH)];
        nameLabel.font = [UIFont systemFontOfSize:16*BILI_WIDTH];
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.text = @"喜付钱包";
        [self.contentView addSubview:nameLabel];
        
        
        UIImageView *selectImgV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 10*BILI_WIDTH - 20, (80-15*BILI_WIDTH)/2, 15*BILI_WIDTH, 15*BILI_WIDTH)];
        selectImgV.image = [UIImage imageNamed:@"Select_Bank_card"];
        [self.contentView addSubview:selectImgV];
    }
    return self;
}

@end
