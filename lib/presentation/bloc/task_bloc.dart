// presentation/bloc/task_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solid_and_pagination/domain/entities/task_entity.dart';
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
  int _currentPage = 1;
  final int _limit = 10;
  bool _hasMore = true;
  final List<TaskEntity> _tasks = [];
  TaskBloc({
    required this.getTasksUseCase,
    required this.addTaskUseCase,
    required this.updateTaskUseCase,
    required this.deleteTaskUseCase,
  }) : super(TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<LoadMoreTasks>(_onLoadMoreTasks);
    on<AddNewTask>(_onAddTask);
    on<UpdateExistingTask>(_onUpdateTask);
    on<DeleteExistingTask>(_onDeleteTask);
  }
///
  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    _currentPage = 1;
    _tasks.clear();
    emit(TaskLoading());

    final newTasks = await getTasksUseCase(page: _currentPage, limit: _limit);
    _hasMore = newTasks.length == _limit;
    _tasks.addAll(newTasks);

    emit(TaskLoaded(tasks: _tasks, hasMore: _hasMore));
  }

  Future<void> _onLoadMoreTasks(LoadMoreTasks event, Emitter<TaskState> emit) async {
    if (!_hasMore) return;

    _currentPage++;
    emit(TaskLoadingMore(tasks: _tasks));

    final newTasks = await getTasksUseCase(page: _currentPage, limit: _limit);
    _hasMore = newTasks.length == _limit;
    _tasks.addAll(newTasks);

    emit(TaskLoaded(tasks: _tasks, hasMore: _hasMore));
  }
  ///
  // Future<void> _onLoadTasks(
  //     LoadTasks event,
  //     Emitter<TaskState> emit,
  //     ) async {
  //   emit(TaskLoading());
  //   try {
  //     final tasks = await getTasksUseCase();
  //     emit(TaskLoaded(tasks));
  //   } catch (e) {
  //     emit(TaskError('Failed to load tasks.'));
  //   }
  // }
  Future<void> _onAddTask(AddNewTask event, Emitter<TaskState> emit) async {
    await addTaskUseCase(event.task);
    add(LoadTasks());
  }

  Future<void> _onUpdateTask(UpdateExistingTask event, Emitter<TaskState> emit) async {
    await updateTaskUseCase(event.task);
    add(LoadTasks());
  }

  Future<void> _onDeleteTask(DeleteExistingTask event, Emitter<TaskState> emit) async {
    await deleteTaskUseCase(event.id);
    add(LoadTasks());
  }
/*
  Future<void> _onAddTask(
      AddNewTask event,
      Emitter<TaskState> emit,
      ) async {
    if (state is TaskLoaded) {
      try {
        await addTaskUseCase(event.task);
        // Reload the tasks after adding new one
        // final tasks = await getTasksUseCase();
        // emit(TaskLoaded(tasks));
        final newTasks = await getTasksUseCase(page: _currentPage, limit: _limit);
        _hasMore = newTasks.length == _limit;
        _tasks.addAll(newTasks);

        emit(TaskLoaded(tasks: _tasks, hasMore: _hasMore));
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
        // final tasks = await getTasksUseCase();
        // emit(TaskLoaded(tasks));
        final newTasks = await getTasksUseCase(page: _currentPage, limit: _limit);
        _hasMore = newTasks.length == _limit;
        _tasks.addAll(newTasks);

        emit(TaskLoaded(tasks: _tasks, hasMore: _hasMore));
      } catch (e) {
        emit(TaskError('Failed to update task.'));
      }
    }
  }

  Future<void> _onDeleteTask(
      UpdateExistingTask event,
      Emitter<TaskState> emit,
      ) async {
    if (state is TaskLoaded) {
      try {
        await deleteTaskUseCase(event.id);
        // final tasks = await getTasksUseCase();
        // emit(TaskLoaded(tasks));
        final newTasks = await getTasksUseCase(page: _currentPage, limit: _limit);
        _hasMore = newTasks.length == _limit;
        _tasks.addAll(newTasks);

        emit(TaskLoaded(tasks: _tasks, hasMore: _hasMore));
      } catch (e) {
        emit(TaskError('Failed to delete task.'));
      }
    }
  }*/
}
