//
//  BNNavigationController.h
//
//  Created by BN on 14-4-22.
//  Copyright (c) 2014年 xjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNNavigationController : UINavigationController<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic) NSInteger tag;

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated;

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated;



@end
