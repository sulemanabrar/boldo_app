class VoiceReply {
  const VoiceReply({
    required this.id,
    required this.confessionId,
    required this.duration,
    required this.createdAt,
    this.audioPath,
  });

  final String id;
  final String confessionId;
  final Duration duration;
  final DateTime createdAt;
  final String? audioPath;
}
