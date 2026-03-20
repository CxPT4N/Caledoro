import 'package:home_widget/home_widget.dart';

class WidgetService {
  static Future<void> updateWidgets({
    required int secondsRemaining,
    required bool isWorking,
    required int completedTasks,
  }) async {
    await HomeWidget.saveWidgetData<int>('secondsRemaining', secondsRemaining);
    await HomeWidget.saveWidgetData<bool>('isWorking', isWorking);
    await HomeWidget.saveWidgetData<int>('completedTasks', completedTasks);
    await HomeWidget.updateWidget(name: 'CaledoroWidgetProvider');
  }
}
