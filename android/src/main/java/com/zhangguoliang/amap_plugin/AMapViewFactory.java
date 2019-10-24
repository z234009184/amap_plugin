package com.zhangguoliang.amap_plugin;

import android.content.Context;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class AMapViewFactory extends PlatformViewFactory {
    private final BinaryMessenger messenger;

    public AMapViewFactory(BinaryMessenger messenger) {
        super(StandardMessageCodec.INSTANCE);
        this.messenger = messenger;
    }


    @Override
    public PlatformView create(Context context, int i, Object o) {
        return new YZXMapView(context, messenger, i, (Map<String, Object>) o);
    }
}
