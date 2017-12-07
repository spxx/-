//
//  BNHomeDropItem.m
//  Wallet
//
//  Created by mac1 on 2017/2/24.
//  Copyright © 2017年 BNDK. All rights reserved.
//

#import "BNHomeDropItem.h"

@implementation BNHomeDropItem


- (instancetype)initWithFrame:(CGRect)frame itemDic:(NSDictionary *)dic
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemAcion:)];
        [self addGestureRecognizer:tap];
        
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30 * NEW_BILI, 12 * NEW_BILI, 17 * BILI_WIDTH, 17 * BILI_WIDTH)];
        imageView.image = [UIImage imageNamed:[dic valueNotNullForKey:@"imageName"]];
        [self addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imageView.rightValue + 10 * NEW_BILI, 0, frame.size.width, 17 * NEW_BILI)];
        label.centerYValue = imageView.centerYValue;
        label.textColor = UIColorFromRGB(0x38474e);
        label.font = [UIFont systemFontOfSize:15];
        label.text = [dic valueNotNullForKey:@"title"];
        [self addSubview:label];
    }
    
    return self;
    
}

- (void)itemAcion:(UITapGestureRecognizer *)tap
{
    self.clickBlock();
}

@end
