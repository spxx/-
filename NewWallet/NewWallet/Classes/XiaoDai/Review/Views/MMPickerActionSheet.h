//
//  MMDateView.h
//  MMPopupView
//
//  Created by Ralph Li on 9/7/15.
//  Copyright © 2015 LJC. All rights reserved.
//

#import "MMPopupView.h"

@protocol PickerActionSheetDelegate <NSObject>

- (void)selectedTitles:(NSArray *)titles;

@end

@interface MMPickerActionSheet : MMPopupView

@property (weak, nonatomic) id <PickerActionSheetDelegate> delegate;

- (void)setComponents:(NSArray *)components;

- (void)setDefaultSelect:(NSArray *)titles;

@end
