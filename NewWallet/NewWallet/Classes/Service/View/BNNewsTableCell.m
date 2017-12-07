//
//  BNNewsTableCell.m
//  NewWallet
//
//  Created by cyjjkz1 on 14-11-10.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNNewsTableCell.h"
#import "OneCardNews.h"
#import "FXLabel.h"

@interface BNNewsTableCell ()

@property (weak, nonatomic) UILabel *timeLabel;

@property (weak, nonatomic) UIImageView *newsImageView;

@property (weak, nonatomic) UILabel *newsTitleLable;

@property (weak, nonatomic) UILabel *newsSubTitleLabel;

@end








//"create_time" = "2014-11-11 15:05:37";
//id = 3;
//"image_url" = "http://imageurl_2.com";
//"school_id" = 101;
//tag = "tag 2";
//"text_abstract" = "text_abstract content 2";
//"text_url" = "http://text_url_2.com";
//title = "title 2";


@implementation BNNewsTableCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.backgroundView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
        UILabel *dateLable = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2, 20, 150, 18)];
        dateLable.backgroundColor = UIColorFromRGB(0xd9d9d9);
        dateLable.textAlignment = NSTextAlignmentCenter;
        dateLable.font = [UIFont systemFontOfSize:[BNTools sizeFit:11 six:11 sixPlus:13]];
        dateLable.textColor = [UIColor whiteColor];
        dateLable.text = @"";
        [self.contentView addSubview:dateLable];
        self.timeLabel = dateLable;
        
        UIView *newsBodyView = [[UIView alloc] initWithFrame:CGRectMake(15, self.timeLabel.frame.origin.y+self.timeLabel.frame.size.height+10, SCREEN_WIDTH - 15*2, (SCREEN_WIDTH/320-1)*160+300)];
        newsBodyView.backgroundColor = [UIColor whiteColor];
        newsBodyView.layer.cornerRadius = 3;
        newsBodyView.layer.borderColor = UIColorFromRGB(0xd9d9d9).CGColor;
        newsBodyView.layer.borderWidth = 0.5;
        self.newsBodyBackgroundView = newsBodyView;
        [self.contentView addSubview:newsBodyView];
        
        
        FXLabel *titleLabel = [[FXLabel alloc] initWithFrame:CGRectMake(20, 10, NewsCardContentWidth, 30)];
        titleLabel.font = [UIFont boldSystemFontOfSize:[BNTools sizeFit:16 six:16 sixPlus:18]];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        titleLabel.numberOfLines = 0;
        [newsBodyView addSubview:titleLabel];
        self.newsTitleLable = titleLabel;
        
        UIImageView *newsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, titleLabel.frame.origin.y + titleLabel.frame.size.height + 10, NewsCardContentWidth, NewsCardContentWidth * (456.0/1080.0))];
        [newsBodyView addSubview:newsImageView];
        [newsImageView setContentMode:UIViewContentModeScaleAspectFit];
        self.newsImageView = newsImageView;
        
        FXLabel *subTitleLabel = [[FXLabel alloc] initWithFrame:CGRectMake(10, newsImageView.frame.origin.y + newsImageView.frame.size.height + 20, NewsCardContentWidth, 60)];
        subTitleLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:14 sixPlus:16]];
        subTitleLabel.textColor = [UIColor lightGrayColor];
        subTitleLabel.textAlignment = NSTextAlignmentLeft;
        subTitleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        subTitleLabel.backgroundColor = [UIColor clearColor];
        subTitleLabel.numberOfLines = 0;
        [newsBodyView addSubview:subTitleLabel];
        self.newsSubTitleLabel = subTitleLabel;
        
    }
    return self;
}


- (void)drawDataWithInfo:(NSManagedObject *)newInfo withHeightDic:(NSDictionary *)heightInfo
{
    //"create_time" = "2014-11-11 15:05:37";
    //id = 3;
    //"image_url" = "http://imageurl_2.com";
    //"school_id" = 101;
    //tag = "tag 2";
    //"text_abstract" = "text_abstract content 2";
    //"text_url" = "http://text_url_2.com";1080 × 456  456.0/1080.0
    //title = "title 2";
    BNLog(@"111111211    %f",NewsCardContentWidth * (456.0/1080.0));
    self.newsBodyBackgroundView.frame = CGRectMake(15, self.timeLabel.frame.origin.y+self.timeLabel.frame.size.height+10, SCREEN_WIDTH - 15*2, [[heightInfo objectForKey:CellHeight] doubleValue] - self.timeLabel.bottomValue-10);
    self.newsTitleLable.frame = CGRectMake(10, 10, NewsCardContentWidth, [[heightInfo objectForKey:TitleHeight] doubleValue]);
    self.newsImageView.frame = CGRectMake(10, self.newsTitleLable.frame.origin.y + self.newsTitleLable.frame.size.height + 10, NewsCardContentWidth, NewsCardContentWidth * (456.0/1080.0));
    
    self.newsSubTitleLabel.frame = CGRectMake(10, self.newsImageView.frame.origin.y + self.newsImageView.frame.size.height + 10, NewsCardContentWidth, [[heightInfo objectForKey:SubTitleHeight] doubleValue]);
    
    OneCardNews *xifuNews = (OneCardNews *)newInfo;
    self.timeLabel.text = xifuNews.create_time;
    self.newsSubTitleLabel.text = xifuNews.text_abstract;
    self.newsTitleLable.text = xifuNews.title;
    NSString *imageUrl = xifuNews.image_url;
    NSURL *url = [[NSURL alloc] initWithString:[imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [self.newsImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Service_defaultImage.png"]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
