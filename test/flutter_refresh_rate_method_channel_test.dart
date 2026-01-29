import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_refresh_rate/flutter_refresh_rate_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelFlutterRefreshRate platform = MethodChannelFlutterRefreshRate();
  const MethodChannel channel = MethodChannel('flutter_refresh_rate');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          switch (methodCall.method) {
            case 'getPlatformVersion':
              return '42';
            case 'getSupportedModes':
              return [
                {
                  'modeId': 1,
                  'width': 1920,
                  'height': 1080,
                  'refreshRate': 60.0,
                },
                {
                  'modeId': 2,
                  'width': 1920,
                  'height': 1080,
                  'refreshRate': 120.0,
                },
              ];
            case 'getActiveMode':
              return {
                'modeId': 1,
                'width': 1920,
                'height': 1080,
                'refreshRate': 60.0,
              };
            default:
              return null;
          }
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });

  test('getSupportedModes', () async {
    final modes = await platform.getSupportedModes();
    expect(modes.length, 2);
    expect(modes[0].modeId, 1);
    expect(modes[0].refreshRate, 60.0);
    expect(modes[1].modeId, 2);
    expect(modes[1].refreshRate, 120.0);
  });

  test('getActiveMode', () async {
    final mode = await platform.getActiveMode();
    expect(mode.modeId, 1);
    expect(mode.width, 1920);
    expect(mode.height, 1080);
    expect(mode.refreshRate, 60.0);
  });
}
