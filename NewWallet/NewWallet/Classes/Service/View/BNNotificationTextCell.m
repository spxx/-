//
//  BNNotificationTextCell.m
//  Wallet
//
//  Created by crx on 9/22/15.
//  Copyright © 2015 BNDK. All rights reserved.
//

#import "BNNotificationTextCell.h"
#import "XifuNews.h"

@interface BNNotificationTextCell ()

@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UIView *bodyView;
@property (strong, nonatomic) UILabel *typeLabel;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *descriptLabel;
@property (strong, nonatomic) UIView *line;
@property (strong, nonatomic) UILabel *viewDetailLabel;

@end

@implementation BNNotificationTextCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.backgroundView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
        UILabel *dateLable = [[UILabel alloc] initWithFrame:CGRectMake(25, 20, SCREEN_WIDTH-25*2, 18)];
        dateLable.backgroundColor = [UIColor clearColor];
        dateLable.font = [UIFont systemFontOfSize:[BNTools sizeFit:10 six:10 sixPlus:11]];
        dateLable.textColor = UIColor_NewLightTextColor;
        dateLable.text = @"";
        self.dateLabel = dateLable;
        [self.contentView addSubview:dateLable];
        
        UIView *bodyView = [[UIView alloc] initWithFrame:CGRectMake(15, self.dateLabel.bottomValue+10, SCREEN_WIDTH-15*2, 260)];
        bodyView.backgroundColor = [UIColor whiteColor];
        bodyView.layer.cornerRadius = 8;
        bodyView.layer.borderColor = UIColorFromRGB(0xd9d9d9).CGColor;
        bodyView.layer.borderWidth = 0.5;
        bodyView.layer.masksToBounds = YES;
        bodyView.clipsToBounds = YES;
        self.bodyView = bodyView;
        [self.contentView addSubview:self.bodyView];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bodyView.widthValue, 58)];
        bgView.backgroundColor = UIColorFromRGB(0x9ca6cb);
        [self.bodyView addSubview:bgView];

        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, self.bodyView.widthValue-14*2, 58)];
        titleLabel.font = [UIFont boldSystemFontOfSize:15];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self.bodyView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UILabel *descriptLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, self.titleLabel.bottomValue, self.bodyView.widthValue-14*2, 65)];
        descriptLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:13 six:13 sixPlus:14]];
        descriptLabel.textColor = UIColorFromRGB(0x78909c);
        descriptLabel.textAlignment = NSTextAlignmentLeft;
        descriptLabel.lineBreakMode = NSLineBreakByCharWrapping;
        descriptLabel.backgroundColor = [UIColor clearColor];
        descriptLabel.numberOfLines = 2;
        [bodyView addSubview:descriptLabel];
        self.descriptLabel = descriptLabel;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(13, self.descriptLabel.bottomValue, self.bodyView.frame.size.width-13*2, 0.5)];
        line.backgroundColor = UIColorFromRGB(0xe5e5e5);
        [bodyView addSubview:line];
        self.line = line;
        
        UILabel *viewDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, line.bottomValue, 150, 54)];
        viewDetailLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:14 sixPlus:16]];
        viewDetailLabel.textColor = UIColorFromRGB(0x37474f);
        viewDetailLabel.text = @"查看详情";
        [bodyView addSubview:viewDetailLabel];
        self.viewDetailLabel = viewDetailLabel;
    
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawDataWithInfo:(NSManagedObject *)newInfo withHeightDic:(NSDictionary *)heightInfo {
    CGFloat cellHeight = [[heightInfo objectForKey:@"cellHeight"] floatValue];
//    CGFloat dateHeight = [[heightInfo objectForKey:@"titleHeight"] floatValue];
    CGFloat descHeight = [[heightInfo objectForKey:@"subTitleHeight"] floatValue];
    
    self.bodyView.frame = CGRectMake(15, self.dateLabel.bottomValue+10, SCREEN_WIDTH-15*2, cellHeight-self.dateLabel.bottomValue-10);
    self.descriptLabel.frame = CGRectMake(14, self.titleLabel.bottomValue, self.bodyView.widthValue-14*2, descHeight);
    self.line.frame = CGRectMake(14, self.bodyView.heightValue-54, self.bodyView.frame.size.width-14*2, 0.5);
    self.viewDetailLabel.frame = CGRectMake(14, self.line.bottomValue, 150, 54);

    XifuNews *xifuNews = (XifuNews *)newInfo;
    self.dateLabel.text = xifuNews.create_time;
//    self.typeLabel.text = xifuNews.busiType;
    self.titleLabel.text = xifuNews.subBusiType;
    if (!xifuNews.subBusiType || (xifuNews.subBusiType.length == 0)) {
        self.titleLabel.text = @"";
    }
    self.descriptLabel.text = xifuNews.desc;
    
    if ((xifuNews.messageType.integerValue == 1) || (xifuNews.messageType.integerValue == 2)) {
        if (!xifuNews.text_url || [xifuNews.text_url isEqualToString:@""]) {
            self.line.hidden = YES;
            self.viewDetailLabel.hidden = YES;
        }
        else {
            self.line.hidden = NO;
            self.viewDetailLabel.hidden = NO;
        }
    }
    else {
        self.line.hidden = NO;
        self.viewDetailLabel.hidden = NO;
    }
}

@end
