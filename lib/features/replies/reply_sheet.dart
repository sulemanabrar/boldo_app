import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

import '../../app/providers.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/time_format.dart';
import 'reply_controller.dart';

class ReplySheet extends ConsumerWidget {
  const ReplySheet({required this.confessionId, super.key});

  final String confessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(replyControllerProvider(confessionId));
    final controller = ref.read(replyControllerProvider(confessionId).notifier);
    final recorderController = ref.read(audioRecordingServiceProvider).recorderController;

    return FractionallySizedBox(
      heightFactor: 0.96,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1B0212), AppPalette.bg],
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
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
                  const SizedBox(width: 8),
                  Text(
                    state.isRecording ? 'Reply with voice' : 'Voice replies',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              if (state.items.isEmpty && !state.isRecording) ...[
                const Spacer(),
                Icon(Icons.chat_bubble_outline_rounded, color: AppPalette.accent, size: 64),
                const SizedBox(height: 12),
                Text(
                  'No voices yet',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Text(
                  'Be the first to reply with your voice.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Spacer(),
              ] else ...[
                const SizedBox(height: 18),
                Text(
                  state.isRecording ? formatDuration(state.elapsed) : 'Recent voices',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 14),
                if (state.isRecording)
                  AudioWaveforms(
                    enableGesture: false,
                    size: const Size(double.infinity, 118),
                    recorderController: recorderController,
                    waveStyle: WaveStyle(
                      spacing: 6,
                      waveColor: Colors.white.withOpacity(0.18),
                      extendWaveform: true,
                      showMiddleLine: false,
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 18,
                                backgroundColor: AppPalette.accent,
                                child: Icon(Icons.mic_rounded, color: Colors.white),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Voice ${index + 1}',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const Spacer(),
                              Text(
                                formatDuration(item.duration),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                const Spacer(),
              ],
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: state.isRecording ? controller.stopAndSave : controller.startRecording,
                      icon: Icon(state.isRecording ? Icons.send_rounded : Icons.mic_rounded),
                      label: Text(state.isRecording ? 'Send reply' : 'Record reply'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
