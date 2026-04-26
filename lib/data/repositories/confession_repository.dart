import '../models/confession.dart';

abstract class ConfessionRepository {
  List<Confession> getFeed();
  Future<Confession> addConfession({
    required Duration duration,
    required List<double> waveform,
    String? audioPath,
  });
  Future<void> incrementReplyCount(String confessionId);
}
