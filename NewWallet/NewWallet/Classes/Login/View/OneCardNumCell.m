//
//  OneCardNumCell.m
//  NewWallet
//
//  Created by mac1 on 14-10-28.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "OneCardNumCell.h"

@implementation OneCardNumCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [delBtn setFrame:CGRectMake(SCREEN_WIDTH - 45 * BILI_WIDTH, 0, 45 * BILI_WIDTH, 45 * BILI_WIDTH)];
        [delBtn setImage:[UIImage imageNamed:@"Main_Cancel_btn"] forState:UIControlStateNormal];
        [delBtn addTarget:self action:@selector(deleteHistoryNumber:) forControlEvents:UIControlEventTouchUpInside];
        _deleteButton = delBtn;
        [self.contentView addSubview:delBtn];
        
        
        UILabel *cellTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 45 * BILI_WIDTH, 0, SCREEN_WIDTH - 45 * BILI_WIDTH * 2, 45 * BILI_WIDTH)];
        cellTitleLab.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
        cellTitleLab.textAlignment = NSTextAlignmentLeft;
        cellTitleLab.textColor = [UIColor lightGrayColor];
        _cellTitleLabel = cellTitleLab;
        [self.contentView addSubview:cellTitleLab];
        
        UILabel *bindLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 120 - 12, 0, 120, 45 * BILI_WIDTH)];
        bindLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:10 six:10 sixPlus:12]];
        bindLabel.textAlignment = NSTextAlignmentRight;
        bindLabel.textColor = [UIColor lightGrayColor];
        _bindStrLabel = bindLabel;
        
        [self.contentView addSubview:bindLabel];
        
        
    }
    return self;
}

- (void)deleteHistoryNumber:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(deleteButtonTapedAtRow:)]) {
        [self.delegate deleteButtonTapedAtRow:_row];
    }
}
@end
