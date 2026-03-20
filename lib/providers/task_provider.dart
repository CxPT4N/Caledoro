import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/task_model.dart';
import '../services/hive_service.dart';

final taskListProvider =
    StateNotifierProvider<TaskListNotifier, List<TaskModel>>(
  (ref) => TaskListNotifier(),
);

final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

class TaskListNotifier extends StateNotifier<List<TaskModel>> {
  TaskListNotifier() : super([]) {
    _loadTasks();
  }

  void _loadTasks() {
    final tasks = HiveService.tasksBox().values.toList();
    state = tasks;
  }

  void addTask({
    required String title,
    String description = '',
    required DateTime dueDate,
    TaskPriority priority = TaskPriority.medium,
    bool recurringDaily = false,
  }) {
    final task = TaskModel(
      id: const Uuid().v4(),
      title: title,
      description: description,
      dueDate: dueDate,
      priority: priority,
      recurringDaily: recurringDaily,
    );
    final box = HiveService.tasksBox();
    box.put(task.id, task);
    state = [...state, task];
  }

  void toggleComplete(String id) {
    final index = state.indexWhere((task) => task.id == id);
    if (index == -1) return;
    final task = state[index];
    task.completed = !task.completed;
    task.save();
    state = [...state]..[index] = task;
  }

  void updateTask(TaskModel task) {
    task.save();
    state = state.map((t) => t.id == task.id ? task : t).toList();
  }

  void deleteTask(String id) {
    HiveService.tasksBox().delete(id);
    state = state.where((task) => task.id != id).toList();
  }

  void dailyResetRecurring(DateTime today) {
    final updateList = state.map((task) {
      if (task.recurringDaily && task.completed) {
        task.completed = false;
        task.save();
      }
      return task;
    }).toList();
    state = updateList;
  }
}
