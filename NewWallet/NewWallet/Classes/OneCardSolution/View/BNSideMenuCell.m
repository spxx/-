//
//  BNSideMenuCell.m
//  Wallet
//
//  Created by 陈荣雄 on 2016/12/23.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "BNSideMenuCell.h"
#import "Masonry.h"

@interface BNSideMenuCell ()

@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UILabel *badgeLabel;
@property (weak, nonatomic) UIImageView *iconImageView;

@end

@implementation BNSideMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = [UIColor string2Color:@"#37474f"];
        titleLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel.superview).offset(31);
            make.top.equalTo(titleLabel.superview);
            make.bottom.equalTo(titleLabel.superview);
            make.width.equalTo(@100);
        }];
        
        UILabel *badgeLabel = [[UILabel alloc] init];
        badgeLabel.textAlignment = NSTextAlignmentCenter;
        badgeLabel.backgroundColor = UIColorFromRGB(0xffb770);
        badgeLabel.textColor = [UIColor whiteColor];
        badgeLabel.font = [UIFont systemFontOfSize:12];
        badgeLabel.text = @"NEW";
        badgeLabel.layer.cornerRadius = 8;
        badgeLabel.clipsToBounds = YES;
        [self.contentView addSubview:badgeLabel];
        self.badgeLabel = badgeLabel;
        
        [badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel.mas_right);
            make.centerY.equalTo(titleLabel);
            make.width.equalTo(@40);
            make.height.equalTo(@16);
        }];
        
        
        UIImageView *iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconImageView];
        self.iconImageView = iconImageView;
        
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(iconImageView.superview).offset(-26);
            make.width.equalTo(@45);
            make.height.equalTo(@45);
            make.centerY.equalTo(iconImageView.superview);
        }];
        
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = UIColor_GrayLine;
        [self.contentView addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(line.superview).offset(31);
            make.right.equalTo(line.superview).offset(-14);
            make.bottom.equalTo(line.superview);
            make.height.equalTo(@1);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(NSDictionary *)data {
    NSString *title = [data valueWithNoDataForKey:@"biz_name"];
    self.titleLabel.text = title;
    CGFloat titleWidth = [Tools getTextWidthWithText:title font:[UIFont systemFontOfSize:16] height:16];
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(titleWidth+6));
    }];
    
    NSString *badge = [data valueWithNoDataForKey:@"biz_label"];
    if ([badge isEqualToString:@"NEW"]) {
        self.badgeLabel.backgroundColor = UIColorFromRGB(0xffb770);
    } else {
        self.badgeLabel.backgroundColor = UIColorFromRGB(0xff6d6a);
    }
    if (badge.length > 0) {
        self.badgeLabel.hidden = NO;
        self.badgeLabel.text = [data valueWithNoDataForKey:@"biz_label"];
    } else {
        self.badgeLabel.hidden = YES;
    }

    NSString *iconURL = [data valueForKey:@"biz_icon_url"];
    if (iconURL.length > 0) {
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:iconURL]];
    }
}

@end
