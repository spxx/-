//
//  OneCardNumCell.h
//  NewWallet
//
//  Created by mac1 on 14-10-28.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OneCardNumCellDelegate <NSObject>

- (void)deleteButtonTapedAtRow:(NSInteger)row;

@end

@interface OneCardNumCell : UITableViewCell
@property (weak, nonatomic) id <OneCardNumCellDelegate> delegate;
@property (nonatomic) NSInteger row;
@property (weak, nonatomic) UILabel *bindStrLabel;
@property (weak, nonatomic) UIButton *deleteButton;
@property (weak, nonatomic) UILabel *cellTitleLabel;

@end
