//
//  LDClassCell.m
//  Wallet
//
//  Created by mac1 on 16/6/1.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "LDClassCell.h"

@interface LDClassCell ()

@property (nonatomic, weak) UILabel *className;
@property (nonatomic, weak) UILabel *descriptionLabel;
@property (nonatomic, weak) UILabel *price;
@property (nonatomic, weak) UILabel *firstPay;

@property (nonatomic, weak) UIButton *applyBtn;


@end

@implementation LDClassCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createCellSubViews];
    }
    
    return  self;
}


- (void)createCellSubViews
{
    UILabel *className =  [[UILabel alloc] initWithFrame:CGRectMake(15 * NEW_BILI,16 * NEW_BILI,250 * NEW_BILI, 20 * NEW_BILI)];
    className.text = @"C1型驾照（手动挡）培训班";
    className.font = [UIFont systemFontOfSize:14 * NEW_BILI];
    className.textColor = [UIColor blackColor];
    [self.contentView addSubview:className];
    _className = className;
    
    UILabel *description = [[UILabel alloc] initWithFrame:CGRectMake(15 * NEW_BILI,CGRectGetMaxY(className.frame) + 10 * NEW_BILI,SCREEN_WIDTH - 30 * NEW_BILI, 12 * NEW_BILI)];
    description.text = @"一人一车一教练 教练接送 一周七天 指定场地";
    description.font = [UIFont systemFontOfSize:12 * NEW_BILI];
    description.textColor = BNColorRGB(155, 174, 183);
    description.numberOfLines = 0;
    [self.contentView addSubview:description];
    _descriptionLabel = description;
    
    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(15 * NEW_BILI,CGRectGetMaxY(description.frame) + 14 * NEW_BILI,150, 16 * NEW_BILI)];
    price.text = @"¥ 3860.00";
    price.font = [UIFont systemFontOfSize:12 * NEW_BILI];
    [price sizeToFit];
    price.textColor = [UIColor redColor];
    [self.contentView addSubview:price];
    _price = price;

    UILabel *firstPay = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(price.frame) + 12 * NEW_BILI,0,110 * NEW_BILI, 20 * NEW_BILI)];
    CGPoint centerPayLabel = firstPay.center;
    centerPayLabel.y = price.center.y;
    firstPay.center = centerPayLabel;
    firstPay.text = @"可首付1250元";
    firstPay.textAlignment = NSTextAlignmentCenter;
    firstPay.font = [UIFont systemFontOfSize:12 * NEW_BILI];
    firstPay.layer.cornerRadius = 2;
    firstPay.layer.borderColor = [UIColor redColor].CGColor;
    firstPay.layer.borderWidth = 0.5;
    firstPay.textColor = [UIColor redColor];
    [self.contentView addSubview:firstPay];
    _firstPay = firstPay;
    
    UIButton *applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    applyBtn.frame = CGRectMake(SCREEN_WIDTH - 95 * NEW_BILI, CGRectGetMaxY(description.frame) + 8 * NEW_BILI, 80 * NEW_BILI, 23 * NEW_BILI);
    applyBtn.userInteractionEnabled = NO;
    applyBtn.titleLabel.font = [UIFont systemFontOfSize:12 * NEW_BILI];
    applyBtn.layer.cornerRadius = 2;
    [applyBtn setTitle:@"现在报名" forState:UIControlStateNormal];
    applyBtn.backgroundColor = UIColor_Button_Normal;
    [applyBtn addTarget: self action:@selector(applyBtnAcion:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:applyBtn];
    _applyBtn = applyBtn;
}

- (void)setModel:(DrivingClass *)model
{
    _model = model;
    _className.text = model.class_name;
    _descriptionLabel.text = model.class_desc;
    [_descriptionLabel sizeToFit];
   
    _price.topValue = CGRectGetMaxY(_descriptionLabel.frame) + 14 * NEW_BILI;
    _price.text = [NSString stringWithFormat:@"¥ %@",model.class_total_fee];
    [_price sizeToFit];
    
    _firstPay.hidden = ![model.support_installment  isEqual: @"1"];
    _firstPay.text = [NSString stringWithFormat:@"可首付%@元",model.first_pay_fee];
    _firstPay.centerYValue = _price.centerYValue;

    _applyBtn.tag = model.classId;
    _applyBtn.topValue =  CGRectGetMaxY(_descriptionLabel.frame) + 8 * NEW_BILI;
    
}


//现在不走代理了
- (void)applyBtnAcion:(UIButton *)btn
{
    //友盟事件点击
    [MobClick event:@"LearnDrive_ApplyNow"];
    
    if ([self.delegate respondsToSelector:@selector(applyButtonClick:)]) {
        [self.delegate applyButtonClick:btn];
    }
}

@end
