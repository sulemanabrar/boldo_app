import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

import '../../app/providers.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/time_format.dart';
import 'record_confession_controller.dart';

class RecordConfessionSheet extends ConsumerWidget {
  const RecordConfessionSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(recordConfessionControllerProvider);
    final controller = ref.read(recordConfessionControllerProvider.notifier);
    final remaining = AppConstants.confessionLimit - state.elapsed;
    final recorderController = ref.read(audioRecordingServiceProvider).recorderController;

    return FractionallySizedBox(
      heightFactor: 0.96,
      child: Container(
        decoration: const BoxDecoration(
          color: AppPalette.bg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Confess anonymously',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text('Sounds good?', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 8),
              Text(
                formatDuration(state.elapsed),
                style: Theme.of(context).textTheme.displayLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                'MAX 30 SECONDS',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(letterSpacing: 3),
              ),
              const SizedBox(height: 36),
              AudioWaveforms(
                enableGesture: false,
                size: const Size(double.infinity, 130),
                recorderController: recorderController,
                waveStyle: WaveStyle(
                  spacing: 6,
                  waveColor: Colors.white.withOpacity(0.18),
                  extendWaveform: true,
                  showMiddleLine: false,
                ),
              ),
              const Spacer(),
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.08),
                  minimumSize: const Size(98, 98),
                ),
                onPressed: !state.canRecord
                    ? null
                    : state.isRecording
                        ? controller.stopAndSave
                        : controller.start,
                icon: Icon(
                  state.isRecording ? Icons.stop_rounded : Icons.play_arrow_rounded,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: controller.discard,
                      icon: const Icon(Icons.delete_outline_rounded),
                      label: const Text('Discard'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: state.isRecording ? controller.stopAndSave : null,
                      icon: const Icon(Icons.arrow_upward_rounded),
                      label: const Text('Drop it'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                state.canRecord
                    ? 'Remaining ${formatDuration(remaining.isNegative ? Duration.zero : remaining)}'
                    : 'Microphone permission required',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
