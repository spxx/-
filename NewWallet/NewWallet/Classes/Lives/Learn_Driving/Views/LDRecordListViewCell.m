//
//  LDRecordListViewCell.m
//  Wallet
//
//  Created by 陈荣雄 on 16/6/3.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "LDRecordListViewCell.h"

@interface LDRecordListViewCell ()

@property (weak, nonatomic) UIView *bgView;
@property (weak, nonatomic) UIImageView *thumbnailView;
@property (weak, nonatomic) UILabel *schoolNameLabel;
@property (weak, nonatomic) UILabel *userNameLabel;
@property (weak, nonatomic) UILabel *classNameLabel;
@property (weak, nonatomic) UILabel *totalFeeLabel;
@property (weak, nonatomic) UILabel *timeLabel;
@property (weak, nonatomic) UILabel *installmentLabel;

@end

@implementation LDRecordListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier {
    self = [super initWithStyle:style reuseIdentifier:identifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, self.contentView.widthValue, self.contentView.heightValue-10)];
        backgroundView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:backgroundView];
        self.bgView = backgroundView;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 30, 80, 80)];
        //imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        [self.contentView addSubview:imageView];
        self.thumbnailView = imageView;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20+80+5, 30, SCREEN_WIDTH-105-80, 20)];
        label.text = @"School Name";
        label.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:label];
        self.schoolNameLabel = label;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, 30, 80, 20)];
        label.text = @"User Name";
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label];
        self.userNameLabel = label;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20+80+5, label.bottomValue+5, SCREEN_WIDTH-110, 1)];
        line.backgroundColor = UIColor_GrayLine;
        [self.contentView addSubview:line];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(20+80+5, line.bottomValue+20, 100, 15)];
        label.text = @"Class Name";
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = RGB(126, 147, 158);
        [self.contentView addSubview:label];
        self.classNameLabel = label;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-90, line.bottomValue+8, 85, 20)];
        label.text = @"Total";
        label.font = [UIFont systemFontOfSize:13];
        label.layer.borderColor = RGB(220, 94, 98).CGColor;
        label.layer.borderWidth = 1;
        label.layer.cornerRadius = 2;
        label.textColor = RGB(220, 94, 98);
        label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label];
        self.totalFeeLabel = label;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(20+80+5, label.bottomValue+12, 140, 15)];
        label.text = @"Time";
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = RGB(126, 147, 158);
        [self.contentView addSubview:label];
        self.timeLabel = label;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-90, label.topValue-5, 85, 20)];
        label.text = @"Install";
        label.font = [UIFont systemFontOfSize:13];
        label.layer.borderColor = RGB(129, 183, 255).CGColor;
        label.layer.borderWidth = 1;
        label.layer.cornerRadius = 2;
        label.textColor = RGB(129, 183, 255);
        label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label];
        self.installmentLabel = label;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.bgView.frame = CGRectMake(0, 10, self.contentView.widthValue, self.contentView.heightValue-10);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(NSDictionary *)data {
    [self.thumbnailView sd_setImageWithURL:[NSURL URLWithString:data[@"driving_school_logo"]]];
    self.schoolNameLabel.text = data[@"driving_school_name"];
    self.userNameLabel.text = data[@"apply_name"];
    self.classNameLabel.text = data[@"class_name"];
    self.timeLabel.text = [NSString stringWithFormat:@"报名时间:%@", data[@"apply_time"]];
    
    if ([data[@"status"] integerValue] == 1) {
        self.totalFeeLabel.hidden = NO;
        self.totalFeeLabel.text = [NSString stringWithFormat:@"总费用 %.f", [data[@"total_fee"] floatValue]];
        self.installmentLabel.text = [NSString stringWithFormat:@"已缴费 %.f", [data[@"payed_fee"] floatValue]];
    } else if ([data[@"status"] integerValue] == 2) {
        self.totalFeeLabel.hidden = YES;
        self.installmentLabel.text = @"已全额缴费";
    }
    
}

@end
