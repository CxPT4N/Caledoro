import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
enum TaskPriority {
  @HiveField(0)
  low,

  @HiveField(1)
  medium,

  @HiveField(2)
  high,
}

@HiveType(typeId: 1)
class TaskModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  DateTime dueDate;

  @HiveField(4)
  TaskPriority priority;

  @HiveField(5)
  bool completed;

  @HiveField(6)
  bool recurringDaily;

  @HiveField(7)
  DateTime? lastCompletedDate;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.priority = TaskPriority.medium,
    this.completed = false,
    this.recurringDaily = false,
    this.lastCompletedDate,
  });
}
