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

class _PomodoroTimerWidgetState extends ConsumerState<PomodoroTimerWidget> {
  PomodoroPhase phase = PomodoroPhase.work;
  Timer? _timer;
  int _remainingSeconds = 0;
  int _completedPomodoros = 0;

  @override
  void initState() {
    super.initState();
    _setupForPhase();
  }

  @override
  void dispose() {
    _timer?.cancel();
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
      PomodoroPhase.work => Colors.deepOrangeAccent,
      PomodoroPhase.shortBreak => Colors.greenAccent,
      PomodoroPhase.longBreak => Colors.blueAccent,
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 190,
              height: 190,
              child: CircularProgressIndicator(
                value: ratio,
                strokeWidth: 12,
                valueColor: AlwaysStoppedAnimation(color),
                backgroundColor: Colors.grey.shade800,
              ),
            ),
            GestureDetector(
              onTap: _toggleTimer,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatTime(_remainingSeconds),
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text('Completed cycles: $_completedPomodoros',
            style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}
