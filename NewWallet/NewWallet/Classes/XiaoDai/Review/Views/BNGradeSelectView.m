//
//  BNGradeSelectView.m
//  Wallet
//
//  Created by mac1 on 15/5/13.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNGradeSelectView.h"


#define kGradeBarHeight  [BNTools sizeFit:30 six:32 sixPlus:36]


@interface BNGradeSelectView ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (assign, nonatomic) CGFloat boardHeight;

@property (weak,   nonatomic) UIPickerView *gradePickView;

@end

@implementation BNGradeSelectView

- (id)initWithDataSource:(NSArray *)grades
{
    _boardHeight = 216;
    if (SCREEN_HEIGHT == 736 || SCREEN_WIDTH == 414) {
        _boardHeight = 226;
    }
    
    self = [super initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, _boardHeight + kGradeBarHeight)];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.datasource = grades;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:15 sixPlus:16]];
        cancelBtn.frame = CGRectMake(10, 3, 60, kGradeBarHeight);
        [cancelBtn setTitleColor:UIColorFromRGB(0x31d1fe) forState:UIControlStateNormal];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelSelectDate:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        finishBtn.titleLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:15 sixPlus:16]];
        finishBtn.frame = CGRectMake(SCREEN_WIDTH - 10 - 60, 3, 60, kGradeBarHeight);
        [finishBtn setTitleColor:UIColorFromRGB(0x31d1fe) forState:UIControlStateNormal];
        [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        [finishBtn addTarget:self action:@selector(finishSelectDate:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        
        UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kGradeBarHeight, SCREEN_WIDTH, _boardHeight)];
        picker.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        picker.delegate = self;
        picker.dataSource = self;
        picker.showsSelectionIndicator = YES;
        _gradePickView = picker;
        
        [self addSubview:picker];
        
        [self addSubview:line];
        [self addSubview:cancelBtn];
        [self addSubview:finishBtn];
    
        _pickIsShow = NO;
    }
    return self;
}


- (void)cancelSelectDate:(UIButton *)btn
{
    [self dismiss];
}

- (void)finishSelectDate:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(selectedGradeNO:)]) {
        NSString *selectGrade = [NSString stringWithFormat:@"%@",self.datasource[[_gradePickView selectedRowInComponent:0]]];
        [self.delegate selectedGradeNO:selectGrade];
        
    }
    [self dismiss];
}

- (void)show
{
    if (_pickIsShow == NO) {
        __weak typeof(self) weakSelf = self;
        UIWindow *keyWindow = shareAppDelegateInstance.window;
        [keyWindow addSubview:self];
        _pickIsShow = YES;
        
        [UIView animateWithDuration:.5 animations:^{
            weakSelf.frame = CGRectMake(0, SCREEN_HEIGHT - (_boardHeight + kGradeBarHeight), SCREEN_WIDTH, _boardHeight + kGradeBarHeight);
        } completion:^(BOOL finished) {
            [weakSelf.gradePickView selectRow:2 inComponent:0 animated:NO];
        }];
    }
    
    
}

- (void)dismiss
{
    _pickIsShow = NO;
    UIWindow *keyWindow = shareAppDelegateInstance.window;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:.5 animations:^{
        weakSelf.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, _boardHeight + kGradeBarHeight);
    } completion:^(BOOL finished) {
        [keyWindow removeFromSuperview];
    }];
 
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 1;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return [self.datasource count];
    
}

#pragma mark - UIPickerViewDelegate
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    UILabel *myView = nil;
    
    if (component == 0) {
        
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 300, 30)];
        
        myView.textAlignment = NSTextAlignmentCenter;
        
        myView.text = self.datasource[row];
        
        myView.font = [UIFont boldSystemFontOfSize:18];         //用label来设置字体大小
        
        myView.backgroundColor = [UIColor clearColor];
        
    }
    return myView;
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return SCREEN_WIDTH;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component

{
    
    return 40.0;
    
}


@end
