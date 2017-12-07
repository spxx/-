//
//  LineProgressView.m
//  Layer
//
//  Created by Carver Li on 14-12-1.
//
//


#import "LineProgressView.h"
@interface LineProgressView ()

@property (nonatomic) NSTimer *timer;

@end

@implementation LineProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

+ (Class)layerClass
{
    return [CustomLayer class];
}


//动画
- (void)setCompleted:(int)completed animated:(BOOL)animated
{
    CustomLayer *layer = (CustomLayer *)self.layer;
    if (animated && self.animationDuration > 0.0f)
    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"completed"];
        animation.duration = self.animationDuration;
        animation.fromValue = [NSNumber numberWithFloat:0];
        animation.toValue = [NSNumber numberWithFloat:completed];
        animation.delegate = self;
        [self.layer addAnimation:animation forKey:@"currentAnimation"];
    }

    layer.completed = completed;
    [layer setNeedsDisplay];
}


- (void)setTotal:(int)total
{
    _total = total;
    
    CustomLayer *layer = (CustomLayer *)self.layer;
    layer.total = total;
}


-(void)setCompleted:(int)completed
{
    [self setCompleted:completed animated:NO];
}


- (void)setRadius:(CGFloat)radius
{
    _radius = radius;
    
    CustomLayer *layer = (CustomLayer *)self.layer;
    layer.radius = radius;
}

- (void)setInnerRadius:(CGFloat)innerRadius
{
    _innerRadius = innerRadius;
    
    CustomLayer *layer = (CustomLayer *)self.layer;
    layer.innerRadius = innerRadius;
}

- (void)setStartAngle:(CGFloat)startAngle
{
    _startAngle = startAngle;
    CustomLayer *layer = (CustomLayer *)self.layer;
    layer.startAngle = startAngle;
}

- (void)setEndAngle:(CGFloat)endAngle
{
    _endAngle = endAngle;
    
    CustomLayer *layer = (CustomLayer *)self.layer;
    layer.endAngle = endAngle;
}

- (void)setAnimationDuration:(CFTimeInterval)animationDuration
{
    _animationDuration = animationDuration;
    
    CustomLayer *layer = (CustomLayer *)self.layer;
    layer.animationDuration = animationDuration;
}


- (void)drawRect:(CGRect)rect
{
    
}

@end


