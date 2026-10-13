import 'package:dio/dio.dart';
import '../models/task.dart';
import '../services/task_api.dart';

class TaskRepository {
  final TaskApi api;

  TaskRepository({required this.api});

  Future<List<Task>> getTasks() async {
    try {
      return await api.fetchTasks();
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw Exception('Failed to load tasks: $e');
    }
  }

  Future<Task> addTask(String title) async {
    if (title.trim().length < 3) {
      throw Exception('Title must be at least 3 characters');
    }

    try {
      return await api.addTask(title.trim());
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw Exception('Failed to add task: $e');
    }
  }

  Future<Task> toggleTaskStatus(Task task) async {
    final newStatus = task.isDone ? 'todo' : 'done';
    try {
      return await api.updateTaskStatus(
        id: task.id,
        status: newStatus,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw Exception('Failed to update task status: $e');
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await api.deleteTask(id);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  Exception _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return Exception('Connection timed out. Please check your network or server.');
    } else if (e.type == DioExceptionType.connectionError) {
      return Exception('Cannot connect to task server (${api.baseUrl}). Please retry.');
    } else if (e.response != null) {
      final message = e.response?.data is Map && e.response?.data['error'] != null
          ? e.response?.data['error']
          : (e.response?.data is Map && e.response?.data['message'] != null
              ? e.response?.data['message']
              : 'Server error (${e.response?.statusCode})');
      return Exception(message);
    }
    return Exception('Network error occurred: ${e.message}');
  }
}
