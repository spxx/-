//
//  BNSideMenuView.m
//  Wallet
//
//  Created by 陈荣雄 on 2016/12/27.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "BNSideMenuView.h"

@interface BNSideMenuView () <SideMenuDelegate>

@property (weak, nonatomic) UIButton *closeButton;

@property (strong, nonatomic) BNSideMenuViewController *sideMenuVC;

@end

@implementation BNSideMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        closeButton.frame = CGRectMake(SCREEN_WIDTH, (SCREEN_HEIGHT-40)/2, 40, 40);
        [closeButton setImage:[UIImage imageNamed:@"sidemenu_arrow"] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeTapped) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:closeButton];
        self.closeButton = closeButton;
        
        self.hidden = YES;
        
        
        BNSideMenuViewController *sideMenuVC = [[BNSideMenuViewController alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 20, SCREEN_WIDTH-75, SCREEN_HEIGHT-20*2)];
        sideMenuVC.delegate = self;
        
        [self addSubview:sideMenuVC];
        self.sideMenuVC = sideMenuVC;
        
        [sideMenuVC reset];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:sideMenuVC.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(5, 5)];
        maskLayer.path = path.CGPath;
        sideMenuVC.layer.mask = maskLayer;
    }
    return self;
}

- (void)setMenu:(NSArray *)menus {
    [self.sideMenuVC setMenus:menus];
}

- (void)show {
    self.hidden = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    }];
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
    self.closeButton.centerXValue = SCREEN_WIDTH+20;
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.closeButton.centerXValue = 15+20;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.closeButton.transform = CGAffineTransformRotate(self.closeButton.transform, -(M_PI/180.0)*179.999);
        } completion:^(BOOL finished) {
            
        }];
    }];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.sideMenuVC.center = CGPointMake((SCREEN_WIDTH-75)/2+75, SCREEN_HEIGHT/2);
    } completion:^(BOOL finished) {
        
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        
    } completion:^(BOOL finished) {
        [self.sideMenuVC reloadData];
    }];
}

- (void)dismiss {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.sideMenuVC.center = CGPointMake(SCREEN_WIDTH+self.sideMenuVC.widthValue/2, SCREEN_HEIGHT/2);
    } completion:^(BOOL finished) {
        [self.sideMenuVC reset];
    }];
    
    
    [UIView animateWithDuration:0.5 animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.closeButton.centerXValue = SCREEN_WIDTH+20;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        self.closeButton.transform = CGAffineTransformIdentity;
    }];
}

- (void)closeTapped {
    
    [self dismiss];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (touch.view == self.sideMenuVC) {
        return;
    }

    [self dismiss];
}

- (void)menuSelected:(NSDictionary *)data {
    if (self.delegate) {
        [self.delegate menuSelected:data];
    }
}

@end
