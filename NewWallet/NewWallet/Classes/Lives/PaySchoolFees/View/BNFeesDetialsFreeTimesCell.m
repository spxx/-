//
//  BNFeesDetialsFreeTimesCell.m
//  Wallet
//
//  Created by mac on 16/5/17.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "BNFeesDetialsFreeTimesCell.h"
@interface BNFeesDetialsFreeTimesCell ()
@property (nonatomic) UILabel *nameLbl;
@property (nonatomic) UILabel *moneyLbl;

@end
@implementation BNFeesDetialsFreeTimesCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(16*BILI_WIDTH, 0, SCREEN_WIDTH/2, kFreeTimesCellHeight)];
        _nameLbl.backgroundColor = [UIColor clearColor];
        _nameLbl.font = [UIFont systemFontOfSize:14*BILI_WIDTH];
        _nameLbl.textColor = UIColorFromRGB(0x90a4ae);
        [self.contentView addSubview:_nameLbl];
        
        self.moneyLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-12*BILI_WIDTH-SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, kFreeTimesCellHeight)];
        _moneyLbl.backgroundColor = [UIColor clearColor];
        _moneyLbl.textAlignment = NSTextAlignmentRight;
        _moneyLbl.font = [UIFont systemFontOfSize:14*BILI_WIDTH];
        _moneyLbl.textColor = UIColor_Black_Text;
        [self.contentView addSubview:_moneyLbl];
    }
    
    return self;
}

- (void)drawData:(NSDictionary *)info
{
    _nameLbl.text = [NSString stringWithFormat:@"%@", [info valueNotNullForKey:@"prj_name"]];
    _moneyLbl.text = [NSString stringWithFormat:@"%@", [info valueNotNullForKey:@"amount"]];

}

@end
