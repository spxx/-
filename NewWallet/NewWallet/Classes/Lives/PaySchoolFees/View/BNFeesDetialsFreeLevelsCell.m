//
//  BNFeesDetialsFreeLevelsCell.m
//  Wallet
//
//  Created by mac on 16/5/17.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "BNFeesDetialsFreeLevelsCell.h"
@interface BNFeesDetialsFreeLevelsCell ()
@property (nonatomic) UIView *selectView;
@property (nonatomic) UILabel *nameLbl;
@property (nonatomic) UILabel *moneyLbl;

@end
@implementation BNFeesDetialsFreeLevelsCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.selectView = [[UIView alloc] initWithFrame:CGRectMake(8*BILI_WIDTH, 6*BILI_WIDTH, SCREEN_WIDTH-2*8*BILI_WIDTH, kLevelsCellHeight-2*6*BILI_WIDTH)];
        _selectView.layer.borderColor = UIColorFromRGB(0xd9d9d9).CGColor;
        _selectView.layer.borderWidth = 1;
        [self.contentView addSubview:_selectView];
        
        self.nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(16*BILI_WIDTH, 1, SCREEN_WIDTH/2, CGRectGetHeight(_selectView.frame)-2)];
        _nameLbl.backgroundColor = [UIColor clearColor];
        _nameLbl.font = [UIFont systemFontOfSize:14*BILI_WIDTH];
        _nameLbl.textColor = UIColor_Black_Text;
        [_selectView addSubview:_nameLbl];
        
        self.moneyLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(_selectView.frame)-12*BILI_WIDTH-SCREEN_WIDTH/2, 1, SCREEN_WIDTH/2, CGRectGetHeight(_selectView.frame)-2)];
        _moneyLbl.backgroundColor = [UIColor clearColor];
        _moneyLbl.textAlignment = NSTextAlignmentRight;
        _moneyLbl.font = [UIFont systemFontOfSize:14*BILI_WIDTH];
        _moneyLbl.textColor = UIColor_Black_Text;
        [_selectView addSubview:_moneyLbl];
    }
    
    return self;
}

- (void)drawData:(NSDictionary *)info selectCell:(NSDictionary *)selectDict
{
    if (selectDict && [info valueNotNullForKey:@"level_id"] == [selectDict valueNotNullForKey:@"level_id"]) {
        _selectView.layer.borderColor = UIColorFromRGB(0x448aff).CGColor;
    } else {
        _selectView.layer.borderColor = UIColorFromRGB(0xeeeeee).CGColor;
    }
    _nameLbl.text = [NSString stringWithFormat:@"%@", [info valueNotNullForKey:@"level_name"]];
    _moneyLbl.text = [NSString stringWithFormat:@"%@", [info valueNotNullForKey:@"amount"]];

}

@end
