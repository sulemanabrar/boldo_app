import '../models/voice_reply.dart';

abstract class ReplyRepository {
  List<VoiceReply> getReplies(String confessionId);
  Future<VoiceReply> addReply({
    required String confessionId,
    required Duration duration,
    String? audioPath,
  });
}
