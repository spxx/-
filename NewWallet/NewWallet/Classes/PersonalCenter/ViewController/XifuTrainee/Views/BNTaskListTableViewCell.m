//
//  BNTaskListTableViewCell.m
//  Wallet
//
//  Created by mac1 on 15/12/23.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import "BNTaskListTableViewCell.h"

@interface BNTaskListTableViewCell ()
@property (weak, nonatomic) UIImageView *theImageView;
@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UILabel *desLabel;
@property (weak, nonatomic) UIView *redBGView;

@end

@implementation BNTaskListTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10 * NEW_BILI)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:whiteView];
        
        UIView *redBGView = [[UIView alloc] initWithFrame:CGRectMake(16 * NEW_BILI, CGRectGetMaxY(whiteView.frame), SCREEN_WIDTH - 32 * NEW_BILI, 50 * NEW_BILI)];
        redBGView.backgroundColor = UIColorFromRGB(0xfff0f3);
        redBGView.layer.cornerRadius = 2;
        redBGView.layer.masksToBounds = YES;
        [self.contentView addSubview:redBGView];
        _redBGView = redBGView;
        
        CGFloat redBGViewHeight = CGRectGetHeight(redBGView.frame);
        CGFloat redBGViewWidth = CGRectGetWidth(redBGView.frame);

        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (redBGViewHeight - 15)/2.0, 15 , 15)];
        [redBGView addSubview:imageView];
        _theImageView = imageView;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 9.5 * NEW_BILI, (redBGViewHeight - 16*NEW_BILI)/2.0, 150 * NEW_BILI, 16 * NEW_BILI)];
        titleLabel.textColor = UIColorFromRGB(0x37474f);
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:14 * NEW_BILI];
        [redBGView addSubview:titleLabel];
        _titleLabel = titleLabel;
        
        UIImageView *arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(redBGViewWidth - 26, (redBGViewHeight - 16)/2, 16, 16)];
        arrowImg.image = [UIImage imageNamed:@"right_arrow"];
        [redBGView addSubview:arrowImg];
        
        UILabel *desLabel = [[UILabel alloc] initWithFrame:CGRectMake(redBGViewWidth - 181 * NEW_BILI,  (redBGViewHeight - 16*NEW_BILI)/2.0, 150 * NEW_BILI, 16 * NEW_BILI)];
        desLabel.textAlignment = NSTextAlignmentRight;
        desLabel.textColor = UIColorFromRGB(0x78909c);
        desLabel.font = [UIFont systemFontOfSize:13 * NEW_BILI];
        [redBGView addSubview:desLabel];
        _desLabel = desLabel;
    }
    
    return self;
}

- (void)drawCellDataWithDictionary:(NSDictionary *)dictionary
{
    _theImageView.image = [UIImage imageNamed:@"icon_Task1"];
    _titleLabel.text = [dictionary valueNotNullForKey:@"task_name"];
    _desLabel.text =  [dictionary valueNotNullForKey:@"description"];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    _redBGView.backgroundColor = highlighted ? UIColorFromRGB(0xffe1e8) : UIColorFromRGB(0xfef2f3);
}


@end
