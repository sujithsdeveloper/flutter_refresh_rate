import 'package:flutter/material.dart';
import 'dart:async';

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
  String _platformVersion = 'Unknown';
  DisplayMode? _activeMode;
  List<DisplayMode> _supportedModes = [];
  String? _error;
  final _flutterRefreshRatePlugin = FlutterRefreshRate();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    DisplayMode? activeMode;
    List<DisplayMode> supportedModes = [];
    String? error;

    try {
      platformVersion =
          await _flutterRefreshRatePlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    try {
      activeMode = await _flutterRefreshRatePlugin.getActiveMode();
      supportedModes = await _flutterRefreshRatePlugin.getSupportedModes();
    } on PlatformException catch (e) {
      error = e.message;
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _activeMode = activeMode;
      _supportedModes = supportedModes;
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Flutter Refresh Rate Example')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Platform: $_platformVersion',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              if (_error != null) ...[
                Text(
                  'Error: $_error',
                  style: const TextStyle(color: Colors.red),
                ),
              ] else ...[
                Text(
                  'Active Display Mode',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                if (_activeMode != null)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Mode ID: ${_activeMode!.modeId}'),
                          Text(
                            'Resolution: ${_activeMode!.width} x ${_activeMode!.height}',
                          ),
                          Text(
                            'Refresh Rate: ${_activeMode!.refreshRate.toStringAsFixed(2)} Hz',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                Text(
                  'Supported Display Modes (${_supportedModes.length})',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _supportedModes.length,
                  itemBuilder: (context, index) {
                    final mode = _supportedModes[index];
                    final isActive = _activeMode?.modeId == mode.modeId;
                    return Card(
                      color: isActive ? Colors.green.shade50 : null,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isActive
                              ? Colors.green
                              : Colors.grey,
                          child: Text(
                            '${mode.modeId}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text('${mode.width} x ${mode.height}'),
                        subtitle: Text(
                          '${mode.refreshRate.toStringAsFixed(2)} Hz',
                        ),
                        trailing: isActive
                            ? const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              )
                            : null,
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: initPlatformState,
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}
