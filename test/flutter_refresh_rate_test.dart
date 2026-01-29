import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_refresh_rate/flutter_refresh_rate.dart';
import 'package:flutter_refresh_rate/flutter_refresh_rate_platform_interface.dart';
import 'package:flutter_refresh_rate/flutter_refresh_rate_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterRefreshRatePlatform
    with MockPlatformInterfaceMixin
    implements FlutterRefreshRatePlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<List<DisplayMode>> getSupportedModes() => Future.value([
    const DisplayMode(modeId: 1, width: 1920, height: 1080, refreshRate: 60.0),
    const DisplayMode(modeId: 2, width: 1920, height: 1080, refreshRate: 120.0),
  ]);

  @override
  Future<DisplayMode> getActiveMode() => Future.value(
    const DisplayMode(modeId: 1, width: 1920, height: 1080, refreshRate: 60.0),
  );
}

void main() {
  final FlutterRefreshRatePlatform initialPlatform =
      FlutterRefreshRatePlatform.instance;

  test('\$MethodChannelFlutterRefreshRate is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterRefreshRate>());
  });

  test('getPlatformVersion', () async {
    FlutterRefreshRate flutterRefreshRatePlugin = FlutterRefreshRate();
    MockFlutterRefreshRatePlatform fakePlatform =
        MockFlutterRefreshRatePlatform();
    FlutterRefreshRatePlatform.instance = fakePlatform;

    expect(await flutterRefreshRatePlugin.getPlatformVersion(), '42');
  });

  test('getSupportedModes', () async {
    FlutterRefreshRate flutterRefreshRatePlugin = FlutterRefreshRate();
    MockFlutterRefreshRatePlatform fakePlatform =
        MockFlutterRefreshRatePlatform();
    FlutterRefreshRatePlatform.instance = fakePlatform;

    final modes = await flutterRefreshRatePlugin.getSupportedModes();
    expect(modes.length, 2);
    expect(modes[0].refreshRate, 60.0);
    expect(modes[1].refreshRate, 120.0);
  });

  test('getActiveMode', () async {
    FlutterRefreshRate flutterRefreshRatePlugin = FlutterRefreshRate();
    MockFlutterRefreshRatePlatform fakePlatform =
        MockFlutterRefreshRatePlatform();
    FlutterRefreshRatePlatform.instance = fakePlatform;

    final mode = await flutterRefreshRatePlugin.getActiveMode();
    expect(mode.modeId, 1);
    expect(mode.width, 1920);
    expect(mode.height, 1080);
    expect(mode.refreshRate, 60.0);
  });

  test('DisplayMode equality', () {
    const mode1 = DisplayMode(
      modeId: 1,
      width: 1920,
      height: 1080,
      refreshRate: 60.0,
    );
    const mode2 = DisplayMode(
      modeId: 1,
      width: 1920,
      height: 1080,
      refreshRate: 60.0,
    );
    const mode3 = DisplayMode(
      modeId: 2,
      width: 1920,
      height: 1080,
      refreshRate: 120.0,
    );

    expect(mode1, equals(mode2));
    expect(mode1, isNot(equals(mode3)));
  });

  test('DisplayMode fromMap', () {
    final map = {
      'modeId': 1,
      'width': 1920,
      'height': 1080,
      'refreshRate': 60.0,
    };
    final mode = DisplayMode.fromMap(map);

    expect(mode.modeId, 1);
    expect(mode.width, 1920);
    expect(mode.height, 1080);
    expect(mode.refreshRate, 60.0);
  });

  test('DisplayMode toString', () {
    const mode = DisplayMode(
      modeId: 1,
      width: 1920,
      height: 1080,
      refreshRate: 60.0,
    );
    expect(mode.toString(), contains('1920x1080'));
    expect(mode.toString(), contains('60.00Hz'));
  });
}
