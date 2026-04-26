import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

import '../../../app/providers.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/time_format.dart';
import '../../../data/models/confession.dart';
import '../../../widgets/audio/animated_waveform.dart';
import '../../../widgets/audio/audio_progress_bar.dart';
import '../feed_controller.dart';

class ConfessionCard extends ConsumerWidget {
  const ConfessionCard({
    required this.confession,
    required this.onReplyTap,
    super.key,
  });

  final Confession confession;
  final VoidCallback onReplyTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedState = ref.watch(feedControllerProvider);
    final controller = ref.read(feedControllerProvider.notifier);
    final isActive = feedState.activeId == confession.id;
    final isPlaying = isActive && feedState.isPlaying;
    final duration = isActive && feedState.duration > Duration.zero
        ? feedState.duration
        : confession.duration;
    final position = isActive ? feedState.position : Duration.zero;
    final progress = duration.inMilliseconds == 0
        ? 0.0
        : position.inMilliseconds / duration.inMilliseconds;
    final hasFile = (confession.audioPath ?? '').isNotEmpty;
    final playerController = ref.read(audioPlaybackServiceProvider).playerController;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF280014), AppPalette.bg],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 54, 16, 24),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.fiber_manual_record, size: 10, color: AppPalette.accent),
                const SizedBox(width: 8),
                Text(
                  'BolDo',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${DateFormat('mm').format(confession.createdAt)}m ago',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            const Spacer(),
            if (hasFile && isActive)
              AudioFileWaveforms(
                playerController: playerController,
                size: const Size(double.infinity, 170),
                playerWaveStyle: PlayerWaveStyle(
                  spacing: 6,
                  fixedWaveColor: AppPalette.textPrimary.withOpacity(0.22),
                  liveWaveColor: AppPalette.textPrimary,
                  showSeekLine: false,
                  waveThickness: 4,
                ),
              )
            else
              AnimatedWaveform(
                samples: confession.waveform,
                isActive: isPlaying,
                height: 170,
                minBarHeight: 16,
                activeColor: AppPalette.textPrimary,
                idleColor: AppPalette.textPrimary.withOpacity(0.2),
              ),
            const SizedBox(height: 18),
            Text(
              '${formatDuration(position)} / ${formatDuration(duration)}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: 170,
              child: FilledButton.icon(
                onPressed: () => controller.togglePlayback(confession),
                icon: Icon(isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
                label: const Text('Listen'),
              ),
            ),
            const SizedBox(height: 16),
            AudioProgressBar(progress: progress),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onReplyTap,
                    icon: const Icon(Icons.chat_bubble_outline_rounded),
                    label: Text('${confession.replyCount} replies'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'SWIPE UP · NEXT CONFESSION',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(letterSpacing: 2),
            ),
          ],
        ),
      ),
    );
  }
}
