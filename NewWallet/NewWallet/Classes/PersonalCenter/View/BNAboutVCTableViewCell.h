//
//  BNAboutVCTableViewCell.h
//  Wallet
//
//  Created by mac on 15/6/4.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNAboutVCTableViewCell : UITableViewCell

@property (nonatomic) UIView *sepLine;

- (void)drawtitleStr:(NSString *)titleStr contentStr:(NSString *)contentStr;

@end
