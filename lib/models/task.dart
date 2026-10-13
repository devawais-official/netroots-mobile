import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String id;
  final String title;
  final String status;

  const Task({
    required this.id,
    required this.title,
    required this.status,
  });

  bool get isDone => status.toLowerCase() == 'done';

  Task copyWith({
    String? id,
    String? title,
    String? status,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      status: status ?? this.status,
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: (json['id'] ?? '').toString(),
      title: json['title'] as String? ?? '',
      status: json['status'] as String? ?? 'todo',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'status': status,
    };
  }

  @override
  List<Object?> get props => [id, title, status];
}
