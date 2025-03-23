
import '../../domain/entities/task_entity.dart';

abstract class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}
//
// class TaskLoaded extends TaskState {
//   final List<TaskEntity> tasks;
//   TaskLoaded(this.tasks);
// }
class TaskLoadingMore extends TaskState {
  final List<TaskEntity> tasks;
  TaskLoadingMore({required this.tasks});
}

class TaskLoaded extends TaskState {
  final List<TaskEntity> tasks;
  final bool hasMore;
  TaskLoaded({required this.tasks, required this.hasMore});
}
class TaskError extends TaskState {
  final String message;
  TaskError(this.message);
}
