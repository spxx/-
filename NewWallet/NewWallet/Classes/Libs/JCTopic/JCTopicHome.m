//
//  JCTopic.m
//  Helome
//
//  Created by XuEric on 14-4-9.
//  Copyright (c) 2014年 helome.com. All rights reserved.
//

#import "JCTopicHome.h"
#import "UIImageView+WebCache.h"

@implementation JCTopicHome

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self setSelf];
    }
    return self;
}
-(void)setSelf{
    self.pagingEnabled = YES;
    self.scrollEnabled = YES;
    _showPageControl = YES;
    self.delegate = self;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = NO;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self setSelf];
    
    // Drawing code
}
-(void)upDate{
    NSMutableArray * tempImageArray = [[NSMutableArray alloc]init];
    
    [tempImageArray addObject:[self.pics lastObject]];
    for (id obj in self.pics) {
        [tempImageArray addObject:obj];
    }
    [tempImageArray addObject:[self.pics objectAtIndex:0]];
    self.pics = nil;
    self.pics = tempImageArray;
    
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            [subView removeFromSuperview];
        }
    }
    
    int i = 0;
    
    
    if (self.pics.count == 3) {//只有一张图片情况
        NSDictionary *obj = [self.pics firstObject];
        pic= nil;
        pic = [UIButton buttonWithType:UIButtonTypeCustom];
        pic.imageView.contentMode = UIViewContentModeTop;
        CGFloat bannerWidth = SCREEN_WIDTH;
        [pic setFrame:CGRectMake(i*self.frame.size.width,0, bannerWidth, self.frame.size.height)];
        UIImageView * tempImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bannerWidth, pic.frame.size.height)];
        tempImage.backgroundColor = [UIColor clearColor];
        tempImage.contentMode = UIViewContentModeScaleToFill;
        [tempImage setClipsToBounds:YES];
        if ([[obj objectForKey:@"isLoc"] boolValue]) {
            [tempImage setImage:[obj objectForKey:@"pic"]];
        }else{
            //方法1.用SDWebImage加载
            NSString *imgStr = [obj objectForKey:@"pic"];
            imgStr = [imgStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [tempImage sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"Home_TopBaner"] completed:nil];
        }
        [pic addSubview:tempImage];
        [pic setBackgroundColor:[UIColor clearColor]];
        pic.tag = 0;
        [pic addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:pic];
    } else {
        for (id obj in self.pics) {
            pic= nil;
            pic = [UIButton buttonWithType:UIButtonTypeCustom];
            pic.imageView.contentMode = UIViewContentModeTop;
            CGFloat bannerWidth = floorf(350*NEW_BILI);
            [pic setFrame:CGRectMake(i*self.frame.size.width,0, self.frame.size.width, self.frame.size.height)];
            UIImageView * tempImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bannerWidth, pic.frame.size.height)];
            tempImage.backgroundColor = [UIColor clearColor];
            tempImage.contentMode = UIViewContentModeScaleToFill;
            [tempImage setClipsToBounds:YES];
            if ([[obj objectForKey:@"isLoc"]boolValue]) {
                [tempImage setImage:[obj objectForKey:@"pic"]];
            }else{
                //方法1.用SDWebImage加载
                NSString *imgStr = [obj objectForKey:@"pic"];
                imgStr = [imgStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [tempImage sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"Home_TopBaner"] completed:nil];
                
                //方法2.用NSURLConnection加载
                //            if ([obj objectForKey:@"placeholderImage"]) {
                //                [tempImage setImage:[obj objectForKey:@"placeholderImage"]];
                //            }
                //            [NSURLConnection sendAsynchronousRequest:[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[obj objectForKey:@"pic"]]]
                //                                               queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                //                                                   NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                //                                                   if (!error && responseCode == 200) {
                //                                                       tempImage.image = Nil;
                //                                                       UIImage *_img = [[UIImage alloc] initWithData:data];
                //                                                       [tempImage setImage:_img];
                //                                                   }else{
                //                                                       if ([obj objectForKey:@"placeholderImage"]) {
                //                                                           [tempImage setImage:[obj objectForKey:@"placeholderImage"]];
                //                                                       }
                //                                                   }
                //                                               }];
            }
            [pic addSubview:tempImage];
            [pic setBackgroundColor:[UIColor clearColor]];
            pic.tag = i;
            [pic addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:pic];
            
            if ([[obj allKeys] containsObject:@"title"]) {
                UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(i*self.frame.size.width, self.frame.size.height-30, self.frame.size.width,30)];
                [title setBackgroundColor:[UIColor blackColor]];
                [title setAlpha:.7f];
                [title setText:[NSString stringWithFormat:@" %@",[obj objectForKey:@"title"]]];
                [title setTextColor:[UIColor whiteColor]];
                [title setFont:[UIFont fontWithName:@"Helvetica" size:12]];
                [self addSubview:title];
            }
            
            i ++;
        }
    }
    
    if (_showPageControl) {
        if (self.pageControl) {
            [self.superview addSubview:_pageControl];
            /*加在self.superview上面，不随scrollview滚动。所以初始化的时候顺序要
             [self.view addSubview:_Topic];
             [_Topic upDate];*/ //才有superView，pageControl才能显示。
        }
    }

    //判断1张时不滚动。
    if (self.pics.count == 3) {
        [self setContentSize:CGSizeMake(SCREEN_WIDTH, self.frame.size.height)];
        [self setContentOffset:CGPointMake(0, 0) animated:NO];
        self.scrollEnabled = NO;
    } else {
        [self setContentSize:CGSizeMake(self.frame.size.width*(([self.pics count]>3) ? [self.pics count] : 1), self.frame.size.height)];
        [self setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
        self.scrollEnabled = YES;
    }
    
    if (scrollTimer) {
        [scrollTimer invalidate];
        scrollTimer = nil;
        
    }
    if ([self.pics count]>3) {
        scrollTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(scrollTopic) userInfo:nil repeats:YES];
    }
}
-(void)click:(id)sender{
    UIButton *button = sender;
    if ([self.JCdelegate respondsToSelector:@selector(didClick:)]) {
        [self.JCdelegate didClick:[self.pics objectAtIndex:[button tag]]];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_pics.count == 3) {
        self.contentOffset = CGPointMake(0, 0);
        [self currentPage:0 total:[self.pics count]-2];
        return ;
    }
    CGFloat Width=self.frame.size.width;
    if (scrollView.contentOffset.x == self.frame.size.width) {
        flag = YES;
    }
    if (flag) {
        if (scrollView.contentOffset.x <= 0) {
            [self setContentOffset:CGPointMake(Width*([self.pics count]-2), 0) animated:NO];
        }else if (scrollView.contentOffset.x >= Width*([self.pics count]-1)) {
            [self setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
        }
    }
    currentPage = scrollView.contentOffset.x/self.frame.size.width-1;
    if (_showPageControl) {
        [self currentPage:currentPage total:[self.pics count]-2];
    }
    scrollTopicFlag = currentPage+2==2?2:currentPage+2;
}
-(void)currentPage:(int)page total:(NSUInteger)total
{
    _pageControl.numberOfPages = total;
    _pageControl.currentPage = page;
}
-(void)scrollTopic{
    [self setContentOffset:CGPointMake(self.frame.size.width*scrollTopicFlag, 0) animated:YES];
    
    if (scrollTopicFlag > [self.pics count]) {
        scrollTopicFlag = 1;
    }else {
        scrollTopicFlag++;
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    scrollTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(scrollTopic) userInfo:nil repeats:YES];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollTimer) {
        [scrollTimer invalidate];
        scrollTimer = nil;
    }
    
}
-(void)releaseTimer{
    if (scrollTimer) {
        [scrollTimer invalidate];
        scrollTimer = nil;
        
    }
}

@end
