import 'package:dio/dio.dart';
import '../models/task.dart';

class TaskApi {
  final Dio _dio;
  final String baseUrl;

  TaskApi({
    Dio? dio,
    this.baseUrl = 'http://localhost:3000',
  }) : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: baseUrl,
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
            );

  Future<List<Task>> fetchTasks() async {
    final response = await _dio.get('/api/tasks');

    dynamic data = response.data;
    if (data is Map<String, dynamic> && data.containsKey('tasks')) {
      data = data['tasks'];
    }

    if (data is List) {
      return data
          .map((item) => Task.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      error: 'Unexpected response format: ${response.data}',
    );
  }

  Future<Task> addTask(String title) async {
    final response = await _dio.post(
      '/api/tasks',
      data: {'title': title},
    );

    dynamic data = response.data;
    if (data is Map<String, dynamic>) {
      if (data.containsKey('task')) {
        data = data['task'];
      }
      return Task.fromJson(data as Map<String, dynamic>);
    }

    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      error: 'Failed to create task',
    );
  }

  Future<Task> updateTaskStatus({
    required String id,
    required String status,
  }) async {
    Response response;
    try {
      response = await _dio.patch(
        '/api/tasks/$id',
        data: {'status': status},
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404 || e.response?.statusCode == 405) {
        response = await _dio.patch(
          '/api/tasks',
          data: {
            'id': id,
            'status': status,
          },
        );
      } else {
        rethrow;
      }
    }

    dynamic data = response.data;
    if (data is Map<String, dynamic>) {
      if (data.containsKey('task')) {
        data = data['task'];
      }
      return Task.fromJson(data as Map<String, dynamic>);
    }

    return Task(
      id: id,
      title: '',
      status: status,
    );
  }

  Future<void> deleteTask(String id) async {
    await _dio.delete('/api/tasks/$id');
  }
}
