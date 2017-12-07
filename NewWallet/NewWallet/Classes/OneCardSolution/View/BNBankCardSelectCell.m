//
//  BNBankCardSelectCell.m
//  NewWallet
//
//  Created by mac on 14-11-7.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNBankCardSelectCell.h"

@interface BNBankCardSelectCell ()

@property (weak, nonatomic) UILabel *bankNameLabel;
@property (weak, nonatomic) UILabel *tailNumLabel;
@property (nonatomic) UIImageView *bankLogoImgV;
@end

@implementation BNBankCardSelectCell

static NSInteger cellHeight;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        cellHeight = kBankCardListCellHeight;
        
        self.bankLogoImgV = [[UIImageView alloc]initWithFrame:CGRectMake(11*BILI_WIDTH, (cellHeight-38*BILI_WIDTH)/2, 38*BILI_WIDTH, 38*BILI_WIDTH)];
        [self.contentView addSubview:_bankLogoImgV];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60*BILI_WIDTH, 12*BILI_WIDTH, SCREEN_WIDTH - 60*BILI_WIDTH * 2, 16*BILI_WIDTH)];
        nameLabel.font = [UIFont boldSystemFontOfSize:16*BILI_WIDTH];
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:nameLabel];
        self.bankNameLabel = nameLabel;
        
        UILabel *tailLabel = [[UILabel alloc] initWithFrame:CGRectMake(60*BILI_WIDTH, cellHeight-(14+12)*BILI_WIDTH, SCREEN_WIDTH - 60*BILI_WIDTH * 2, 14*BILI_WIDTH)];
        tailLabel.font = [UIFont boldSystemFontOfSize:14*BILI_WIDTH];
        tailLabel.textColor = [UIColor lightGrayColor];
        tailLabel.textAlignment = NSTextAlignmentLeft;
        tailLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:tailLabel];
        self.tailNumLabel = tailLabel;
        
        UILabel *defaultLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - (20+60)*BILI_WIDTH, 12*BILI_WIDTH, 60*BILI_WIDTH, 14*BILI_WIDTH)];
        defaultLabel.font = [UIFont systemFontOfSize:14*BILI_WIDTH];
        defaultLabel.textColor = UIColor_Blue_BarItemText;
        defaultLabel.textAlignment = NSTextAlignmentLeft;
        defaultLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:defaultLabel];
        defaultLabel.text = @"默认支付";
        self.defaultPayLabel = defaultLabel;
        
//        UIImageView *selectImgV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 10*BILI_WIDTH - 20, (cellHeight-15*BILI_WIDTH)/2, 15*BILI_WIDTH, 15*BILI_WIDTH)];
//        selectImgV.image = [UIImage imageNamed:@"Select_Bank_card"];
//        [self.contentView addSubview:selectImgV];
//        self.selectImgView = selectImgV;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(60*BILI_WIDTH, cellHeight - 1, SCREEN_WIDTH - 60*BILI_WIDTH, 1)];
        line.backgroundColor = UIColorFromRGB(0xDEDEDE);
        [self.contentView addSubview:line];
    }
    return self;
}

- (void)drawData:(NSDictionary *)dict selectCardNoStr:(NSString *)selectCardNoStr chargeMoney:(NSString *)moneyStr
{
    BNLog(@"%@",dict);
    if ([[dict valueNotNullForKey:@"bank_name"] isEqualToString:@"小额贷款不显示"]) {
        self.bankNameLabel.hidden = YES;
        self.tailNumLabel.hidden = YES;
        self.defaultPayLabel.hidden = YES;
    } else {
        self.bankNameLabel.hidden = NO;
        self.tailNumLabel.hidden = NO;
        self.defaultPayLabel.hidden = NO;
    }
    self.bankNameLabel.text = [dict valueNotNullForKey:@"bank_name"];
    NSString *cardNo = [dict valueNotNullForKey:@"bankCardNo"];
    if ([selectCardNoStr isEqualToString:cardNo]) {
        self.defaultPayLabel.hidden = NO;
    } else {
        self.defaultPayLabel.hidden = YES;
    }
    if ([[dict valueNotNullForKey:@"bank_name"] isEqualToString:@"喜付钱包"]) {
        _bankNameLabel.textColor = [moneyStr floatValue] > [cardNo floatValue] ? UIColorFromRGB(0xb4b4b4) : [UIColor blackColor];
        cardNo = [NSString stringWithFormat:@"余额 : %@",cardNo];
        [_bankLogoImgV setImage:[UIImage imageNamed:@"wallet_icon"]];

    } else {
        if (cardNo != nil && cardNo.length > 4) {
            cardNo = [NSString stringWithFormat:@"尾号 : %@",[cardNo substringWithRange:NSMakeRange(cardNo.length - 4, 4)]];
        }
        NSString *bank_logo = [dict valueNotNullForKey:@"bank_logo"];
        [_bankLogoImgV sd_setImageWithURL:[NSURL URLWithString:bank_logo] placeholderImage:[UIImage imageNamed:@"bank_icon_default"]];

    }
    self.tailNumLabel.text = cardNo;


}
@end
