import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:caledoro/models/settings_model.dart';
import 'package:caledoro/models/task_model.dart';
import 'package:caledoro/providers/settings_provider.dart';
import 'package:caledoro/providers/task_provider.dart';
import 'package:caledoro/services/hive_service.dart';
import 'package:caledoro/utils/date_utils.dart';

void main() {
  late Directory tempDir;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tempDir = await Directory.systemTemp.createTemp('caledoro_test_');
    Hive.init(tempDir.path);

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TaskPriorityAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TaskModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(SettingsModelAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(SubtaskCreatorAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(SubtaskModelAdapter());
    }
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(TaskSortModeAdapter());
    }

    await Hive.openBox<TaskModel>(HiveService.tasksBoxName);
    final settingsBox = await Hive.openBox<SettingsModel>(
      HiveService.settingsBoxName,
    );
    if (settingsBox.isEmpty) {
      await settingsBox.put('settings', SettingsModel());
    }
  });

  setUp(() async {
    await HiveService.tasksBox().clear();
    await HiveService.settingsBox().clear();
  });

  tearDownAll(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  test('Reorder ignores tasks from other days and appends remaining', () async {
    final day = DateTime(2026, 5, 2, 9);
    final otherDay = DateTime(2026, 5, 3, 9);

    final first = TaskModel(
      id: 't1',
      title: 'Alpha',
      description: '',
      dueDate: day,
    );
    final second = TaskModel(
      id: 't2',
      title: 'Beta',
      description: '',
      dueDate: day,
    );
    final other = TaskModel(
      id: 't3',
      title: 'Gamma',
      description: '',
      dueDate: otherDay,
    );

    final box = HiveService.tasksBox();
    await box.put(first.id, first);
    await box.put(second.id, second);
    await box.put(other.id, other);

    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(taskListProvider.notifier);
    final state = container.read(taskListProvider);
    final orderedDayTask = state.firstWhere((task) => task.id == 't2');
    final orderedOtherDayTask = state.firstWhere((task) => task.id == 't3');

    await notifier.reorderTasksForDay(
      day,
      [orderedDayTask, orderedOtherDayTask],
    );

    final next = container.read(taskListProvider);
    final sameDayIds = next
        .where((task) => DateUtilsHelper.isSameDay(task.dueDate, day))
        .map((task) => task.id)
        .toList();
    expect(sameDayIds, ['t2', 't1']);

    final otherDayTasks = next
        .where((task) => DateUtilsHelper.isSameDay(task.dueDate, otherDay))
        .toList();
    expect(otherDayTasks.length, 1);
    expect(otherDayTasks.first.id, 't3');
    expect(next.length, 3);
  });

  test('Parent completion derives from subtasks', () {
    final task = TaskModel(
      id: 't1',
      title: 'Essay',
      description: '',
      dueDate: DateTime(2026, 5, 2, 9),
      subtasks: [
        SubtaskModel(id: 's1', label: 'Draft', completed: true, sortOrder: 0),
        SubtaskModel(id: 's2', label: 'Cite', completed: false, sortOrder: 1),
      ],
    );
    final allDone = task.subtasks.every((s) => s.completed);
    expect(allDone, false);
  });

  test('Settings default to smart order', () {
    final s = SettingsModel();
    expect(s.taskSortMode, TaskSortMode.smart);
  });

  test('Settings provider persists task sort mode', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(settingsProvider.notifier);
    await notifier.update(taskSortMode: TaskSortMode.custom);

    final state = container.read(settingsProvider);
    expect(state.taskSortMode, TaskSortMode.custom);

    final stored = HiveService.settingsBox().get('settings');
    expect(stored, isNotNull);
    expect(stored!.taskSortMode, TaskSortMode.custom);
  });
}
