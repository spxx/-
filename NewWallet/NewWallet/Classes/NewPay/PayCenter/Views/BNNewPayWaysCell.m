//
//  BNNewPayWaysCell.m
//  NewWallet
//
//  Created by mac1 on 14-11-7.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNNewPayWaysCell.h"

@interface BNNewPayWaysCell ()

@property (weak, nonatomic) UILabel *bankNameLabel;

@property (nonatomic) UIImageView *bankLogoImgV;
@property (weak, nonatomic) UIImageView *arrowImg;

@property (weak, nonatomic) UIImageView *selectedImageView;
@end

@implementation BNNewPayWaysCell

static NSInteger cellHeight;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        cellHeight = 40*BILI_WIDTH;

//        UIImageView *selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10*BILI_WIDTH, (cellHeight - 15*BILI_WIDTH)/2, 15*BILI_WIDTH, 15*BILI_WIDTH)];
//        [selectImageView setImage:[UIImage imageNamed:@"Select_Bank_card"]];
//        [self.contentView addSubview:selectImageView];
//        self.selectedImageView = selectImageView;

        self.bankLogoImgV = [[UIImageView alloc]initWithFrame:CGRectMake(25*BILI_WIDTH, (cellHeight-28*BILI_WIDTH)/2, 28*BILI_WIDTH, 28*BILI_WIDTH)];
        [self.contentView addSubview:_bankLogoImgV];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(74*BILI_WIDTH, 0, SCREEN_WIDTH - (74+20)*BILI_WIDTH, cellHeight)];
        nameLabel.font = [UIFont systemFontOfSize:14*BILI_WIDTH];
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:nameLabel];
        self.bankNameLabel = nameLabel;
        
        UIImageView *arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - (15+5)*BILI_WIDTH, (cellHeight - 15*BILI_WIDTH)/2, 15*BILI_WIDTH, 15*BILI_WIDTH)];
        arrowImg.backgroundColor = [UIColor clearColor];
        arrowImg.image = [UIImage imageNamed:@"right_arrow"];
        [self.contentView addSubview:arrowImg];
        _arrowImg = arrowImg;
        
        UIImageView *selectImgV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - (15+5+20)*BILI_WIDTH, (cellHeight-15*BILI_WIDTH)/2, 15*BILI_WIDTH, 15*BILI_WIDTH)];
        selectImgV.image = [UIImage imageNamed:@"Select_Bank_card"];
        [self.contentView addSubview:selectImgV];
        self.selectedImageView = selectImgV;
        
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, cellHeight - 1, SCREEN_WIDTH, 1)];
//        line.backgroundColor = UIColor_GrayLine;
//        [self.contentView addSubview:line];
    }
    return self;
}


- (void)drawDataWithInfo:(NSDictionary *)bankCardInfo selectedDict:(NSDictionary *)selectedDict payWayStatus:(NSDictionary *)pay_type_list
{
    self.bankNameLabel.textColor = [UIColor blackColor];

    NSString *bankName = [NSString stringWithFormat:@"%@", [bankCardInfo valueNotNullForKey:@"name"]];
    self.bankNameLabel.text = bankName;
    [_bankLogoImgV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [bankCardInfo valueNotNullForKey:@"image_url"]]]];

    NSInteger cellPayID = [[bankCardInfo valueWithNoDataForKey:@"id"] integerValue];
    switch (cellPayID) {
        case 6: {//易极付支付
            //喜付支付
            //判断支付渠道可用性
            NSInteger unionSystemStatus = [[pay_type_list valueNotNullForKey:@"xfp_status"] integerValue];
            NSString *unionSystemErrorMsg = [NSString stringWithFormat:@"(%@)", [pay_type_list valueNotNullForKey:@"xfp_msg"]];
            if (pay_type_list && [[pay_type_list allKeys] containsObject:@"xfp_status"] && unionSystemStatus == 0) {
                NSString *name = self.bankNameLabel.text;
                NSString *systemErrorStr = [name stringByAppendingString:unionSystemErrorMsg];
                self.bankNameLabel.text = systemErrorStr;
                self.bankNameLabel.textColor = UIColor_Gray_Text;
            }
            break;
        }
        case 7: {//银联支付
            //中国银联支付
            //判断支付渠道可用性
            NSInteger unionSystemStatus = [[pay_type_list valueNotNullForKey:@"xfunion_status"] integerValue];
            NSString *unionSystemErrorMsg = [NSString stringWithFormat:@"(%@)", [pay_type_list valueNotNullForKey:@"xfunion_msg"]];
            if (pay_type_list && [[pay_type_list allKeys] containsObject:@"xfunion_status"] && unionSystemStatus == 0) {
                NSString *name = self.bankNameLabel.text;
                NSString *systemErrorStr = [name stringByAppendingString:unionSystemErrorMsg];
                self.bankNameLabel.text = systemErrorStr;
                self.bankNameLabel.textColor = UIColor_Gray_Text;
            }

            break;
        }
        case 15: {
            //微信支付
            //判断支付渠道可用性
            NSInteger unionSystemStatus = [[pay_type_list valueNotNullForKey:@"wxsdk_status"] integerValue];
            NSString *unionSystemErrorMsg = [NSString stringWithFormat:@"(%@)", [pay_type_list valueNotNullForKey:@"wxsdk_msg"]];
            if (pay_type_list && [[pay_type_list allKeys] containsObject:@"wxsdk_status"] && unionSystemStatus == 0) {
                NSString *name = self.bankNameLabel.text;
                NSString *systemErrorStr = [name stringByAppendingString:unionSystemErrorMsg];
                self.bankNameLabel.text = systemErrorStr;
                self.bankNameLabel.textColor = UIColor_Gray_Text;
            }
            
            break;
        }

        case 12: {
            //一卡通支付
            //判断支付渠道可用性
            NSInteger unionSystemStatus = [[pay_type_list valueNotNullForKey:@"xfykt_status"] integerValue];
            NSString *unionSystemErrorMsg = [NSString stringWithFormat:@"(%@)", [pay_type_list valueNotNullForKey:@"xfykt_msg"]];
            if (pay_type_list && [[pay_type_list allKeys] containsObject:@"xfykt_status"] && unionSystemStatus == 0) {
                NSString *name = self.bankNameLabel.text;
                NSString *systemErrorStr = [name stringByAppendingString:unionSystemErrorMsg];
                self.bankNameLabel.text = systemErrorStr;
                self.bankNameLabel.textColor = UIColor_Gray_Text;
            }
            
            break;
        }
    }
    _arrowImg.hidden = YES;  //隐藏右箭头
    
    NSInteger selectedPayID = [[selectedDict valueWithNoDataForKey:@"id"] integerValue];
    if (cellPayID == selectedPayID) {
        self.selectedImageView.hidden = NO;
    }else{
        self.selectedImageView.hidden = YES;
    }
    
//    switch (row) {
////        case 0: {
////            //喜付支付
////            if ([bankName isEqualToString:@"喜付支付"]) {
////                //57-57
////                NSString *title = [NSString stringWithFormat:@"%@", bankName];
////                self.bankNameLabel.text = title;
////                [_bankLogoImgV setImage:[UIImage imageNamed:@"PayCenter_XifuWalletPay"]];
////
////            } else if ([bankName isEqualToString:@"喜付钱包"]) {
////                //
////                NSString *amountStr = [NSString stringWithFormat:@"%.2f",[amount floatValue]];
////
////                NSString *title = [NSString stringWithFormat:@"%@（余额:￥%@元）", bankName, amountStr];
////                self.bankNameLabel.text = title;
////                [_bankLogoImgV setImage:[UIImage imageNamed:@"PayCenter_XifuWalletPay"]];
////
////            } else {
////                bankCardNo = [bankCardNo substringWithRange:NSMakeRange(bankCardNo.length - 4, 4)];
////                NSString *title = [NSString stringWithFormat:@"%@（尾号: %@）", bankName, bankCardNo];
////                self.bankNameLabel.text = title;
////                [_bankLogoImgV sd_setImageWithURL:[NSURL URLWithString:[bankCardInfo valueNotNullForKey:@"card_logo"]] placeholderImage:[UIImage imageNamed:@"bank_icon_default"]];
////            }
////            
////            //判断支付渠道可用性
////            NSInteger xifuSystemStatus = [[pay_type_list valueNotNullForKey:@"xf_status"] integerValue];
////            NSString *xifuSystemErrorMsg = [NSString stringWithFormat:@"(%@)", [pay_type_list valueNotNullForKey:@"xf_msg"]];
////            if (pay_type_list && [[pay_type_list allKeys] containsObject:@"xf_status"] && xifuSystemStatus == 0) {
////                NSString *name = self.bankNameLabel.text;
////                NSString *systemErrorStr = [name stringByAppendingString:xifuSystemErrorMsg];
////                self.bankNameLabel.text = systemErrorStr;
////                self.bankNameLabel.textColor = UIColor_Gray_Text;
////            }
////
////            break;
////        }
//        case 0: {
//            //易极付支付
//            self.bankNameLabel.text = bankName;
//            _bankLogoImgV.image = [UIImage imageNamed:@"PayCenter_XifuWalletPay"];
//            
//            //判断支付渠道可用性
//            NSInteger unionSystemStatus = [[pay_type_list valueNotNullForKey:@"xfp_status"] integerValue];
//            NSString *unionSystemErrorMsg = [NSString stringWithFormat:@"(%@)", [pay_type_list valueNotNullForKey:@"xfp_msg"]];
//            if (pay_type_list && [[pay_type_list allKeys] containsObject:@"xfp_status"] && unionSystemStatus == 0) {
//                NSString *name = self.bankNameLabel.text;
//                NSString *systemErrorStr = [name stringByAppendingString:unionSystemErrorMsg];
//                self.bankNameLabel.text = systemErrorStr;
//                self.bankNameLabel.textColor = UIColor_Gray_Text;
//            }
//            break;
//        }
//        case 1: {
//            //中国银联
//            self.bankNameLabel.text = bankName;
//            _bankLogoImgV.image = [UIImage imageNamed:@"PayCenter_unionPay"];
//            
//            //判断支付渠道可用性
//            NSInteger unionSystemStatus = [[pay_type_list valueNotNullForKey:@"xfunion_status"] integerValue];
//            NSString *unionSystemErrorMsg = [NSString stringWithFormat:@"(%@)", [pay_type_list valueNotNullForKey:@"xfunion_msg"]];
//            if (pay_type_list && [[pay_type_list allKeys] containsObject:@"xfunion_status"] && unionSystemStatus == 0) {
//                NSString *name = self.bankNameLabel.text;
//                NSString *systemErrorStr = [name stringByAppendingString:unionSystemErrorMsg];
//                self.bankNameLabel.text = systemErrorStr;
//                self.bankNameLabel.textColor = UIColor_Gray_Text;
//            }
//
//            break;
//        }
//        case 2: {
//            //微信---暂未开通
////            self.bankNameLabel.text = bankName;
////            _bankLogoImgV.image = [UIImage imageNamed:@"PayCenter_wechatPay"];
//
//            break;
//        }
//        case 3: {
//            //支付宝---暂未开通
////            self.bankNameLabel.text = bankName;
////            _bankLogoImgV.image = [UIImage imageNamed:@"PayCenter_aliPay"];
//            
//            break;
//        }
//    }

//    _arrowImg.hidden = (row == 0) ? NO : YES;  //喜付支付才有右箭头
    

    

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
