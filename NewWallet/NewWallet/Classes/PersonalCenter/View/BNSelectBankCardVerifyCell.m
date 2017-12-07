//
//  BNSelectBankCardVerifyCell.m
//  NewWallet
//
//  Created by mac1 on 14-11-7.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNSelectBankCardVerifyCell.h"

@interface BNSelectBankCardVerifyCell ()

@property (weak, nonatomic) UILabel *bankNameLabel;

@property (weak, nonatomic) UILabel *subTitleLabel;
@property (nonatomic) UIImageView *bankLogoImgV;

@property (weak, nonatomic) UIImageView *selectedImageView;
@end

@implementation BNSelectBankCardVerifyCell

static NSInteger cellHeight = 80;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier width:(CGFloat) width
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
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
        self.subTitleLabel = tailLabel;

//        
//        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, 18, self.frame.size.width - 24 * 2, 25)];
//        nameLabel.font = [UIFont boldSystemFontOfSize:[BNTools sizeFit:16 six:17 sixPlus:18]];
//        nameLabel.textColor = [UIColor blackColor];
//        nameLabel.textAlignment = NSTextAlignmentLeft;
//        nameLabel.backgroundColor = [UIColor clearColor];
//        [self.contentView addSubview:nameLabel];
//        self.bankNameLabel = nameLabel;
//        
//        UILabel *tailLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, 20 + 25, self.frame.size.width - 24 * 2, 20)];
//        tailLabel.font = [UIFont boldSystemFontOfSize:[BNTools sizeFit:14 six:15 sixPlus:16]];
//        tailLabel.textColor = [UIColor lightGrayColor];
//        tailLabel.textAlignment = NSTextAlignmentLeft;
//        tailLabel.backgroundColor = [UIColor clearColor];
//        [self.contentView addSubview:tailLabel];
//        self.subTitleLabel = tailLabel;
        
        UIImageView *selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width - 15-15, (cellHeight - 15)/2, 15, 15)];
        [selectImageView setImage:[UIImage imageNamed:@"Select_Bank_card"]];
        [self.contentView addSubview:selectImageView];
        self.selectedImageView = selectImageView;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(24, cellHeight - 1, width - 24, 1)];
        line.backgroundColor = UIColor_GrayLine;
        [self.contentView addSubview:line];
    }
    return self;
}


- (void)drawDataWithInfo:(NSDictionary *)bankCardInfo isSelected:(BOOL)isSelected
{
    self.bankNameLabel.text = [bankCardInfo valueNotNullForKey:@"bank_name"];
    NSString *bankCardNo = [bankCardInfo valueNotNullForKey:@"bankCardNo"];
    
    if (bankCardNo.length > 4) {
        bankCardNo = [bankCardNo substringWithRange:NSMakeRange(bankCardNo.length - 4, 4)];
        NSString *title = [NSString stringWithFormat:@"尾号: %@", bankCardNo];
        self.subTitleLabel.text = title;
    }
    if (isSelected == YES) {
        self.selectedImageView.hidden = NO;
    }else{
        self.selectedImageView.hidden = YES;
    }
    
    [_bankLogoImgV sd_setImageWithURL:[NSURL URLWithString:[bankCardInfo valueNotNullForKey:@"bank_logo"]] placeholderImage:[UIImage imageNamed:@"bank_icon_default"]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
