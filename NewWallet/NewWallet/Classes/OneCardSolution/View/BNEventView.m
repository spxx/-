//
//  BNEventView.m
//  Wallet
//
//  Created by 陈荣雄 on 16/7/1.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "BNEventView.h"
#import "Masonry.h"

@interface BNEventView ()

@property (strong, nonatomic) UIImageView *iconView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UILabel *descriptionLabel;

@property (strong, nonatomic) id data;

@end

@implementation BNEventView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.iconView];
        
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconView.superview.mas_top).with.offset(20);
            make.left.equalTo(self.iconView.superview.mas_left).with.offset(20);
            make.width.equalTo(@60);
            make.height.equalTo(@60);
        }];
        
        [self addSubview:self.titleLabel];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.superview.mas_top).with.offset(20);
            make.left.equalTo(self.iconView.mas_right).with.offset(20);
            make.right.equalTo(self.titleLabel.superview.mas_right).with.offset(-10);
            make.height.equalTo(@18);
        }];
        
        [self addSubview:self.dateLabel];
        
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom);
            make.left.equalTo(self.iconView.mas_right).with.offset(20);
            make.right.equalTo(self.dateLabel.superview.mas_right).with.offset(-10);
            make.height.equalTo(@15);
        }];
        
        [self addSubview:self.descriptionLabel];
        
        [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconView.mas_right).with.offset(20);
            make.right.equalTo(self.descriptionLabel.superview.mas_right).with.offset(-10);
            make.bottom.equalTo(self.descriptionLabel.superview.mas_bottom).with.offset(-20);
            make.height.equalTo(@20);
        }];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(eventTapped:)];
        [self addGestureRecognizer:recognizer];
    }
    return self;
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
        _descriptionLabel = UILabel.new;
        _descriptionLabel.font = [UIFont systemFontOfSize:13];
        _descriptionLabel.textColor = [UIColor colorWithRed:0.49 green:0.58 blue:0.62 alpha:1.00];
        _descriptionLabel.text = @"";
    }
    
    return _descriptionLabel;
}

- (void)setData:(id)data {
    _data = data;

    NSString *iconURL = [data valueNotNullForKey:@"biz_icon_url"];
    if ([iconURL hasPrefix:@"http"]) {
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:iconURL] placeholderImage:[UIImage imageNamed:@"event_list_placeholder"]];
    }
    self.titleLabel.text = data[@"event_name"];
    self.dateLabel.text = data[@"push_time"];
    self.descriptionLabel.text = data[@"describe"];
}

- (void)eventTapped:(UITapGestureRecognizer *)recognizer {
    if (self.delegate) {
        [self.delegate eventSelected:_data];
    }
}

@end
