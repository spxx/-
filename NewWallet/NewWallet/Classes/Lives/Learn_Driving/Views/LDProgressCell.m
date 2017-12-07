//
//  LDProgressCell.m
//  Wallet
//
//  Created by 陈荣雄 on 5/30/16.
//  Copyright © 2016 BNDK. All rights reserved.
//

#import "LDProgressCell.h"
#import "ExpandButton.h"

@interface LDProgressCell ()

@property (weak, nonatomic) UIImageView *vline;
@property (weak, nonatomic) UILabel *itemLabel;
@property (weak, nonatomic) UILabel *descriptionLabel;
@property (weak, nonatomic) UIButton *payButton;

@end

@implementation LDProgressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier {
    self = [super initWithStyle:style reuseIdentifier:identifier];
    if (self) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
        imageView.image = [UIImage imageNamed:@"ld_timeline_spot"];
        [self.contentView addSubview:imageView];
        
        UIImageView *vline = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"ld_timeline"] stretchableImageWithLeftCapWidth:0 topCapHeight:0]];
        [self.contentView addSubview:vline];
        self.vline = vline;
        
        UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.rightValue+10, 5, 100, 20)];
        itemLabel.text = @"";
        itemLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:itemLabel];
        self.itemLabel = itemLabel;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(itemLabel.leftValue, itemLabel.bottomValue+5, SCREEN_WIDTH-itemLabel.leftValue, 1)];
        line.backgroundColor = UIColor_GrayLine;
        [self.contentView addSubview:line];
        
        UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(itemLabel.leftValue, line.bottomValue+10, SCREEN_WIDTH-itemLabel.leftValue-10, self.contentView.heightValue-line.bottomValue-10-10)];
        descriptionLabel.font = [UIFont systemFontOfSize:13];
        descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        descriptionLabel.numberOfLines = 0;
        [self.contentView addSubview:descriptionLabel];
        self.descriptionLabel = descriptionLabel;
        

        ExpandButton *button = [ExpandButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(SCREEN_WIDTH-80-10, 5, 80, 20);
        [button setupTitle:@"培训费" enable:YES];
        [button setBackgroundImage:[Tools imageWithColor:RGB(54, 113, 255) andSize:CGSizeMake(80, 20)] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button addTarget:self action:@selector(payTapped:) forControlEvents:UIControlEventTouchUpInside];
        button.hidden = YES;
        [self.contentView addSubview:button];
        self.payButton = button;

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.vline.frame = CGRectMake(19, 25, 2, self.contentView.heightValue-25);
    self.descriptionLabel.topValue = 31+10;
    self.descriptionLabel.heightValue = self.contentView.heightValue-31-10-10;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPayState:(BOOL)payable {
    self.payButton.enabled = payable;
    self.payButton.hidden = NO;
}

- (void)payTapped:(UIButton *)button {
    if (self.payDelegate && [self.payDelegate respondsToSelector:@selector(pay)]) {
        [self.payDelegate pay];
    }
}

- (void)setData:(NSDictionary *)data {
    self.itemLabel.text = data[@"title"];
    self.descriptionLabel.text = data[@"description"];
    
    [self.payButton setTitle:[NSString stringWithFormat:@"%@培训费", data[@"title"]] forState:UIControlStateNormal];
}

@end
