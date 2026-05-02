import 'package:hive/hive.dart';

part 'settings_model.g.dart';

@HiveType(typeId: 5)
enum TaskSortMode {
  @HiveField(0)
  smart,

  @HiveField(1)
  custom,
}

@HiveType(typeId: 2)
class SettingsModel extends HiveObject {
  @HiveField(0)
  int workMinutes;

  @HiveField(1)
  int shortBreakMinutes;

  @HiveField(2)
  int longBreakMinutes;

  @HiveField(3)
  int pomodorosUntilLongBreak;

  @HiveField(4)
  bool autoStartNext;

  @HiveField(5)
  bool notificationsEnabled;

  @HiveField(6)
  bool soundEnabled;

  @HiveField(7)
  bool isDarkMode;

  @HiveField(8, defaultValue: TaskSortMode.smart)
  TaskSortMode taskSortMode;

  SettingsModel({
    this.workMinutes = 25,
    this.shortBreakMinutes = 5,
    this.longBreakMinutes = 15,
    this.pomodorosUntilLongBreak = 4,
    this.autoStartNext = true,
    this.notificationsEnabled = true,
    this.soundEnabled = true,
    this.isDarkMode = true,
    this.taskSortMode = TaskSortMode.smart,
  });
}
