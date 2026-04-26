import 'package:uuid/uuid.dart';

import '../../models/voice_reply.dart';
import '../reply_repository.dart';

class MockReplyRepository implements ReplyRepository {
  final Uuid _uuid = const Uuid();
  final Map<String, List<VoiceReply>> _items = <String, List<VoiceReply>>{};

  @override
  List<VoiceReply> getReplies(String confessionId) {
    return List.unmodifiable(_items[confessionId] ?? const []);
  }

  @override
  Future<VoiceReply> addReply({
    required String confessionId,
    required Duration duration,
    String? audioPath,
  }) async {
    final reply = VoiceReply(
      id: _uuid.v4(),
      confessionId: confessionId,
      duration: duration,
      createdAt: DateTime.now(),
      audioPath: audioPath,
    );
    _items.putIfAbsent(confessionId, () => <VoiceReply>[]).insert(0, reply);
    return reply;
  }
}
