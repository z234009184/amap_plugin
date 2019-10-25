# amap_plugin
这是一个flutter的高德地图插件，支持iOS和Android平台

---
## Getting Started

### Add dependency
```
dependencies:
  amap_plugin:  
```
---
### Useage
#### Android
1.AndroidManifest.xml 配置  网络 定位 权限
```
//地图包、搜索包需要的基础权限

<!--允许程序打开网络套接字-->
<uses-permission android:name="android.permission.INTERNET" />  
<!--允许程序设置内置sd卡的写权限-->
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />    
<!--允许程序获取网络状态-->
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" /> 
<!--允许程序访问WiFi网络信息-->
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE" /> 
<!--允许程序读写手机状态和身份-->
<uses-permission android:name="android.permission.READ_PHONE_STATE" />     
<!--允许程序访问CellID或WiFi热点来获取粗略的位置-->
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" /> 
```
2.配置 AndroidManifest.xml 文件
在AndroidManifest.xml的application标签中配置Key：
```
<meta-data
android:name="com.amap.api.v2.apikey"
android:value="您的Key"/>
```
---
#### iOS
1.配置Info.plist 文件

iOS9为了增强数据访问安全，将所有的http请求都改为了https，为了能够在iOS9中正常使用地图SDK，请在"Info.plist"中添加如下配置，否则影响高德SDK的使用。
```
<key>NSAppTransportSecurity</key>
<dict>
<key>NSAllowsArbitraryLoads</key>
<true></true>
</dict>
```
在info.plist加入定位权限
定位权限有三种（前两个同时添加 或 同时不添加），您可根据需求进行选择。
```
Privacy - Location Always Usage Description   始终允许访问位置信息
Privacy - Location Always and When In Use Usage Description 始终允许访问位置信息

Privacy - Location Usage Description   永不允许访问位置信息

Privacy - Location When In Use Usage Description  使用应用期间允许访问位置信息
```

2.配置Info.plist 文件
如下加入高德apikey 字段
```
<key>AMapAPIKey</key>
<string>
您的Key
</string>
```
---
#### Flutter
使用如下：

```
import 'package:amap_plugin/amap_plugin.dart';
```
```
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
    @override
    _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            home: Scaffold(
                appBar: AppBar(
                    title: const Text('Plugin example app'),
                    ),
            body: AMapView(),
            ),
        );
    }   
}
```

---
##### 其他
如有bug 或者 需求 请在 [GitHub](https://github.com/z234009184/amap_plugin) 提 issues
或者发本人邮箱共同学习探讨：234009184@qq.com

