import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/settings_model.dart';
import '../services/hive_service.dart';

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsModel>(
  (ref) {
    final box = HiveService.settingsBox();
    final model = box.get('settings') ?? SettingsModel();
    return SettingsNotifier(model);
  },
);

class SettingsNotifier extends StateNotifier<SettingsModel> {
  SettingsNotifier(SettingsModel state) : super(state);

  void update({
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
