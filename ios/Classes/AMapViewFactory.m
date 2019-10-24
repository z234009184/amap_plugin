//
//  AMapViewFactory.m
//  amap_plugin
//
//  Created by 张国梁 on 2019/10/24.
//

#import "AMapViewFactory.h"
#import "YZXMapView.h"
@implementation AMapViewFactory {
    NSObject<FlutterBinaryMessenger> *_messenger;
}
- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messager {
    if (self = [super init]) {
        _messenger = messager;
    }
    return self;
}

- (NSObject<FlutterMessageCodec> *)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}

- (NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args {
    YZXMapView *mapView = [[YZXMapView alloc] initWithFrame:frame viewIdentifier:viewId arguments:args binaryMessenger:_messenger];
    return mapView;
}

@end
