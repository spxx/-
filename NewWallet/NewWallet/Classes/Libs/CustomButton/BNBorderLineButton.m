//
//  BNBorderLineButton.m
//  Wallet
//
//  Created by mac on 16/3/11.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "BNBorderLineButton.h"

@implementation BNBorderLineButton

-(void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    if (enabled == NO) {
        self.layer.borderColor = UIColor_Gray_Text.CGColor;
        [self setTitleColor:UIColor_Gray_Text forState:UIControlStateDisabled];
    } else if (_enableLayerColor) {
        self.layer.borderColor = _enableLayerColor;
    }
}
@end
