//
//  BNTypeDefines.h
//  Wallet
//
//  Created by mac on 15/2/3.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#ifndef Wallet_BNTypeDefines_h
#define Wallet_BNTypeDefines_h


//还钱类型
typedef NS_ENUM(NSInteger, ReturnMoneyStatus) {
    ReturnMoneyStatusReturnAll,         //已还完
    ReturnMoneyStatusReturnSome,        //未还完
    ReturnMoneyStatusTimeOut,           //已逾期
};

//还钱结果类型
typedef NS_ENUM(NSInteger, XiaoDaiPayResultStatus) {
    XiaoDaiPayResultStatusReturnMoneySuccess,         //还钱成功
    XiaoDaiPayResultStatusReturnMoneyFailed,          //还钱失败
    XiaoDaiPayResultStatusReturnMoneyProcessing,      //还钱处理中
    
    XiaoDaiPayResultStatusBorrowMoneySuccess,         //借钱成功
    XiaoDaiPayResultStatusBorrowMoneyFailed,          //借钱失败
    XiaoDaiPayResultStatusBorrowMoneyProcessing,      //借钱处理中
};

//提现详情
typedef NS_ENUM(NSInteger, FetchCashStatus) {
    FetchCashStatusUnderWay = 0,        //提现进行中
    FetchCashStatusFailed = 1,          //提现失败
};

//电费充值结果
typedef NS_ENUM(NSInteger, ElectricChargeStatus) {
    ElectricChargeStatusUnderWay = 0,    //充值进行中
    ElectricChargeStatusSucceed = 1,     //充值成功
    ElectricChargeStatusFailed = 2,      //充值失败
};

//收支交易状态
typedef NS_ENUM(NSInteger, IncomeSpendStatus) {
    IncomeSpendStatusSucceed = 0,        //交易成功
    IncomeSpendStatusProcessing = 1,     //交易进行中
    IncomeSpendStatusFailed = 2,         //交易失败
};

typedef NS_ENUM(NSInteger, RealNameReviewResult) {
    RealNameReviewResult_None = 0,
    RealNameReviewResult_Reviewing = 1,     //正在审核实名认证信息
    RealNameReviewResult_Failed    = 2,     //已经认证失败
    RealNameReviewResult_UploadFailed = 3,   //活体验证 上传失败
    
    RealNameReviewResult_TixianReviewing = 4,  //提现实名认证，正在审核实名认证信息
    RealNameReviewResult_TixianFailed = 5      //提现实名认真，失败了
};
#endif
