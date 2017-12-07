//
//  HLBaseSearchViewController.m
//  helome
//
//  Created by XuEric on 14-10-8.
//  Copyright (c) 2014年 zhb. All rights reserved.
//

#import "HLBaseSearchViewController.h"
#import "XJYSearchBar.h"

@interface HLBaseSearchViewController ()<UISearchBarDelegate>
{
    int keyboardHeight;
}
@end

@implementation HLBaseSearchViewController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.searchBar.delegate = self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.searchBar.delegate = nil;
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    _isSearchResult = NO;
    self.searchBar = [[XJYSearchBar alloc]initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH-20, 45)];
    //[_searchBar setPlaceholder:@"搜索"];
    _searchBar.delegate = self;
    _searchBar.tintColor = [UIColor darkGrayColor];
    self.tableView.tableHeaderView = self.searchBar;

    if (_searchBaseGrayView == nil) {
        _searchBaseGrayView = [[UIView alloc]initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge+44, SCREEN_WIDTH, SCREEN_HEIGHT-self.sixtyFourPixelsView.viewBottomEdge+44)];
        _searchBaseGrayView.backgroundColor = [UIColor clearColor];
        _searchBaseGrayView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGestuer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchBarCancelButtonClicked:)];
        [_searchBaseGrayView addGestureRecognizer:tapGestuer];
    }
    [self.view addSubview:_searchBaseGrayView];
    _searchBaseGrayView.hidden = YES;

    self.noResultLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-80)/2, (SCREEN_HEIGHT-219-self.sixtyFourPixelsView.viewBottomEdge-30-_extraHeight)/2, 80, 30)];
    _noResultLabel.textAlignment = NSTextAlignmentCenter;
    _noResultLabel.text = @"无结果";
    _noResultLabel.textColor = [UIColor grayColor];
    _noResultLabel.font = [UIFont systemFontOfSize:15];
    [self.tableView addSubview:_noResultLabel];
    _noResultLabel.hidden = YES;
    
    //增加监听，当键盘出现或改变时收出消息
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{

    [_searchBar setShowsCancelButton:YES animated:YES];

    _searchBaseGrayView.hidden = NO;
    
    [UIView animateWithDuration:.25 animations:^{
        _searchBaseGrayView.backgroundColor = [UIColor blackColor];
        _searchBaseGrayView.alpha = .5;
        _searchBaseGrayView.frame = CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT-self.sixtyFourPixelsView.viewBottomEdge);
        self.sixtyFourPixelsView.frame = CGRectMake(0, -self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, self.sixtyFourPixelsView.viewBottomEdge);
        self.tableView.frame = CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT-20);
    } completion:^(BOOL finished) {
        self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
        _searchBar.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
        [self.view addSubview:_searchBar];
        [_searchBar becomeFirstResponder];
        
        self.tableView.frame = CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT-keyboardHeight-self.sixtyFourPixelsView.viewBottomEdge);
        self.tableView.tableHeaderView = nil;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }];
    return YES;
}

-(void)searchBarCancelButtonClicked
{

    _isSearchResult = NO;
    self.noResultLabel.hidden = YES;
    
    [_searchBar setShowsCancelButton:NO animated:YES];
    _searchBar.text = @"";
    [_searchBar removeFromSuperview];
    self.tableView.tableHeaderView = _searchBar;
    [_searchBar resignFirstResponder];
    self.tableView.frame = CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT-self.sixtyFourPixelsView.viewBottomEdge-20);

    [UIView animateWithDuration:.25 animations:^{
        _searchBaseGrayView.backgroundColor = [UIColor clearColor];

        _searchBaseGrayView.frame = CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge+44, SCREEN_WIDTH, SCREEN_HEIGHT-self.sixtyFourPixelsView.viewBottomEdge+44);
        self.sixtyFourPixelsView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.sixtyFourPixelsView.viewBottomEdge);
        self.tableView.frame = CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT-self.sixtyFourPixelsView.viewBottomEdge-_extraHeight);
    } completion:^(BOOL finished) {
        _searchBaseGrayView.hidden = YES;
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];

    }];
    [self.tableView reloadData];
}
-(void)searchBarTextDidChange
{
    if (_searchBar.text.length > 0)
    {
        self.searchBaseGrayView.hidden = YES;
        _isSearchResult = YES;
    }
    else
    {
        self.searchBaseGrayView.hidden = NO;
        _isSearchResult = NO;
    }
}
#pragma mark -NSNotification事件
//当键盘高度改变时调用
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
//    DLog(@"beginFrame.origin.y--%f",beginFrame.origin.y);
//    DLog(@"endFrame.origin.y--%f",endFrame.origin.y);
//    DLog(@"duration--%f",duration);
    
    self.tableView.frame = CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, endFrame.origin.y-self.sixtyFourPixelsView.viewBottomEdge);
    [UIView animateWithDuration:duration animations:^{
        self.extraView.frame = CGRectMake(0, endFrame.origin.y-self.extraView.frame.size.height, SCREEN_WIDTH, self.extraView.frame.size.height);
        
    }];
}
//当键盘将要出现时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    keyboardHeight = height;
    
    [UIView animateWithDuration:duration animations:^{
        self.extraView.frame = CGRectMake(0, endFrame.origin.y-self.extraView.frame.size.height, SCREEN_WIDTH, self.extraView.frame.size.height);
    }];
}

@end
