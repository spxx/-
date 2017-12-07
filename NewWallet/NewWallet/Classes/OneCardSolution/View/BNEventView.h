//
//  BNEventView.h
//  Wallet
//
//  Created by 陈荣雄 on 16/7/1.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EventDelegate <NSObject>

- (void)eventSelected:(id)data;

@end

@interface BNEventView : UIView

@property (weak, nonatomic) id<EventDelegate> delegate;

- (void)setData:(id)data;

@end
