import 'dart:io';
import 'native_app_launcher.dart';

class AppLauncherService {
  static const String tailscalePackage = 'com.tailscale.ipn';

  static Future<void> launchTailscale() async {
    if (!Platform.isAndroid) return;

    final success = await NativeAppLauncher.launchApp(tailscalePackage);
    if (!success) {
      await NativeAppLauncher.openPlayStore(tailscalePackage);
    }
  }
}
