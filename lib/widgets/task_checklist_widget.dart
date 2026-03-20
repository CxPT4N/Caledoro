import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';

class TaskChecklistWidget extends ConsumerWidget {
  const TaskChecklistWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskListProvider);
    final today = ref.watch(selectedDateProvider);
    final dayTasks = tasks
        .where((task) =>
            task.dueDate.year == today.year &&
            task.dueDate.month == today.month &&
            task.dueDate.day == today.day)
        .toList()
      ..sort((a, b) {
        final priority = b.priority.index.compareTo(a.priority.index);
        if (priority != 0) return priority;
        return a.dueDate.compareTo(b.dueDate);
      });

    return Card(
      color: Colors.grey.shade900,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('To‑Do Checklist',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white)),
            const SizedBox(height: 8),
            if (dayTasks.isEmpty)
              const Text('No tasks for selected day',
                  style: TextStyle(color: Colors.white70))
            else
              SizedBox(
                height: 260,
                child: ListView.builder(
                  itemCount: dayTasks.length,
                  itemBuilder: (context, index) {
                    final task = dayTasks[index];
                    return CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: task.priority == TaskPriority.high
                          ? Colors.redAccent
                          : task.priority == TaskPriority.medium
                              ? Colors.orangeAccent
                              : Colors.greenAccent,
                      value: task.completed,
                      onChanged: (_) => ref
                          .read(taskListProvider.notifier)
                          .toggleComplete(task.id),
                      title: Text(task.title,
                          style: TextStyle(
                              color: task.completed
                                  ? Colors.white54
                                  : Colors.white,
                              decoration: task.completed
                                  ? TextDecoration.lineThrough
                                  : null)),
                      subtitle: Text(
                          '${task.dueDate.hour.toString().padLeft(2, '0')}:${task.dueDate.minute.toString().padLeft(2, '0')} • ${task.description}',
                          style: const TextStyle(color: Colors.white70)),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
