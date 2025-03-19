// data/repositories/task_repository_impl.dart
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../data_source/local_task_data_source.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final LocalTaskDataSource localDataSource;

  TaskRepositoryImpl({required this.localDataSource});

  @override
  Future<List<TaskEntity>> getTasks() async {
    final taskModels = await localDataSource.getTasks();
    return taskModels;
  }

  @override
  Future<void> addTask(TaskEntity task) async {
    final model = TaskModel(
      id: task.id,
      title: task.title,
      isCompleted: task.isCompleted,
    );
    await localDataSource.addTask(model);
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    final model = TaskModel(
      id: task.id,
      title: task.title,
      isCompleted: task.isCompleted,
    );
    await localDataSource.updateTask(model);
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await localDataSource.deleteTask(taskId);
  }
}
