package com.zhangguoliang.amap_plugin;

import android.content.Context;
import android.location.Location;
import android.view.View;

import com.amap.api.location.AMapLocation;
import com.amap.api.location.AMapLocationClient;
import com.amap.api.location.AMapLocationClientOption;
import com.amap.api.location.AMapLocationListener;
import com.amap.api.maps.AMap;
import com.amap.api.maps.CameraUpdate;
import com.amap.api.maps.CameraUpdateFactory;
import com.amap.api.maps.TextureMapView;
import com.amap.api.maps.UiSettings;
import com.amap.api.maps.model.CameraPosition;
import com.amap.api.maps.model.LatLng;
import com.amap.api.maps.model.MyLocationStyle;
import com.amap.api.services.route.RouteSearch;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

public class YZXMapView implements PlatformView {
    // flutter->Native 地图交互ChannelName
    private final String methodChannelNameMapView = "flutter_native_mapview_";
    private final String methodChannelNameStartLocation = "methodChannelNameStartLocation";

    // 交互
    private MethodChannel methodChannel;

    // 地图视图
    private TextureMapView mapView;
    private AMap aMap; // 地图设置

    // 定位
    private AMapLocationClient mLocationClient; // 声明AMapLocationClient类对象

    // 路线规划相关
    private RouteSearch routeSearch;

    /**
     * 原生View初始化
     */
    YZXMapView(Context context, BinaryMessenger messenger, int id, Map<String, Object> params) {

        // flutter 传递过来的参数
        if (params != null && params.containsKey("content")) {
            String myContent = (String) params.get("content");
        }

        // flutter_native_mapview_ 是更新数据的通信标识
        methodChannel = new MethodChannel(messenger, methodChannelNameMapView + id);
        methodChannel.setMethodCallHandler(this::onMethodCall);


        // **** 地图功能
        initMapView(context);

        // **** 定位功能
        initLocation(context);

    }


    /**
     * 初始化地图
     */
    private void initMapView(Context context) {
        mapView = new TextureMapView(context);
        mapView.onCreate(null);
        aMap = mapView.getMap();
        // 显示我的定位点
        showMyLocation();
        // 设置交互
        setupInteract();

    }

    /**
     * 显示我的定位点
     */
    private void showMyLocation() {

        // 定位样式
        MyLocationStyle locationStyle = new MyLocationStyle();
        locationStyle.interval(1000); // 连续定位模式下的 定位间隔
        locationStyle.showMyLocation(true); // 设置是否显示定位小蓝点，用于满足只想使用定位，不想使用定位小蓝点的场景，设置false以后图面上不再有定位蓝点的概念，但是会持续回调位置信息。

        locationStyle.myLocationType(MyLocationStyle.LOCATION_TYPE_FOLLOW_NO_CENTER);
//        BitmapDescriptor bitmap = BitmapDescriptorFactory.fromResource(R.mipmap.location);
//        locationStyle.myLocationIcon(bitmap);
//        locationStyle.radiusFillColor(0x00000000);
        aMap.setMyLocationStyle(locationStyle);
        aMap.setMyLocationEnabled(true); // 是否显示定位蓝点 并启用定位功能 为false则表示不开启定位功能
        aMap.setOnMyLocationChangeListener(new AMap.OnMyLocationChangeListener() {
            @Override
            public void onMyLocationChange(Location location) {
                // 地图内置的定位监听
//            Log.e("zgl---地图定位", location.toString());
            }
        });

    }

    /**
     * 设置地图交互控件
     */
    private void setupInteract() {
        UiSettings mUiSettings = aMap.getUiSettings();
        // 不显示放大缩小 按钮
        mUiSettings.setZoomControlsEnabled(false);
    }


    /**
     * 初始化定位
     */
    private void initLocation(Context context) {
        // 参数设置
        // 声明初始化AMapLocationClientOption对象（参数设置）
        AMapLocationClientOption mLocationOption = new AMapLocationClientOption();
        // 设置定位模式为AMapLocationMode.Hight_Accuracy，高精度模式。
        mLocationOption.setLocationMode(AMapLocationClientOption.AMapLocationMode.Hight_Accuracy);
        // 获取一次定位结果：
        mLocationOption.setOnceLocation(true);
        // 设置定位同时是否需要返回地址描述。
        mLocationOption.setNeedAddress(false);
        // 设置是否允许模拟软件Mock位置结果，多为模拟GPS定位结果，默认为true，允许模拟位置。
        mLocationOption.setMockEnable(false);
        // 设置是否开启定位缓存机制
        mLocationOption.setLocationCacheEnable(true);

        // 初始化定位
        mLocationClient = new AMapLocationClient(context);
        // 给定位客户端对象设置定位参数
        mLocationClient.setLocationOption(mLocationOption);
        // 设置定位回调监听
        mLocationClient.setLocationListener(new AMapLocationListener() {
            @Override
            public void onLocationChanged(AMapLocation aMapLocation) {
                if (aMapLocation.getErrorCode() != 0) {
                    return;
                }

                showMyLocation();

                // 定位我的位置并动画位置到地图中心
                CameraUpdate mcameraUpdate = CameraUpdateFactory.newCameraPosition(
                        new CameraPosition(
                                new LatLng(aMapLocation.getLatitude(), aMapLocation.getLongitude()),
                                18,
                                0,
                                0)
                );

                aMap.animateCamera(mcameraUpdate, 250, new AMap.CancelableCallback() {
                    @Override
                    public void onFinish() {
                    }

                    @Override
                    public void onCancel() {
                    }
                });

            }
        });

        startLocation();
    }

    /**
     * 开始定位
     */
    private void startLocation() {
        // 开始定位
        mLocationClient.startLocation();
    }


    /**
     * flutter 交互回调
     */
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {

        //updateText 是flutter 中调用的方法名称，可以随意定义
        if (methodChannelNameStartLocation.equals(methodCall.method)) {
            // 先清空地图上的标记
            aMap.clear();
            //启动定位
            startLocation();
            result.success(null);
        }
    }

    @Override
    public View getView() {
        return mapView;
    }

    @Override
    public void dispose() {

    }

}
