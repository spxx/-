//
//  BNServerCardView.h
//  Wallet
//
//  Created by 陈荣雄 on 16/7/8.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CardStyleTitle,
    CardStyleTitleAndSubtitle,
} CardStyle;

@protocol CardViewDelegate <NSObject>

- (void)cardSelected:(NSDictionary *)data;

@end

@interface BNServerCardView : UIView

- (instancetype)initWithFrame:(CGRect)frame style:(CardStyle)style;

@property (weak, nonatomic) id<CardViewDelegate> delegate;

- (void)setData:(NSDictionary *)data;

@end
