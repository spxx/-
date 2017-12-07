//
//  BNHomeDropView.m
//  Wallet
//
//  Created by mac1 on 2017/2/20.
//  Copyright © 2017年 BNDK. All rights reserved.
//

#import "BNHomeDropView.h"
#import "BNHomeDropItem.h"

@interface BNHomeDropView ()

@property (nonatomic, copy) NSArray *items;

@end

@implementation BNHomeDropView


- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items
{
    if (self = [super initWithFrame:frame]) {
        
        _items = items;
        
        CGFloat itemH = frame.size.height / items.count;
        
        for (int i = 0; i < items.count; i ++) {
            
            NSDictionary *dic = items[i];
            
            __weak typeof(self) weakSelf = self;
            BNHomeDropItem *item = [[BNHomeDropItem alloc] initWithFrame:CGRectMake(0, itemH * i, frame.size.width, itemH) itemDic:dic];
            item.clickBlock = ^{
                [weakSelf itemClick:i];
            };
            [self addSubview:item];

        }
        
        
    }
    
    return self;
    
}

    

- (void)itemClick:(NSInteger)index
{
    
    if ([self.delegate respondsToSelector:@selector(homeDropViewSelectItemIndex:)]) {
        [self.delegate homeDropViewSelectItemIndex:index];
    }
}

- (void)layoutSubviews
{
    BNLog(@"--- %@",NSStringFromCGRect(self.frame));
}


- (void)show {
    //do nothing
}


@end
