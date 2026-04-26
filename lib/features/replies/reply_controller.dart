import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/voice_reply.dart';

class ReplyState {
  const ReplyState({
    this.items = const <VoiceReply>[],
    this.isRecording = false,
    this.elapsed = Duration.zero,
    this.currentPath,
  });

  final List<VoiceReply> items;
  final bool isRecording;
  final Duration elapsed;
  final String? currentPath;

  ReplyState copyWith({
    List<VoiceReply>? items,
    bool? isRecording,
    Duration? elapsed,
    String? currentPath,
  }) {
    return ReplyState(
      items: items ?? this.items,
      isRecording: isRecording ?? this.isRecording,
      elapsed: elapsed ?? this.elapsed,
      currentPath: currentPath ?? this.currentPath,
    );
  }
}

class ReplyController extends StateNotifier<ReplyState> {
  ReplyController(this._ref, this.confessionId) : super(const ReplyState()) {
    load();
  }

  final Ref _ref;
  final String confessionId;
  Timer? _timer;

  void load() {
    final replies = _ref.read(replyRepositoryProvider).getReplies(confessionId);
    state = state.copyWith(items: replies);
  }

  Future<void> startRecording() async {
    final recording = _ref.read(audioRecordingServiceProvider);
    if (!await recording.hasPermission()) return;
    final path = await recording.start();
    state = state.copyWith(isRecording: true, elapsed: Duration.zero, currentPath: path);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      final next = state.elapsed + const Duration(seconds: 1);
      if (next >= AppConstants.confessionLimit) {
        await stopAndSave();
        return;
      }
      state = state.copyWith(elapsed: next);
    });
  }

  Future<void> stopAndSave() async {
    _timer?.cancel();
    final audioPath = await _ref.read(audioRecordingServiceProvider).stop();
    await _ref.read(replyRepositoryProvider).addReply(
          confessionId: confessionId,
          duration: state.elapsed,
          audioPath: audioPath,
        );
    await _ref.read(confessionRepositoryProvider).incrementReplyCount(confessionId);
    load();
    state = state.copyWith(
      isRecording: false,
      elapsed: Duration.zero,
      currentPath: null,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final replyControllerProvider =
    StateNotifierProvider.autoDispose.family<ReplyController, ReplyState, String>(
  (ref, confessionId) => ReplyController(ref, confessionId),
);
