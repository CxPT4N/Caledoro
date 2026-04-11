import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/task_provider.dart';
import '../services/hive_service.dart';
import '../utils/date_utils.dart';

final streakProvider = Provider<int>((ref) {
  final _ = ref.watch(taskListProvider);
  final meta = HiveService.widgetBox().get('meta') ?? <String, dynamic>{};
  final current = (meta['currentStreak'] as int?) ?? 0;

  final lastStreakDateRaw = meta['lastStreakDate'] as String?;
  final lastStreakDate =
      lastStreakDateRaw == null ? null : DateTime.tryParse(lastStreakDateRaw);
  final today = DateTime.now();

  if (lastStreakDate == null) return 0;
  final valid = DateUtilsHelper.isSameDay(lastStreakDate, today) ||
      DateUtilsHelper.isSameDay(
        lastStreakDate,
        today.subtract(const Duration(days: 1)),
      );
  if (!valid) return 0;
  return current;
});

final longestStreakProvider = Provider<int>((ref) {
  ref.watch(taskListProvider);
  final meta = HiveService.widgetBox().get('meta') ?? <String, dynamic>{};
  return (meta['longestStreak'] as int?) ?? 0;
});
