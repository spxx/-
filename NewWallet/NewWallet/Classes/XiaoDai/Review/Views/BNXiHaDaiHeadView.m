//
//  BNXiHaDaiHeadView.m
//  Wallet
//
//  Created by mac1 on 15/4/30.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNXiHaDaiHeadView.h"

@interface BNXiHaDaiHeadView ()

@property (strong, nonatomic) NSAttributedString *amountTitle;
@property (strong, nonatomic) NSAttributedString *spendTitle;
@property (strong, nonatomic) NSAttributedString *leftTitle;



@property (assign, nonatomic) CGFloat changeAmount;
@property (assign, nonatomic) CGFloat changespend;
@property (assign, nonatomic) CGFloat changeLeft;

@property (strong, nonatomic) CADisplayLink *displayLink;

@property (assign, nonatomic) BOOL amountAnimitionFinish;
@property (assign, nonatomic) BOOL spendAnimitionFinish;
@property (assign, nonatomic) BOOL leftAnimitionFinish;

@property (strong, nonatomic) NSDictionary *amountAttri;
@property (strong, nonatomic) NSDictionary *spendAttri;
@property (strong, nonatomic) NSDictionary *leftAttri;
@end

@implementation BNXiHaDaiHeadView

- (instancetype)initWithFrame:(CGRect)frame amount:(CGFloat) amount hasSpend:(CGFloat)spend leftAmount:(CGFloat) left
{
    self = [super initWithFrame:frame];
    
    if (self) {
       _amountTitle = [[NSAttributedString alloc] initWithString:@"授信额度 (元)" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]], NSForegroundColorAttributeName:[UIColor whiteColor]}];
       _spendTitle  = [[NSAttributedString alloc] initWithString:@"已用金额 (元)" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]], NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
       _leftTitle   = [[NSAttributedString alloc] initWithString:@"可用金额 (元)" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]], NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
        
        _amount = amount;
        _spend  = spend;
        _left   = left;
        
        _amountAttri = @{NSFontAttributeName:[UIFont systemFontOfSize:[BNTools sizeFit:64 six:74 sixPlus:84]], NSForegroundColorAttributeName:[UIColor whiteColor]};
        _spendAttri  = @{NSFontAttributeName:[UIFont systemFontOfSize:[BNTools sizeFit:24 six:28 sixPlus:32]], NSForegroundColorAttributeName:[UIColor blackColor]};
        _leftAttri   = @{NSFontAttributeName:[UIFont systemFontOfSize:[BNTools sizeFit:24 six:28 sixPlus:32]], NSForegroundColorAttributeName:[UIColor blackColor]};
    }
    return self;
    
}

- (void)startAnimition
{
    _changeAmount = .0;
    _changespend  = .0;
    _changeLeft   = .0;
    
    _amountAnimitionFinish = NO;
    _spendAnimitionFinish  = NO;
    _leftAnimitionFinish   = NO;
    
    [self.displayLink invalidate];
    self.displayLink = nil;
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                           forMode:NSDefaultRunLoopMode];
    
}

- (void)displayLinkAction:(CADisplayLink *)disLink
{
    if (_changeAmount < _amount) {
        _changeAmount = _changeAmount + _amount/60.0;
    }else{
        _amountAnimitionFinish = YES;
    }
    
    if (_changespend < _spend) {
        _changespend = _changespend + _spend / 60;
    }else{
        _spendAnimitionFinish  = YES;
        
    }
    if (_changeLeft < _left) {
        _changeLeft = _changeLeft + _left / 60.0;
    }else{
        _leftAnimitionFinish   = YES;
    }
    if (_amountAnimitionFinish == YES && _leftAnimitionFinish == YES && _spendAnimitionFinish == YES) {
        [self stopAnimition];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
    });
}

- (void)stopAnimition
{
    _changeAmount = _amount;
    _changespend  = _spend;
    _changeLeft   = _left;
    
    [self.displayLink invalidate];
    self.displayLink = nil;
    
    //屏蔽“您有%li笔借款已经逾期。。。”的TipsView
//    if ([self.delegate respondsToSelector:@selector(xiHaDaiHeadAnimitionStoped)]) {
//        [self.delegate xiHaDaiHeadAnimitionStoped];
//    }
}
- (void)drawRect:(CGRect)rect
{
    
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    [[UIColor whiteColor] setFill];

    NSString *theCAmount = [NSString stringWithFormat:@"%.2f", _changeAmount];
    CGSize amoutSize = [[UIFont systemFontOfSize:[BNTools sizeFit:64 six:74 sixPlus:84]] useThisFontWithString:theCAmount];
    NSAttributedString *theChangeAmountStr = [[NSAttributedString alloc] initWithString:theCAmount attributes:self.amountAttri];

    NSString *theSpend = [NSString stringWithFormat:@"%.2f", _changespend];
    NSString *theLeft = [NSString stringWithFormat:@"%.2f", _changeLeft];
    
    NSAttributedString *theSpendStr = [[NSAttributedString alloc] initWithString:theSpend attributes:self.spendAttri];
    NSAttributedString *theleftStr  = [[NSAttributedString alloc] initWithString:theLeft  attributes:self.leftAttri];
    

    CGContextSaveGState(currentContext);

    [_amountTitle drawInRect:CGRectMake(20, kSectionHeight, _amountTitle.size.width + 1, _amountTitle.size.height + 1)];
    
    [[UIColor whiteColor] setFill];
    
    [theChangeAmountStr drawInRect:CGRectMake(20, kSectionHeight + 24.0 + (CGRectGetHeight(self.frame) * kInfoBiLi - kSectionHeight - 24.0 - amoutSize.height)/2.0, theChangeAmountStr.size.width + 1, theChangeAmountStr.size.height + 1)];
    
    CGContextRestoreGState(currentContext);
    
    
    CGContextSaveGState(currentContext);
    CGContextSetLineWidth(currentContext, 1);
    CGContextMoveToPoint(currentContext, SCREEN_WIDTH/2.0, CGRectGetHeight(self.frame) * kInfoBiLi + 20.0);
    CGContextAddLineToPoint(currentContext, SCREEN_WIDTH/2.0, CGRectGetHeight(self.frame) - 20);
    [UIColorFromRGB(0xeaeaea) setStroke];
    CGContextStrokePath(currentContext);
    CGContextRestoreGState(currentContext);
    
    
    CGContextSaveGState(currentContext);
    
    [_spendTitle drawInRect:CGRectMake(20, CGRectGetHeight(self.frame) * kInfoBiLi + 20.0, _spendTitle.size.width + 1, _spendTitle.size.height + 1)];
    
    [_leftTitle drawInRect:CGRectMake(SCREEN_WIDTH - 20 - _leftTitle.size.width - 1, CGRectGetHeight(self.frame) * kInfoBiLi + 20.0, _leftTitle.size.width + 1, _leftTitle.size.height + 1)];
    
    CGContextRestoreGState(currentContext);
    
    
    CGContextSaveGState(currentContext);
    
    CGFloat originY = CGRectGetHeight(self.frame) * kInfoBiLi + 20.0 + 24.0 + ((CGRectGetHeight(self.frame) * (1-kInfoBiLi)-40) - 24 - theSpendStr.size.height)/2.0;
    [theSpendStr drawInRect:CGRectMake(20.0, originY, theSpendStr.size.width + 1, theSpendStr.size.height + 1)];
    [theleftStr drawInRect:CGRectMake(SCREEN_WIDTH - 20 - theleftStr.size.width -1, originY, theleftStr.size.width + 1, theleftStr.size.height + 1)];
    CGContextRestoreGState(currentContext);
    
}
@end
