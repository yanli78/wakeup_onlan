import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class NativeAppLauncher {
  static const platform = MethodChannel('com.example.wakeup_onlan/launcher');

  static Future<bool> launchApp(String packageName) async {
    if (!Platform.isAndroid) return false;

    try {
      final bool result = await platform.invokeMethod('launchApp', {
        'packageName': packageName,
      });
      return result;
    } on PlatformException catch (e) {
      debugPrint("启动失败: '${e.message}'.");
      return false;
    }
  }

  static Future<void> openPlayStore(String packageName) async {
    if (!Platform.isAndroid) return;

    try {
      await platform.invokeMethod('openPlayStore', {
        'packageName': packageName,
      });
    } on PlatformException catch (e) {
      debugPrint("打开应用商店失败: '${e.message}'.");
    }
  }
}
