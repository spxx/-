//
//  BNServerCenterCell.m
//  NewWallet
//
//  Created by cyjjkz1 on 14-11-10.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNServerCenterCell.h"

@interface BNServerCenterCell ()

@property (weak, nonatomic) UIImageView *serverCenterIconImageView;

@property (weak, nonatomic) UILabel *serverCenterNameLabel;
@property (weak, nonatomic) UILabel *latestNewsLabel;

@property (weak, nonatomic) UILabel *countNewsLabel;

@end
@implementation BNServerCenterCell

static CGFloat cellHeight;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    cellHeight = 80*BILI_WIDTH;
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat iconWidth = [BNTools sizeFit:50 six:50 sixPlus:75];
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(15*BILI_WIDTH, (cellHeight - iconWidth) / 2, iconWidth, iconWidth)];
        [self.contentView addSubview:icon];
        self.serverCenterIconImageView = icon;
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80*BILI_WIDTH, cellHeight/2-18*BILI_WIDTH-4*BILI_WIDTH, SCREEN_WIDTH - 80*BILI_WIDTH, 18*BILI_WIDTH)];
        nameLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:16 sixPlus:18]];
        nameLabel.textColor = UIColor_BlackBlue_Text;
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:nameLabel];
        self.serverCenterNameLabel = nameLabel;
        
        UILabel *latestNewsLabel = [[UILabel alloc] initWithFrame:CGRectMake(80*BILI_WIDTH, CGRectGetMaxY(nameLabel.frame)+7*BILI_WIDTH, SCREEN_WIDTH - 80*BILI_WIDTH- 60*BILI_WIDTH, 15*BILI_WIDTH)];
        latestNewsLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:13 six:14 sixPlus:16]];
        latestNewsLabel.textColor = [UIColor lightGrayColor];
        latestNewsLabel.textAlignment = NSTextAlignmentLeft;
        latestNewsLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:latestNewsLabel];
        self.latestNewsLabel = latestNewsLabel;
        
        CGFloat countLblHeight = nameLabel.frame.size.height+4*BILI_WIDTH;
        UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 20*BILI_WIDTH - countLblHeight, (cellHeight - countLblHeight) / 2, countLblHeight, countLblHeight)];
        countLabel.font = [UIFont boldSystemFontOfSize:12*BILI_WIDTH];
        countLabel.layer.cornerRadius = countLabel.frame.size.height/2;
        countLabel.layer.masksToBounds = YES;
        countLabel.textColor = [UIColor whiteColor];
        countLabel.backgroundColor = [UIColor redColor];
        countLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:countLabel];
        self.countNewsLabel = countLabel;

//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(80*BILI_WIDTH, cellHeight - 0.5, SCREEN_WIDTH - 80*BILI_WIDTH, 0.5)];
//        line.backgroundColor = UIColor_GrayLine;
//        [self.contentView addSubview:line];
    }
    return self;
}

- (void)drawDataWithIcon:(UIImage *)icon title:(NSString *)title latestNewsTitle:(NSString *)latestTitle countNews:(NSInteger) count
{
    [self.serverCenterIconImageView setImage:icon];
    [self.serverCenterNameLabel setText:title];
    self.latestNewsLabel.text = latestTitle;

    if (count <= 0) {
        self.countNewsLabel.hidden = YES;
    }else {
        self.countNewsLabel.hidden = NO;
        self.countNewsLabel.text = [NSString stringWithFormat:@"%li", (long)count];
        if (count > 99){
            self.countNewsLabel.size = CGSizeMake(_countNewsLabel.frame.size.height+10*BILI_WIDTH, _countNewsLabel.frame.size.height);
        } else {
            self.countNewsLabel.size = CGSizeMake(_countNewsLabel.frame.size.height, _countNewsLabel.frame.size.height);
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
