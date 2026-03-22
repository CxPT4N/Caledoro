import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/settings_model.dart';
import '../services/hive_service.dart';

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsModel>(
  SettingsNotifier.new,
);

class SettingsNotifier extends Notifier<SettingsModel> {
  @override
  SettingsModel build() {
    final box = HiveService.settingsBox();
    return box.get('settings') ?? SettingsModel();
  }

  Future<void> update({
    int? workMinutes,
    int? shortBreakMinutes,
    int? longBreakMinutes,
    int? pomodorosUntilLongBreak,
    bool? autoStartNext,
    bool? notificationsEnabled,
    bool? soundEnabled,
    bool? isDarkMode,
  }) async {
    state = SettingsModel(
      workMinutes: workMinutes ?? state.workMinutes,
      shortBreakMinutes: shortBreakMinutes ?? state.shortBreakMinutes,
      longBreakMinutes: longBreakMinutes ?? state.longBreakMinutes,
      pomodorosUntilLongBreak:
          pomodorosUntilLongBreak ?? state.pomodorosUntilLongBreak,
      autoStartNext: autoStartNext ?? state.autoStartNext,
      notificationsEnabled: notificationsEnabled ?? state.notificationsEnabled,
      soundEnabled: soundEnabled ?? state.soundEnabled,
      isDarkMode: isDarkMode ?? state.isDarkMode,
    );
    await HiveService.settingsBox().put('settings', state);
  }
}
