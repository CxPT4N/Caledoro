import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../widgets/mini_calendar_widget.dart';
import '../widgets/task_checklist_widget.dart';
import '../widgets/pomodoro_timer_widget.dart';

class HomeWidgetScreen extends StatelessWidget {
  const HomeWidgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Caledoro')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            MiniCalendarWidget(),
            SizedBox(height: 12),
            PomodoroTimerWidget(),
            SizedBox(height: 12),
            TaskChecklistWidget(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => showModalBottomSheet<void>(
          context: context,
          builder: (context) {
            return const _AddTaskPanel();
          },
        ),
      ),
    );
  }
}

class _AddTaskPanel extends ConsumerStatefulWidget {
  const _AddTaskPanel();

  @override
  ConsumerState<_AddTaskPanel> createState() => _AddTaskPanelState();
}

class _AddTaskPanelState extends ConsumerState<_AddTaskPanel> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  DateTime _dueDate = DateTime.now();
  TaskPriority _priority = TaskPriority.medium;
  bool _recurring = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('New Task',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _titleCtrl,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) => (value == null || value.isEmpty)
                  ? 'Please enter a title'
                  : null,
            ),
            TextFormField(
              controller: _descCtrl,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 2,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Due:'),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _dueDate,
                      firstDate:
                          DateTime.now().subtract(const Duration(days: 365)),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() {
                        _dueDate = DateTime(date.year, date.month, date.day,
                            _dueDate.hour, _dueDate.minute);
                      });
                    }
                  },
                  child: Text(
                      '${_dueDate.year}-${_dueDate.month}-${_dueDate.day}'),
                ),
              ],
            ),
            Row(
              children: [
                const Text('Priority:'),
                const SizedBox(width: 8),
                DropdownButton<TaskPriority>(
                  value: _priority,
                  items: TaskPriority.values
                      .map((p) => DropdownMenuItem(
                          value: p,
                          child: Text(
                              p.name[0].toUpperCase() + p.name.substring(1))))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _priority = value);
                  },
                ),
              ],
            ),
            CheckboxListTile(
              value: _recurring,
              onChanged: (v) => setState(() => _recurring = v ?? false),
              title: const Text('Recurring Daily'),
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: Colors.blueAccent,
            ),
            ElevatedButton(
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;
                ref.read(taskListProvider.notifier).addTask(
                      title: _titleCtrl.text.trim(),
                      description: _descCtrl.text.trim(),
                      dueDate: _dueDate,
                      priority: _priority,
                      recurringDaily: _recurring,
                    );
                Navigator.pop(context);
              },
              child: const Text('Save Task'),
            ),
          ],
        ),
      ),
    );
  }
}
