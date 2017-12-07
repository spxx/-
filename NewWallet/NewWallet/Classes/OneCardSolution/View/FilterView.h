//
//  FilterView.h
//  Wallet
//
//  Created by mac1 on 15/2/2.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FILTER_BTN_TAG_BASE 20

@protocol FilterDelegate <NSObject>

- (void)filterSelectedIndex:(NSInteger)index;
@end

@interface FilterView : UIView

@property (assign, nonatomic) BOOL filterIsShowing;
@property (weak, nonatomic) id<FilterDelegate> delegate;

- (id)initWithFilterNames:(NSArray *) names relativeView:(UIView *) relativeView;

- (void)filterShow;

- (void)filterHidden;
@end
