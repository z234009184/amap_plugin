package com.zhangguoliang.amap_plugin;

import io.flutter.plugin.common.PluginRegistry.Registrar;

/** AmapPlugin */
public class AmapPlugin {
  private static final String _viewType = "flutter_native_mapview";

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    registrar.platformViewRegistry().registerViewFactory(_viewType, new AMapViewFactory(registrar.messenger()));
  }

}
