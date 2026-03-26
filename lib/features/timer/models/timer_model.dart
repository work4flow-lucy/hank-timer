class TimerModel {
  final Duration duration;
  final String label;
  final String sound;
  bool isRunning;

  TimerModel({
    required this.duration,
    this.label = 'Timer',
    this.sound = 'Radar',
    this.isRunning = false,
  });

  String get displayTime {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  TimerModel copyWith({
    Duration? duration,
    String? label,
    String? sound,
    bool? isRunning,
  }) {
    return TimerModel(
      duration: duration ?? this.duration,
      label: label ?? this.label,
      sound: sound ?? this.sound,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}
