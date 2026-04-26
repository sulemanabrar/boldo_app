import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({
    required this.onStart,
    required this.onSkip,
    super.key,
  });

  final VoidCallback onStart;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final waveform = List<double>.generate(30, (index) {
      final seed = ((index * 5) % 10) + 1;
      return (seed / 10).clamp(0.18, 0.95);
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF220010), AppPalette.bg],
          ),
        ),
        padding: const EdgeInsets.fromLTRB(24, 56, 24, 28),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              Row(
                children: [
                  const Icon(Icons.fiber_manual_record, color: AppPalette.accent, size: 10),
                  const SizedBox(width: 8),
                  Text(
                    'BolDo',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Center(
                child: Container(
                  width: 208,
                  height: 208,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppPalette.accentSoft, AppPalette.accent],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppPalette.accent.withOpacity(0.4),
                        blurRadius: 24,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.mic_none_rounded, color: Colors.white, size: 72),
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                height: 88,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: waveform
                      .map(
                        (v) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: Container(
                              height: (v * 78).clamp(10, 78),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Speak. Don't type.",
                style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 10),
              Text(
                "BolDo is anonymous voice. Drop a 30-second confession and reply with voice only.",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppPalette.textMuted),
              ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: onStart,
                        icon: const Icon(Icons.mic_rounded),
                        label: const Text('Record my first confession'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: TextButton(
                        onPressed: onSkip,
                        child: const Text('Just listen for now'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
