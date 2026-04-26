import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/audio/audio_playback_service.dart';
import '../core/audio/audio_recording_service.dart';
import '../data/repositories/confession_repository.dart';
import '../data/repositories/mock/mock_confession_repository.dart';
import '../data/repositories/mock/mock_reply_repository.dart';
import '../data/repositories/reply_repository.dart';
import '../features/auth/auth_service.dart';

final confessionRepositoryProvider = Provider<ConfessionRepository>(
  (ref) => MockConfessionRepository(),
);

final replyRepositoryProvider = Provider<ReplyRepository>(
  (ref) => MockReplyRepository(),
);

final audioPlaybackServiceProvider = Provider<AudioPlaybackService>((ref) {
  final service = AudioPlaybackService();
  ref.onDispose(service.dispose);
  return service;
});

final audioRecordingServiceProvider = Provider<AudioRecordingService>((ref) {
  final service = AudioRecordingService();
  ref.onDispose(service.dispose);
  return service;
});

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final authServiceProvider = Provider<AuthService>(
  (ref) => AuthService(ref.read(firebaseAuthProvider)),
);

final authStateChangesProvider = StreamProvider<User?>(
  (ref) => ref.read(authServiceProvider).authStateChanges(),
);
