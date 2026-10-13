import 'package:equatable/equatable.dart';
import '../models/task.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasksEvent extends TaskEvent {
  const LoadTasksEvent();
}

class AddTaskEvent extends TaskEvent {
  final String title;

  const AddTaskEvent(this.title);

  @override
  List<Object?> get props => [title];
}

class ToggleTaskStatusEvent extends TaskEvent {
  final Task task;

  const ToggleTaskStatusEvent(this.task);

  @override
  List<Object?> get props => [task];
}

class DeleteTaskEvent extends TaskEvent {
  final String taskId;

  const DeleteTaskEvent(this.taskId);

  @override
  List<Object?> get props => [taskId];
}
