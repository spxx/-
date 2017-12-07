//
//  BNHomeProjectTableViewCell.m
//  NewWallet
//
//  Created by mac on 16-12-26.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNHomeProjectTableViewCell.h"
#import "UICountingLabel.h"

@interface BNHomeProjectTableViewCell ()
@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *subTitleLabel;
@property (nonatomic) UICountingLabel *moneyLabel;

@property (nonatomic) UILabel *moneyTag;
@property (nonatomic) UILabel *hotTag;

@property (nonatomic) UIImageView *iconImgV;

@end

@implementation BNHomeProjectTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.moneyTag = [[UILabel alloc]initWithFrame:CGRectMake(15*NEW_BILI, 13*NEW_BILI, 15*NEW_BILI, 15*NEW_BILI)];
        _moneyTag.backgroundColor = UIColor_NewIconColor;
        _moneyTag.textColor = [UIColor whiteColor];
        _moneyTag.font = [UIFont boldSystemFontOfSize:10*NEW_BILI];
        _moneyTag.layer.cornerRadius = CGRectGetHeight(_moneyTag.frame)/2;
        _moneyTag.layer.masksToBounds = YES;
        _moneyTag.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_moneyTag];
        _moneyTag.text = @"￥";
        
        self.hotTag = [[UILabel alloc]initWithFrame:CGRectMake(15*NEW_BILI, 13*NEW_BILI, 34*NEW_BILI, 14*NEW_BILI)];
        _hotTag.backgroundColor = UIColorFromRGB(0xff6d6a);    //#ff6d6a HOT的颜色      #ffb770 NEW的颜色
        _hotTag.textColor = [UIColor whiteColor];
        _hotTag.font = [UIFont boldSystemFontOfSize:10*NEW_BILI];
        _hotTag.layer.cornerRadius = CGRectGetHeight(_hotTag.frame)/2;
        _hotTag.layer.masksToBounds = YES;
        _hotTag.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_hotTag];
       
        self.iconImgV = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-(51+45)*NEW_BILI, 32*NEW_BILI, 45*NEW_BILI, 45*NEW_BILI)];
        [self.contentView addSubview:_iconImgV];
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-(51+45)*NEW_BILI, 88*NEW_BILI, 80*NEW_BILI, 14*NEW_BILI)];
        _nameLabel.textColor = UIColorFromRGB(0x474747);
        _nameLabel.font = [UIFont systemFontOfSize:12*NEW_BILI];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_nameLabel];
        _nameLabel.center = CGPointMake(_iconImgV.center.x, _nameLabel.center.y);

        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(25*NEW_BILI, 43*NEW_BILI, 185*NEW_BILI, 36*NEW_BILI)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15*NEW_BILI];
        _titleLabel.textColor = UIColor_NewBlack_Text;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.numberOfLines = 2;
        [self.contentView addSubview:_titleLabel];
        
        self.subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(25*NEW_BILI, 90*NEW_BILI, SCREEN_WIDTH- (25+110)*NEW_BILI, 12*NEW_BILI)];
        _subTitleLabel.textColor = UIColor_NewLightTextColor;
        _subTitleLabel.font = [UIFont systemFontOfSize:11*NEW_BILI];
        [self.contentView addSubview:_subTitleLabel];

        self.moneyLabel = [[UICountingLabel alloc]initWithFrame:CGRectMake(25*NEW_BILI, 40*NEW_BILI, SCREEN_WIDTH- (25+110)*NEW_BILI, 35*NEW_BILI)];
        _moneyLabel.font = [UIFont boldSystemFontOfSize:40*NEW_BILI];
        _moneyLabel.textColor = UIColor_NewBlack_Text;
        _moneyLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_moneyLabel];
        _moneyLabel.format = @"%.2f";
        _moneyLabel.method = UILabelCountingMethodLinear;
        _moneyLabel.text = @"_ _";

        
        _moneyTag.hidden = YES;
        _hotTag.hidden = YES;
        _moneyLabel.hidden = YES;
        _titleLabel.hidden = YES;
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)drawData:(NSDictionary *)dict animation:(BOOL)animation oneCardAmount:(NSString *)oneCardAmount electricAmount:(NSString *)electricAmount
{
    NSString *biz_id = [NSString stringWithFormat:@"%@", [dict valueWithNoDataForKey:@"biz_id"]];
//    [_iconImgV sd_setImageWithURL:[NSURL URLWithString:[dict valueWithNoDataForKey:@"biz_icon_url"]] placeholderImage:nil];
    [_iconImgV sd_setImageWithURL:[NSURL URLWithString:[dict valueWithNoDataForKey:@"biz_icon_url"]] placeholderImage:nil options:SDWebImageRefreshCached];
    _nameLabel.text = [dict valueWithNoDataForKey:@"biz_name"];
    _titleLabel.text = [dict valueWithNoDataForKey:@"biz_title"];
    _subTitleLabel.text = [dict valueWithNoDataForKey:@"biz_subTitle"];
    _hotTag.text = [dict valueWithNoDataForKey:@"biz_label"];


//    _nameLabel.text = @"一卡通";
//    _moneyLabel.text = @"102.34";
//    _titleLabel.text = @"体育场馆会员支持月充值来体验一下吧";
//    _subTitleLabel.text = @"一卡通充值缴费";
//    _hotTag.text = @"HOT";
    
    //一卡通biz_id=18，电费biz_id=5；
    if (biz_id.length <= 0) {
        _hotTag.hidden = YES;
        _moneyTag.hidden = YES;
        _moneyLabel.hidden = YES;
        _titleLabel.hidden = YES;
        
    } else if ([biz_id isEqualToString:@"18"] || [biz_id isEqualToString:@"5"]) {
        _hotTag.hidden = YES;
        _moneyTag.hidden = NO;
        _moneyLabel.hidden = NO;
        _titleLabel.hidden = YES;
        
        if ([biz_id isEqualToString:@"18"]) {
            BNLog(@"oneCardAmount--%@",oneCardAmount);
            BOOL isNumber = [self isPureFloat:oneCardAmount];
            if (isNumber) {
                //是数字，则动画显示金额_moneyLabel
                _moneyLabel.hidden = NO;
                _titleLabel.hidden = YES;
                if (animation) {
                    [_moneyLabel countFrom:0.00 to:oneCardAmount.floatValue withDuration:1.f];
                } else {
                    _moneyLabel.text = oneCardAmount;
                }
            } else {
                //不是数字则显示_titleLabel
                _titleLabel.text = oneCardAmount;
                _moneyLabel.hidden = YES;
                _titleLabel.hidden = NO;
            }
        } else if ([biz_id isEqualToString:@"5"]) {
            BNLog(@"electricAmount--%@",electricAmount);
            BOOL isNumber = [self isPureFloat:electricAmount];
            if (isNumber) {
                //是数字，则动画显示金额_moneyLabel
                _moneyLabel.hidden = NO;
                _titleLabel.hidden = YES;
                if (animation) {
                    [_moneyLabel countFrom:0.00 to:electricAmount.floatValue withDuration:1.f];
                } else {
                    _moneyLabel.text = electricAmount;
                }
            } else {
                //不是数字则显示_titleLabel
                _titleLabel.text = electricAmount;
                _moneyLabel.hidden = YES;
                _titleLabel.hidden = NO;
            }

        }
    } else {
        _hotTag.hidden = NO;
        _moneyTag.hidden = YES;
        _moneyLabel.hidden = YES;
        _titleLabel.hidden = NO;
        if ([_hotTag.text isEqualToString:@"NEW"]) {
            _hotTag.backgroundColor = UIColorFromRGB(0xffb770);    //#ff6d6a HOT的颜色      #ffb770 NEW的颜色
        } else {
            _hotTag.backgroundColor = [UIColor clearColor];    //#ff6d6a HOT的颜色      #ffb770 NEW的颜色
        }
    }
    
}
//浮点形判断
- (BOOL)isPureFloat:(NSString *)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    float val;
    
    return [scan scanFloat:&val] && [scan isAtEnd];
    
}
@end
