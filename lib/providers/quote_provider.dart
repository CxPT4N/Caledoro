import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/quotes.dart';

final quoteProvider = Provider<String>((ref) {
  final today = DateTime.now();
  final dayOfYear =
      today.difference(DateTime(today.year, 1, 1)).inDays.clamp(0, 366);
  return dailyQuotes[dayOfYear % dailyQuotes.length];
});
