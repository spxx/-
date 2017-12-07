//
//  BNYKTHomeListCell.m
//  NewWallet
//
//  Created by mac on 14-10-27.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNYKTHomeListCell.h"

@interface BNYKTHomeListCell ()

@property (nonatomic) UIImageView *iconImageView;
@property (nonatomic) UILabel *schoolLabel;
@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UILabel *stuempnoLabel;
@property (nonatomic) UIButton *rechargeBtn;
@property (nonatomic) UILabel *lineLabel;
@property (nonatomic) NSDictionary *dict;

@end

@implementation BNYKTHomeListCell
static NSInteger cellHeight;

- (void)awakeFromNib {
    // Initialization code
    
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        cellHeight = 68*BILI_WIDTH;
        //icon
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15*BILI_WIDTH, (cellHeight-35*BILI_WIDTH)/2.0, 35 * BILI_WIDTH, 35 * BILI_WIDTH)];
        _iconImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.contentView addSubview:_iconImageView];
        
        self.schoolLabel = [[UILabel alloc]initWithFrame:CGRectMake(65*BILI_WIDTH, 16*BILI_WIDTH, SCREEN_WIDTH-(65+55)*BILI_WIDTH, 14*BILI_WIDTH)];
        _schoolLabel.backgroundColor = [UIColor clearColor];
        _schoolLabel.font = [UIFont systemFontOfSize:12*BILI_WIDTH];
        _schoolLabel.textColor = UIColor_DarkGray_Text;
        _schoolLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_schoolLabel];
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(65*BILI_WIDTH, cellHeight - (14+14)*BILI_WIDTH, (SCREEN_WIDTH-(65+55)*BILI_WIDTH)/2, 14*BILI_WIDTH)];
        _nameLabel.font = [UIFont systemFontOfSize:12*BILI_WIDTH];
        _nameLabel.textColor = UIColor_BlackBlue_Text;
        _nameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_nameLabel];
        
        self.stuempnoLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_nameLabel.frame), cellHeight - (14+14)*BILI_WIDTH, (SCREEN_WIDTH-(65+55)*BILI_WIDTH)/2, 14*BILI_WIDTH)];
        _stuempnoLabel.font = [UIFont systemFontOfSize:12*BILI_WIDTH];
        _stuempnoLabel.textColor = UIColor_BlackBlue_Text;
        _stuempnoLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_stuempnoLabel];
        
        self.rechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rechargeBtn.frame = CGRectMake(SCREEN_WIDTH-(40+15)*BILI_WIDTH, 16* BILI_WIDTH, 40*BILI_WIDTH, 18 * BILI_WIDTH);
        [_rechargeBtn setupBlueBorderLineBtnTitle:@"充值" enable:YES];
        _rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:12*BILI_WIDTH];
        _rechargeBtn.layer.cornerRadius = 3*BILI_WIDTH;
        [_rechargeBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_rechargeBtn];
        
        self.lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(65*BILI_WIDTH, 0, SCREEN_WIDTH-65*BILI_WIDTH, 0.5)];
        _lineLabel.backgroundColor = UIColor_GrayLine;
        [self.contentView addSubview:_lineLabel];
        
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)drawData:(NSDictionary *)dict systemError:(BOOL)systemError cellBtnTapBlock:(CellBtnTapBlock)cellBtnTapBlock
{
    _dict = dict;
    _cellBtnTapBlock = cellBtnTapBlock;
    _rechargeBtn.enabled = !systemError;
    
    _schoolLabel.text = [NSString stringWithFormat:@"%@", [dict valueNotNullForKey:@"recharge_school_name"]];
    _nameLabel.text = [NSString stringWithFormat:@"%@", [dict valueNotNullForKey:@"recharge_ykt_name"]];
    _stuempnoLabel.text = [NSString stringWithFormat:@"%@", [dict valueNotNullForKey:@"recharge_stuempno"]];

    NSString *schoolIconStr = [NSString stringWithFormat:@"%@", [dict valueNotNullForKey:@"school_logo_url"]];
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:schoolIconStr] placeholderImage:nil];
    
}
- (void)buttonAction:(UIButton *)button
{
    if (_cellBtnTapBlock) {
         _cellBtnTapBlock(_dict);
    }
}

@end
