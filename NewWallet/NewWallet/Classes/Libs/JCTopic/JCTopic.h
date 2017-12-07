//
//  JCTopic.h
//  Helome
//
//  Created by XuEric on 14-4-9.
//  Copyright (c) 2014年 helome.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JCTopicDelegate<NSObject>
@optional
-(void)didClick:(id)data;

@end

@interface JCTopic : UIScrollView<UIScrollViewDelegate>{
    UIButton * pic;
    bool flag;
    int scrollTopicFlag;
    NSTimer * scrollTimer;
    int currentPage;
    CGSize imageSize;
    UIImage *image;
}
@property(nonatomic) NSArray * pics;
@property(nonatomic) BOOL showPageControl;
@property(nonatomic) UIPageControl *pageControl;

@property(nonatomic,weak)id<JCTopicDelegate> JCdelegate;

-(void)releaseTimer;
-(void)upDate;
@end




/*pageControl是加在self.superview上面，不随scrollview滚动。所以初始化的时候顺序要
 [self.view addSubview:_Topic];
 [_Topic upDate];*/ //才有superView，pageControl才能显示。 pageControl的属性也可在外面重新设置。

/*记得在viewWillDisappear中停止timer。
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    //停止自己滚动的timer
    [_Topic releaseTimer];
}
*/