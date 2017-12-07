//
//  BNRefreshControl.h
//  Wallet
//
//  Created by mac1 on 2016/12/28.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RefreshDelegate <NSObject>

@optional
- (void)headerRefresh;

@end

@interface BNRefreshControl : UIView

- (void)endRefreshing;

@property (nonatomic, weak) id<RefreshDelegate>delegate;

@end


@interface BNRefreshView : UIView

@property (nonatomic, weak) UILabel *refreshLabel;
- (void)setLabelY:(CGFloat)yValue;
- (void)startRotate;
- (void)removeAnimation;

@end
