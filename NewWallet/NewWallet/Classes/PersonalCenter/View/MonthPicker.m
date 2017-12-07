//
//  MonthPicker.m
//  Wallet
//
//  Created by mac1 on 15/2/12.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "MonthPicker.h"


@interface MonthPicker ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) UIPickerView *thePickerView;

@property (assign, nonatomic) CGFloat boardHeight;

@property (strong, nonatomic) NSArray *monthArray;

@property (strong, nonatomic) NSArray *yearArray;

@property (assign, nonatomic) NSInteger defaultMonth;

@property (assign, nonatomic) NSInteger defaultYear;

@end


@implementation MonthPicker

@synthesize delegate;
- (void)setDefaultMonth:(NSInteger) month year:(NSInteger) year
{
    _defaultMonth = month;
    _defaultYear = year;
    [_thePickerView selectRow:12 * 700 + month - 1 inComponent:1 animated:NO];
    NSString *string = [NSString stringWithFormat:@"%li", (long)year];
    NSInteger index = [_yearArray indexOfObject:string];
    [_thePickerView selectRow:101 * 70 + index inComponent:2 animated:NO];
}
- (id)init{
    _boardHeight = 216;
    if (SCREEN_HEIGHT == 736 || SCREEN_WIDTH == 414) {
        _boardHeight = 226;
    }
    
    self = [super initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, _boardHeight + kMonthPickerBarHeight)];
    
    if (self) {
        self.backgroundColor = UIColor_Gray_BG;
        
        UIView *boardToolBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 36)];
        boardToolBar.backgroundColor = [UIColor whiteColor];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        cancelBtn.frame = CGRectMake(10, 3, 60, 30);
        [cancelBtn setTitleColor:UIColorFromRGB(0x31d1fe) forState:UIControlStateNormal];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelSelectMoney:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        finishBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        finishBtn.frame = CGRectMake(SCREEN_WIDTH - 10 - 60, 3, 60, 30);
        [finishBtn setTitleColor:UIColorFromRGB(0x31d1fe) forState:UIControlStateNormal];
        [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        [finishBtn addTarget:self action:@selector(finishSelectMoney:) forControlEvents:UIControlEventTouchUpInside];
        
        [boardToolBar addSubview:line];
        [boardToolBar addSubview:cancelBtn];
        [boardToolBar addSubview:finishBtn];
        
        UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectZero];
        picker.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        picker.frame = CGRectMake(0, kMonthPickerBarHeight, SCREEN_WIDTH, _boardHeight);
        picker.delegate = self;
        picker.dataSource = self;
        picker.showsSelectionIndicator = YES;
        
        self.thePickerView = picker;
        [self addSubview:boardToolBar];
        [self addSubview:picker];
        _isShow = NO;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh-Hant"]];
        _monthArray = dateFormatter.monthSymbols;
        
        NSMutableArray *yearTempArray = [[NSMutableArray alloc] init];
        for (int i = 2000; i <= 2100; i++) {
            NSString *str = [NSString stringWithFormat:@"%i", i];
            [yearTempArray addObject:str];
        }
        _yearArray = yearTempArray;
    
        
    }
    return self;
}


- (void)cancelSelectMoney:(UIButton *)btn
{
    [self dismiss];
    if ([self.delegate respondsToSelector:@selector(cancelSelectDate)]) {
        [self.delegate cancelSelectDate];
    }
}

- (void)finishSelectMoney:(UIButton *)btn
{
    NSInteger month = [_thePickerView selectedRowInComponent:1] % 12;
    NSInteger year = [_thePickerView selectedRowInComponent:2] % 101;
    if([self.delegate respondsToSelector:@selector(selectMonth:year:)])
    {
         [self.delegate selectMonth:month + 1 year:[[_yearArray objectAtIndex:year] integerValue]];
    }

    [self dismiss];
}
- (void)show
{
    if (_isShow == NO) {
        __weak typeof(self) weakSelf = self;
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:self];
        _isShow = YES;
        
        [UIView animateWithDuration:.5 animations:^{
            weakSelf.frame = CGRectMake(0, SCREEN_HEIGHT - (_boardHeight + kMonthPickerBarHeight), SCREEN_WIDTH, _boardHeight + kMonthPickerBarHeight);
        } completion:^(BOOL finished) {
            weakSelf.frame = CGRectMake(0, SCREEN_HEIGHT - (_boardHeight + kMonthPickerBarHeight), SCREEN_WIDTH, _boardHeight + kMonthPickerBarHeight);
            [_thePickerView selectRow:12 * 700 + _defaultMonth - 1 inComponent:1 animated:NO];
            NSString *string = [NSString stringWithFormat:@"%li", (long)_defaultYear];
            NSInteger index = [_yearArray indexOfObject:string];
            [_thePickerView selectRow:101 * 70 + index inComponent:2 animated:NO];
        }];
    }
    
    
}

- (void)dismiss
{
    _isShow = NO;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:.5 animations:^{
        weakSelf.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, _boardHeight + kMonthPickerBarHeight);
    } completion:^(BOOL finished) {
        [keyWindow removeFromSuperview];
    }];
    
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 4;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger row = 0;
    switch (component) {
        case 0:
            row = 1;
            break;
        
        case 1:
            row = 16000;
            break;
            
        case 2:
            row = 16000;
            break;
            
        case 3:
            row = 1;
            break;
            
       
            break;
            
            
        default:
            break;
    }
    return row;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    CGFloat width = 0;
    switch (component) {
        case 0:
            width = (SCREEN_WIDTH -180)/2.0;
            break;
            
        case 1:
            width = 60;
            break;
            
        case 2:
            width = 120;
            break;
            
        case 3:
            width = (SCREEN_WIDTH -180)/2.0;
            break;
            
            
            break;
            
            
        default:
            break;
    }
    return width;
}
#pragma mark - UIPickerViewDelegate
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    UILabel *myView = [[UILabel alloc] init];
    myView.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
    myView.textAlignment = NSTextAlignmentCenter;
    switch (component) {
        case 0:
        {
            
        }
            break;
            
        case 1:
        {
            NSInteger index = row % 12;
            NSString *title = [_monthArray objectAtIndex:index];
            myView.frame = CGRectMake(0, 0, 60, 40);
            myView.text = title;
        }
            break;
            
        case 2:
        {
            NSInteger index = row % 101;
            NSString *title = [_yearArray objectAtIndex:index];
            myView.frame = CGRectMake(0, 0, 120, 40);
            myView.text = [NSString stringWithFormat:@"%@年", title];
        }
            break;
            
        case 3:
        
            break;
            
        default:
            break;
    }
   
    return myView;
    
}


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    
    return 40.0;
    
}


@end
