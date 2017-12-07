//
//  BNInterestTableViewCell.m
//  Wallet
//
//  Created by mac1 on 15/5/5.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNInterestTableViewCell.h"

@interface BNInterestTableViewCell ()
@property (nonatomic) UIImageView *selectImgView;
@property (nonatomic) UILabel *stagesInfoLabel;

@end

@implementation BNInterestTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10 * BILI_WIDTH, (40 * BILI_WIDTH - 14)/2.0, 14, 14)];
        [_selectImgView setImage:[UIImage imageNamed:@"xiao_dai_stages_unselected"]];
        [self.contentView addSubview:_selectImgView];
        
        self.stagesInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 *BILI_WIDTH + 14 , (40 * BILI_WIDTH - 24)/2.0, SCREEN_WIDTH - 15 * BILI_WIDTH, 24.0)];
        _stagesInfoLabel.backgroundColor = [UIColor clearColor];
        _stagesInfoLabel.textColor = [UIColor blackColor];
        _stagesInfoLabel.textAlignment = NSTextAlignmentLeft;
        _stagesInfoLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
        [self.contentView addSubview:_stagesInfoLabel];
    }
    return self;
}
- (void)drawDataWithDict:(NSDictionary *)dict isSelected:(BOOL) isSelected
{
    _stagesInfoLabel.text = [NSString stringWithFormat:@"%@期（%.2f元/期），每月%@号之前还款日",dict[@"installments"],[dict[@"installment_amount"] doubleValue],dict[@"repay_date"]];
    
    if (isSelected) {
        [_selectImgView setImage:[UIImage imageNamed:@"xiao_dai_stages_selected"]];
    }
    else
    {
        [_selectImgView setImage:[UIImage imageNamed:@"xiao_dai_stages_unselected"]];
    }

}


@end
