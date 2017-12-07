//
//  PersonalCenterCell.m
//  Wallet
//
//  Created by mac1 on 15/2/4.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "PersonalCenterCell.h"


@interface PersonalCenterCell ()

@property (weak, nonatomic) UIImageView *iconImageView;

@property (weak, nonatomic) UILabel *itemTitleLabel;

@property (weak, nonatomic) UILabel *itemSubTitlelabel;

//@property (weak, nonatomic) UIImageView *rightArrowImageView;

@property (weak, nonatomic) UIView *seprateLine;
@end
@implementation PersonalCenterCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-31-31, 24, 31, 31)];
        iconImg.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:iconImg];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 160, 80)];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = UIColor_BlackBlue_Text;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:titleLabel];
        
        UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 32, 16, 16)];
        subTitleLabel.textAlignment = NSTextAlignmentCenter;
        subTitleLabel.textColor = [UIColor whiteColor];
        subTitleLabel.backgroundColor = [UIColor clearColor];
        subTitleLabel.font = [UIFont systemFontOfSize:10];
        subTitleLabel.layer.cornerRadius = 8;
        subTitleLabel.clipsToBounds = YES;
        [self.contentView addSubview:subTitleLabel];
        
//        UIImageView *arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 26, (kPersonalCellHeight - 16)/2, 16, 16)];
//        arrowImg.backgroundColor = [UIColor clearColor];
//        [self.contentView addSubview:arrowImg];

        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, kPersonalCellHeight - 0.5, SCREEN_WIDTH - 15, 0.5)];
        line.backgroundColor = UIColor_GrayLine;
        [self.contentView addSubview:line];
        
        _iconImageView = iconImg;
        _itemTitleLabel = titleLabel;
        _itemSubTitlelabel = subTitleLabel;
        //_rightArrowImageView = arrowImg;
//        _seprateLine = line;
    }
    return self;
}


- (void)setupDataForCell:(NSDictionary *) cellInfo isShowLine:(BOOL) isShow
{
    [_iconImageView setImage:[UIImage imageNamed:[cellInfo valueForKey:kPersonal_Cell_Icon]]];
    
    //NSString *arrowName = [cellInfo valueForKey:kPersonal_Cell_Arrow];
    
//    if (arrowName.length > 0) {
//        _rightArrowImageView.hidden = NO;
        //[_rightArrowImageView setImage:[UIImage imageNamed:arrowName]];
        //_itemSubTitlelabel.frame = CGRectMake(SCREEN_WIDTH - 126, (kPersonalCellHeight - 24)/2, 100, 24);
//    }else{
//        _rightArrowImageView.hidden = YES;
//        _itemSubTitlelabel.frame = CGRectMake(SCREEN_WIDTH - 110, (kPersonalCellHeight - 24)/2, 100, 24);
//    }
    
    NSString *subTitle = [cellInfo valueForKey:kPersonal_Cell_SubTitle];
    if (subTitle.length > 0 && [subTitle isEqualToString:@"null"] == NO) {
        _itemSubTitlelabel.hidden = NO;
        _itemSubTitlelabel.text = subTitle;
        //_rightArrowImageView.hidden = NO;
    }else{
         _itemSubTitlelabel.hidden = YES;
        //_rightArrowImageView.hidden = NO;
    }
    
    NSString *title = [cellInfo valueForKey:kPersonal_Cell_Title];
    CGFloat titleWidth = [Tools getTextWidthWithText:title font:[UIFont systemFontOfSize:16] height:16];
    CGFloat subTitleWidth = [Tools getTextWidthWithText:subTitle font:[UIFont systemFontOfSize:10] height:16];
    _itemTitleLabel.text = title;
    _itemSubTitlelabel.frame = CGRectMake(15+titleWidth+5, 32, subTitleWidth+5*2, 16);
    
//    if ([subTitle isEqualToString:@"未认证"]
//        || [subTitle isEqualToString:@"认证中"]
//        || [subTitle isEqualToString:@"认证失败"]) {
//        
    if ([subTitle isEqualToString:@"已认证"]) {
        _itemSubTitlelabel.backgroundColor = [UIColor string2Color:@"#ffb770"];
    } else {
        _itemSubTitlelabel.backgroundColor = [UIColor string2Color:@"#bec6e2"];
    }
    
    _seprateLine.hidden = !isShow;
}

@end
