//
//  MMDateView.m
//  MMPopupView
//
//  Created by Ralph Li on 9/7/15.
//  Copyright © 2015 LJC. All rights reserved.
//

#import "MMPickerActionSheet.h"
#import "MMPopupDefine.h"
#import "MMPopupCategory.h"
#import <Masonry/Masonry.h>

@interface MMPickerActionSheet() <UIPickerViewDataSource,
                                   UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) UIButton *btnCancel;
@property (nonatomic, strong) UIButton *btnConfirm;

@property (strong, nonatomic) NSArray *components;

@end

@implementation MMPickerActionSheet


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
    }
    
    return self;
}

- (void)setComponents:(NSArray *)components
{
    _components = components;
    
    [self.pickerView reloadAllComponents];
}

- (void)setDefaultSelect:(NSArray *)titles
{
    if (titles.count <= self.components.count) {
        __weak __typeof(self) weakSelf = self;
        [titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *component = self.components[idx];
            NSUInteger selectedRow = [component indexOfObject:obj];
            [weakSelf.pickerView selectRow:selectedRow inComponent:idx animated:NO];
        }];
    }
}

- (void)actionHide
{
    [self hide];
}

- (void)actionOK
{
    [self hide];
    
    if ([self.delegate respondsToSelector:@selector(selectedTitles:)]) {
        NSMutableArray *selectedTitles = [NSMutableArray array];
        for (NSInteger i=0; i<self.components.count; i++) {
            NSArray *com = self.components[i];
            NSInteger selectedRow = [self.pickerView selectedRowInComponent:i];
            [selectedTitles addObject:[NSString stringWithFormat:@"%@", com[selectedRow]]];
        }
        [self.delegate selectedTitles:selectedTitles];
    }
}

#pragma mark - UIPickerView Datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.components.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    NSArray *componentData = self.components[component];
    return componentData.count;
}

#pragma mark - UIPickerView Delegate

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    NSArray *componentData = self.components[component];
    return [NSString stringWithFormat:@"%@", componentData[row]];
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    
}

@end
