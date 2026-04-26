import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';

class AudioProgressBar extends StatelessWidget {
  const AudioProgressBar({
    required this.progress,
    super.key,
  });

  final double progress;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: LinearProgressIndicator(
        value: progress.clamp(0, 1),
        minHeight: 5,
        backgroundColor: Colors.white.withOpacity(0.14),
        valueColor: const AlwaysStoppedAnimation<Color>(AppPalette.accent),
      ),
    );
  }
}
