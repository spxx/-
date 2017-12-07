//
//  BNServerCardView.m
//  Wallet
//
//  Created by 陈荣雄 on 16/7/8.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "BNServerCardView.h"
#import "Masonry.h"

@interface BNServerCardView ()

@property (strong, nonatomic) UIImageView *backgroundView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *descriptionLabel;
@property (strong, nonatomic) UIView *badgeView;
@property (strong, nonatomic) UILabel *badgeLabel;

@property (strong, nonatomic) NSDictionary *data;

@end

@implementation BNServerCardView

- (instancetype)initWithFrame:(CGRect)frame style:(CardStyle)style
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 3;
        
        [self addSubview:self.backgroundView];
        [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.backgroundView.superview);
        }];
        
        
        [self addSubview:self.titleLabel];
        if (style == CardStyleTitleAndSubtitle) {
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.titleLabel.superview).with.offset(15);
                make.right.equalTo(self.titleLabel.superview).with.offset(0);
                make.bottom.equalTo(self.titleLabel.superview.mas_centerY);
                make.height.greaterThanOrEqualTo(@20);
            }];
        } else {
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.titleLabel.superview).with.offset(0);
                make.right.equalTo(self.titleLabel.superview).with.offset(0);
                make.bottom.equalTo(self.titleLabel.superview);
                make.top.equalTo(self.titleLabel.superview);
            }];
        }
        
        if (style == CardStyleTitleAndSubtitle) {
            [self addSubview:self.descriptionLabel];
            [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.descriptionLabel.superview).with.offset(15);
                make.right.equalTo(self.descriptionLabel.superview).with.offset(0);
                make.top.equalTo(self.titleLabel.superview.mas_centerY);
                make.height.greaterThanOrEqualTo(@20);
            }];
        }
        
        
        [self addSubview:self.badgeView];
        [self.badgeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.badgeView.superview).with.offset(-3);
            make.right.equalTo(self.badgeView.superview).with.offset(3);
            make.width.equalTo(@(25*NEW_BILI));
            make.height.equalTo(@(22*NEW_BILI));
        }];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardTapped:)];
        [self addGestureRecognizer:recognizer];
    }
    return self;
}

- (UIImageView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = UIImageView.new;
    }
    
    return _backgroundView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.new;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"";
    }
    
    return _titleLabel;
}

- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = UILabel.new;
        _descriptionLabel.numberOfLines = 0;
        _descriptionLabel.font = [UIFont systemFontOfSize:13];
        _descriptionLabel.textColor = [UIColor whiteColor];
        _descriptionLabel.text = @"";
    }
    
    return _descriptionLabel;
}

- (UIView *)badgeView {
    if (!_badgeView) {
        _badgeView = UIView.new;
        _badgeView.backgroundColor = [UIColor whiteColor];
        /*_badgeView.layer.borderColor = [UIColor whiteColor].CGColor;
        _badgeView.layer.borderWidth = 3;*/
        _badgeView.layer.cornerRadius = 3;
        _badgeView.clipsToBounds = YES;
        
        [_badgeView addSubview:self.badgeLabel];
        
        [self.badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.left.and.bottom.and.right.equalTo(self.badgeLabel.superview).insets(UIEdgeInsetsMake(3, 3, 3, 3));
        }];
    }
    
    return _badgeView;
}

- (UILabel *)badgeLabel {
    if (!_badgeLabel) {
        _badgeLabel = UILabel.new;
        _badgeLabel.backgroundColor = [UIColor redColor];
        _badgeLabel.font = [UIFont systemFontOfSize:12];
        _badgeLabel.textColor = [UIColor whiteColor];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.text = @"";
    }
    
    return _badgeLabel;
}

- (void)setData:(NSDictionary *)data {
    _data = data;
    
    self.backgroundView.image = [UIImage imageNamed:[data valueNotNullForKey:@"icon"]];
    self.titleLabel.text = [data valueNotNullForKey:@"title"];
    self.descriptionLabel.text = [data valueNotNullForKey:@"latestNewsTitle"];
    NSInteger count = [[data valueNotNullForKey:@"count"] integerValue];
    self.badgeView.hidden = count > 0 ? NO : YES;
    if (count > 0) {
        self.badgeLabel.text = [NSString stringWithFormat:@"%d", count];
        CGFloat width = [Tools getTextWidthWithText:self.badgeLabel.text font:[UIFont systemFontOfSize:12] height:14];
        if (width+10 > 25*NEW_BILI) {
            [self.badgeView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(width+10));
            }];
        }
    }
}

- (void)cardTapped:(UITapGestureRecognizer *)recognizer {
    if (self.delegate) {
        [self.delegate cardSelected:_data];
    }
}

@end
