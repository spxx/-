//
//  BillTableHeadView.h
//  Wallet
//
//  Created by mac1 on 15/2/2.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kHeadViewHeight [BNTools sizeFit:20 six:24 sixPlus:28]

@interface BillTableHeadView : UIView

- (void)setupDataForHeadViewWith:(NSString *)date;

@end
