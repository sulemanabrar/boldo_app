import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/audio/audio_playback_service.dart';
import '../../data/models/confession.dart';

class FeedState {
  const FeedState({
    this.items = const <Confession>[],
    this.activeId,
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
  });

  final List<Confession> items;
  final String? activeId;
  final bool isPlaying;
  final Duration position;
  final Duration duration;

  FeedState copyWith({
    List<Confession>? items,
    String? activeId,
    bool? isPlaying,
    Duration? position,
    Duration? duration,
  }) {
    return FeedState(
      items: items ?? this.items,
      activeId: activeId ?? this.activeId,
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
    );
  }
}

class FeedController extends StateNotifier<FeedState> {
  FeedController(this._ref) : super(const FeedState()) {
    _load();
    _sub = _playback.stream.listen(_onPlayback);
  }

  final Ref _ref;
  late final AudioPlaybackService _playback = _ref.read(audioPlaybackServiceProvider);
  StreamSubscription<AudioPlaybackState>? _sub;

  void _load() {
    final items = _ref.read(confessionRepositoryProvider).getFeed();
    state = state.copyWith(items: items);
  }

  Future<void> togglePlayback(Confession confession) async {
    final isCurrent = state.activeId == confession.id;
    if (isCurrent && state.isPlaying) {
      await _playback.pause();
      return;
    }
    await _playback.play(
      id: confession.id,
      filePath: confession.audioPath,
      fallbackDuration: confession.duration,
    );
  }

  Future<void> refreshFeed() async {
    _load();
  }

  void _onPlayback(AudioPlaybackState playback) {
    state = state.copyWith(
      activeId: playback.activeId,
      isPlaying: playback.isPlaying,
      position: playback.position,
      duration: playback.duration,
    );
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

final feedControllerProvider = StateNotifierProvider<FeedController, FeedState>(
  (ref) => FeedController(ref),
);
