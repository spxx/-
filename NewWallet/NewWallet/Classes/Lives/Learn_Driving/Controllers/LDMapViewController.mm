//
//  LDMapViewController.m
//  Wallet
//
//  Created by mac1 on 16/5/30.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "LDMapViewController.h"
#import "LDAnnotation.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件

#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件


@interface LDMapViewController ()<BMKLocationServiceDelegate,BMKMapViewDelegate>

@property (strong, nonatomic) BMKMapView *mapView;
@property (strong, nonatomic) BMKLocationService *locationsService;
@property (strong, nonatomic) UIView *bottomView;
@property (weak, nonatomic) UILabel *distanceLbl;

@property (assign, nonatomic) BOOL isFirstUpdateUserLocation;

@end

@implementation LDMapViewController
-(void)viewWillAppear:(BOOL)animated
{
    [self.mapView viewWillAppear];
    self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locationsService.delegate = self;
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locationsService.delegate = nil;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.customNavigationBar.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.isFirstUpdateUserLocation = YES;
    
    [self setupLoadedView];
    //   启动定位服务
    _locationsService=[[BMKLocationService alloc] init];
    [_locationsService startUserLocationService];
}

- (void)setupLoadedView
{
    self.mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    _mapView.delegate = self;
    _mapView.logoPosition = BMKLogoPositionRightTop;
    [self.view addSubview:_mapView];
    
    double fieldLongtiude = [NSString stringWithFormat:@"%@", self.areaModel.field_longitude].doubleValue;
    double fieldLatiude = [NSString stringWithFormat:@"%@", self.areaModel.field_latitude].doubleValue;
    
    BMKPointAnnotation *pointAnnotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor1;
    coor1.latitude = fieldLatiude;
    coor1.longitude = fieldLongtiude;
    pointAnnotation.coordinate = coor1;
    pointAnnotation.title = _areaModel.field_name;
    [_mapView addAnnotation:pointAnnotation];

    
    CGFloat bottomViewWidth =  SCREEN_WIDTH - 30 * NEW_BILI;
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(15 * NEW_BILI, SCREEN_HEIGHT,bottomViewWidth, 120 * NEW_BILI)];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.layer.borderWidth = 0.5;
    bottomView.layer.borderColor = UIColor_GrayLine.CGColor;
    [self.view insertSubview:bottomView aboveSubview:_mapView];
    _bottomView = bottomView;
    
    UIView *verticlLine = [[UIView alloc] initWithFrame:CGRectMake(15 * NEW_BILI, 22 * NEW_BILI, 4 * NEW_BILI, 15 * NEW_BILI)];
    verticlLine.backgroundColor = BNColorRGB(78, 149, 255);
    [bottomView addSubview:verticlLine];
    
    UIColor *tempColor = BNColorRGB(155, 174, 183);
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(verticlLine.frame) + 5 * NEW_BILI, 22 * NEW_BILI, 140, 15 * NEW_BILI)];
    nameLabel.text = _areaModel.field_name;
    nameLabel.font = [UIFont systemFontOfSize:15 * NEW_BILI];
    nameLabel.textColor = [UIColor blackColor];
    [bottomView addSubview:nameLabel];
    
    UILabel *distance = [[UILabel alloc] initWithFrame:CGRectMake(bottomViewWidth - 117*NEW_BILI, 22 * NEW_BILI, 100 * NEW_BILI, 15 * NEW_BILI)];
    distance.text = [NSString stringWithFormat:@"距离 %@km",@"__"];
    distance.font = [UIFont systemFontOfSize:12 * NEW_BILI];
    distance.textColor = tempColor;
    distance.textAlignment = NSTextAlignmentRight;
    [bottomView addSubview:distance];
    _distanceLbl = distance;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15*NEW_BILI, CGRectGetMaxY(nameLabel.frame) + 12.5 * NEW_BILI, SCREEN_WIDTH - 30 * NEW_BILI, 0.5)];
    line.backgroundColor = UIColor_GrayLine;
    [bottomView addSubview:line];
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(24*NEW_BILI, CGRectGetMaxY(line.frame) + 10*NEW_BILI, 300 * NEW_BILI, 14 * NEW_BILI)];
    addressLabel.text = [NSString stringWithFormat:@"地址： %@",_areaModel.field_position_name];
    addressLabel.font = [UIFont systemFontOfSize:12 * NEW_BILI];
    addressLabel.textColor = tempColor;
    [bottomView addSubview:addressLabel];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(addressLabel.frame), CGRectGetMaxY(addressLabel.frame) + 14*NEW_BILI, 300 * NEW_BILI, 16 * NEW_BILI)];
    timeLabel.text = [NSString stringWithFormat:@"运营时间： %@",_areaModel.operate_time_desc];
    timeLabel.font = [UIFont systemFontOfSize:12 * NEW_BILI];
    timeLabel.textColor = tempColor;
    [bottomView addSubview:timeLabel];
    

    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(15 * NEW_BILI, 23.5 * NEW_BILI, 37, 37);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"ld_map_backButton"] forState:UIControlStateNormal];
    [backBtn addTarget: self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}



#pragma mark - BMKMapViewDelegate

//地图加载完毕
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView
{
    [UIView animateWithDuration:1.5 animations:^{
        _bottomView.frame = CGRectMake(15 * NEW_BILI, SCREEN_HEIGHT - 120 * NEW_BILI,  SCREEN_WIDTH - 30 * NEW_BILI, 120 * NEW_BILI);
    }];
}

//区域已经改变
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation;
{
//    if (![annotation isKindOfClass:[LDAnnotation class]]) {
//        BMKPinAnnotationView *pinAnno = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
//        pinAnno.image = [UIImage imageNamed:@"ld_map_myPosion"];
//        pinAnno.animatesDrop = YES;
//        return pinAnno;
//    }
    
    BMKPinAnnotationView *annotaionView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"ldannotaion"];
    if (!annotaionView) {
        annotaionView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"ldannotaion"];
    }
    annotaionView.annotation = annotation;
    annotaionView.image = [UIImage imageNamed:@"ld_map_fieldPosion"];
    annotaionView.animatesDrop = YES;
    return annotaionView;
    
}

#pragma mark - BMKLocationServiceDelegate
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    if (self.isFirstUpdateUserLocation) {
        
        userLocation.title = @"我的位置";
        self.isFirstUpdateUserLocation = NO;
        
        BMKCoordinateSpan span;
        span.longitudeDelta = 0.2;
        span.latitudeDelta = 0.2;
        BMKCoordinateRegion region;
        region.center = userLocation.location.coordinate;
        region.span = span;
        _mapView.region = region;
        [_mapView updateLocationData:userLocation];
        
        double fieldLongtiude = [NSString stringWithFormat:@"%@", self.areaModel.field_longitude].doubleValue;
        double fieldLatiude = [NSString stringWithFormat:@"%@", self.areaModel.field_latitude].doubleValue;
        BMKMapPoint point1 = BMKMapPointForCoordinate(userLocation.location.coordinate);
        BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(fieldLatiude,fieldLongtiude));
        CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);
        _distanceLbl.text = [NSString stringWithFormat:@"距离 %.2fkm",distance/1000];
        
        [_locationsService stopUserLocationService];
    }
}






@end
