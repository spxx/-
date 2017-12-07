//
//  RechargeGridView.h
//  Wallet
//
//  Created by 陈荣雄 on 15/12/16.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RechargeItem : NSObject

@property (strong, nonatomic) NSString *productID;
@property (strong, nonatomic) NSString *productName;
@property (assign, nonatomic) CGFloat parprice;
@property (assign, nonatomic) CGFloat salePrice;

@end

@interface RechargeItemView : UIView

@property (assign, nonatomic) BOOL enable;

@property (strong, nonatomic) RechargeItem *item;

@property (assign, nonatomic) BOOL selected;

@end

@protocol RechargeGridViewDelegate <NSObject>

- (void)rechargeItemSelected:(RechargeItem *)item;

@end

@interface RechargeGridView : UIView

@property (assign, nonatomic) BOOL enable;

@property (weak, nonatomic) id<RechargeGridViewDelegate> delegate;

@property (strong, nonatomic) NSArray<RechargeItem *> *items;

@end
