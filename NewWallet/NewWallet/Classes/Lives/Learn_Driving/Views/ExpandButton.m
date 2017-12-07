//
//  ExpandButton.m
//  Wallet
//
//  Created by 陈荣雄 on 16/6/8.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "ExpandButton.h"

@implementation ExpandButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGFloat margin = 20.0;
    CGRect area = CGRectInset(self.bounds, -margin, -margin);
    return CGRectContainsPoint(area, point);
}

@end
