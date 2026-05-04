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

@HiveType(typeId: 3)
enum SubtaskCreator {
  @HiveField(0)
  user,

  @HiveField(1)
  ai,
}

@HiveType(typeId: 4)
class SubtaskModel {
  @HiveField(0)
  String id;

  @HiveField(1)
  String label;

  @HiveField(2)
  bool completed;

  @HiveField(3)
  int sortOrder;

  @HiveField(4)
  SubtaskCreator createdBy;

  @HiveField(5)
  bool suggested;

  @HiveField(6)
  DateTime? acceptedAt;

  SubtaskModel({
    required this.id,
    required this.label,
    this.completed = false,
    this.sortOrder = 0,
    this.createdBy = SubtaskCreator.user,
    this.suggested = false,
    this.acceptedAt,
  });
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

  @HiveField(8, defaultValue: <SubtaskModel>[])
  List<SubtaskModel> subtasks;

  @HiveField(9, defaultValue: 0)
  int sortOrder;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.priority = TaskPriority.medium,
    this.completed = false,
    this.recurringDaily = false,
    this.lastCompletedDate,
    List<SubtaskModel>? subtasks,
    this.sortOrder = 0,
  }) : subtasks = subtasks ?? <SubtaskModel>[];
}
