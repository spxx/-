#import <UIKit/UIKit.h>


#define kTimeLineOriginX [BNTools sizeFitfour:68 five:68 six:78 sixPlus:88]

#define kReviewHeadHeight 44

#define kReviewFootHeight [BNTools sizeFitfour:64 five:70 six:76 sixPlus:82]

#define kReviewRowHeight  [BNTools sizeFitfour:50 five:60 six:75 sixPlus:90]

#define kReviewBtnBaseTag 200

#define kNotification_Updat_Review_Step                       @"kNotification_Updat_Review_Step"

typedef NS_ENUM(NSInteger, BNReviewStepType) {
    BNReviewStepTypeOne,   //实名信息填写
    BNReviewStepTypeTwo,   //等待信息认证
    BNReviewStepTypeThree, //阅读服务协议
    BNReviewStepTypeFour,  //用户视频认证
    BNReviewStepTypeFive,  //等待官方审核（审核视屏）
    BNReviewStepTypeSix    //认证完成
    
};


@interface BNReviewBKView : UIView

@property (strong, nonatomic) CADisplayLink *displayLink;

@property (assign, nonatomic) BNReviewStepType reviewStepType;

- (id)initWithFrame:(CGRect)frame reviewStep:(BNReviewStepType)step;

- (void)startDisplayLink;
@end
