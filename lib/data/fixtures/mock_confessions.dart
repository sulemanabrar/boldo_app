import '../models/confession.dart';

final mockConfessions = <Confession>[
  Confession(
    id: 'conf_1',
    duration: const Duration(seconds: 17),
    createdAt: DateTime.now().subtract(const Duration(minutes: 3)),
    replyCount: 3,
    waveform: const [0.2, 0.6, 0.4, 0.85, 0.5, 0.35, 0.7, 0.45],
  ),
  Confession(
    id: 'conf_2',
    duration: const Duration(seconds: 22),
    createdAt: DateTime.now().subtract(const Duration(minutes: 9)),
    replyCount: 5,
    waveform: const [0.35, 0.5, 0.75, 0.55, 0.3, 0.65, 0.45, 0.8],
  ),
  Confession(
    id: 'conf_3',
    duration: const Duration(seconds: 12),
    createdAt: DateTime.now().subtract(const Duration(minutes: 14)),
    replyCount: 2,
    waveform: const [0.15, 0.45, 0.8, 0.3, 0.6, 0.4, 0.5, 0.7],
  ),
];
