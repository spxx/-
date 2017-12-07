//
//  BNYKTHomeListCell.h
//  NewWallet
//
//  Created by mac on 14-10-27.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNYKTHomeListCell : UITableViewCell

typedef void (^CellBtnTapBlock)(NSDictionary *dict);

@property (nonatomic, copy) CellBtnTapBlock cellBtnTapBlock;

- (void)drawData:(NSDictionary *)dict systemError:(BOOL)systemError cellBtnTapBlock:(CellBtnTapBlock)cellBtnTapBlock;

@end
