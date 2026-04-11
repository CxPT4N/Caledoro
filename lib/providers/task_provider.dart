import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/task_model.dart';
import '../services/hive_service.dart';
import '../utils/date_utils.dart';

final taskListProvider = NotifierProvider<TaskListNotifier, List<TaskModel>>(
  TaskListNotifier.new,
);

final selectedDateProvider = NotifierProvider<SelectedDateNotifier, DateTime>(
  SelectedDateNotifier.new,
);

class SelectedDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    return DateTime.now();
  }

  void setDate(DateTime date) {
    state = date;
  }
}

class TaskListNotifier extends Notifier<List<TaskModel>> {
  @override
  List<TaskModel> build() {
    return HiveService.tasksBox().values.toList();
  }

  Future<void> addTask({
    required String title,
    String description = '',
    required DateTime dueDate,
    TaskPriority priority = TaskPriority.medium,
    bool recurringDaily = false,
  }) async {
    final task = TaskModel(
      id: const Uuid().v4(),
      title: title.trim(),
      description: description.trim(),
      dueDate: dueDate,
      priority: priority,
      recurringDaily: recurringDaily,
    );
    final box = HiveService.tasksBox();
    try {
      await box.put(task.id, task);
      state = [...state, task];
    } catch (e) {
      debugPrint('Failed to add task: $e');
      throw Exception('Failed to add task. Please try again.');
    }
  }

  Future<void> toggleComplete(String id) async {
    final index = state.indexWhere((task) => task.id == id);
    if (index == -1) return;
    final task = state[index];
    task.completed = !task.completed;
    task.lastCompletedDate = task.completed ? DateTime.now() : null;
    await task.save();
    state = [...state]..[index] = task;

    if (task.recurringDaily && task.completed) {
      await _updateStreakOnRecurringCompletion(DateTime.now());
    }
  }

  void updateTask(TaskModel task) {
    task.save();
    state = state.map((t) => t.id == task.id ? task : t).toList();
  }

  void deleteTask(String id) {
    HiveService.tasksBox().delete(id);
    state = state.where((task) => task.id != id).toList();
  }

  Future<void> dailyResetRecurring(DateTime today) async {
    final meta = HiveService.widgetBox().get('meta') ?? <String, dynamic>{};
    final lastResetRaw = meta['lastResetDate'] as String?;
    final lastReset =
        lastResetRaw == null ? null : DateTime.tryParse(lastResetRaw);
    if (DateUtilsHelper.isSameDay(lastReset, today)) return;

    final updateList = state.map((task) {
      if (task.recurringDaily && task.completed) {
        task.completed = false;
        task.save();
      }
      return task;
    }).toList();
    state = updateList;

    await HiveService.widgetBox().put('meta', {
      ...meta,
      'lastResetDate': today.toIso8601String(),
    });
  }

  Future<void> _updateStreakOnRecurringCompletion(DateTime today) async {
    final dailyTasks = state.where((t) => t.recurringDaily).toList();
    if (dailyTasks.isEmpty) return;

    final allCompletedToday = dailyTasks.every(
      (task) =>
          task.completed &&
          DateUtilsHelper.isSameDay(task.lastCompletedDate, today),
    );
    if (!allCompletedToday) return;

    final meta = HiveService.widgetBox().get('meta') ?? <String, dynamic>{};
    final lastStreakDateRaw = meta['lastStreakDate'] as String?;
    final lastStreakDate =
        lastStreakDateRaw == null ? null : DateTime.tryParse(lastStreakDateRaw);

    if (DateUtilsHelper.isSameDay(lastStreakDate, today)) {
      return;
    }

    final wasYesterday = DateUtilsHelper.isSameDay(
      lastStreakDate,
      today.subtract(const Duration(days: 1)),
    );

    final prevCurrent = (meta['currentStreak'] as int?) ?? 0;
    final prevLongest = (meta['longestStreak'] as int?) ?? 0;
    final current = wasYesterday ? prevCurrent + 1 : 1;
    final longest = math.max(prevLongest, current);

    await HiveService.widgetBox().put('meta', {
      ...meta,
      'currentStreak': current,
      'longestStreak': longest,
      'lastStreakDate': today.toIso8601String(),
    });
  }
}
