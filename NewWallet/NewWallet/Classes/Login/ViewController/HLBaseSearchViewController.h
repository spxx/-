//
//  HLBaseSearchViewController.h
//  helome
//
//  Created by XuEric on 14-10-8.
//  Copyright (c) 2014年 zhb. All rights reserved.
//

#import "BNBaseViewController.h"
@class XJYSearchBar;

@interface HLBaseSearchViewController : BNBaseViewController
@property (nonatomic) UITableView *tableView;
@property (nonatomic) XJYSearchBar *searchBar;
@property (nonatomic) UIView *searchBaseGrayView;
@property (nonatomic) CGFloat extraHeight;       //额外的要减去的高度（如toolBar）。
@property (nonatomic) BOOL isSearchResult;       //在搜索结果中，不刷新新消息。
@property (nonatomic) UILabel *noResultLabel;    //显示无结果。
@property (nonatomic) UIView *extraView;

-(void)searchBarCancelButtonClicked;

-(void)searchBarTextDidChange;

@end





/*
 记得在子类的searchBarDelegate中调用以下两个方法：
 -(void)searchBarCancelButtonClicked;
 -(void)searchBarTextDidChange;
 如：
 -(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
 {
    [super searchBarCancelButtonClicked];
 }
 
 - (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
 {
     [super searchBarTextDidChange];
 }
*/