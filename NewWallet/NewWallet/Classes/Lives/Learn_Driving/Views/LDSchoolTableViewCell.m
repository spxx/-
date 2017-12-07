//
//  LDSchoolTableViewCell.m
//  Wallet
//
//  Created by mac1 on 16/5/31.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "LDSchoolTableViewCell.h"
#import "LDCenterLineLabel.h"

@interface LDSchoolTableViewCell ()

@property (nonatomic, weak) UIImageView *iconImageView;
@property (nonatomic, weak) UILabel *schoolNameLable;
@property (nonatomic, weak) UILabel *priceLable;
@property (nonatomic, weak) UIButton *signUpBtn;
@property (nonatomic, weak) UIButton *latelyLocation;
@property (nonatomic, weak) UILabel *firstPayLabel; //首付
@property (nonatomic, weak) LDCenterLineLabel *marketPriceLabel;

@end

@implementation LDSchoolTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createCellSubViews];
    }
    
    return  self;
}

- (void)createCellSubViews
{
 
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15 * NEW_BILI, 26.5 * NEW_BILI, 70 * NEW_BILI, 70 * NEW_BILI)];
    imageView.image = [UIImage imageNamed:@"loc1"];
    [self.contentView addSubview:imageView];
    _iconImageView = imageView;
    
    UILabel *schoolNameLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 15 * NEW_BILI, CGRectGetMinY(imageView.frame),150, 20 * NEW_BILI)];
    schoolNameLable.text = @"成都泰来驾校";
    schoolNameLable.font = [UIFont systemFontOfSize:14 * NEW_BILI];
    schoolNameLable.textColor = [UIColor blackColor];
    [self.contentView addSubview:schoolNameLable];
    _schoolNameLable = schoolNameLable;
    
    UILabel *priceLable = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 142*NEW_BILI, CGRectGetMinY(schoolNameLable.frame), 120 * NEW_BILI, CGRectGetHeight(schoolNameLable.frame))];
    priceLable.text = @"¥ 3860";
    priceLable.font = [UIFont boldSystemFontOfSize:15 * NEW_BILI];
    priceLable.textColor = [UIColor redColor];
    priceLable.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:priceLable];
    _priceLable = priceLable;
    
    UIColor *temColor = BNColorRGB(155, 174, 183);
    UIButton *signUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    signUpBtn.frame = CGRectMake(CGRectGetMinX(schoolNameLable.frame), CGRectGetMaxY(schoolNameLable.frame) + 10 * NEW_BILI, 100 * NEW_BILI, 15 * NEW_BILI);
    signUpBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    signUpBtn.titleLabel.font = [UIFont systemFontOfSize:12 * NEW_BILI];
    [signUpBtn setImage:[UIImage imageNamed:@"ld_main_applyNum"] forState:UIControlStateNormal];
    [signUpBtn setTitle:@"已报名50人" forState:UIControlStateNormal];
    [signUpBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [signUpBtn setTitleColor:temColor forState:UIControlStateNormal];
    signUpBtn.userInteractionEnabled = NO;
    [self.contentView addSubview:signUpBtn];
    _signUpBtn = signUpBtn;
    
    UILabel *shouFu = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 122 * NEW_BILI, CGRectGetMinY(signUpBtn.frame), 100 * NEW_BILI, 15 * NEW_BILI)];
    shouFu.text = @"可首付 ¥1250";
    shouFu.textColor = temColor;
    shouFu.textAlignment = NSTextAlignmentRight;
    shouFu.font = [UIFont systemFontOfSize:12 * NEW_BILI];
    [self.contentView addSubview:shouFu];
    _firstPayLabel = shouFu;
    
    UIButton *latelyLocation = [UIButton buttonWithType:UIButtonTypeCustom];
    latelyLocation.frame = CGRectMake(CGRectGetMinX(schoolNameLable.frame), CGRectGetMaxY(signUpBtn.frame) + 10 * NEW_BILI, 200 * NEW_BILI, 15 * NEW_BILI);
    latelyLocation.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    latelyLocation.titleLabel.font = [UIFont systemFontOfSize:12 * NEW_BILI];
    [latelyLocation setImage:[UIImage imageNamed:@"ld_main_location"] forState:UIControlStateNormal];
    [latelyLocation setTitle:@"最近场地3.0km 郫县" forState:UIControlStateNormal];
    [latelyLocation setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [latelyLocation setTitleColor:temColor forState:UIControlStateNormal];
    latelyLocation.userInteractionEnabled = NO;
    [self.contentView addSubview:latelyLocation];
    _latelyLocation = latelyLocation;
    
    LDCenterLineLabel *marketPriceLabel = [[LDCenterLineLabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 222 * NEW_BILI, CGRectGetMinY(latelyLocation.frame), 200 * NEW_BILI, 15 * NEW_BILI)];
    marketPriceLabel.text = @"市场价 ¥4000";
    marketPriceLabel.textColor = temColor;
    marketPriceLabel.textAlignment = NSTextAlignmentRight;
    marketPriceLabel.font = [UIFont systemFontOfSize:12 * NEW_BILI];
    [self.contentView addSubview:marketPriceLabel];
    _marketPriceLabel = marketPriceLabel;
    
}

- (void)setModel:(DrivingSchoolModel *)model
{
    _model = model;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.driving_school_logo]];
    _schoolNameLable.text = model.driving_school_name;
    _priceLable.text = [NSString stringWithFormat:@"¥ %@",model.default_total_amount];
    NSString *text1 = [NSString stringWithFormat:@"已报名%@人",model.apply_amount];
    [_signUpBtn setTitle:text1 forState:UIControlStateNormal];
    _firstPayLabel.text = [NSString stringWithFormat:@"可首付 ¥%@",model.first_amount];
    NSString *text2 = [NSString stringWithFormat:@"最近场地%@ %@",model.nearest_train_distance,model.nearest_train_area_name];
    [_latelyLocation setTitle:text2 forState:UIControlStateNormal];
    _marketPriceLabel.text = [NSString stringWithFormat:@"市场价 ¥%@",model.market_amount];
    CGFloat marketLabelWidth = [Tools getTextWidthWithText:_marketPriceLabel.text font:[UIFont systemFontOfSize:12 * NEW_BILI] height:15 * NEW_BILI];
    
    //重写设置label的位置
    _marketPriceLabel.widthValue = ceilf(marketLabelWidth);
    _marketPriceLabel.leftValue = SCREEN_WIDTH - ceilf(marketLabelWidth) - 22 * NEW_BILI;
    
    //计算需要划线的文字宽度
    CGFloat centerLineTextLength = [Tools getTextWidthWithText:[NSString stringWithFormat:@"¥%@",model.market_amount] font:[UIFont systemFontOfSize:12 * NEW_BILI] height:15 * NEW_BILI];
    //开始划线
    [_marketPriceLabel setCenterLineStartX:marketLabelWidth - centerLineTextLength width:centerLineTextLength];
    
}


@end
