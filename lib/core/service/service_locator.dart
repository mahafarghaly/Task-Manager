import 'package:get_it/get_it.dart';
import 'package:solid_and_pagination/domain/repositories/task_repository.dart';

import '../../data/data_source/local_task_data_source.dart';
import '../../data/data_source/local_task_data_source_impl.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/get_tasks.dart';
import '../../domain/usecases/update_task.dart';
import '../../presentation/bloc/task_bloc.dart';

final sl = GetIt.instance;

class ServicesLocator {
  void init() {
    sl.registerLazySingleton<LocalTaskDataSource>(() => LocalTaskDataSourceImpl());
    // Register Repository
    sl.registerLazySingleton<TaskRepository>(() => TaskRepositoryImpl(localDataSource: sl()));

    // Register Use Cases
    sl.registerLazySingleton<GetTasks>(() => GetTasks(sl()));
    sl.registerLazySingleton<AddTask>(() => AddTask(sl()));
    sl.registerLazySingleton<UpdateTask>(() => UpdateTask(sl()));
    sl.registerLazySingleton<DeleteTask>(() => DeleteTask(sl()));
    // Register Bloc
    sl.registerFactory(() => TaskBloc(
      getTasksUseCase: sl(),
      addTaskUseCase: sl(),
      updateTaskUseCase: sl(),
      deleteTaskUseCase: sl(),
    ));


  }
}