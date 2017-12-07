//
//  BNAboutVCTableViewCell.m
//  Wallet
//
//  Created by mac on 15/6/4.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNAboutVCTableViewCell.h"
@interface BNAboutVCTableViewCell ()

@property (nonatomic) UILabel *cellTitleLabel;
@property (nonatomic) UILabel *contentLabel;

@end
@implementation BNAboutVCTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.cellTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*BILI_WIDTH, 0, SCREEN_WIDTH/2, 45*BILI_WIDTH)];
        _cellTitleLabel.textColor = [UIColor blackColor];
        _cellTitleLabel.textAlignment = NSTextAlignmentLeft;
        _cellTitleLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
        
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-15*BILI_WIDTH, 0, SCREEN_WIDTH/2, 45 * BILI_WIDTH)];
        _contentLabel.textColor = UIColor_XiaoDaiCellGray_Text;
        _contentLabel.textAlignment = NSTextAlignmentRight;
        _contentLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
        _contentLabel.userInteractionEnabled = YES;
        
        [self.contentView addSubview:_cellTitleLabel];
        [self.contentView addSubview:_contentLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15*BILI_WIDTH, 45*BILI_WIDTH - 0.5, SCREEN_WIDTH - 15*BILI_WIDTH, 0.5)];
        line.backgroundColor = UIColor_GrayLine;
        _sepLine = line;
        [self.contentView addSubview:line];

        UILongPressGestureRecognizer *longGS = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longGS:)];
        [_contentLabel addGestureRecognizer:longGS];
    }
    return self;
}

- (void)drawtitleStr:(NSString *)titleStr contentStr:(NSString *)contentStr
{
    _cellTitleLabel.text = titleStr;
    _contentLabel.text = contentStr;

    if ([titleStr isEqualToString:@"用户Q群"] || [titleStr isEqualToString:@"客服QQ"] || [titleStr isEqualToString:@"微信公众号"]) {
        _contentLabel.textColor = UIColor_XiaoDaiCellGray_Text;
    } else {
        _contentLabel.textColor = UIColorFromRGB(0x00a7ec);
    }
}

- (void)longGS:(UIGestureRecognizer *)gesture
{
    CGRect itemRect = CGRectMake(_contentLabel.frame.origin.x, _contentLabel.frame.origin.y+20*BILI_WIDTH, _contentLabel.frame.size.width, _contentLabel.frame.size.height);
    UIMenuItem *item1 = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(copyAction:)];
    UIMenuController * menu = [UIMenuController sharedMenuController];
    [menu setMenuItems:@[item1]];
    [menu setTargetRect:itemRect inView:_contentLabel];
    [menu setMenuVisible: YES animated: YES];

    [self becomeFirstResponder];
}
- (void)copyAction:(UIMenuItem *)item
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _contentLabel.text;
}
#pragma mark -UIMenuController显示
-(BOOL) canBecomeFirstResponder
{
    return YES;
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(copyAction:)){
        return YES;
    }
    return NO;
}
@end
