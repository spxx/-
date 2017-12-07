//
//  MMDateView.m
//  MMPopupView
//
//  Created by Ralph Li on 9/7/15.
//  Copyright © 2015 LJC. All rights reserved.
//

#import "MMDegreeSelectedView.h"
#import "MMPopupDefine.h"
#import "MMPopupCategory.h"
#import <Masonry/Masonry.h>

@interface MMDegreeSelectedView() <UIPickerViewDataSource,
                                   UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) UIButton *btnCancel;
@property (nonatomic, strong) UIButton *btnConfirm;

@property (strong, nonatomic) NSDictionary *allDegree;
@property (strong, nonatomic) NSArray *component1;
@property (strong, nonatomic) NSDictionary *component2;

@end

@implementation MMDegreeSelectedView


- (instancetype)init
{
    self = [super init];
    
    if ( self )
    {
        self.type = MMPopupTypeSheet;
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
            make.height.mas_equalTo(216+50);
        }];
        
        self.btnCancel = [UIButton mm_buttonWithTarget:self action:@selector(actionHide)];
        [self addSubview:self.btnCancel];
        [self.btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 50));
            make.left.top.equalTo(self);
        }];
        [self.btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [self.btnCancel setTitleColor:MMHexColor(0xE76153FF) forState:UIControlStateNormal];
        
        
        self.btnConfirm = [UIButton mm_buttonWithTarget:self action:@selector(actionOK)];
        [self addSubview:self.btnConfirm];
        [self.btnConfirm mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 50));
            make.right.top.equalTo(self);
        }];
        [self.btnConfirm setTitle:@"确定" forState:UIControlStateNormal];
        [self.btnConfirm setTitleColor:MMHexColor(0xE76153FF) forState:UIControlStateNormal];
        
        self.pickerView = [UIPickerView new];
        self.pickerView.dataSource = self;
        self.pickerView.delegate = self;
        [self addSubview:self.pickerView];
        [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(50, 0, 0, 0));
        }];
        
        self.allDegree = @{@"大专一年级": @11,
                                    @"大专二年级": @12,
                                    @"大专三年级": @13,
                                    @"本科一年级": @21,
                                    @"本科二年级": @22,
                                    @"本科三年级": @23,
                                    @"本科四年级": @24,
                                    @"本科五年级": @25,
                                    @"硕士一年级": @31,
                                    @"硕士二年级": @32,
                                    @"硕士三年级": @33,
                                    @"博士一年级": @41,
                                    @"博士二年级": @42,
                                    @"博士三年级": @43
                           };
        self.component1 = @[@"大专", @"本科", @"硕士", @"博士"];
        self.component2 = @{@"大专": @[@"一年级", @"二年级", @"三年级"],
                                     @"本科": @[@"一年级", @"二年级", @"三年级", @"四年级", @"五年级"],
                                     @"硕士": @[@"一年级", @"二年级", @"三年级"],
                                     @"博士": @[@"一年级", @"二年级", @"三年级"]};
    }
    
    return self;
}

- (void)setDefaultSelected:(NSString *)title
{
    NSString *com1 = [title substringWithRange:NSMakeRange(0, 2)];
    NSString *com2 = [title substringWithRange:NSMakeRange(2, 3)];
    NSUInteger com1SelectedRow = [self.component1 indexOfObject:com1];
    NSArray *componentsArray = self.component2[com1];
    NSUInteger com2SelectedRow = [componentsArray indexOfObject:com2];
    [self.pickerView selectRow:com1SelectedRow inComponent:0 animated:NO];
    
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.pickerView selectRow:com2SelectedRow inComponent:1 animated:NO];
    });
}

- (void)actionHide
{
    [self hide];
}

- (void)actionOK
{
    [self hide];
    
    if ([self.delegate respondsToSelector:@selector(selectedTitle:code:)]) {
        NSUInteger component1SelectedRow = [self.pickerView selectedRowInComponent:0];
        NSUInteger component2SelectedRow = [self.pickerView selectedRowInComponent:1];
        
        NSString *component1SelectedTitle = [self.component1 objectAtIndex: component1SelectedRow];
        NSArray *component2Array = self.component2[component1SelectedTitle];
        NSString *component2SelectedTitle = component2Array[component2SelectedRow];
        
        NSString *title = [component1SelectedTitle stringByAppendingString:component2SelectedTitle];
        NSNumber *code = self.allDegree[title];
        
        [self.delegate selectedTitle:title code:code];
    }
}

#pragma mark - UIPickerView Datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    NSUInteger rows = 0;
    switch (component) {
        case 0:
        {
            rows = self.component1.count;
            
            break;
        }
        case 1:
        {
            NSString *component1Selected = [self.component1 objectAtIndex: [pickerView selectedRowInComponent:0]];
            NSArray *component2Array = self.component2[component1Selected];
            rows = component2Array.count;
            
            break;
        }
        default:
            break;
    }
    
    return rows;
}

#pragma mark - UIPickerView Delegate

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    NSString *title = @"";
    switch (component) {
        case 0:
        {
            title = self.component1[row];
            break;
        }
        case 1:
        {
            NSString *component1Selected = [self.component1 objectAtIndex: [pickerView selectedRowInComponent:0]];
            NSArray *component2Array = self.component2[component1Selected];
            title = component2Array[row];
            break;
        }
        default:
            break;
    }
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    if (component == 0) {
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
    }
}

@end
