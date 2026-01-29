import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_refresh_rate_method_channel.dart';
import 'src/display_mode.dart';

abstract class FlutterRefreshRatePlatform extends PlatformInterface {
  /// Constructs a FlutterRefreshRatePlatform.
  FlutterRefreshRatePlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterRefreshRatePlatform _instance =
      MethodChannelFlutterRefreshRate();

  /// The default instance of [FlutterRefreshRatePlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterRefreshRate].
  static FlutterRefreshRatePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterRefreshRatePlatform] when
  /// they register themselves.
  static set instance(FlutterRefreshRatePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Returns the platform version string.
  Future<String?> getPlatformVersion() {
    throw UnimplementedError('getPlatformVersion() has not been implemented.');
  }

  /// Returns a list of all supported display modes.
  ///
  /// Each mode contains resolution (width x height) and refresh rate information.
  /// Requires Android 6.0 (API level 23) or higher.
  Future<List<DisplayMode>> getSupportedModes() {
    throw UnimplementedError('getSupportedModes() has not been implemented.');
  }

  /// Returns the currently active display mode.
  ///
  /// Contains the current resolution and refresh rate.
  /// Requires Android 6.0 (API level 23) or higher.
  Future<DisplayMode> getActiveMode() {
    throw UnimplementedError('getActiveMode() has not been implemented.');
  }
}
