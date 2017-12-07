//
//  BNPersonalDetialCell.m
//  Wallet
//
//  Created by mac1 on 15/3/3.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNPersonalDetialCell.h"


@interface BNPersonalDetialCell ()

@property (nonatomic) UIImageView *verifyImgView;

@end


@implementation BNPersonalDetialCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *cellTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 45 * BILI_WIDTH)];
        cellTitleLabel.textColor = [UIColor blackColor];
        cellTitleLabel.textAlignment = NSTextAlignmentLeft;
        cellTitleLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
        _cellTitleLab = cellTitleLabel;

        UILabel *cellSubTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, SCREEN_WIDTH - 110, 45 * BILI_WIDTH)];
        cellSubTitleLabel.textColor = [UIColor lightGrayColor];
        cellSubTitleLabel.textAlignment = NSTextAlignmentRight;
        cellSubTitleLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
        _cellSubTitleLab = cellSubTitleLabel;
        
        UIImageView *rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 26, (45 * BILI_WIDTH - 16)/2, 16, 16)];
        [rightArrow setImage:[UIImage imageNamed:@"right_arrow"]];
        _rightArrow = rightArrow;
        
        self.verifyImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 10-30, (45 * BILI_WIDTH - 30)/2, 30, 30)];
        [_verifyImgView setImage:[UIImage imageNamed:@"TixianVerifyed"]];
        _verifyImgView.hidden = YES;
        
        [self.contentView addSubview:cellTitleLabel];
        [self.contentView addSubview:cellSubTitleLabel];
        [self.contentView addSubview:rightArrow];
        [self.contentView addSubview:_verifyImgView];

        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 45.0 * BILI_WIDTH - 0.5, SCREEN_WIDTH - 10, 0.5)];
        line.backgroundColor = UIColor_GrayLine;
        _sepLine = line;
        [self.contentView addSubview:line];
        
    }
    return self;

}


- (void)setupCellViewIndexPath:(NSIndexPath *)indexPath isBind:(BOOL) isBind isRealNamed:(BOOL)isRealNamed
{
//    isBind既是用来判断是否显示右箭头，也是用来判断时候已提现认证，显示验证图标。VC里的判断不一样而已。
    
    if (indexPath.section == 0 && indexPath.row == 2) {
        _verifyImgView.hidden = YES;
        _rightArrow.hidden = isBind;
        if(shareAppDelegateInstance.boenUserInfo.stuempno.length > 0 && [shareAppDelegateInstance.boenUserInfo.stuempno isEqualToString:@"null"] != YES)
        {
            _cellSubTitleLab.frame = CGRectMake(100, 0, SCREEN_WIDTH - 110, 45 * BILI_WIDTH);
            
        }else{
            _cellSubTitleLab.frame = CGRectMake(100, 0, SCREEN_WIDTH - 110 - 18, 45 * BILI_WIDTH);
        }

    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        _verifyImgView.hidden = !isRealNamed;
        _rightArrow.hidden = isRealNamed;
    }
    else if (indexPath.section == 1 && indexPath.row == 0) {
        if(shareAppDelegateInstance.boenUserInfo.stuempno.length > 0 && [shareAppDelegateInstance.boenUserInfo.stuempno isEqualToString:@"null"] != YES)
        {
            _rightArrow.hidden = !isBind;
            _cellSubTitleLab.frame = CGRectMake(100, 0, SCREEN_WIDTH - 110 - 18, 45 * BILI_WIDTH);
        }
        else {
            _verifyImgView.hidden = !isRealNamed;
            _rightArrow.hidden = isBind;
        }
    }
    else {
        _verifyImgView.hidden = YES;
        _cellSubTitleLab.frame = CGRectMake(100, 0, SCREEN_WIDTH - 110, 45 * BILI_WIDTH);
        _rightArrow.hidden = YES;
    }
}
@end
