//
//  GesturePasswordView.h
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//

@protocol GesturePasswordDelegate <NSObject>

- (void)forget;
- (void)change;
- (void)ignore;

@end

#import <UIKit/UIKit.h>
#import "TentacleView.h"

@interface GesturePasswordView : UIView<TouchBeginDelegate>

@property (nonatomic,strong) TentacleView * tentacleView;

@property (nonatomic,strong) UILabel * state;

@property (nonatomic,assign) id<GesturePasswordDelegate> gesturePasswordDelegate;

@property (nonatomic,strong) UILabel * name;
@property (nonatomic,strong) UIImageView * imgView;
@property (nonatomic,strong) UIButton * forgetButton;
@property (nonatomic,strong) UIButton * changeButton;
@property (nonatomic,strong) UIButton * ignoreButton;
@property (nonatomic,strong) UIView * lineView;

- (void)enterArgin;

@end
