
import '../models/task_model.dart';

abstract class LocalTaskDataSource {
  Future<List<TaskModel>> getTasks({required int page, required int limit});
  Future<void> addTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(String id);
}

class LocalTaskDataSourceImpl implements LocalTaskDataSource {
  //List<TaskModel> _tasks =[];
  final List<TaskModel> _taskStorage = List.generate(100, (index) => TaskModel(id: index.toString(), title: 'Task $index'));

  @override
  Future<List<TaskModel>> getTasks({required int page, required int limit}) async {
    final startIndex = (page - 1) * limit;
    if (startIndex >= _taskStorage.length) return [];
    return _taskStorage.skip(startIndex).take(limit).toList();
  }
 // @override
 //  Future<List<TaskModel>> getTasks() async {
 //    return _tasks;
 //  }

  @override
  Future<void> addTask(TaskModel task) async {
    _taskStorage.add(task);
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    final index = _taskStorage.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _taskStorage[index] = task;
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    _taskStorage.removeWhere((t) => t.id == id);
  }
}
