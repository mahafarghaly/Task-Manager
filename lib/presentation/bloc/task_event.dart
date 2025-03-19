// presentation/bloc/task_event.dart
import '../../domain/entities/task_entity.dart';

abstract class TaskEvent {}

class LoadTasks extends TaskEvent {}

class AddNewTask extends TaskEvent {
  final TaskEntity task;
  AddNewTask(this.task);
}

class UpdateExistingTask extends TaskEvent {
  final TaskEntity task;
  UpdateExistingTask(this.task);
}

class DeleteTask extends TaskEvent {
  final String id;
  DeleteTask(this.id);
}
