import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/constants/app_constants.dart';

class RecordConfessionState {
  const RecordConfessionState({
    this.isRecording = false,
    this.elapsed = Duration.zero,
    this.canRecord = true,
    this.currentPath,
  });

  final bool isRecording;
  final Duration elapsed;
  final bool canRecord;
  final String? currentPath;

  RecordConfessionState copyWith({
    bool? isRecording,
    Duration? elapsed,
    bool? canRecord,
    String? currentPath,
  }) {
    return RecordConfessionState(
      isRecording: isRecording ?? this.isRecording,
      elapsed: elapsed ?? this.elapsed,
      canRecord: canRecord ?? this.canRecord,
      currentPath: currentPath ?? this.currentPath,
    );
  }
}

class RecordConfessionController extends StateNotifier<RecordConfessionState> {
  RecordConfessionController(this._ref) : super(const RecordConfessionState());

  final Ref _ref;
  Timer? _timer;

  Future<void> start() async {
    final audio = _ref.read(audioRecordingServiceProvider);
    final hasPermission = await audio.hasPermission();
    if (!hasPermission) {
      state = state.copyWith(canRecord: false);
      return;
    }

    final path = await audio.start();
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
    final duration = state.elapsed;
    final waveform = _mockWaveform();
    await _ref.read(confessionRepositoryProvider).addConfession(
          duration: duration,
          waveform: waveform,
          audioPath: audioPath,
        );
    state = const RecordConfessionState();
  }

  void discard() {
    _timer?.cancel();
    state = const RecordConfessionState();
  }

  List<double> _mockWaveform() {
    final random = Random();
    return List<double>.generate(14, (_) => 0.15 + random.nextDouble() * 0.8);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final recordConfessionControllerProvider =
    StateNotifierProvider.autoDispose<RecordConfessionController, RecordConfessionState>(
  (ref) => RecordConfessionController(ref),
);
