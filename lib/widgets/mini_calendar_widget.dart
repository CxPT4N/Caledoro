import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';

class MiniCalendarWidget extends ConsumerWidget {
  const MiniCalendarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskListProvider);
    final selectedDate = ref.watch(selectedDateProvider);

    Map<DateTime, List<TaskModel>> events = {};
    for (final task in tasks) {
      final day =
          DateTime(task.dueDate.year, task.dueDate.month, task.dueDate.day);
      events[day] = [...?events[day], task];
    }

    return Card(
      color: Colors.grey.shade900,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Mini Calendar',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            TableCalendar<TaskModel>(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2100, 12, 31),
              focusedDay: selectedDate,
              selectedDayPredicate: (date) =>
                  DateTime(date.year, date.month, date.day) ==
                  DateTime(
                      selectedDate.year, selectedDate.month, selectedDate.day),
              eventLoader: (date) {
                final key = DateTime(date.year, date.month, date.day);
                return events[key] ?? [];
              },
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (events.isEmpty) return const SizedBox.shrink();
                  final high = events
                      .where((e) => e.priority == TaskPriority.high)
                      .length;
                  final med = events
                      .where((e) => e.priority == TaskPriority.medium)
                      .length;
                  final low = events
                      .where((e) => e.priority == TaskPriority.low)
                      .length;
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (high > 0)
                        const CircleAvatar(
                            radius: 4, backgroundColor: Colors.redAccent),
                      if (med > 0)
                        const CircleAvatar(
                            radius: 4, backgroundColor: Colors.orangeAccent),
                      if (low > 0)
                        const CircleAvatar(
                            radius: 4, backgroundColor: Colors.greenAccent),
                    ],
                  );
                },
              ),
              onDaySelected: (day, focusedDay) {
                ref.read(selectedDateProvider.notifier).state = day;
              },
              headerStyle: const HeaderStyle(
                  formatButtonVisible: false, titleCentered: true),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                    color: Colors.white24, shape: BoxShape.circle),
                selectedDecoration: BoxDecoration(
                    color: Colors.blueAccent, shape: BoxShape.circle),
                markerSizeScale: 0.6,
                cellMargin: const EdgeInsets.all(1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
