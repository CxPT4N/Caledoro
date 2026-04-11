import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../theme.dart';

class MiniCalendarWidget extends ConsumerWidget {
  const MiniCalendarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskListProvider);
    final selectedDate = ref.watch(selectedDateProvider);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    Map<DateTime, List<TaskModel>> events = {};
    for (final task in tasks) {
      final day =
          DateTime(task.dueDate.year, task.dueDate.month, task.dueDate.day);
      events[day] = [...?events[day], task];
    }

    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cozy Calendar',
            style: tt.titleLarge?.copyWith(
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 12),
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
                final high =
                    events.where((e) => e.priority == TaskPriority.high).length;
                final med = events
                    .where((e) => e.priority == TaskPriority.medium)
                    .length;
                final low =
                    events.where((e) => e.priority == TaskPriority.low).length;
                return Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (high > 0)
                        Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          decoration: BoxDecoration(
                            color: cs.tertiary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      if (med > 0)
                        Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          decoration: BoxDecoration(
                            color: cs.secondary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      if (low > 0)
                        Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          decoration: BoxDecoration(
                            color: cs.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
            onDaySelected: (day, focusedDay) {
              ref.read(selectedDateProvider.notifier).setDate(day);
            },
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: tt.titleMedium?.copyWith(
                    color: cs.onSurface,
                  ) ??
                  const TextStyle(),
              leftChevronIcon: Icon(
                Icons.chevron_left_rounded,
                color: cs.onSurfaceVariant,
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right_rounded,
                color: cs.onSurfaceVariant,
              ),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: tt.labelSmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ) ??
                  const TextStyle(),
              weekendStyle: tt.labelSmall?.copyWith(
                    color: cs.onSurfaceVariant.withValues(alpha: 0.6),
                  ) ??
                  const TextStyle(),
            ),
            calendarStyle: CalendarStyle(
              // Default day
              defaultTextStyle: tt.bodyMedium?.copyWith(
                    color: cs.onSurface,
                  ) ??
                  const TextStyle(),
              weekendTextStyle: tt.bodyMedium?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.7),
                  ) ??
                  const TextStyle(),
              outsideTextStyle: tt.bodyMedium?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.5),
                  ) ??
                  const TextStyle(),

              // Today — soft surface highlight
              todayDecoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              todayTextStyle: tt.bodyMedium?.copyWith(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w600,
                  ) ??
                  const TextStyle(),

              // Selected — primary container fill
              selectedDecoration: BoxDecoration(
                color: CozyColors.primaryContainer,
                shape: BoxShape.circle,
              ),
              selectedTextStyle: tt.bodyMedium?.copyWith(
                    color: CozyColors.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ) ??
                  const TextStyle(),

              markerSizeScale: 0.5,
              cellMargin: const EdgeInsets.all(3),
              cellPadding: const EdgeInsets.all(2),
            ),
          ),
        ],
      ),
    );
  }
}
