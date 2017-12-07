//
//  BNNavigationController.m
//
//  Created by BN on 14-4-22.
//  Copyright (c) 2014年 xjy. All rights reserved.
//

#import "BNNavigationController.h"

@interface BNNavigationController ()

@property (nonatomic) BOOL animating;

@end

@implementation BNNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
//    __weak BNNavigationController *weakSelf = self;
//    
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.interactivePopGestureRecognizer.delegate = weakSelf;
//        self.delegate = weakSelf;
//    }
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
//    if (_animating == YES) {
//        return;
//    }
//    _animating = YES;
//
//    [self performSelector:@selector(timeOver) withObject:nil afterDelay:1];
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]&&animated == YES) {
//        self.interactivePopGestureRecognizer.enabled = NO;
//    }
//    
    [super pushViewController:viewController animated:animated];
}
- (void)timeOver
{
    _animating = NO;
}


- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]&&animated == YES) {
//        self.interactivePopGestureRecognizer.enabled = NO;
//    }
    return  [super popToRootViewControllerAnimated:animated];
}



- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.interactivePopGestureRecognizer.enabled = NO;
//    }
    
    return [super popToViewController:viewController animated:animated];
}

#pragma mark UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate
{
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]){
//        self.interactivePopGestureRecognizer.enabled = YES;
//    }
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
//    if (gestureRecognizer==self.interactivePopGestureRecognizer) {
//        if (self.viewControllers.count<2||self.visibleViewController==[self.viewControllers objectAtIndex:0]) {
//            return NO;
//        }
//    }
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (BOOL)shouldAutorotate
{
//    if ([self.topViewController isKindOfClass:NSClassFromString(@"HLChatPhotoPreviewViewController")] ||
//        [self.topViewController isKindOfClass:NSClassFromString(@"HLAlbumPreviewViewController")] {
//        return self.topViewController.shouldAutorotate;
//    }
//    else{
        return NO;
//    }
//
}

- (NSUInteger)supportedInterfaceOrientations
{
//UIInterfaceOrientationMask
//    if ([self.topViewController isKindOfClass:NSClassFromString(@"HLChatPhotoPreviewViewController")] ||
//        [self.topViewController isKindOfClass:NSClassFromString(@"HLAlbumPreviewViewController")]{
//        return self.topViewController.supportedInterfaceOrientations;
//    }
//    else{
        return UIInterfaceOrientationMaskPortrait;
//    }
}

@end
