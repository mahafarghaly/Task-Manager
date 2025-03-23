import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class GetTasks {
  final TaskRepository repository;

  GetTasks(this.repository);

  Future<List<TaskEntity>> call({required int page, required int limit}) {
    return repository.getTasks(page: page, limit: limit);
  }
}