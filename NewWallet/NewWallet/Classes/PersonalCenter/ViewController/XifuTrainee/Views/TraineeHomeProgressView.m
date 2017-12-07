//
//  TraineeHomeProgressView.m
//  Wallet
//
//  Created by mac1 on 15/12/21.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import "TraineeHomeProgressView.h"

@interface TraineeHomeProgressView ()

@property (assign,nonatomic) float changAmount;
@property (assign,nonatomic) float amount;
@property (assign,nonatomic) float valueRatio;

@property (assign,nonatomic) CGFloat progressViewWith;
@property (assign,nonatomic) CGFloat changWith;


@property (nonatomic) CADisplayLink *displayLink;

@property (weak, nonatomic) UILabel *moveLabel;
@property (weak, nonatomic) UIView *progreesView;
@property (weak, nonatomic) UIView *progreesBGView;
@property (weak, nonatomic) UILabel *monthValueLabel;
@property (weak, nonatomic) UIImageView *currentLevelImageView;
@property (weak, nonatomic) UIImageView *nextLevelImageView;


@end

@implementation TraineeHomeProgressView

- (instancetype)initWithFrame:(CGRect)frame currentLevel:(NSString *)currentLevel currentMonthValue:(NSString *)monthValue currentValue:(NSString *)currentValue needValue:(NSString *)
needValue
{
    if (self = [super initWithFrame:frame]) {
        _currentLevel = currentLevel;
        _mothValue = monthValue;
        _currentValue = currentValue;
        _needValue = needValue;
        
        UIImageView *currentLevelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15 * NEW_BILI, 18 * NEW_BILI, 35 * NEW_BILI, 18 * NEW_BILI)];
        currentLevelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"redLV%@",currentLevel]];
        [self addSubview:currentLevelImageView];
        _currentLevelImageView =currentLevelImageView;
        
        UIImageView *nextLevelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50 * NEW_BILI, CGRectGetMinY(currentLevelImageView.frame), CGRectGetWidth(currentLevelImageView.frame), CGRectGetHeight(currentLevelImageView.frame))];
        nextLevelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"redLV%d",currentLevel.intValue + 1]];
        [self addSubview:nextLevelImageView];
        _nextLevelImageView = nextLevelImageView;
        
        UILabel *monthValueLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 150 * NEW_BILI)/2.0, 21 * NEW_BILI, 150 * NEW_BILI, 12 * NEW_BILI)];
        monthValueLabel.text = [NSString stringWithFormat:@"本月获得经验值 %@",monthValue];
        monthValueLabel.font = [UIFont systemFontOfSize:13 * NEW_BILI];
        monthValueLabel.textColor = UIColorFromRGB(0xaec0c9);
        monthValueLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:monthValueLabel];
        _monthValueLabel = monthValueLabel;
        
        UIView *progreesBGView = [[UIView alloc] initWithFrame:CGRectMake(15 * NEW_BILI, 41 * NEW_BILI, SCREEN_WIDTH - 30 * NEW_BILI, 10 * NEW_BILI)];
        progreesBGView.backgroundColor = UIColorFromRGB(0xffe4ea);
        [self addSubview:progreesBGView];
        _progreesBGView = progreesBGView;
        
        UIView *progreesView = [[UIView alloc] init];
        progreesView.backgroundColor = [UIColor colorWithRed:252/255.0 green:144/255.0 blue:172/255.0 alpha:1.0f];
        [self addSubview:progreesView];
        _progreesView = progreesView;
        
        UILabel *moveLabel = [[UILabel alloc] init];
        moveLabel.textColor = UIColorFromRGB(0x8a9aa2);
        moveLabel.font = [UIFont systemFontOfSize:13 * NEW_BILI];
        [self addSubview:moveLabel];
        _moveLabel = moveLabel;
        
        _valueRatio = currentValue.floatValue/needValue.floatValue;
       
        _amount = currentValue.floatValue;
        _progressViewWith = CGRectGetWidth(progreesBGView.frame) * _valueRatio;
    }
    
    return self;
}
- (void)startAnimation
{
    _changAmount = 0.0;
    _changWith = 0.0;
    if (_displayLink == nil) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction:)];
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                               forMode:NSDefaultRunLoopMode];
    }

}

- (void)displayLinkAction:(CADisplayLink *)displayLink
{
    if (_changAmount < _amount && _changWith < _progressViewWith) {
        _changAmount = _changAmount + _amount/60.0;
        _changWith = _changWith + _progressViewWith/60.0;
    }else{
        _changAmount = _amount;
        _changWith = _progressViewWith;
        [_displayLink invalidate];
        _displayLink = nil;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _progreesView.frame = CGRectMake(15 * NEW_BILI, CGRectGetMinY(_progreesBGView.frame), _changWith, CGRectGetHeight(_progreesBGView.frame));//progress动画
        
        _moveLabel.text = [NSString stringWithFormat:@"%.0f/%@",_changAmount,_needValue];
        NSAttributedString *moveAtts = [[NSAttributedString alloc] initWithString:_moveLabel.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13 * NEW_BILI]}];
        CGFloat moveLabelWidth = moveAtts.size.width;//移动label的宽,label上的文字有可能3位数或2位数，所以需要动态计算宽度。
        CGFloat moveLabelX = _changWith > moveLabelWidth/2.0 ? 15 * NEW_BILI + _changWith - moveLabelWidth/2.0 : 15.0 * NEW_BILI; //_changWith最终也就是_progressViewWith 换算成label需要加加上离屏幕左边的15再减去label宽的一半。
        if ((moveLabelX + moveLabelWidth) >= CGRectGetMaxX(_progreesBGView.frame)) {//与_progreesBGView右对齐
            moveLabelX = CGRectGetMaxX(_progreesBGView.frame) - moveLabelWidth;
        }
        
        _moveLabel.frame = CGRectMake(moveLabelX, CGRectGetMaxY(_progreesBGView.frame) + 8, moveLabelWidth, 14 * NEW_BILI);
        
    });
}

- (void)setCurrentLevel:(NSString *)currentLevel
{
    _currentLevel = currentLevel;
    _currentLevelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"redLV%@",currentLevel]];
    _nextLevelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"redLV%d",currentLevel.intValue + 1]];
}

- (void)setMothValue:(NSString *)mothValue
{
    _mothValue = mothValue;
    _monthValueLabel.text = [NSString stringWithFormat:@"本月获得经验值 %@",mothValue];
}

- (void)setCurrentValue:(NSString *)currentValue
{
    _currentValue = currentValue;
    ;
    
    _amount = currentValue.floatValue;
   
    
}
- (void)setNeedValue:(NSString *)needValue
{
    _needValue = needValue;
    _valueRatio = _currentValue.floatValue/needValue.floatValue;
    _progressViewWith = CGRectGetWidth(_progreesBGView.frame) * _valueRatio;
}

@end
