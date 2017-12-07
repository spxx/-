//
//  BNHomeDropView.h
//  Wallet
//
//  Created by mac1 on 2017/2/20.
//  Copyright © 2017年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BNHomeDropViewDelegate <NSObject>

@optional

//选择了某一行 index 从0开始
- (void)homeDropViewSelectItemIndex:(NSInteger)index;


@end

@interface BNHomeDropView : UIView


@property (nonatomic, weak) id<BNHomeDropViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items;

//- (void)show;

@end
