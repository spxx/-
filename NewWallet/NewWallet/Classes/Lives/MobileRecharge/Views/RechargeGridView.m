//
//  RechargeGridView.m
//  Wallet
//
//  Created by 陈荣雄 on 15/12/16.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import "RechargeGridView.h"

@implementation RechargeItem

@end

@interface RechargeItemView ()
@property (strong, nonatomic) UIImageView *backgroundView;
@property (strong, nonatomic) UILabel *productNameLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@end

@implementation RechargeItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        //self.backgroundView.image = [UIImage imageNamed:@"item_selected"];
        self.backgroundView.layer.borderWidth = 0.5f;
        self.backgroundView.layer.borderColor = [UIColorFromRGB(0x666666) CGColor];
        self.backgroundView.layer.cornerRadius = 2.0f;
        self.backgroundView.clipsToBounds = YES;
        [self addSubview:self.backgroundView];
        
        self.productNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height/2-15, frame.size.width, 20)];
        self.productNameLabel.textAlignment = NSTextAlignmentCenter;
        self.productNameLabel.textColor = UIColorFromRGB(0x666666);
        self.productNameLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:self.productNameLabel];
        
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height/2+5, frame.size.width, 15)];
        self.priceLabel.textAlignment = NSTextAlignmentCenter;
        self.priceLabel.textColor = UIColorFromRGB(0x666666);
        self.priceLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:self.priceLabel];
    
    }
    return self;
}

- (void)setItem:(RechargeItem *)item {
    _item = item;
    
    self.productNameLabel.text = item.productName;
    self.priceLabel.text = [NSString stringWithFormat:@"售价：%.2f元", item.salePrice];
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    
    if (_selected) {
        self.backgroundView.image = [UIImage imageNamed:@"item_selected"];
        self.backgroundView.layer.borderColor = [[UIColor clearColor] CGColor];
        self.productNameLabel.textColor = UIColorFromRGB(0x0090ff);
        self.priceLabel.textColor = UIColorFromRGB(0x0090ff);
    }
    else {
        self.backgroundView.image = nil;
        self.backgroundView.layer.borderColor = [UIColorFromRGB(0x666666) CGColor];
        self.productNameLabel.textColor = UIColorFromRGB(0x666666);
        self.priceLabel.textColor = UIColorFromRGB(0x666666);
    }
}

- (void)setEnable:(BOOL)enable {
    if (enable) {
        self.backgroundView.image = nil;
        self.backgroundView.layer.borderColor = [UIColorFromRGB(0x666666) CGColor];
        self.productNameLabel.textColor = UIColorFromRGB(0x666666);
        self.priceLabel.textColor = UIColorFromRGB(0x666666);
    } else {
        self.backgroundView.image = nil;
        self.backgroundView.layer.borderColor = [UIColorFromRGB(0xc9caca) CGColor];
        self.productNameLabel.textColor = UIColorFromRGB(0xc9caca);
        self.priceLabel.textColor = UIColorFromRGB(0xc9caca);
    }
}

@end

@implementation RechargeGridView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemTapped:)];
        [self addGestureRecognizer:gesture];
    }
    return self;
}

- (void)setItems:(NSArray<RechargeItem *> *)items {
    [self removeAllSubviews];
    
    CGFloat scale = 190.0/120;
    
    CGFloat gap = 10;
    
    CGFloat itemWidth = (self.frame.size.width-gap*4)/3;
    CGFloat itemHeight = itemWidth/scale;
    
    for (RechargeItem *item in items) {
        NSUInteger index = [items indexOfObject:item];

        CGFloat x = 0;
        CGFloat y = 0;
        
        NSUInteger pos = index%3;
        x = (gap+itemWidth)*pos+gap;

        NSUInteger row = index/3;
        y = (gap+itemHeight)*row+gap;
        
        RechargeItemView *itemView = [[RechargeItemView alloc] initWithFrame:CGRectMake(x, y, itemWidth, itemHeight)];
        [itemView setItem:item];
        [self addSubview:itemView];
    }
    
    CGFloat height = (gap+itemHeight)*ceilf(items.count/3.0)+gap;
    self.heightValue = height;
}

- (void)itemTapped:(UITapGestureRecognizer *)gesture {
    CGPoint touchPoint = [gesture locationInView:self];
    for (RechargeItemView *itemView in self.subviews) {
        if ([itemView isKindOfClass:[RechargeItemView class]]) {
            if (CGRectContainsPoint(itemView.frame, touchPoint)) {
                itemView.selected = YES;
                if ([self.delegate respondsToSelector:@selector(rechargeItemSelected:)]) {
                    [self.delegate rechargeItemSelected:itemView.item];
                }
            }
            else {
                itemView.selected = NO;
            }
        }
    }
}

- (void)setEnable:(BOOL)enable {
    _enable = enable;
    
    self.userInteractionEnabled = enable;
    
    for (RechargeItemView *itemView in self.subviews) {
        if ([itemView isKindOfClass:[RechargeItemView class]]) {
            [itemView setEnable:enable];
        }
    }
}

@end
