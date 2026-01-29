import 'flutter_refresh_rate_platform_interface.dart';
import 'src/display_mode.dart';

export 'src/display_mode.dart';

/// A Flutter plugin to get display refresh rate and resolution information.
///
/// This plugin provides access to the device's display modes including
/// supported refresh rates and resolutions on Android devices.
class FlutterRefreshRate {
  /// Returns the platform version string.
  Future<String?> getPlatformVersion() {
    return FlutterRefreshRatePlatform.instance.getPlatformVersion();
  }

  /// Returns a list of all supported display modes.
  ///
  /// Each [DisplayMode] contains:
  /// - [DisplayMode.modeId]: Unique identifier for the mode
  /// - [DisplayMode.width]: Physical width in pixels
  /// - [DisplayMode.height]: Physical height in pixels
  /// - [DisplayMode.refreshRate]: Refresh rate in Hz
  ///
  /// Example:
  /// ```dart
  /// final refreshRate = FlutterRefreshRate();
  /// final modes = await refreshRate.getSupportedModes();
  /// for (final mode in modes) {
  ///   print('${mode.width}x${mode.height} @ ${mode.refreshRate}Hz');
  /// }
  /// ```
  ///
  /// Throws [PlatformException] if:
  /// - Android version is below 6.0 (API 23)
  /// - Activity is not attached
  Future<List<DisplayMode>> getSupportedModes() {
    return FlutterRefreshRatePlatform.instance.getSupportedModes();
  }

  /// Returns the currently active display mode.
  ///
  /// The returned [DisplayMode] contains the current resolution and refresh rate.
  ///
  /// Example:
  /// ```dart
  /// final refreshRate = FlutterRefreshRate();
  /// final activeMode = await refreshRate.getActiveMode();
  /// print('Current: ${activeMode.refreshRate}Hz');
  /// ```
  ///
  /// Throws [PlatformException] if:
  /// - Android version is below 6.0 (API 23)
  /// - Activity is not attached
  Future<DisplayMode> getActiveMode() {
    return FlutterRefreshRatePlatform.instance.getActiveMode();
  }
}
