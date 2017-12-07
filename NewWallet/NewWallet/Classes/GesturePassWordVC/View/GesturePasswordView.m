//
//  GesturePasswordView.m
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//

#import "GesturePasswordView.h"
#import "GesturePasswordButton.h"
#import "TentacleView.h"

@implementation GesturePasswordView {
    NSMutableArray * buttonArray;
    
    CGPoint lineStartPoint;
    CGPoint lineEndPoint;
    
}
@synthesize imgView;
@synthesize forgetButton;
@synthesize lineView;
@synthesize changeButton;
@synthesize ignoreButton;
@synthesize tentacleView;
@synthesize state;
@synthesize name;
@synthesize gesturePasswordDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        buttonArray = [[NSMutableArray alloc]initWithCapacity:0];
        CGFloat beginY = frame.size.height/2-30;
        CGFloat addFont = 0;
        BNLog(@"SCREEN_WIDTH--%f",SCREEN_WIDTH);
        if (SCREEN_WIDTH == 414) {
            //6 plus
            addFont = 3;
            beginY = frame.size.height/2-100;
        } else if (SCREEN_WIDTH == 375) {
            //6
            addFont = 2;
            beginY = frame.size.height/2-80;
        } else if (SCREEN_HEIGHT == 568) {
            //5
            beginY = frame.size.height/2-60;
        }
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, beginY, SCREEN_WIDTH, SCREEN_WIDTH)];
        for (int i=0; i<9; i++) {
            NSInteger row = i/3;
            NSInteger col = i%3;
            // Button Frame
            
            NSInteger size = 55;
            NSInteger margin = 51;//边距
            NSInteger distance = (view.frame.size.width - 2*margin - 3*size)/2;

            GesturePasswordButton * gesturePasswordButton = [[GesturePasswordButton alloc]initWithFrame:CGRectMake(col*(distance+size)+margin, row*(distance+size), size, size)];
            [gesturePasswordButton setTag:i];
            [view addSubview:gesturePasswordButton];
            [buttonArray addObject:gesturePasswordButton];
        }
        frame.origin.y=0;
        tentacleView = [[TentacleView alloc]initWithFrame:view.frame];
        [tentacleView setButtonArray:buttonArray];
        [tentacleView setTouchBeginDelegate:self];
        [self addSubview:tentacleView];
        
        view.userInteractionEnabled = NO;
        [self addSubview:view]; //view在tentacleView之上，可挡住滑动手指时从button中经过的线条。

        name = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/2-140, 156, 280, 30)];
        [name setTextAlignment:NSTextAlignmentCenter];
        [name setFont:[UIFont systemFontOfSize:16.f+addFont]];
        name.textColor = UIColorFromRGB(0xa0a0a0);
        name.backgroundColor = [UIColor clearColor];
        [self addSubview:name];
        
        state = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/2-140, 191, 280, 30)];
        [state setTextAlignment:NSTextAlignmentCenter];
        [state setFont:[UIFont systemFontOfSize:13.f+addFont]];
        state.backgroundColor = [UIColor clearColor];
        [self addSubview:state];

        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width/2-35, 74, 70, 70)];
        [imgView setBackgroundColor:[UIColor whiteColor]];
        [imgView.layer setCornerRadius:35];
        imgView.layer.masksToBounds = YES;
        imgView.image = [UIImage imageNamed:@"HomeVC_HeadBtn"];
        [self addSubview:imgView];
        
        forgetButton = [[UIButton alloc]initWithFrame:CGRectMake(43*BILI_WIDTH, frame.size.height-50, 120*BILI_WIDTH, 30)];
        [forgetButton.titleLabel setFont:[UIFont systemFontOfSize:13+addFont]];
        [forgetButton setTitleColor:UIColorFromRGB(0xa0a0a0) forState:UIControlStateNormal];
        [forgetButton setTitleColor:UIColorFromRGB(0xd0d0d0) forState:UIControlStateHighlighted];
        [forgetButton setTitle:@"忘记手势密码" forState:UIControlStateNormal];
        forgetButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [forgetButton addTarget:self action:@selector(forget) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:forgetButton];
        
        lineView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(forgetButton.frame)+10*BILI_WIDTH, frame.size.height-50+(30-(13+addFont))/2, 1, 13+addFont)];
        lineView.backgroundColor = UIColorFromRGB(0xa0a0a0);
        [self addSubview:lineView];
        
        changeButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView.frame)+10*BILI_WIDTH, frame.size.height-50, 120*BILI_WIDTH, 30)];
        [changeButton.titleLabel setFont:[UIFont systemFontOfSize:13+addFont]];
        [changeButton setTitleColor:UIColorFromRGB(0xa0a0a0) forState:UIControlStateNormal];
        [changeButton setTitleColor:UIColorFromRGB(0xd0d0d0) forState:UIControlStateHighlighted];
        [changeButton setTitle:@"切换账号" forState:UIControlStateNormal];
        changeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [changeButton addTarget:self action:@selector(change) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:changeButton];
        
        ignoreButton = [[UIButton alloc]initWithFrame:CGRectMake(0, frame.size.height-50, frame.size.width, 30)];
        [ignoreButton.titleLabel setFont:[UIFont systemFontOfSize:13+addFont]];
        ignoreButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [ignoreButton setTitleColor:UIColorFromRGB(0xa0a0a0) forState:UIControlStateNormal];
        [ignoreButton setTitleColor:UIColorFromRGB(0xd0d0d0) forState:UIControlStateHighlighted];
        [ignoreButton setTitle:@"暂不设置" forState:UIControlStateNormal];
        [ignoreButton addTarget:self action:@selector(ignore) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:ignoreButton];
    }
    
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGFloat colors[] =
    {
        255.0 / 255.0, 255.0 / 255.0, 255.0 / 255.0, 1.00,  //UIColor_NewBlueColor
        255.0 / 255.0,  255.0 / 255.0, 255.0 / 255.0, 1.00, //UIColor_NewBlueColor
    };
    CGGradientRef gradient = CGGradientCreateWithColorComponents
    (rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
    CGColorSpaceRelease(rgb);
    CGContextDrawLinearGradient(context, gradient,CGPointMake
                                (0.0,0.0) ,CGPointMake(0.0,self.frame.size.height),
                                kCGGradientDrawsBeforeStartLocation);
}

- (void)gestureTouchBegin {
//    [self.state setText:@""];
}

-(void)forget{
    [gesturePasswordDelegate forget];
}

-(void)change{
    [gesturePasswordDelegate change];
}
- (void)ignore
{
    [gesturePasswordDelegate ignore];
}
- (void)enterArgin
{
    //清除输入的内容
    [self performSelector:@selector(enterArginTentacleView) withObject:nil afterDelay:.5];
}
- (void)enterArginTentacleView
{
    [tentacleView enterArgin];
}

@end
