//
//  MMDateView.h
//  MMPopupView
//
//  Created by Ralph Li on 9/7/15.
//  Copyright © 2015 LJC. All rights reserved.
//

#import "MMPopupView.h"

@protocol DegreeSelectedDelegate <NSObject>

- (void)selectedTitle:(NSString *)title code:(NSNumber *)code;

@end

@interface MMDegreeSelectedView : MMPopupView

@property (weak, nonatomic) id <DegreeSelectedDelegate> delegate;

- (void)setDefaultSelected:(NSString *)title;

@end
