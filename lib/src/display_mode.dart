/// Represents a display mode with resolution and refresh rate information.
class DisplayMode {
  /// Unique identifier for this display mode.
  final int modeId;

  /// Physical width of the display in pixels.
  final int width;

  /// Physical height of the display in pixels.
  final int height;

  /// Refresh rate in Hz (frames per second).
  final double refreshRate;

  /// Creates a new [DisplayMode] instance.
  const DisplayMode({
    required this.modeId,
    required this.width,
    required this.height,
    required this.refreshRate,
  });

  /// Creates a [DisplayMode] from a map (typically from platform channel).
  factory DisplayMode.fromMap(Map<dynamic, dynamic> map) {
    return DisplayMode(
      modeId: map['modeId'] as int,
      width: map['width'] as int,
      height: map['height'] as int,
      refreshRate: (map['refreshRate'] as num).toDouble(),
    );
  }

  /// Converts this [DisplayMode] to a map.
  Map<String, dynamic> toMap() {
    return {
      'modeId': modeId,
      'width': width,
      'height': height,
      'refreshRate': refreshRate,
    };
  }

  @override
  String toString() {
    return 'DisplayMode(modeId: $modeId, ${width}x$height @ ${refreshRate.toStringAsFixed(2)}Hz)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DisplayMode &&
        other.modeId == modeId &&
        other.width == width &&
        other.height == height &&
        other.refreshRate == refreshRate;
  }

  @override
  int get hashCode {
    return Object.hash(modeId, width, height, refreshRate);
  }
}
