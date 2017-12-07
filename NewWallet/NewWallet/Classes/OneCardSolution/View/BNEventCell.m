//
//  BNEventCell.m
//  Wallet
//
//  Created by 陈荣雄 on 16/7/4.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "BNEventCell.h"
#import "ExpandButton.h"
#import "Masonry.h"

@interface BNEventCell ()

@property (strong, nonatomic) UILabel *dateTitleLabel;
@property (strong, nonatomic) UIImageView *iconView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UILabel *descriptionLabel;
@property (weak, nonatomic) ExpandButton *checkButton;

@end

@implementation BNEventCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier {
    self = [super initWithStyle:style reuseIdentifier:identifier];
    if (self) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        self.contentView.backgroundColor = UIColor_Gray_BG;
        
        UIView *bgView = UIView.new;
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = 5;
        [self.contentView addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bgView.superview).with.offset(8);
            make.left.equalTo(bgView.superview).with.offset(8);
            make.bottom.equalTo(bgView.superview);
            make.right.equalTo(bgView.superview).with.offset(-8);
        }];
        
        
        [bgView addSubview:self.dateTitleLabel];
        [self.dateTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dateTitleLabel.superview);
            make.left.equalTo(self.dateTitleLabel.superview).with.offset(10);
            make.right.equalTo(self.dateTitleLabel.superview).with.offset(-10);
            make.height.equalTo(@44);
        }];
        
        
        ExpandButton *checkButton = ExpandButton.new;
        [checkButton setImage:[UIImage imageNamed:@"event_check"] forState:UIControlStateNormal];
        [checkButton addTarget:self action:@selector(checkTapped:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:checkButton];
        self.checkButton = checkButton;
        [checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(checkButton.superview).with.offset(0);
            make.right.equalTo(checkButton.superview).with.offset(0);
            make.width.and.height.equalTo(@44);
        }];
        
        
        UIView *line = UIView.new;
        line.backgroundColor = UIColor_GrayLine;
        [bgView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.superview).with.offset(44);
            make.left.equalTo(line.superview).with.offset(10);
            make.right.equalTo(line.superview).with.offset(-10);
            make.height.equalTo(@0.5);
        }];
        
        
        [bgView addSubview:self.iconView];
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom).with.offset(20);
            make.left.equalTo(self.iconView.superview).with.offset(10);
            make.width.equalTo(@60);
            make.height.equalTo(@60);
        }];
        
        
        [bgView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_top).with.offset(20);
            make.left.equalTo(self.iconView.mas_right).with.offset(10);
            make.right.equalTo(self.titleLabel.superview.mas_right).with.offset(-10);
            make.height.equalTo(@20);
        }];
        
        
        [bgView addSubview:self.dateLabel];
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom);
            make.left.equalTo(self.iconView.mas_right).with.offset(10);
            make.right.equalTo(self.dateLabel.superview.mas_right).with.offset(-10);
            make.height.equalTo(@16);
        }];
        
        
        [bgView addSubview:self.descriptionLabel];
        [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dateLabel.mas_bottom).with.offset(5);
            make.left.equalTo(self.iconView.mas_right).with.offset(10);
            make.right.equalTo(bgView.mas_right).with.offset(-10);
            make.bottom.equalTo(bgView.mas_bottom).with.offset(-20);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel *)dateTitleLabel {
    if (!_dateTitleLabel) {
        _dateTitleLabel = UILabel.new;
        _dateTitleLabel.font = [UIFont systemFontOfSize:14];
        _dateTitleLabel.textColor = [UIColor colorWithRed:0.49 green:0.58 blue:0.62 alpha:1.00];
        _dateTitleLabel.text = @"";
    }
    
    return _dateTitleLabel;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = UIImageView.new;
        _iconView.image = [UIImage imageNamed:@"event_list_placeholder"];
    }
    
    return _iconView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.new;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.text = @"";
        _titleLabel.textColor = [UIColor colorWithRed:0.11 green:0.15 blue:0.16 alpha:1.00];
    }
    
    return _titleLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = UILabel.new;
        _dateLabel.font = [UIFont systemFontOfSize:12];
        _dateLabel.textColor = [UIColor colorWithRed:0.49 green:0.58 blue:0.62 alpha:1.00];
        _dateLabel.text = @"";
    }
    
    return _dateLabel;
}

- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _descriptionLabel.numberOfLines = 0;
        _descriptionLabel.font = [UIFont systemFontOfSize:13];
        _descriptionLabel.textColor = [UIColor colorWithRed:0.49 green:0.58 blue:0.62 alpha:1.00];
        _descriptionLabel.text = @"";
    }
    
    return _descriptionLabel;
}

- (void)setData:(id)data {
    _data = data;
    
    if ([[data objectForKey:@"app_type"] integerValue]) {
        self.descriptionLabel.numberOfLines = 3;
    } else {
        self.descriptionLabel.numberOfLines = 0;
    }
    
    NSString *iconURL = [data valueNotNullForKey:@"biz_icon_url"];
    if ([iconURL hasPrefix:@"http"]) {
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:iconURL] placeholderImage:[UIImage imageNamed:@"event_list_placeholder"]];
    }
    self.titleLabel.text = data[@"event_name"];
    self.dateTitleLabel.text = data[@"push_time"];
    self.dateLabel.text = data[@"push_time"];
    self.descriptionLabel.text = data[@"describe"];
}

- (void)setCheckMode:(BOOL)mode {
    self.checkButton.hidden = !mode;
}

- (void)checkTapped:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate eventCheck:_data];
    }
}

@end
