#import "AmapPlugin.h"
#import "AMapViewFactory.h"
@implementation AmapPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    static NSString *identifier = @"flutter_native_mapview";
    [registrar registerViewFactory:[[AMapViewFactory alloc] initWithMessenger:registrar.messenger] withId:identifier];
}


@end
