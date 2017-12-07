//
//  LineProgressView.h
//  Layer
//
//  Created by Carver Li on 14-12-1.
//
//

#import <UIKit/UIKit.h>
#import "CustomLayer.h"

@interface LineProgressView : UIView


@property (nonatomic,assign) int total;
@property (nonatomic,assign) int completed;

@property (nonatomic,assign) CGFloat radius;
@property (nonatomic,assign) CGFloat innerRadius;

@property (nonatomic,assign) CGFloat startAngle;
@property (nonatomic,assign) CGFloat endAngle;

@property (nonatomic, assign) CFTimeInterval animationDuration;

- (void)setCompleted:(int)completed animated:(BOOL)animated;

@end


