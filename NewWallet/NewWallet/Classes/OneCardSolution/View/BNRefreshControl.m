//
//  BNRefreshControl.m
//  Wallet
//
//  Created by mac1 on 2016/12/28.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "BNRefreshControl.h"

typedef enum {
    WillRefresh, //即将刷新
    Refreshing,  //刷新中

} RefreshState;

@interface BNRefreshControl ()

@property (nonatomic, weak) BNRefreshView *refreshView;

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, assign) RefreshState state;

@end

@implementation BNRefreshControl


- (void)willMoveToSuperview:(UIView *)newSuperview
{
     if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
    _scrollView = (UIScrollView *)newSuperview;
    _scrollView.alwaysBounceVertical = YES;
    
     [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (instancetype)init
{
    self = [super init];
    if(self){
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    
    BNRefreshView *refreshView = [[BNRefreshView alloc] initWithFrame:CGRectMake(0, -60, SCREEN_WIDTH, 60)];
    refreshView.backgroundColor = UIColor_Gray_BG;
    [self addSubview:refreshView];
    _refreshView = refreshView;
//    [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    

}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{

    if ([keyPath isEqualToString:@"contentOffset"]) {
    
        CGFloat contentOffsetY = _scrollView.contentOffset.y;
        [_refreshView setLabelY:contentOffsetY];
        
        
        if (_scrollView.isDragging) {//拖动中
            self.state = WillRefresh; //设置即将刷新
            
        }else{
            //松手
            if (self.state == WillRefresh && contentOffsetY <= -60) {
                self.state = Refreshing;
            }
        }
        
    }
    
}

- (void)setState:(RefreshState)state
{
    _state = state;
    if (state == WillRefresh) {
        //
    }else if (state == Refreshing){
        [self beginRefresh];
    }
    
}

- (void)beginRefresh
{
    [_refreshView startRotate];
    
    [UIView animateWithDuration:0.5 animations:^{
        UIEdgeInsets inset = _scrollView.contentInset;
        inset.top = 60;
        _scrollView.contentInset = inset;
    }];
    
    
    if ([self.delegate respondsToSelector:@selector(headerRefresh)]){
        [self.delegate headerRefresh]; //代理刷新数据
    }
}

- (void)endRefreshing
{
    [_refreshView removeAnimation];
    
    [UIView animateWithDuration:0.5 animations:^{
        UIEdgeInsets inset = _scrollView.contentInset;
        inset.top = 0;
        _scrollView.contentInset = inset;
    }];
   
    
}



@end




@implementation BNRefreshView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, -10, 100, 4)];
        label.centerXValue = frame.size.width * 0.5;
        label.text = @"— —";
        label.font = [UIFont boldSystemFontOfSize:10];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        [self addSubview:label];
        _refreshLabel = label;
    }
    return self;
}

- (void)setLabelY:(CGFloat)yValue
{
   
    CGRect rect = _refreshLabel.frame;
    CGFloat y = 56 + 0.5 * yValue;
    rect.origin.y = y;
    _refreshLabel.frame = rect;
}

- (void)startRotate
{
    CGRect rect = _refreshLabel.frame;
    rect.origin.y = 28;
    _refreshLabel.frame = rect;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @(0);
    animation.toValue = @(2 * M_PI);
    animation.duration = 0.7;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = YES;
    [_refreshLabel.layer addAnimation:animation forKey:@"ratation"];
    
}

- (void)removeAnimation
{
    [_refreshLabel.layer removeAllAnimations];
}

@end
