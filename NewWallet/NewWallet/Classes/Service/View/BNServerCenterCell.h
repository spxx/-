//
//  BNServerCenterCell.h
//  NewWallet
//
//  Created by cyjjkz1 on 14-11-10.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNServerCenterCell : UITableViewCell

- (void)drawDataWithIcon:(UIImage *)icon title:(NSString *)title latestNewsTitle:(NSString *)latestTitle countNews:(NSInteger) count;

@end
