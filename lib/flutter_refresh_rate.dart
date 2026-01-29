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
  /// final refreshRate = FlutterRefreshRate();ph
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

  /// Sets the preferred display mode by mode ID.
  ///
  /// Use this to change the display refresh rate. Pass the [modeId]
  /// from one of the [DisplayMode] objects returned by [getSupportedModes].
  ///
  /// Example:
  /// ```dart
  /// final refreshRate = FlutterRefreshRate();
  /// final modes = await refreshRate.getSupportedModes();
  /// // Find the mode with highest refresh rate
  /// final maxMode = modes.reduce((a, b) =>
  ///     a.refreshRate > b.refreshRate ? a : b);
  /// await refreshRate.setPreferredMode(maxMode.modeId);
  /// ```
  ///
  /// Returns `true` if the mode was set successfully.
  ///
  /// Throws [PlatformException] if:
  /// - Android version is below 6.0 (API 23)
  /// - Activity is not attached
  /// - Invalid modeId is provided
  Future<bool> setPreferredMode(int modeId) {
    return FlutterRefreshRatePlatform.instance.setPreferredMode(modeId);
  }

  /// Sets the display to the maximum available refresh rate.
  ///
  /// This is a convenience method that finds the highest refresh rate
  /// among the supported display modes and sets it as the preferred mode.
  ///
  /// Example:
  /// ```dart
  /// final refreshRate = FlutterRefreshRate();
  /// await refreshRate.setMaxRefreshRate();
  /// ```
  ///
  /// Returns the [DisplayMode] that was set.
  ///
  /// Throws [PlatformException] if:
  /// - Android version is below 6.0 (API 23)
  /// - Activity is not attached
  /// - No supported modes are available
  Future<DisplayMode> setMaxRefreshRate() async {
    final modes = await getSupportedModes();
    if (modes.isEmpty) {
      throw Exception('No supported display modes available');
    }
    final maxMode = modes.reduce(
      (a, b) => a.refreshRate > b.refreshRate ? a : b,
    );
    await setPreferredMode(maxMode.modeId);
    return maxMode;
  }
}
