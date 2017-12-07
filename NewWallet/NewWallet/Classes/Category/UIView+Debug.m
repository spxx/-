//
//  UIView+Debug.m
//  Pray
//
//  Created by Tapan Thaker on 29/08/14.
//  Copyright (c) 2014 Tapan. All rights reserved.
//

#import "UIView+Debug.h"
#if defined(DEBUG_FRAME)
#import "NSObject+Helper.h"

@implementation UIView (Debug)

//+ (void) initialize {
+ (void)load {
    
    [self swizzleSelector:@selector(init)
             withSelector:@selector(init_debug)];
    
    [self swizzleSelector:@selector(awakeFromNib)
             withSelector:@selector(awakeFromNib_debug)];
    
    [self swizzleSelector:@selector(initWithFrame:)
             withSelector:@selector(initWithFrame_debug:)];
    
    [self swizzleSelector:@selector(initWithCoder:)
             withSelector:@selector(initWithCoder_debug:)];
}

-(id)init_debug{
    
    self = [self init_debug];
    [self addBorders];
    return self;
}

-(void)awakeFromNib_debug{
    [self addBorders];
}

-(id)initWithFrame_debug:(CGRect)frame{
    self = [self initWithFrame_debug:frame];
    [self addBorders];
    return self;
}

-(id)initWithCoder_debug:(NSCoder *)coder{
    self = [self initWithCoder_debug:coder];
    [self addBorders];
    return self;
}

-(void)addBorders{
    self.layer.borderColor = [UIColor redColor].CGColor;
    self.layer.borderWidth = 1.0;
}

@end

#endif
