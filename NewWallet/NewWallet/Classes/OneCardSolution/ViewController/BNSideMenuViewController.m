//
//  BNSideMenuViewController.m
//  Wallet
//
//  Created by 陈荣雄 on 2016/12/23.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "BNSideMenuViewController.h"
#import "BNSideMenuCell.h"
#import "Masonry.h"

@interface BNSideMenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *data;

@property (assign, nonatomic) BOOL isDisplayed;

@end

@implementation BNSideMenuViewController

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *headerView = [[UILabel alloc] init];
    headerView.text = @"全部功能";
    headerView.textAlignment = NSTextAlignmentRight;
    headerView.font = [UIFont boldSystemFontOfSize:16];
    headerView.textColor = [UIColor string2Color:@"#b0bec5"];
    [self addSubview:headerView];
    
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.superview);
        make.top.equalTo(headerView.superview).offset(25);
        make.right.equalTo(headerView.superview).offset(-10);
        make.height.equalTo(@20);
    }];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[BNSideMenuCell class] forCellReuseIdentifier:sideMenuCellIdentifier];
    [self addSubview:tableView];
    self.tableView = tableView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tableView.superview);
        make.right.equalTo(tableView.superview);
        make.top.equalTo(tableView.superview).offset(45);
        make.bottom.equalTo(tableView.superview);
    }];
    
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 63, 0);
    
    UIImageView *shadowLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.heightValue-63, self.widthValue, 63)];
    shadowLine.image = [[UIImage imageNamed:@"line_shadow"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self addSubview:shadowLine];
}

- (void)reset {
    
    self.data = @[];
    [self.tableView reloadData];
    self.isDisplayed = NO;
}

- (void)reloadData {
    
    self.data = self.menus;
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BNSideMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:sideMenuCellIdentifier forIndexPath:indexPath];

    NSDictionary *data = self.menus[indexPath.row];
    
    [cell setData:data];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isDisplayed) {
        return;
    }
    
    CGRect originFrame = cell.frame;
    CGRect frame = cell.frame;
    frame.origin.x = tableView.frame.size.width;
    cell.frame = frame;
    
    NSTimeInterval duration = 0.3 + (NSTimeInterval)(indexPath.row) / 10.0;
    [UIView animateWithDuration:duration animations:^{
        cell.frame = originFrame;
    } completion:^(BOOL finished) {
        if (indexPath.row == 4) {
            self.isDisplayed = YES;
        }
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *data = self.menus[indexPath.row];
    
    if (self.delegate) {
        [self.delegate menuSelected:data];
    }
}

@end
