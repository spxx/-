//
//  DiscoverMainCell.m
//  Wallet
//
//  Created by mac1 on 16/7/11.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "DiscoverMainCell.h"

@interface DiscoverMainCell ()

@property (nonatomic, weak) UIImageView *theImageView;

@end

@implementation DiscoverMainCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *blackView = [[UIView alloc] init];
        blackView.backgroundColor = UIColor_Gray_BG;
        [self.contentView addSubview:blackView];
        
        UIImageView *theImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:theImageView];
        _theImageView = theImageView;
        
        [blackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(154);
        }];
        
        [theImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(blackView.mas_top).with.offset(13);
            make.left.mas_equalTo(13);
            make.right.mas_equalTo(-13);
            make.height.mas_equalTo(141);
            
        }];
    }
    
    return self;
}

- (void)setData:(NSDictionary *)data
{
    _data = data;
    [_theImageView sd_setImageWithURL:[NSURL URLWithString:[data valueNotNullForKey:@"privilege_image"]]];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
}

@end
