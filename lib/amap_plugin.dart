import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AMapView extends StatelessWidget {

  static const methodChannelNameMap = 'flutter_native_mapview';
  static const methodChannelNameStartLocation = 'methodChannelNameStartLocation';

  MethodChannel _channel;

  @override
  Widget build(BuildContext context) {
    Widget nativeView;
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      nativeView = UiKitView(
        viewType: methodChannelNameMap,
        creationParams: {"content": "flutter 传入的文本内容"},
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (viewId) {
          _initChannel(viewId);
        },
      );
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      nativeView = AndroidView(
        viewType: methodChannelNameMap,
        creationParams: {"content": "flutter 传入的文本内容"},
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (_viewId) {
          _initChannel(_viewId);
        },
      );
    } else {
      nativeView = Center(
        child: Text(
          '$defaultTargetPlatform is not yet supported by the maps plugin',
        ),
      );
    }
    return nativeView;
  }

  /// 初始化Channel
  void _initChannel(int viewId) {
    _channel = MethodChannel(methodChannelNameMap + '_' + viewId.toString());

    // 监听Native的调用
    _channel.setMethodCallHandler((call) async {
      if (call.method == '') {

      }
    });
  }

  /// 定位
  void starLocation() {
    _channel.invokeMethod(methodChannelNameStartLocation);
  }


}

