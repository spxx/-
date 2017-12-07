//
//  BNScanedByShopChangePayListCell.m
//  Wallet
//
//  Created by mac on 2017/2/21.
//  Copyright © 2017年 BNDK. All rights reserved.
//

#import "BNScanedByShopChangePayListCell.h"


@interface BNScanedByShopChangePayListCell ()


@end
@implementation BNScanedByShopChangePayListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0,SCREEN_WIDTH, 48*NEW_BILI)];
        titleLabel.textColor = UIColor_NewBlack_Text;
       // titleLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
        titleLabel.font = [UIFont systemFontOfSize:14*NEW_BILI];
        [self.contentView addSubview:titleLabel];

        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 48*NEW_BILI - 0.5, SCREEN_WIDTH - 2*15, 0.5)];
        line.backgroundColor = UIColor_GrayLine;
        [self.contentView addSubview:line];
        
        self.tintColor = UIColorFromRGB(0x8bc7e4);

        _titleLabel = titleLabel;

    }
    return self;
}


- (void)drawData:(NSDictionary *) cellInfo
{
    _titleLabel.text = [NSString stringWithFormat:@"%@", [cellInfo valueWithNoDataForKey:@"name"]];

}
- (void) setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing: editing animated: YES];
    
    if (editing) {
        
        for (UIView * view in self.subviews) {
            if ([NSStringFromClass([view class]) rangeOfString: @"Reorder"].location != NSNotFound) {
                for (UIView * subview in view.subviews) {
                    if ([subview isKindOfClass: [UIImageView class]]) {
                        subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y, 26, 24);
                        ((UIImageView *)subview).image = [UIImage imageNamed:@"BNScanedByShopVC_move_Icon.png"];
                    }
                }
            }
        }
    }   
}
@end
