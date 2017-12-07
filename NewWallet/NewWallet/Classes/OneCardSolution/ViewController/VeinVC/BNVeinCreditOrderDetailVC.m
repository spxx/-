//
//  BNVeinCreditOrderDetailVC.m
//  Wallet
//
//  Created by xjy on 17/6/21.
//  Copyright (c) 2017年 BNDK. All rights reserved.
//

#import "BNVeinCreditOrderDetailVC.h"

@interface BNVeinCreditOrderDetailVC ()

@property (nonatomic) UIImageView *iconImageView;

@end

@implementation BNVeinCreditOrderDetailVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationTitle = @"订单详情";
    
    UIScrollView *theScollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge)];
    theScollView.contentSize = CGSizeMake(0, CGRectGetHeight(theScollView.frame)+1);
    theScollView.backgroundColor = UIColor_Gray_BG;
    [self.view addSubview:theScollView];
    
    CGFloat originY = 7*BILI_WIDTH;

    UIView *whiteView0 = [[UIView alloc]initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, 130*BILI_WIDTH)];
    whiteView0.backgroundColor = [UIColor whiteColor];
    [theScollView addSubview:whiteView0];
    
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15*BILI_WIDTH, originY+33*BILI_WIDTH, 47*BILI_WIDTH, 47*BILI_WIDTH)];
    [theScollView addSubview:_iconImageView];
    NSString *iconUrl = [NSString stringWithFormat:@"%@", [_dict valueWithNoDataForKey:@"consume_icon_url"]];
    if ([_dict.allKeys containsObject:@"repay_way_icon"]) {
        iconUrl = [NSString stringWithFormat:@"%@", [_dict valueWithNoDataForKey:@"repay_way_icon"]];
    }
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:nil];
    
    originY += 20*BILI_WIDTH;
    
    UILabel *nameLbl = [[UILabel alloc]initWithFrame:CGRectMake(77*BILI_WIDTH, originY, SCREEN_WIDTH-(77+15)*BILI_WIDTH, 65*BILI_WIDTH)];
    nameLbl.font = [UIFont systemFontOfSize:14*BILI_WIDTH];
    nameLbl.backgroundColor = [UIColor clearColor];
    nameLbl.textColor = [UIColor blackColor];
    nameLbl.numberOfLines = 0;
    [theScollView addSubview:nameLbl];
    NSString *goodsName = [NSString stringWithFormat:@"%@", [_dict valueWithNoDataForKey:@"goods_summary"]];
    nameLbl.text = goodsName;
    CGFloat nameLblHeight = [Tools caleNewsCellHeightWithTitle:goodsName font:nameLbl.font width:nameLbl.frame.size.width];
    
    nameLbl.size = CGSizeMake(SCREEN_WIDTH- (77+15)*BILI_WIDTH, nameLblHeight);
    
    originY += CGRectGetHeight(nameLbl.frame)+20*BILI_WIDTH;

    UIView *lineView0 = [[UIView alloc]initWithFrame:CGRectMake(77*BILI_WIDTH, originY, SCREEN_WIDTH-77*BILI_WIDTH, 0.5)];
    lineView0.backgroundColor = UIColor_GrayLine;
    [theScollView addSubview:lineView0];
    
    originY += 23*BILI_WIDTH;

    UILabel *statusLbl = [[UILabel alloc]initWithFrame:CGRectMake(77*BILI_WIDTH, originY, 60*BILI_WIDTH, 25*BILI_WIDTH)];
    statusLbl.font = [UIFont systemFontOfSize:14*BILI_WIDTH];
    statusLbl.backgroundColor = [UIColor clearColor];
    statusLbl.textColor = UIColorFromRGB(0x475b65);
    [theScollView addSubview:statusLbl];
    NSString *status = [NSString stringWithFormat:@"%@", [_dict valueWithNoDataForKey:@"pay_status_desc"]];
    if ([_dict.allKeys containsObject:@"repay_status_desc"]) {
        status = [NSString stringWithFormat:@"%@", [_dict valueWithNoDataForKey:@"repay_status_desc"]];
    }
    statusLbl.text = status;

    CGFloat statusLblWidth = [Tools getTextWidthWithText:statusLbl.text font:statusLbl.font height:statusLbl.frame.size.height];
    statusLbl.frame = CGRectMake(77*BILI_WIDTH, originY, statusLblWidth, 25*BILI_WIDTH);
    
    UILabel *moneyLbl = [[UILabel alloc]initWithFrame:CGRectMake((77+15)*BILI_WIDTH+statusLblWidth, originY, 150*BILI_WIDTH, 25*BILI_WIDTH)];
    moneyLbl.font = [UIFont systemFontOfSize:20*BILI_WIDTH];
    moneyLbl.backgroundColor = [UIColor clearColor];
    moneyLbl.textColor = UIColorFromRGB(0x899fa9);
    [theScollView addSubview:moneyLbl];

    NSString *pay_amount = [NSString stringWithFormat:@"%@元", [_dict valueWithNoDataForKey:@"consume_amount"]];
    if ([_dict.allKeys containsObject:@"repay_amount"]) {
        pay_amount = [NSString stringWithFormat:@"%@", [_dict valueWithNoDataForKey:@"repay_amount"]];
    }
    moneyLbl.text = pay_amount;

    NSInteger finishstatus = 1;
    //为1的时候业务已经完成，为0的时候表示未完成,
    if (finishstatus == 1) {
        moneyLbl.textColor = UIColor_NewBlueColor;
    } else {
        moneyLbl.textColor = UIColorFromRGB(0xda8f0d);
    }

    originY += CGRectGetHeight(moneyLbl.frame)+23*BILI_WIDTH;
    whiteView0.size = CGSizeMake(SCREEN_WIDTH, originY-7*BILI_WIDTH);

    originY += 12*BILI_WIDTH;

    CGFloat originY1 = originY;
    UIView *whiteView1 = [[UIView alloc]initWithFrame:CGRectMake(0, originY1, SCREEN_WIDTH, 7*40*BILI_WIDTH+10*BILI_WIDTH)];
    whiteView1.backgroundColor = [UIColor whiteColor];
    [theScollView addSubview:whiteView1];
    
    NSArray *leftNameArray ;
    NSDictionary *contengDict;
    
    NSString *xifu_merchant_name = [NSString stringWithFormat:@"%@", [_dict valueWithNoDataForKey:@"xifu_merchant_name"]];
    if ([_dict.allKeys containsObject:@"credit_merchant_name"]) {
        xifu_merchant_name = [NSString stringWithFormat:@"%@", [_dict valueWithNoDataForKey:@"credit_merchant_name"]];
    }
    NSString *consume_no = [NSString stringWithFormat:@"%@", [_dict valueWithNoDataForKey:@"consume_no"]];
    if ([_dict.allKeys containsObject:@"repay_no"]) {
        consume_no = [NSString stringWithFormat:@"%@", [_dict valueWithNoDataForKey:@"repay_no"]];
    }
    NSString *pay_type = [NSString stringWithFormat:@"%@", [_dict valueWithNoDataForKey:@"pay_type"]];
    if ([_dict.allKeys containsObject:@"repay_way_desc"]) {
        pay_type = [NSString stringWithFormat:@"%@", [_dict valueWithNoDataForKey:@"repay_way_desc"]];
    }
    NSString *refund_reason = [NSString stringWithFormat:@"%@", [_dict valueWithNoDataForKey:@"refund_reason"]];

    NSString *create_time = [NSString stringWithFormat:@"%@", [_dict valueWithNoDataForKey:@"create_time"]];
    NSString *pay_time = [NSString stringWithFormat:@"%@", [_dict valueWithNoDataForKey:@"pay_time"]];
    NSString *finish_time = [NSString stringWithFormat:@"%@", [_dict valueWithNoDataForKey:@"finish_time"]];
    if ([_dict.allKeys containsObject:@"repay_time"]) {
        create_time = [NSString stringWithFormat:@"%@", [_dict valueWithNoDataForKey:@"repay_time"]];
        pay_time = create_time;
        finish_time = create_time;
    }
        leftNameArray = @[@"收款方", @"交易单号", @"支付方式", @"备注信息", @"创建时间", @"付款时间", @"完成时间"];
        contengDict = @{leftNameArray[0] : xifu_merchant_name,
                        leftNameArray[1] : consume_no,
                        leftNameArray[2] : pay_type,
                        leftNameArray[3] : refund_reason,
                        leftNameArray[4] : create_time,
                        leftNameArray[5] : pay_time,
                        leftNameArray[6] : finish_time
                        };

       for (int i = 0; i < leftNameArray.count; i++) {
        UILabel *leftLbl = [[UILabel alloc]initWithFrame:CGRectMake(15*BILI_WIDTH, originY1, 60*BILI_WIDTH, 40*BILI_WIDTH)];
        leftLbl.font = [UIFont systemFontOfSize:14*BILI_WIDTH];
        leftLbl.backgroundColor = [UIColor clearColor];
        leftLbl.contentMode = UIViewContentModeTopLeft;
        leftLbl.textColor = UIColorFromRGB(0x9d9d9d);
        [theScollView addSubview:leftLbl];
        leftLbl.text = leftNameArray[i];

        NSString *contentText = [contengDict valueForKey:leftNameArray[i]];
        CGFloat contentTextHeight = [Tools caleNewsCellHeightWithTitle:contentText font:[UIFont systemFontOfSize:14*BILI_WIDTH] width:SCREEN_WIDTH-CGRectGetMaxX(leftLbl.frame)-2*10*BILI_WIDTH];
        UILabel *contentLbl = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftLbl.frame)+10*BILI_WIDTH, originY1, SCREEN_WIDTH-CGRectGetMaxX(leftLbl.frame)-2*10*BILI_WIDTH, contentTextHeight + 22 * BILI_WIDTH)];
        contentLbl.font = [UIFont systemFontOfSize:14*BILI_WIDTH];
        contentLbl.backgroundColor = [UIColor clearColor];
        contentLbl.contentMode = UIViewContentModeTopLeft;
        contentLbl.numberOfLines = 0;
        contentLbl.textColor = UIColorFromRGB(0x475b65);
        [theScollView addSubview:contentLbl];
        contentLbl.text = contentText;
        
        originY1 += CGRectGetHeight(contentLbl.frame);
        
        if (i == leftNameArray.count-4) {
            UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake(0, originY1, SCREEN_WIDTH, 7*BILI_WIDTH)];
            grayView.backgroundColor = UIColor_Gray_BG;
            [theScollView addSubview:grayView];

            originY1 += grayView.frame.size.height;
            
        } else if (i != leftNameArray.count-4 && i != leftNameArray.count-1){
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, originY1, SCREEN_WIDTH, 0.5)];
            lineView.backgroundColor = UIColor_GrayLine;
            [theScollView addSubview:lineView];
        }
    }
    
    whiteView1.heightValue = originY1-originY; //这里修改一下whiteView1的高度
//    whiteView1.frame = CGRectMake(0, originY1, SCREEN_WIDTH, originY1-originY);
    
    if (originY1 > theScollView.contentSize.height) {
        theScollView.contentSize = CGSizeMake(0, originY1);
    }
}

@end
