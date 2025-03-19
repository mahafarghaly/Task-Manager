// presentation/bloc/task_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_tasks.dart';
import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/update_task.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasks getTasksUseCase;
  final AddTask addTaskUseCase;
  final UpdateTask updateTaskUseCase;
  final DeleteTask deleteTaskUseCase;

  TaskBloc({
    required this.getTasksUseCase,
    required this.addTaskUseCase,
    required this.updateTaskUseCase,
    required this.deleteTaskUseCase,
  }) : super(TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddNewTask>(_onAddTask);
    on<UpdateExistingTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
  }

  Future<void> _onLoadTasks(
      LoadTasks event,
      Emitter<TaskState> emit,
      ) async {
    emit(TaskLoading());
    try {
      final tasks = await getTasksUseCase();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError('Failed to load tasks.'));
    }
  }

  Future<void> _onAddTask(
      AddNewTask event,
      Emitter<TaskState> emit,
      ) async {
    if (state is TaskLoaded) {
      try {
        await addTaskUseCase(event.task);
        // Reload the tasks after adding new one
        final tasks = await getTasksUseCase();
        emit(TaskLoaded(tasks));
      } catch (e) {
        emit(TaskError('Failed to add task.'));
      }
    }
  }

  Future<void> _onUpdateTask(
      UpdateExistingTask event,
      Emitter<TaskState> emit,
      ) async {
    if (state is TaskLoaded) {
      try {
        await updateTaskUseCase(event.task);
        final tasks = await getTasksUseCase();
        emit(TaskLoaded(tasks));
      } catch (e) {
        emit(TaskError('Failed to update task.'));
      }
    }
  }

  Future<void> _onDeleteTask(
      DeleteTask event,
      Emitter<TaskState> emit,
      ) async {
    if (state is TaskLoaded) {
      try {
        await deleteTaskUseCase(event.id);
        final tasks = await getTasksUseCase();
        emit(TaskLoaded(tasks));
      } catch (e) {
        emit(TaskError('Failed to delete task.'));
      }
    }
  }
}
