import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';

class PlayPauseButton extends StatelessWidget {
  const PlayPauseButton({
    required this.isPlaying,
    required this.onPressed,
    super.key,
  });

  final bool isPlaying;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        minimumSize: const Size(56, 56),
      ),
      onPressed: onPressed,
      icon: Icon(isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
    );
  }
}
