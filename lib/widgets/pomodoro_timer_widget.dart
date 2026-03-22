import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';
import '../services/widget_service.dart';

enum PomodoroPhase { work, shortBreak, longBreak }

class PomodoroTimerWidget extends ConsumerStatefulWidget {
  const PomodoroTimerWidget({super.key});

  @override
  ConsumerState<PomodoroTimerWidget> createState() =>
      _PomodoroTimerWidgetState();
}

class _PomodoroTimerWidgetState extends ConsumerState<PomodoroTimerWidget>
    with TickerProviderStateMixin {
  PomodoroPhase phase = PomodoroPhase.work;
  Timer? _timer;
  int _remainingSeconds = 0;
  int _completedPomodoros = 0;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _setupForPhase();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _setupForPhase() {
    final settings = ref.read(settingsProvider);
    final duration = switch (phase) {
      PomodoroPhase.work => settings.workMinutes * 60,
      PomodoroPhase.shortBreak => settings.shortBreakMinutes * 60,
      PomodoroPhase.longBreak => settings.longBreakMinutes * 60,
    };
    setState(() {
      _remainingSeconds = duration;
    });
  }

  void _toggleTimer() {
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
      _pulseController.stop();
      _pulseController.value = 0.0; // reset to 1.0 scale
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
            WidgetService.updateWidgets(
              secondsRemaining: _remainingSeconds,
              isWorking: phase == PomodoroPhase.work,
              completedTasks: _completedPomodoros,
            );
          } else {
            timer.cancel();
            _pulseController.stop();
            _pulseController.value = 0.0;
            if (phase == PomodoroPhase.work) {
              _completedPomodoros += 1;
              final settings = ref.read(settingsProvider);
              if (_completedPomodoros % settings.pomodorosUntilLongBreak == 0) {
                phase = PomodoroPhase.longBreak;
              } else {
                phase = PomodoroPhase.shortBreak;
              }
            } else {
              phase = PomodoroPhase.work;
            }
            _setupForPhase();
            if (ref.read(settingsProvider).autoStartNext) {
              _toggleTimer();
            }
          }
        });
      });
      _pulseController.repeat(reverse: true);
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final color = switch (phase) {
      PomodoroPhase.work => Theme.of(context).colorScheme.primary,
      PomodoroPhase.shortBreak => Theme.of(context).colorScheme.secondary,
      PomodoroPhase.longBreak => Theme.of(context).colorScheme.tertiary,
    };

    final totalSeconds = phase == PomodoroPhase.work
        ? settings.workMinutes * 60
        : phase == PomodoroPhase.shortBreak
            ? settings.shortBreakMinutes * 60
            : settings.longBreakMinutes * 60;
    final ratio = totalSeconds == 0 ? 0.0 : _remainingSeconds / totalSeconds;

    final phaseLabel = switch (phase) {
      PomodoroPhase.work => 'Work',
      PomodoroPhase.shortBreak => 'Short Break',
      PomodoroPhase.longBreak => 'Long Break',
    };

    return Card(
      color: Theme.of(context).colorScheme.surface,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: SizedBox(
                        width: 190,
                        height: 190,
                        child: CircularProgressIndicator(
                          value: ratio,
                          strokeWidth: 12,
                          valueColor: AlwaysStoppedAnimation(color),
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                        ),
                      ),
                    );
                  },
                ),
                GestureDetector(
                  onTap: _toggleTimer,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(_remainingSeconds),
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        phaseLabel,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: color),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        (_timer?.isActive ?? false)
                            ? 'Tap to Pause'
                            : 'Tap to Start',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text('Completed cycles: $_completedPomodoros',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}
