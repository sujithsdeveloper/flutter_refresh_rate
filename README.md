# flutter_refresh_rate

A Flutter plugin to get and set display refresh rate and resolution information on Android devices.

[![pub package](https://img.shields.io/pub/v/flutter_refresh_rate.svg)](https://pub.dev/packages/flutter_refresh_rate)

## Features

- 🔍 **Get Supported Display Modes** - Retrieve all available display modes with resolution and refresh rate
- 📊 **Get Active Display Mode** - Get the currently active display mode
- ⚡ **Set Preferred Display Mode** - Change the display refresh rate by mode ID
- 🚀 **Set Maximum Refresh Rate** - Automatically set the highest available refresh rate

## Platform Support

| Platform | Support |
|----------|---------|
| Android  | ✅ API 23+ (Android 6.0+) |
| iOS      | ❌ Not supported |

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_refresh_rate: ^0.0.7
```

Then run:

```bash
flutter pub get
```

## Usage

### Import the package

```dart
import 'package:flutter_refresh_rate/flutter_refresh_rate.dart';
```

### Create an instance

```dart
final flutterRefreshRate = FlutterRefreshRate();
```

### Set Maximum Refresh Rate

The simplest way to enable the highest refresh rate on the device:

```dart
// Automatically finds and sets the highest available refresh rate
final maxMode = await flutterRefreshRate.setMaxRefreshRate();
print('Set to: ${maxMode.refreshRate}Hz');
```

### Get Supported Display Modes

Retrieve all available display modes:

```dart
final modes = await flutterRefreshRate.getSupportedModes();

for (final mode in modes) {
  print('Mode ${mode.modeId}: ${mode.width}x${mode.height} @ ${mode.refreshRate}Hz');
}
```

### Get Active Display Mode

Get the currently active display mode:

```dart
final activeMode = await flutterRefreshRate.getActiveMode();
print('Current: ${activeMode.width}x${activeMode.height} @ ${activeMode.refreshRate}Hz');
```

### Set Preferred Display Mode

Set a specific display mode by its ID:

```dart
final modes = await flutterRefreshRate.getSupportedModes();

// Find a specific mode (e.g., 120Hz)
final mode120Hz = modes.firstWhere(
  (mode) => mode.refreshRate >= 120,
  orElse: () => modes.first,
);

await flutterRefreshRate.setPreferredMode(mode120Hz.modeId);
```

## DisplayMode Class

The `DisplayMode` class contains the following properties:

| Property | Type | Description |
|----------|------|-------------|
| `modeId` | `int` | Unique identifier for the display mode |
| `width` | `int` | Physical width in pixels |
| `height` | `int` | Physical height in pixels |
| `refreshRate` | `double` | Refresh rate in Hz |

## Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_refresh_rate/flutter_refresh_rate.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _flutterRefreshRate = FlutterRefreshRate();
  DisplayMode? _activeMode;
  List<DisplayMode> _supportedModes = [];

  @override
  void initState() {
    super.initState();
    _initRefreshRate();
  }

  Future<void> _initRefreshRate() async {
    try {
      // Set maximum refresh rate on startup
      await _flutterRefreshRate.setMaxRefreshRate();
      
      // Get current state
      final activeMode = await _flutterRefreshRate.getActiveMode();
      final supportedModes = await _flutterRefreshRate.getSupportedModes();

      setState(() {
        _activeMode = activeMode;
        _supportedModes = supportedModes;
      });
    } on PlatformException catch (e) {
      print('Error: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Refresh Rate Demo')),
        body: ListView.builder(
          itemCount: _supportedModes.length,
          itemBuilder: (context, index) {
            final mode = _supportedModes[index];
            final isActive = _activeMode?.modeId == mode.modeId;
            
            return ListTile(
              title: Text('${mode.width}x${mode.height}'),
              subtitle: Text('${mode.refreshRate.toStringAsFixed(2)} Hz'),
              trailing: isActive ? const Icon(Icons.check, color: Colors.green) : null,
              onTap: () async {
                await _flutterRefreshRate.setPreferredMode(mode.modeId);
                await _initRefreshRate();
              },
            );
          },
        ),
      ),
    );
  }
}
```

## Error Handling

The plugin throws `PlatformException` in the following cases:

- **UNSUPPORTED**: Android version is below 6.0 (API 23)
- **NO_ACTIVITY**: Activity is not attached
- **INVALID_ARGUMENT**: Invalid mode ID provided

```dart
try {
  await flutterRefreshRate.setMaxRefreshRate();
} on PlatformException catch (e) {
  if (e.code == 'UNSUPPORTED') {
    print('Android 6.0+ required');
  } else if (e.code == 'NO_ACTIVITY') {
    print('Activity not available');
  }
}
```

## Notes

- The refresh rate change is applied to the current window/activity
- Some devices may not support all refresh rates even if they are listed
- Battery saving modes may override the preferred refresh rate
- The actual refresh rate may vary based on content and system settings

## License

MIT License - see the [LICENSE](LICENSE) file for details.
