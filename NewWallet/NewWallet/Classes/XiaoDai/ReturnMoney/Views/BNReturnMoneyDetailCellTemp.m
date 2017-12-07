//
//  BNReturnMoneyDetailCellTemp.m
//  Wallet
//
//  Created by mac on 15/4/30.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNReturnMoneyDetailCellTemp.h"

@interface BNReturnMoneyDetailCellTemp ()

@property (nonatomic) UILabel *titleLbl;
@property (nonatomic) UILabel *moneyLbl;
@property (nonatomic) UILabel *dayOutLbl;
@property (nonatomic) UILabel *moneyOutLbl;
@property (nonatomic) UILabel *timeLbl;

@end

@implementation BNReturnMoneyDetailCellTemp

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat originY = 15*BILI_WIDTH;
        
        self.timeLbl = [[UILabel alloc]initWithFrame:CGRectMake(10*BILI_WIDTH, originY, SCREEN_WIDTH/2-10*BILI_WIDTH, 13*BILI_WIDTH)];
        _timeLbl.textColor = UIColor_XiaoDaiCellGray_Text;
        _timeLbl.font = [UIFont systemFontOfSize:13*BILI_WIDTH];
        _timeLbl.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_timeLbl];

        self.moneyLbl = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, originY-2, SCREEN_WIDTH/2-10*BILI_WIDTH, 16*BILI_WIDTH)];
        _moneyLbl.textColor = [UIColor blackColor];
        _moneyLbl.textAlignment = NSTextAlignmentRight;
        _moneyLbl.font = [UIFont systemFontOfSize:16*BILI_WIDTH];
        _moneyLbl.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_moneyLbl];
        
       
    }
    return self;
}

- (void)drawDataWithDict:(NSDictionary *)dict andIndexPath:(NSIndexPath *)indexPath cellCount:(NSInteger)count
{
    float repayAmount = [[dict valueNotNullForKey:@"repay_amount"] floatValue];
    _moneyLbl.text = [NSString stringWithFormat:@"%.2f元",repayAmount];
    _timeLbl.text = [NSString stringWithFormat:@"%@",[dict valueNotNullForKey:@"create_time"]];
}

@end
