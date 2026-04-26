import 'dart:math' as math;

import 'package:flutter/material.dart';

class AnimatedWaveform extends StatefulWidget {
  const AnimatedWaveform({
    required this.samples,
    required this.isActive,
    this.height = 120,
    this.minBarHeight = 10,
    this.activeColor = Colors.white,
    this.idleColor = const Color(0x44FFFFFF),
    super.key,
  });

  final List<double> samples;
  final bool isActive;
  final double height;
  final double minBarHeight;
  final Color activeColor;
  final Color idleColor;

  @override
  State<AnimatedWaveform> createState() => _AnimatedWaveformState();
}

class _AnimatedWaveformState extends State<AnimatedWaveform> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );
    if (widget.isActive) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedWaveform oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isActive && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bars = widget.samples.isEmpty ? const [0.3, 0.5, 0.8, 0.4, 0.6] : widget.samples;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final phase = _controller.value * math.pi * 2;
        return SizedBox(
          height: widget.height,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List<Widget>.generate(bars.length, (index) {
              final base = bars[index].clamp(0.08, 1.0);
              final pulse = widget.isActive
                  ? (0.7 + (0.3 * math.sin(phase + (index * 0.45))))
                  : 1.0;
              final h = (base * pulse * widget.height).clamp(widget.minBarHeight, widget.height);
              final isLead = index % 7 == 0;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 120),
                    height: h,
                    decoration: BoxDecoration(
                      color: isLead && widget.isActive ? widget.activeColor : widget.idleColor,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
