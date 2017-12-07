//
//  BNPersonalMessageCell.h
//  Wallet
//
//  Created by xjy on 17/2/20.
//  Copyright © 2015 BNDK. All rights reserved.
//

#import "BNPersonalMessageCell.h"
#import "XifuNews.h"

@interface BNPersonalMessageCell ()

@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UIView *bodyView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *descriptLabel;
@property (strong, nonatomic) UIView *line;
@property (strong, nonatomic) UILabel *viewDetailLabel;
@property (strong, nonatomic) UIImageView *arrowView;

@end

@implementation BNPersonalMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.backgroundView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
        UILabel *dateLable = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, SCREEN_WIDTH-2*25, 50)];
        dateLable.font = [UIFont systemFontOfSize:[BNTools sizeFit:10 six:10 sixPlus:11]];
        dateLable.textColor = UIColor_NewLightTextColor;
        dateLable.text = @"";
        self.dateLabel = dateLable;
        [self.contentView addSubview:dateLable];
        
        UIView *bodyView = [[UIView alloc] initWithFrame:CGRectMake(15, self.dateLabel.bottomValue, SCREEN_WIDTH-15*2, 140)];
        bodyView.backgroundColor = [UIColor whiteColor];
        bodyView.layer.cornerRadius = 5;
        bodyView.layer.borderColor = UIColorFromRGB(0xd9d9d9).CGColor;
        bodyView.layer.borderWidth = 0.5;
        bodyView.clipsToBounds = YES;
        bodyView.layer.masksToBounds = YES;
        self.bodyView = bodyView;
        [self.contentView addSubview:self.bodyView];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bodyView.widthValue, 50)];
        bgView.backgroundColor = UIColorFromRGB(0x9ca6cb);
        [self.bodyView addSubview:bgView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, self.bodyView.widthValue-12*2, 50)];
        titleLabel.font = [UIFont boldSystemFontOfSize:15];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.backgroundColor = [UIColor clearColor];
        [bgView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UILabel *descriptLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, bgView.bottomValue, self.bodyView.widthValue-12*2, 90)];
        descriptLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:13 six:13 sixPlus:14]];
        descriptLabel.textColor = UIColorFromRGB(0x78909c);
        descriptLabel.textAlignment = NSTextAlignmentLeft;
        descriptLabel.lineBreakMode = NSLineBreakByCharWrapping;
        descriptLabel.backgroundColor = [UIColor clearColor];
        descriptLabel.numberOfLines = 2;
        [self.bodyView addSubview:descriptLabel];
        self.descriptLabel = descriptLabel;
    }
    return self;
}

- (void)drawDataWithInfo:(NSDictionary *)dict
{
    self.dateLabel.text = [NSString stringWithFormat:@"%@", [dict valueWithNoDataForKey:@"push_time"]];
    self.titleLabel.text = [NSString stringWithFormat:@"%@", [dict valueWithNoDataForKey:@"event_name"]];
    self.descriptLabel.text = [NSString stringWithFormat:@"%@", [dict valueWithNoDataForKey:@"describe"]];
}

@end
