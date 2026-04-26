import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../record/record_confession_sheet.dart';
import '../replies/reply_sheet.dart';
import 'feed_controller.dart';
import 'widgets/confession_card.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(feedControllerProvider);
    final controller = ref.read(feedControllerProvider.notifier);

    return Scaffold(
      body: state.items.isEmpty
          ? const Center(child: Text('No confessions yet'))
          : PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                final confession = state.items[index];
                return ConfessionCard(
                  confession: confession,
                  onReplyTap: () async {
                    await showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => ReplySheet(confessionId: confession.id),
                    );
                    await controller.refreshFeed();
                  },
                );
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppPalette.accent,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.mic_rounded, size: 30),
        onPressed: () async {
          await showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const RecordConfessionSheet(),
          );
          await controller.refreshFeed();
        },
      ),
    );
  }
}
