//
//  BNScanedByShopPayWaySelectView.h
//  Wallet
//
//  Created by mac on 2017/2/21.
//  Copyright © 2017年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SelectedBlock)(NSDictionary *payWayItem);

@interface BNScanedByShopPayWaySelectView : UIView

@property (copy, nonatomic) SelectedBlock selectedBlock;

-(void)setPayWayArray:(NSArray *)payWayArray andSelectItem:(NSDictionary *)selectItem;

- (void)appearAnimation;
- (void)disAppearAnimation;

@end
