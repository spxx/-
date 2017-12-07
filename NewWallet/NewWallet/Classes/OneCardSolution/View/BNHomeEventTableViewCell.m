//
//  BNHomeEventTableViewCell.m
//  NewWallet
//
//  Created by mac on 16-12-26.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNHomeEventTableViewCell.h"

@interface BNHomeEventTableViewCell ()
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *subTitleLabel;
@property (nonatomic) UILabel *timeLabel;

@property (nonatomic) UILabel *NEWTag;

@property (nonatomic) UIImageView *iconImgV;

@end

@implementation BNHomeEventTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(23*NEW_BILI, 31*NEW_BILI, 180*NEW_BILI, 17*NEW_BILI)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15*NEW_BILI];
        _titleLabel.textColor = UIColor_NewBlack_Text;
        [self.contentView addSubview:_titleLabel];

        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(23*NEW_BILI, 54*NEW_BILI, 180*NEW_BILI, 14*NEW_BILI)];
        _timeLabel.textColor = UIColor_NewLightTextColor;
        _timeLabel.font = [UIFont systemFontOfSize:12*NEW_BILI];
        [self.contentView addSubview:_timeLabel];
        
        self.subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(23*NEW_BILI, 85*NEW_BILI, SCREEN_WIDTH- (23+15)*NEW_BILI, 33*NEW_BILI)];
        _subTitleLabel.textColor = UIColor_NewLightTextColor;
        _subTitleLabel.font = [UIFont systemFontOfSize:13*NEW_BILI];
        _subTitleLabel.numberOfLines = 2;
        [self.contentView addSubview:_subTitleLabel];


        self.NEWTag = [[UILabel alloc]initWithFrame:CGRectMake(125*NEW_BILI, 32*NEW_BILI, 34*NEW_BILI, 14*NEW_BILI)];
        _NEWTag.backgroundColor = UIColorFromRGB(0xffb770);
        _NEWTag.textColor = [UIColor whiteColor];
        _NEWTag.font = [UIFont boldSystemFontOfSize:10*NEW_BILI];
        _NEWTag.layer.cornerRadius = CGRectGetHeight(_NEWTag.frame)/2;
        _NEWTag.layer.masksToBounds = YES;
        _NEWTag.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_NEWTag];
        _NEWTag.text = @"NEW";
        //        _NEWTag.hidden = YES;
        
        
        self.iconImgV = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-(51+45)*NEW_BILI, 32*NEW_BILI, 45*NEW_BILI, 45*NEW_BILI)];
        [self.contentView addSubview:_iconImgV];
        
        
        
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)drawMessageData:(BNHomeMessageModel *)model
{
//    [_iconImgV sd_setImageWithURL:[NSURL URLWithString:[dict valueWithNoDataForKey:@"biz_icon_url"]] placeholderImage:nil];
//    _nameLabel.text = [dict valueWithNoDataForKey:@"biz_name"];
//    _moneyLabel.text = [dict valueWithNoDataForKey:@"biz_title"];
//    _titleLabel.text = [dict valueWithNoDataForKey:@"biz_title"];
//    _subTitleLabel.text = [dict valueWithNoDataForKey:@"biz_subTitle"];
//    _NEWTag.text = [dict valueWithNoDataForKey:@"biz_label"];
//    
    CGFloat titleLblWidth = [Tools getTextWidthWithText:model.title font:_titleLabel.font height:_titleLabel.frame.size.height];
    _titleLabel.frame = CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y, titleLblWidth, _titleLabel.frame.size.height);
    _NEWTag.frame = CGRectMake(_titleLabel.frame.origin.x+titleLblWidth+11*NEW_BILI, _NEWTag.frame.origin.y, _NEWTag.frame.size.width, _NEWTag.frame.size.height);
    _timeLabel.text = model.time;
    _titleLabel.text = model.title;
    _subTitleLabel.text = model.subTitle;
    _NEWTag.text = @"NEW";
    
    _iconImgV.image = [UIImage imageNamed:model.icon];
    
    _NEWTag.hidden = (model.count <= 0);
}

@end
