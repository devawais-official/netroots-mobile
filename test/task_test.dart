import 'package:flutter_test/flutter_test.dart';
import 'package:task_app/di/service_locator.dart';
import 'package:task_app/models/task.dart';
import 'package:task_app/repositories/task_repository.dart';
import 'package:task_app/services/task_api.dart';

void main() {
  group('Task Model Tests', () {
    test('Task correctly deserializes from JSON', () {
      final json = {
        'id': '123',
        'title': 'Test Task',
        'status': 'todo',
      };

      final task = Task.fromJson(json);

      expect(task.id, '123');
      expect(task.title, 'Test Task');
      expect(task.status, 'todo');
      expect(task.isDone, false);
    });

    test('Task isDone getter returns true for status done', () {
      const task = Task(id: '1', title: 'Done Task', status: 'done');
      expect(task.isDone, true);
    });

    test('Task copyWith updates fields correctly', () {
      const task = Task(id: '1', title: 'Task 1', status: 'todo');
      final updated = task.copyWith(status: 'done');

      expect(updated.id, '1');
      expect(updated.title, 'Task 1');
      expect(updated.status, 'done');
      expect(updated.isDone, true);
    });
  });

  group('Service Locator / DI Tests', () {
    test('Service Locator registers and resolves dependencies correctly', () {
      setupServiceLocator();

      expect(getIt.isRegistered<TaskApi>(), true);
      expect(getIt.isRegistered<TaskRepository>(), true);
      expect(getIt<TaskApi>(), isA<TaskApi>());
      expect(getIt<TaskRepository>(), isA<TaskRepository>());
    });
  });
}
