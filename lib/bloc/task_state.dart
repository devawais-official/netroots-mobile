import 'package:equatable/equatable.dart';
import '../models/task.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {
  const TaskInitial();
}

class TaskLoading extends TaskState {
  const TaskLoading();
}

class TaskLoaded extends TaskState {
  final List<Task> tasks;
  final bool isSubmitting;
  final String? actionError;

  const TaskLoaded({
    required this.tasks,
    this.isSubmitting = false,
    this.actionError,
  });

  TaskLoaded copyWith({
    List<Task>? tasks,
    bool? isSubmitting,
    String? actionError,
  }) {
    return TaskLoaded(
      tasks: tasks ?? this.tasks,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      actionError: actionError,
    );
  }

  @override
  List<Object?> get props => [tasks, isSubmitting, actionError];
}

class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object?> get props => [message];
}
