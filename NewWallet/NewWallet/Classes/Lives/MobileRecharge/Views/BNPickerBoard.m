//
//  BNPickerBoard.m
//  Wallet
//
//  Created by mac1 on 15-1-4.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNPickerBoard.h"

#import "MobileRechargeApi.h"
#define kBarHeight 36
@interface BNPickerBoard ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) UIPickerView *thePickerView;

@property (assign, nonatomic) CGFloat boardHeight;

@end


@implementation BNPickerBoard

@synthesize delegate;

@synthesize datasource = _datasource;
- (id)init{
    _boardHeight = 216;
    if (SCREEN_HEIGHT == 736 || SCREEN_WIDTH == 414) {
        _boardHeight = 226;
    }
    
    self = [super initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, _boardHeight + kBarHeight)];
    
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
        picker.frame = CGRectMake(0, kBarHeight, SCREEN_WIDTH, 216);
        picker.delegate = self;
        picker.dataSource = self;
        picker.showsSelectionIndicator = YES;
        self.thePickerView = picker;
        [self addSubview:boardToolBar];
        [self addSubview:picker];
        _isShow = NO;
    }
    return self;
}


- (void)cancelSelectMoney:(UIButton *)btn
{
    [self dismiss];
}

- (void)finishSelectMoney:(UIButton *)btn
{
    NSInteger row = [self.thePickerView selectedRowInComponent:0];
    [self.delegate selectMobileRechargeAmount:[self.datasource objectAtIndex:row]];
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
            weakSelf.frame = CGRectMake(0, SCREEN_HEIGHT - (_boardHeight + kBarHeight), SCREEN_WIDTH, _boardHeight + kBarHeight);
        } completion:^(BOOL finished) {
            weakSelf.frame = CGRectMake(0, SCREEN_HEIGHT - (_boardHeight + kBarHeight), SCREEN_WIDTH, _boardHeight + kBarHeight);
            NSInteger index = 4;
            for (NSDictionary *obj in _datasource) {
                if ([[[obj valueNotNullForKey:@"amount"] stringValue] isEqualToString:_defaultAmount]) {
                    index = [_datasource indexOfObject:obj];
                    break;
                }
            }
            [weakSelf.thePickerView selectRow:index inComponent:0 animated:YES];
        }];
    }
    
    
}

- (void)dismiss
{
    _isShow = NO;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:.5 animations:^{
        weakSelf.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, _boardHeight + kBarHeight);
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
        
        NSDictionary *amountInfo = [self.datasource objectAtIndex:row];
        NSString *string = [NSString stringWithFormat:@"%@",[amountInfo valueNotNullForKey:@"amount"]];
        if ([string length] > 0) {
             myView.text = [string stringByAppendingString:@"元"];
        }

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

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
{
    
}



@end
