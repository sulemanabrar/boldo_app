import 'dart:math';

import 'package:uuid/uuid.dart';

import '../../fixtures/mock_confessions.dart';
import '../../models/confession.dart';
import '../confession_repository.dart';

class MockConfessionRepository implements ConfessionRepository {
  final List<Confession> _items = List.of(mockConfessions);
  final Uuid _uuid = const Uuid();
  final Random _random = Random();

  @override
  List<Confession> getFeed() {
    return List.unmodifiable(_items);
  }

  @override
  Future<Confession> addConfession({
    required Duration duration,
    required List<double> waveform,
    String? audioPath,
  }) async {
    final confession = Confession(
      id: _uuid.v4(),
      duration: duration,
      createdAt: DateTime.now(),
      replyCount: 0,
      waveform: waveform.isNotEmpty ? waveform : _generateWaveform(),
      audioPath: audioPath,
    );
    _items.insert(0, confession);
    return confession;
  }

  @override
  Future<void> incrementReplyCount(String confessionId) async {
    final index = _items.indexWhere((item) => item.id == confessionId);
    if (index == -1) return;
    _items[index] = _items[index].copyWith(replyCount: _items[index].replyCount + 1);
  }

  List<double> _generateWaveform() {
    return List<double>.generate(14, (_) => 0.15 + (_random.nextDouble() * 0.8));
  }
}
