import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';

class PomodoroSettingsScreen extends ConsumerWidget {
  const PomodoroSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pomodoro Settings')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _settingControl(
                context,
                'Work (minutes)',
                settings.workMinutes,
                (n) =>
                    ref.read(settingsProvider.notifier).update(workMinutes: n)),
            _settingControl(
                context,
                'Short Break (minutes)',
                settings.shortBreakMinutes,
                (n) => ref
                    .read(settingsProvider.notifier)
                    .update(shortBreakMinutes: n)),
            _settingControl(
                context,
                'Long Break (minutes)',
                settings.longBreakMinutes,
                (n) => ref
                    .read(settingsProvider.notifier)
                    .update(longBreakMinutes: n)),
            _settingControl(
                context,
                'Long Break every (pomodoros)',
                settings.pomodorosUntilLongBreak,
                (n) => ref
                    .read(settingsProvider.notifier)
                    .update(pomodorosUntilLongBreak: n)),
            SwitchListTile(
              value: settings.autoStartNext,
              title: const Text('Auto-start next'),
              onChanged: (v) =>
                  ref.read(settingsProvider.notifier).update(autoStartNext: v),
            ),
            SwitchListTile(
              value: settings.notificationsEnabled,
              title: const Text('Notifications'),
              onChanged: (v) => ref
                  .read(settingsProvider.notifier)
                  .update(notificationsEnabled: v),
            ),
            SwitchListTile(
              value: settings.soundEnabled,
              title: const Text('Sound'),
              onChanged: (v) =>
                  ref.read(settingsProvider.notifier).update(soundEnabled: v),
            ),
            SwitchListTile(
              value: settings.isDarkMode,
              title: const Text('Dark Mode'),
              onChanged: (v) =>
                  ref.read(settingsProvider.notifier).update(isDarkMode: v),
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Settings saved')));
              },
              child: const Text('Save Settings'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingControl(BuildContext context, String label, int value,
      void Function(int) onUpdate) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Row(
            children: [
              IconButton(
                  onPressed: () => onUpdate(value > 1 ? value - 1 : 1),
                  icon: const Icon(Icons.remove)),
              Text(value.toString()),
              IconButton(
                  onPressed: () => onUpdate(value + 1),
                  icon: const Icon(Icons.add)),
            ],
          ),
        ],
      ),
    );
  }
}
