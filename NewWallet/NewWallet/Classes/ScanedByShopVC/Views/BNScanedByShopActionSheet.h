//
//  BNScanedByShopActionSheet.h
//  Wallet
//
//  Created by mac on 2017/2/21.
//  Copyright © 2017年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SelectedRowBlock)(NSInteger selectRow);

@interface BNScanedByShopActionSheet : UIView

@property (copy, nonatomic) SelectedRowBlock selectedBlock;


- (void)appearAnimation;
- (void)disAppearAnimation;

@end
