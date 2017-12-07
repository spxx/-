//
//  BNPayCreditBankCardCell.m
//  Wallet
//
//  Created by mac1 on 15/5/4.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNPayCreditBankCardCell.h"

@interface BNPayCreditBankCardCell ()

@property (weak,  nonatomic) UILabel *bankNameLabel;

@property (weak,  nonatomic) UILabel *cardTailLabel;

@property (weak,  nonatomic) UILabel *statusLabel;
@property (weak, nonatomic) UILabel *defaultPayLabel;

@property (nonatomic) UIImageView *bankLogoImgV;

@end

@implementation BNPayCreditBankCardCell
static NSInteger cellHeight;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        cellHeight = kBankCardListCellHeight;
        
        self.bankLogoImgV = [[UIImageView alloc]initWithFrame:CGRectMake(11*BILI_WIDTH, (cellHeight-38*BILI_WIDTH)/2, 38*BILI_WIDTH, 38*BILI_WIDTH)];
        [self.contentView addSubview:_bankLogoImgV];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60*BILI_WIDTH, 12*BILI_WIDTH, SCREEN_WIDTH - 60*BILI_WIDTH * 2, 16*BILI_WIDTH)];
        nameLabel.font = [UIFont systemFontOfSize:16*BILI_WIDTH];
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:nameLabel];
        self.bankNameLabel = nameLabel;
        
        UILabel *tailLabel = [[UILabel alloc] initWithFrame:CGRectMake(60*BILI_WIDTH, cellHeight-(14+12)*BILI_WIDTH, SCREEN_WIDTH - 60*BILI_WIDTH * 2, 14*BILI_WIDTH)];
        tailLabel.font = [UIFont systemFontOfSize:14*BILI_WIDTH];
        tailLabel.textColor = [UIColor lightGrayColor];
        tailLabel.textAlignment = NSTextAlignmentLeft;
        tailLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:tailLabel];
        _cardTailLabel = tailLabel;
        
        UILabel *defaultLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - (20+60)*BILI_WIDTH, 12*BILI_WIDTH, 60*BILI_WIDTH, 14*BILI_WIDTH)];
        defaultLabel.font = [UIFont systemFontOfSize:14*BILI_WIDTH];
        defaultLabel.textColor = UIColor_Blue_BarItemText;
        defaultLabel.textAlignment = NSTextAlignmentLeft;
        defaultLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:defaultLabel];
        defaultLabel.text = @"默认支付";
        self.defaultPayLabel = defaultLabel;
        
//        UIImageView *selectImgV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 10*BILI_WIDTH - 20, (80-15*BILI_WIDTH)/2, 15*BILI_WIDTH, 15*BILI_WIDTH)];
//        selectImgV.image = [UIImage imageNamed:@"Select_Bank_card"];
//        [self.contentView addSubview:selectImgV];
//        self.selectImgView = selectImgV;

        UILabel *statusLab = [[UILabel alloc] initWithFrame:CGRectMake(10 * BILI_WIDTH, 44, SCREEN_WIDTH - 10*BILI_WIDTH*2, 24)];
        statusLab.textColor = UIColorFromRGB(0xD92C14);
        statusLab.backgroundColor = [UIColor clearColor];
        statusLab.textAlignment = NSTextAlignmentRight;
        statusLab.font = [UIFont systemFontOfSize:[BNTools sizeFit:13 six:15 sixPlus:17]];
        statusLab.text = @"*暂不支持放款到该银行";
        _statusLabel = statusLab;
        [self.contentView addSubview:statusLab];
        
    }
    return self;
}
- (void)drawData:(NSDictionary *)dict selectCardNoStr:(NSString *)selectCardNoStr
{
    self.bankNameLabel.text = [dict valueNotNullForKey:@"bank_name"];
    NSString *cardNo = [dict valueNotNullForKey:@"bankCardNo"];
    if ([selectCardNoStr isEqualToString:cardNo]) {
        self.defaultPayLabel.hidden = NO;

    } else {
        self.defaultPayLabel.hidden = YES;

    }
    if (cardNo != nil && cardNo.length > 4) {
        cardNo = [NSString stringWithFormat:@"尾号 : %@",[cardNo substringWithRange:NSMakeRange(cardNo.length - 4, 4)]];
    }
    self.cardTailLabel.text = cardNo;
    _statusLabel.hidden = YES;
    [_bankLogoImgV sd_setImageWithURL:[NSURL URLWithString:[dict valueNotNullForKey:@"bank_logo"]] placeholderImage:[UIImage imageNamed:@"bank_icon_default"]];

}
@end
