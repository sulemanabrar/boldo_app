import 'dart:async';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';

class AudioPlaybackState {
  const AudioPlaybackState({
    this.activeId,
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
  });

  final String? activeId;
  final bool isPlaying;
  final Duration position;
  final Duration duration;
}

class AudioPlaybackService {
  AudioPlaybackService() {
    _player.onCurrentDurationChanged.listen((positionMs) {
      _position = Duration(milliseconds: positionMs);
      _emit();
    });
    _player.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
      _emit();
    });
    _player.onCompletion.listen((_) {
      _isPlaying = false;
      _position = _duration;
      _emit();
    });
  }

  final PlayerController _player = PlayerController();
  final StreamController<AudioPlaybackState> _controller =
      StreamController<AudioPlaybackState>.broadcast();

  Timer? _fakeTimer;
  String? _activeId;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _fakePlaying = false;
  bool _isPlaying = false;
  String? _activePath;

  Stream<AudioPlaybackState> get stream => _controller.stream;
  PlayerController get playerController => _player;

  Future<void> play({
    required String id,
    required Duration fallbackDuration,
    String? filePath,
  }) async {
    if (_activeId != id) {
      await stop();
    }

    _activeId = id;
    _duration = fallbackDuration;
    _position = Duration.zero;

    final hasFile = filePath != null && File(filePath).existsSync();
    if (hasFile) {
      if (_activePath != filePath) {
        await _player.preparePlayer(path: filePath);
        _activePath = filePath;
      }
      _duration = Duration(milliseconds: _player.maxDuration);
      await _player.startPlayer();
      _isPlaying = true;
      _emit();
      return;
    }

    _startFakeTicker();
  }

  Future<void> pause() async {
    _fakeTimer?.cancel();
    _fakePlaying = false;
    if (_isPlaying) {
      await _player.pausePlayer();
      _isPlaying = false;
    }
    _emit();
  }

  Future<void> stop() async {
    _fakeTimer?.cancel();
    _fakePlaying = false;
    _position = Duration.zero;
    if (_activePath != null) {
      await _player.stopPlayer();
    }
    _isPlaying = false;
    _activeId = null;
    _duration = Duration.zero;
    _emit();
  }

  void _startFakeTicker() {
    _fakePlaying = true;
    _fakeTimer?.cancel();
    _fakeTimer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      if (!_fakePlaying) return;
      final next = _position + const Duration(milliseconds: 200);
      if (next >= _duration) {
        _position = _duration;
        _fakePlaying = false;
        _fakeTimer?.cancel();
      } else {
        _position = next;
      }
      _emit();
    });
    _emit();
  }

  void _emit() {
    final playing = _fakePlaying || _isPlaying;
    final position = _position;
    final duration = _duration;
    _controller.add(
      AudioPlaybackState(
        activeId: _activeId,
        isPlaying: playing,
        position: position,
        duration: duration,
      ),
    );
  }

  Future<void> dispose() async {
    _fakeTimer?.cancel();
    _player.dispose();
    await _controller.close();
  }
}
