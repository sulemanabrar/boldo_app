class Confession {
  const Confession({
    required this.id,
    required this.duration,
    required this.createdAt,
    required this.replyCount,
    required this.waveform,
    this.audioPath,
  });

  final String id;
  final Duration duration;
  final DateTime createdAt;
  final int replyCount;
  final List<double> waveform;
  final String? audioPath;

  Confession copyWith({
    String? id,
    Duration? duration,
    DateTime? createdAt,
    int? replyCount,
    List<double>? waveform,
    String? audioPath,
  }) {
    return Confession(
      id: id ?? this.id,
      duration: duration ?? this.duration,
      createdAt: createdAt ?? this.createdAt,
      replyCount: replyCount ?? this.replyCount,
      waveform: waveform ?? this.waveform,
      audioPath: audioPath ?? this.audioPath,
    );
  }
}
