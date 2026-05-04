import 'package:flutter_test/flutter_test.dart';
import 'package:caledoro/models/task_model.dart';

void main() {
  test('SubtaskModel supports AI metadata and ordering', () {
    final subtask = SubtaskModel(
      id: 's1',
      label: 'Outline section',
      completed: false,
      sortOrder: 1,
      createdBy: SubtaskCreator.user,
      suggested: false,
      acceptedAt: null,
    );

    expect(subtask.label, 'Outline section');
    expect(subtask.sortOrder, 1);
    expect(subtask.createdBy, SubtaskCreator.user);
    expect(subtask.suggested, false);
    expect(subtask.acceptedAt, isNull);
  });
}
