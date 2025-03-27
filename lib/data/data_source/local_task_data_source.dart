
import '../models/task_model.dart';

abstract class LocalTaskDataSource {
  Future<List<TaskModel>> getTasks({required int page, required int limit});
  Future<void> addTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(String id);
}


