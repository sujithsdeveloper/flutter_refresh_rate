import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_refresh_rate_platform_interface.dart';
import 'src/display_mode.dart';

/// An implementation of [FlutterRefreshRatePlatform] that uses method channels.
class MethodChannelFlutterRefreshRate extends FlutterRefreshRatePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_refresh_rate');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }

  @override
  Future<List<DisplayMode>> getSupportedModes() async {
    final List<dynamic> result = await methodChannel.invokeMethod(
      'getSupportedModes',
    );

    return result
        .map((e) => DisplayMode.fromMap(Map<dynamic, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<DisplayMode> getActiveMode() async {
    final Map<dynamic, dynamic> result = await methodChannel.invokeMethod(
      'getActiveMode',
    );

    return DisplayMode.fromMap(result);
  }

  @override
  Future<bool> setPreferredMode(int modeId) async {
    final bool result = await methodChannel.invokeMethod('setPreferredMode', {
      'modeId': modeId,
    });
    return result;
  }
}
