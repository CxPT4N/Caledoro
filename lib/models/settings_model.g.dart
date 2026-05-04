// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsModelAdapter extends TypeAdapter<SettingsModel> {
  @override
  final int typeId = 2;

  @override
  SettingsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingsModel(
      workMinutes: fields[0] as int,
      shortBreakMinutes: fields[1] as int,
      longBreakMinutes: fields[2] as int,
      pomodorosUntilLongBreak: fields[3] as int,
      autoStartNext: fields[4] as bool,
      notificationsEnabled: fields[5] as bool,
      soundEnabled: fields[6] as bool,
      isDarkMode: fields[7] as bool,
      taskSortMode:
          fields[8] == null ? TaskSortMode.smart : fields[8] as TaskSortMode,
    );
  }

  @override
  void write(BinaryWriter writer, SettingsModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.workMinutes)
      ..writeByte(1)
      ..write(obj.shortBreakMinutes)
      ..writeByte(2)
      ..write(obj.longBreakMinutes)
      ..writeByte(3)
      ..write(obj.pomodorosUntilLongBreak)
      ..writeByte(4)
      ..write(obj.autoStartNext)
      ..writeByte(5)
      ..write(obj.notificationsEnabled)
      ..writeByte(6)
      ..write(obj.soundEnabled)
      ..writeByte(7)
      ..write(obj.isDarkMode)
      ..writeByte(8)
      ..write(obj.taskSortMode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TaskSortModeAdapter extends TypeAdapter<TaskSortMode> {
  @override
  final int typeId = 5;

  @override
  TaskSortMode read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TaskSortMode.smart;
      case 1:
        return TaskSortMode.custom;
      default:
        return TaskSortMode.smart;
    }
  }

  @override
  void write(BinaryWriter writer, TaskSortMode obj) {
    switch (obj) {
      case TaskSortMode.smart:
        writer.writeByte(0);
        break;
      case TaskSortMode.custom:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskSortModeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
