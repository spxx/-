//
//  TraineeHomeHeaderView.m
//  Wallet
//
//  Created by mac1 on 15/12/21.
//  Copyright © 2015年 BNDK. All rights reserved.
//
#import "TraineeHomeHeaderView.h"

@interface TraineeHomeHeaderView ()

@property (weak, nonatomic) UIImageView *levelImageView;
@property (weak, nonatomic) UILabel *nameLabel;
@property (weak, nonatomic) UILabel *joinDaysLabel;
@property (weak, nonatomic) UILabel *valueLabel;


@end

@implementation TraineeHomeHeaderView


- (instancetype)initWithFrame:(CGRect)frame name:(NSString *)name joinDays:(NSString *)daysCount empiricalValue:(NSString *)value level:(NSString *)level
{
    if (self = [super initWithFrame:frame]) {
        self.name = name;
        self.daysCount = daysCount;
        self.value = value;
        self.level = level;
        [self setupSubViews];
    }
    
    return self;
}


- (void)setupSubViews
{

    UIImageView *levelBGImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 69 * NEW_BILI)/2.0, 23 * NEW_BILI, 69 * NEW_BILI, 69 * NEW_BILI)];
    levelBGImageView.image = [UIImage imageNamed:@"topCircle"];
    [self addSubview:levelBGImageView];
    
    UIImageView *levelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 37 * NEW_BILI, 21 * NEW_BILI)];
    levelImageView.center = levelBGImageView.center;
    levelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"whiteLV%@",self.level]];
    [self addSubview:levelImageView];
    _levelImageView = levelImageView;
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100*NEW_BILI)/2.0, CGRectGetMaxY(levelBGImageView.frame) + 17 * NEW_BILI, 100 * NEW_BILI, 20 * NEW_BILI)];
    nameLabel.text = _name;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont systemFontOfSize:18*NEW_BILI];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:nameLabel];
    _nameLabel = nameLabel;
    
    NSString *daysCountStr = [NSString stringWithFormat:@"加入天数\n%@",_daysCount];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:daysCountStr];
    [attStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13 * NEW_BILI]} range:NSMakeRange(0, 4)];
    [attStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12 * NEW_BILI]} range:NSMakeRange(4, daysCountStr.length - 4)];
    UILabel *joinDaysLabel = [[UILabel alloc] initWithFrame:CGRectMake(18 * NEW_BILI, CGRectGetMinY(nameLabel.frame), 60 * NEW_BILI, attStr.size.height)];
    joinDaysLabel.numberOfLines = 0;
    joinDaysLabel.lineBreakMode = NSLineBreakByWordWrapping;
    joinDaysLabel.textAlignment = NSTextAlignmentCenter;
    joinDaysLabel.textColor = [UIColor whiteColor];
    joinDaysLabel.attributedText = attStr;
    [self addSubview:joinDaysLabel];
    _joinDaysLabel = joinDaysLabel;
    
    NSString *valueStr = [NSString stringWithFormat:@"总经验值\n%@",_value];
    NSMutableAttributedString *valueAttStr = [[NSMutableAttributedString alloc] initWithString:valueStr];
    [valueAttStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13 * NEW_BILI]} range:NSMakeRange(0, 4)];
    [valueAttStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12 * NEW_BILI]} range:NSMakeRange(4, valueStr.length - 4)];
    UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 78*NEW_BILI, CGRectGetMinY(joinDaysLabel.frame), 60 * NEW_BILI, valueAttStr.size.height)];
    valueLabel.numberOfLines = 0;
    valueLabel.lineBreakMode = NSLineBreakByWordWrapping;
    valueLabel.textAlignment = NSTextAlignmentCenter;
    valueLabel.textColor = [UIColor whiteColor];
    valueLabel.attributedText = valueAttStr;
    [self addSubview:valueLabel];
    _valueLabel = valueLabel;

}

- (void)setName:(NSString *)name
{
    _name = name;
    _nameLabel.text = name;
}

- (void)setDaysCount:(NSString *)daysCount
{
    _daysCount = daysCount;
    NSString *daysCountStr = [NSString stringWithFormat:@"加入天数\n%@",daysCount];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:daysCountStr];
    [attStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13 * NEW_BILI]} range:NSMakeRange(0, 4)];
    [attStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12 * NEW_BILI]} range:NSMakeRange(4, daysCountStr.length - 4)];
    _joinDaysLabel.attributedText = attStr;
}

- (void)setValue:(NSString *)value
{
    _value = value;
    NSString *valueStr = [NSString stringWithFormat:@"总经验值\n%@",_value];
    NSMutableAttributedString *valueAttStr = [[NSMutableAttributedString alloc] initWithString:valueStr];
    [valueAttStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13 * NEW_BILI]} range:NSMakeRange(0, 4)];
    [valueAttStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12 * NEW_BILI]} range:NSMakeRange(4, valueStr.length - 4)];
    _valueLabel.attributedText = valueAttStr;
}

- (void)setLevel:(NSString *)level
{
    _level = level;
    _levelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"whiteLV%@",level]];
}

@end
