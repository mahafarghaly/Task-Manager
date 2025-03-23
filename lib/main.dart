// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solid_and_pagination/presentation/views/pages/task_list_page.dart';
import 'data/data_source/local_task_data_source.dart';
import 'domain/entities/task_entity.dart';
import 'domain/usecases/delete_task.dart';
import 'domain/usecases/get_tasks.dart';
import 'domain/usecases/add_task.dart';
import 'data/repositories/task_repository_impl.dart';
import 'domain/usecases/update_task.dart';
import 'presentation/bloc/task_bloc.dart';
import 'presentation/bloc/task_event.dart';
import 'presentation/bloc/task_state.dart';

void main() {
  // Setup data source and repository
  final localDataSource = LocalTaskDataSourceImpl();
  final taskRepository = TaskRepositoryImpl(localDataSource: localDataSource);

  // Setup use cases
  final getTasks = GetTasks(taskRepository);
  final addTask = AddTask(taskRepository);
  final updateTask = UpdateTask(taskRepository);
  final deleteTask = DeleteTask(taskRepository);

  runApp(MyApp(
    getTasks: getTasks,
    addTask: addTask,
    updateTask: updateTask,
    deleteTask: deleteTask,
  ));
}

class MyApp extends StatelessWidget {
  final GetTasks getTasks;
  final AddTask addTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;

  const MyApp({
    Key? key,
    required this.getTasks,
    required this.addTask,
    required this.updateTask,
    required this.deleteTask,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager SOLID Example',
      home: BlocProvider(
        create: (_) => TaskBloc(
          getTasksUseCase: getTasks,
          addTaskUseCase: addTask,
          updateTaskUseCase: updateTask,
          deleteTaskUseCase: deleteTask,
        )..add(LoadTasks()), // load tasks on start
        child: TaskListPage()//TaskPage(),
      ),
    );
  }
}

class TaskPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TaskBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            return ListView.builder(
              itemCount: state.tasks.length,
              itemBuilder: (context, index) {
                final task = state.tasks[index];
                return ListTile(
                  title: Text(task.title),
                  leading: Checkbox(
                    value: task.isCompleted,
                    onChanged: (val) {
                      final updatedTask = task.copyWith(isCompleted: val);
                      bloc.add(UpdateExistingTask(updatedTask));
                    },
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => bloc.add(DeleteExistingTask(task.id)),
                  ),
                );
              },
            );
          } else if (state is TaskError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final newTask = TaskEntity(id: DateTime.now().toString(), title: 'New Task');
          bloc.add(AddNewTask(newTask));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
