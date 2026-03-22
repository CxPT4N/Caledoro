import 'package:flutter/material.dart';
import '../widgets/task_checklist_widget.dart';
import '../widgets/pomodoro_timer_widget.dart';

class HomeWidgetScreen extends StatelessWidget {
  const HomeWidgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Caledoro')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              const Center(child: PomodoroTimerWidget()),
              const SizedBox(height: 20),
              const TaskChecklistWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
