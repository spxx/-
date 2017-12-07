//
//  BNLivesTableViewCell.m
//  Wallet
//
//  Created by mac on 14-12-31.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNLivesTableViewCell.h"

@interface BNLivesTableViewCell ()

@property (weak, nonatomic) UIImageView *serverCenterIconImageView;

@property (weak, nonatomic) UILabel *serverCenterNameLabel;

@property (weak, nonatomic) UIView *lineView;
@property (weak, nonatomic) UIView *redCircleView;

@end
@implementation BNLivesTableViewCell

static NSInteger cellHeight;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    cellHeight = 50*BILI_WIDTH;
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];

        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake((50-18)/2*BILI_WIDTH, (cellHeight - 18*BILI_WIDTH) / 2, 18*BILI_WIDTH, 18*BILI_WIDTH)];
        [self.contentView addSubview:icon];
        self.serverCenterIconImageView = icon;
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50*BILI_WIDTH, (cellHeight - 24) / 2, SCREEN_WIDTH - 50*BILI_WIDTH, 24)];
        nameLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:16 sixPlus:18]];
        nameLabel.textColor = UIColor_BlackBlue_Text;
        nameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:nameLabel];
        self.serverCenterNameLabel = nameLabel;
        
        UIImageView *arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 26, (cellHeight - 16)/2, 16, 16)];
        arrowImg.backgroundColor = [UIColor clearColor];
        [arrowImg setImage:[UIImage imageNamed:@"right_arrow"]];
        [self.contentView addSubview:arrowImg];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(50*BILI_WIDTH, cellHeight - 0.5, SCREEN_WIDTH - 50*BILI_WIDTH, 0.5)];
        line.backgroundColor = UIColor_GrayLine;
        [self.contentView addSubview:line];
        self.lineView = line;
        
        UIView *circalView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 40 * BILI_WIDTH, 21 * BILI_WIDTH, 8 * BILI_WIDTH, 8 * BILI_WIDTH)];
        circalView.backgroundColor = [UIColor colorWithRed:220/255.0 green:91/255.0 blue:96/255.0 alpha:1.f];
        circalView.layer.cornerRadius = CGRectGetWidth(circalView.bounds)/2.0;
        circalView.layer.masksToBounds = YES;
        circalView.hidden = YES;
        [self.contentView addSubview:circalView];
        self.redCircleView = circalView;
    }
    return self;
}

- (void)drawDataWithType:(LivesType)livesType isLastLine:(BOOL)isLast
{
    switch (livesType) {
        case LivesTypeMobileRecharge: {
            self.serverCenterNameLabel.text = @"手机充值";
            self.serverCenterIconImageView.image = [UIImage imageNamed:@"Lives_Mobile_Cell_Icon"];
            break;
        }
        case LivesTypeContribute: {
            self.serverCenterNameLabel.text = @"爱心捐助";
            self.serverCenterIconImageView.image = [UIImage imageNamed:@"Lives_contribute_icon"];
            break;
        }
        case LivesTypePaySchoolFees:
        {
            self.serverCenterNameLabel.text = @"教育缴费";
            self.serverCenterIconImageView.image = [UIImage imageNamed:@"submit_fee_img"];
            break;
        }
        case LivesTypeXiaoDai:
        {
            self.serverCenterNameLabel.text = @"嘻哈贷";
            self.serverCenterIconImageView.image = [UIImage imageNamed:@"XiaoDai_HeadIcon"];
            break;
        }
        case LivesTypeDianFei:
        {
            self.serverCenterNameLabel.text = @"电费充值";
            self.serverCenterIconImageView.image = [UIImage imageNamed:@"livesElectric"];
            break;
        }
        case LivesTypeCollectFees:
        {
            self.serverCenterNameLabel.text = @"费用领取";
            self.serverCenterIconImageView.image = [UIImage imageNamed:@"collect_fees_icon"];
            break;
        }

    }
    //修改底部分割线的宽
    if (isLast) {
        _lineView.frame = CGRectMake(0, cellHeight - 1, SCREEN_WIDTH, 1);
        _lineView.backgroundColor = UIColorFromRGB(0xcfcfcf);
    }else{
        _lineView.frame = CGRectMake(50*BILI_WIDTH, cellHeight - 0.5, SCREEN_WIDTH - 50*BILI_WIDTH, 0.5);
        _lineView.backgroundColor = UIColor_GrayLine;
    }
    

}

- (void)drawDataWithType:(LivesType)livesType isLastLine:(BOOL)isLast isHasNotCollectFees:(BOOL)hasNotCollectFees
{
    [self drawDataWithType:livesType isLastLine:isLast];
    if(hasNotCollectFees)
    {
        self.redCircleView.hidden = NO;
    }
    else
    {
        self.redCircleView.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
