import '../../domain/entities/task_entity.dart';

abstract class TaskEvent {}

class LoadTasks extends TaskEvent {}
class LoadMoreTasks extends TaskEvent {}
class AddNewTask extends TaskEvent {
  final TaskEntity task;
  AddNewTask(this.task);
}

class UpdateExistingTask extends TaskEvent {
  final TaskEntity task;
  UpdateExistingTask(this.task);
}

class DeleteExistingTask extends TaskEvent {
  final String id;
  DeleteExistingTask(this.id);
}
