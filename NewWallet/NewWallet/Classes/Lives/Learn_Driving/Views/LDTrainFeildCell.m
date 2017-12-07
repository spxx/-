//
//  LDTrainFeildCell.m
//  Wallet
//
//  Created by mac1 on 16/6/1.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "LDTrainFeildCell.h"

@interface LDTrainFeildCell ()

@property (nonatomic, weak) UIView *whiteBGView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *distance;
@property (nonatomic, weak) UILabel *addressLabel;
@property (nonatomic, weak) UILabel *timeLabel;

@end

@implementation LDTrainFeildCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createCellSubViews];
    }
    
    return  self;
}


- (void)createCellSubViews
{
//    UIView *contentViewCover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,  100 * NEW_BILI)];
//    contentViewCover.backgroundColor = [UIColor redColor];
//    [self.contentView addSubview:contentViewCover];
    
    self.contentView.backgroundColor = BNColorRGB(238, 241, 243);
    
    UIView *whiteBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 10 * NEW_BILI,SCREEN_WIDTH, 240 * NEW_BILI)];
    whiteBGView.backgroundColor = [UIColor whiteColor];
    whiteBGView.layer.borderWidth = 1;
    whiteBGView.layer.borderColor = UIColor_GrayLine.CGColor;
    [self.contentView addSubview:whiteBGView];
    _whiteBGView = whiteBGView;
    
    UIView *verticlLine = [[UIView alloc] initWithFrame:CGRectMake(15 * NEW_BILI, 22 * NEW_BILI, 4 * NEW_BILI, 15 * NEW_BILI)];
    verticlLine.backgroundColor = BNColorRGB(78, 149, 255);
    [whiteBGView addSubview:verticlLine];
    
    UIColor *tempColor = BNColorRGB(155, 174, 183);
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(verticlLine.frame) + 5 * NEW_BILI, 22 * NEW_BILI, 200, 15 * NEW_BILI)];
    nameLabel.text = @"龙潭寺训练场";
    nameLabel.font = [UIFont systemFontOfSize:15 * NEW_BILI];
    nameLabel.textColor = [UIColor blackColor];
    [whiteBGView addSubview:nameLabel];
    _nameLabel = nameLabel;
    
    UILabel *distance = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 117*NEW_BILI, 22 * NEW_BILI, 100 * NEW_BILI, 15 * NEW_BILI)];
    distance.text = @"距离5.22km";
    distance.font = [UIFont systemFontOfSize:12 * NEW_BILI];
    distance.textColor = tempColor;
    distance.textAlignment = NSTextAlignmentRight;
    [whiteBGView addSubview:distance];
    _distance = distance;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15*NEW_BILI, CGRectGetMaxY(nameLabel.frame) + 12.5 * NEW_BILI, SCREEN_WIDTH - 30 * NEW_BILI, 0.5)];
    line.backgroundColor = UIColor_GrayLine;
    [whiteBGView addSubview:line];
    
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(24*NEW_BILI, CGRectGetMaxY(line.frame) + 10*NEW_BILI, 300 * NEW_BILI, 14 * NEW_BILI)];
    addressLabel.text = @"地址：武侯区吧啦啦路成飞大道256号";
    addressLabel.font = [UIFont systemFontOfSize:12 * NEW_BILI];
    addressLabel.textColor = tempColor;
    [whiteBGView addSubview:addressLabel];
    _addressLabel = addressLabel;
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(addressLabel.frame), CGRectGetMaxY(addressLabel.frame) + 14*NEW_BILI, 300 * NEW_BILI, 16 * NEW_BILI)];
    timeLabel.text = @"运营时间：9:00----18:00";
    timeLabel.font = [UIFont systemFontOfSize:12 * NEW_BILI];
    timeLabel.textColor = tempColor;
    [whiteBGView addSubview:timeLabel];
    _timeLabel = timeLabel;
    
    CGFloat imageMargin = 5 * NEW_BILI;
    CGFloat imageWidth = (SCREEN_WIDTH - 28 * NEW_BILI - imageMargin * 3) * 0.25;
    
    for (int i = 0; i < 4; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(14 * NEW_BILI + (imageWidth + imageMargin) * i, CGRectGetMaxY(timeLabel.frame) + 24 * NEW_BILI, imageWidth, imageWidth)];
        imageView.tag = i + 1;
        [whiteBGView addSubview:imageView];
    }
}

- (void)setAreaModel:(TrainArea *)areaModel
{
    _areaModel = areaModel;
    _nameLabel.text = areaModel.field_name;
    _distance.text = [NSString stringWithFormat:@"距离 %@km",areaModel.field_distance];
    _addressLabel.text = [NSString stringWithFormat:@"地址： %@",areaModel.field_position_name];
    _timeLabel.text = [NSString stringWithFormat:@"运营时间： %@",areaModel.operate_time_desc];
    for (int i = 0 ; i < 4; i ++) {
        NSDictionary *dic = areaModel.pic_list[i];
        UIImageView *imageView = (UIImageView *)[_whiteBGView viewWithTag:i + 1];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[dic valueNotNullForKey:@"pic_url"]]];
    }
    
}

//- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
//{
//    [super setHighlighted:highlighted animated:animated];
//    if (highlighted) {
//        _whiteBGView.backgroundColor = [UIColor lightGrayColor];
//    }else{
//        _whiteBGView.backgroundColor = [UIColor whiteColor];
//    }
//}

@end
