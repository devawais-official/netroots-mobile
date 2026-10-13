import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository repository;

  TaskBloc({required this.repository}) : super(const TaskInitial()) {
    on<LoadTasksEvent>(_onLoadTasks);
    on<AddTaskEvent>(_onAddTask);
    on<ToggleTaskStatusEvent>(_onToggleTaskStatus);
    on<DeleteTaskEvent>(_onDeleteTask);
  }

  Future<void> _onLoadTasks(
    LoadTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskLoading());
    try {
      final tasks = await repository.getTasks();
      emit(TaskLoaded(tasks: tasks));
    } catch (e) {
      emit(TaskError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onAddTask(
    AddTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    final currentState = state;
    if (currentState is TaskLoaded) {
      emit(currentState.copyWith(isSubmitting: true, actionError: null));
      try {
        final newTask = await repository.addTask(event.title);
        final updatedList = List<Task>.from(currentState.tasks)..add(newTask);
        emit(TaskLoaded(tasks: updatedList));
      } catch (e) {
        final errorMsg = e.toString().replaceAll('Exception: ', '');
        emit(currentState.copyWith(isSubmitting: false, actionError: errorMsg));
      }
    } else {
      emit(const TaskLoading());
      try {
        await repository.addTask(event.title);
        add(const LoadTasksEvent());
      } catch (e) {
        emit(TaskError(e.toString().replaceAll('Exception: ', '')));
      }
    }
  }

  Future<void> _onToggleTaskStatus(
    ToggleTaskStatusEvent event,
    Emitter<TaskState> emit,
  ) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      final updatedTasks = currentState.tasks.map((task) {
        if (task.id == event.task.id) {
          final newStatus = task.isDone ? 'todo' : 'done';
          return task.copyWith(status: newStatus);
        }
        return task;
      }).toList();

      emit(currentState.copyWith(tasks: updatedTasks));

      try {
        final updatedTask = await repository.toggleTaskStatus(event.task);
        final finalTasks = currentState.tasks.map((task) {
          if (task.id == event.task.id) {
            return updatedTask;
          }
          return task;
        }).toList();
        emit(TaskLoaded(tasks: finalTasks));
      } catch (e) {
        final errorMsg = e.toString().replaceAll('Exception: ', '');
        emit(TaskLoaded(tasks: currentState.tasks, actionError: errorMsg));
      }
    }
  }

  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      final originalTasks = currentState.tasks;
      final updatedTasks = originalTasks
          .where((task) => task.id != event.taskId)
          .toList();

      // Optimistically remove from list
      emit(currentState.copyWith(tasks: updatedTasks, actionError: null));

      try {
        await repository.deleteTask(event.taskId);
      } catch (e) {
        // Rollback state if API call failed
        final errorMsg = e.toString().replaceAll('Exception: ', '');
        emit(TaskLoaded(tasks: originalTasks, actionError: errorMsg));
      }
    }
  }
}
