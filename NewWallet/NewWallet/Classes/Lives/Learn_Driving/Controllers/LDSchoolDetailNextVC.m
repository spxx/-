//
//  LDSchoolDetailNextVC.m
//  Wallet
//
//  Created by mac1 on 16/6/7.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "LDSchoolDetailNextVC.h"

@interface LDSchoolDetailNextVC ()

@end

@implementation LDSchoolDetailNextVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationTitle = @"详情说明";
    [self setupLoadedView];
}

- (void)setupLoadedView
{
    CGFloat originY = self.sixtyFourPixelsView.viewBottomEdge;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, 85 * NEW_BILI)];
    imageView.image = [UIImage imageNamed:@"ld_detail_next"];
    [self.view addSubview:imageView];
    
    originY += imageView.heightValue + 29 * NEW_BILI;
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(15 * NEW_BILI, originY , SCREEN_WIDTH - 15 * NEW_BILI, 16 * NEW_BILI)];
    name.text = self.school.driving_school_name;
    name.font = [UIFont systemFontOfSize:16 * NEW_BILI];
    name.textColor = [UIColor blackColor];
    [self.view addSubview:name];
    originY += name.heightValue + 10 * NEW_BILI;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15 * NEW_BILI, originY, SCREEN_WIDTH - 15 * NEW_BILI, 1)];
    lineView.backgroundColor = UIColor_GrayLine;
    [self.view addSubview:lineView];
    
    originY += lineView.heightValue + 10 * NEW_BILI;
    
    UILabel *desLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 * NEW_BILI, originY , SCREEN_WIDTH - 15 * NEW_BILI, 16 * NEW_BILI)];
    desLabel.text = self.school.driving_school_introduction;
    desLabel.font = [UIFont systemFontOfSize:13 * NEW_BILI];
    desLabel.numberOfLines = 0;
    desLabel.textColor = BNColorRGB(155, 174, 183);
    [self.view addSubview:desLabel];
    [desLabel sizeToFit];
}

@end
