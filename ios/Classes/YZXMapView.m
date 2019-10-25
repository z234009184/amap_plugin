//
//  YZXMapView.m
//  Runner
//
//  Created by 张国梁 on 2019/9/6.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import "YZXMapView.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

static  NSString *methodChannelNameMap = @"flutter_native_mapview_";
static  NSString *methodChannelNameStartLocation = @"methodChannelNameStartLocation";

@interface YZXMapView() <MAMapViewDelegate, AMapSearchDelegate>
/// flutter 交互对象
@property (nonatomic, strong) FlutterMethodChannel *methodChannel;
/// 地图
@property (nonatomic, strong) MAMapView *mapView;
/// 定位管理者
@property (nonatomic, strong) AMapLocationManager *locationManager;
/// 搜索对象 AMapSearchAPI
@property (nonatomic, strong) AMapSearchAPI *search;
@end

@implementation YZXMapView

/// 初始化高德 API_KEY
+ (void)load {
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *apiKey = [infoDict objectForKey:@"AMapAPIKey"];
    [AMapServices sharedServices].apiKey = apiKey;
}

- (instancetype)initWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger {
    if ([super init]) {
        if (CGSizeEqualToSize(frame.size, CGSizeZero)) {
            frame = CGRectMake(frame.origin.x, frame.origin.y, [UIScreen mainScreen].bounds.size.width, 50);
        }
        
        // 注册flutter 与 ios 通信通道
        NSString *channelName = [NSString stringWithFormat:@"%@%lld", methodChannelNameMap, viewId];
        _methodChannel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        __weak __typeof__(self) weakSelf = self;
        [_methodChannel setMethodCallHandler:^(FlutterMethodCall *  call, FlutterResult  result) {
            [weakSelf onMethodCall:call result:result];
        }];
        
        // 初始化地图
        [self initMapViewWithFrame:frame];
        // 定位
        [self locationManager];
        
        
    }
    return self;
}


/**
 初始化地图
 */
- (void)initMapViewWithFrame:(CGRect)frame {
    _mapView = [[MAMapView alloc] initWithFrame:frame];
    _mapView.zoomLevel = 18;
    _mapView.showsCompass = NO;
    _mapView.showsScale = NO;
    _mapView.delegate = self;
    // 显示我的位置
    [self showMyLocation];
}


- (void)showMyLocation {
    
    MAUserLocationRepresentation *representation = [MAUserLocationRepresentation new];
    representation.showsAccuracyRing = YES; // 是否显示精度圈，默认YES
    representation.showsHeadingIndicator = YES; // 是否显示方向指示(MAUserTrackingModeFollowWithHeading模式开启)。默认为YES
//    representation.image = [UIImage imageNamed:@"location"];  // 定位图标, 与蓝色原点互斥
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    [_mapView updateUserLocationRepresentation:representation];
}

/// 开始定位
- (void)startLocation {
    // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
    __weak typeof(self) weakSelf = self;
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error) {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            if (error.code == AMapLocationErrorLocateFailed) {
                return;
            }
        }
        
        [self showMyLocation];
        [weakSelf.mapView setCenterCoordinate:location.coordinate animated:YES];
        [weakSelf.mapView setZoomLevel:18 animated:YES];
    }];
}


#pragma mark - <MAMapViewDelegate>
/**
 *  @brief 当plist配置NSLocationAlwaysUsageDescription或者NSLocationAlwaysAndWhenInUseUsageDescription，并且[CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined，会调用代理的此方法。
 此方法实现调用后台权限API即可（ 该回调必须实现 [locationManager requestAlwaysAuthorization] ）; since 6.8.0
 *  @param locationManager  地图的CLLocationManager。
 */
- (void)mapViewRequireLocationAuth:(CLLocationManager *)locationManager {
    [locationManager requestAlwaysAuthorization];
}

/**
 * @brief 根据anntation生成对应的View。
 
 注意：5.1.0后由于定位蓝点增加了平滑移动功能，如果在开启定位的情况先添加annotation，需要在此回调方法中判断annotation是否为MAUserLocation，从而返回正确的View。
 if ([annotation isKindOfClass:[MAUserLocation class]]) {
 return nil;
 }
 
 * @param mapView 地图View
 * @param annotation 指定的标注
 * @return 生成的标注View
 */
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        return nil;
    }
    return nil;
}

/// Native -> flutter 方法
-(void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result{
    if ([methodChannelNameStartLocation isEqualToString:call.method]) {
        // 定位
        // 清除所有标记
        [self.mapView removeAnnotations:self.mapView.annotations];
        [self.mapView removeOverlays:self.mapView.overlays];
        // 定位
        [self startLocation];
    }
}


/// 返回flutter地图
- (nonnull UIView *)view {
    return _mapView;
}



#pragma mark - lazy

- (AMapLocationManager *)locationManager {
    if (nil == _locationManager) {
        _locationManager = [[AMapLocationManager alloc] init];
        // 带逆地理信息的一次定位（返回坐标和地址信息）
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        //   定位超时时间，最低2s，此处设置为2s
        _locationManager.locationTimeout = 3;
        //   逆地理请求超时时间，最低2s，此处设置为2s
        _locationManager.reGeocodeTimeout = 2;
    }
    return _locationManager;
}

- (AMapSearchAPI *)search {
    if (nil == _search) {
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }
    return _search;
}

@end
