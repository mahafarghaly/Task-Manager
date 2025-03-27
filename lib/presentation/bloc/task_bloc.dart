import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solid_and_pagination/domain/entities/task_entity.dart';
import '../../domain/usecases/get_tasks.dart';
import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/update_task.dart';
import '../helper/pagination_helper.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasks getTasksUseCase;
  final AddTask addTaskUseCase;
  final UpdateTask updateTaskUseCase;
  final DeleteTask deleteTaskUseCase;

  final PaginationHelper<TaskEntity> pagination = PaginationHelper(limit: 10);

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

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    pagination.reset();
    emit(TaskLoading());

    final newTasks = await getTasksUseCase(
      page: pagination.currentPage,
      limit: pagination.limit,
    );
    pagination.update(newTasks);

    emit(
      TaskLoaded(
        tasks: List.from(pagination.items),
        hasMore: pagination.hasMore,
      ),
    );
  }

  Future<void> _onLoadMoreTasks(
    LoadMoreTasks event,
    Emitter<TaskState> emit,
  ) async {
    if (!pagination.hasMore || pagination.isLoadingMore) return;

    pagination.startLoadingMore();
    final newTasks = await getTasksUseCase(
      page: pagination.currentPage,
      limit: pagination.limit,
    );
    pagination.update(newTasks);
    pagination.stopLoadingMore();

    emit(
      TaskLoaded(
        tasks: List.from(pagination.items),
        hasMore: pagination.hasMore,
      ),
    );
  }

  Future<void> _onAddTask(AddNewTask event, Emitter<TaskState> emit) async {
    await addTaskUseCase(event.task);
    pagination.items.insert(0, event.task);
    emit(
      TaskLoaded(
        tasks: List.from(pagination.items),
        hasMore: pagination.hasMore,
      ),
    );
  }

  Future<void> _onUpdateTask(
    UpdateExistingTask event,
    Emitter<TaskState> emit,
  ) async {
    await updateTaskUseCase(event.task);
    final index = pagination.items.indexWhere((t) => t.id == event.task.id);
    if (index != -1) {
      pagination.items[index] = event.task;
    }
    emit(
      TaskLoaded(
        tasks: List.from(pagination.items),
        hasMore: pagination.hasMore,
      ),
    );
  }

  Future<void> _onDeleteTask(
    DeleteExistingTask event,
    Emitter<TaskState> emit,
  ) async {
    await deleteTaskUseCase(event.id);
    pagination.items.removeWhere((task) => task.id == event.id);
    emit(
      TaskLoaded(
        tasks: List.from(pagination.items),
        hasMore: pagination.hasMore,
      ),
    );
  }
}
