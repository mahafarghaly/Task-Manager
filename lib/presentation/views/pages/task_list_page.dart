import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solid_and_pagination/data/models/task_model.dart';
import 'package:solid_and_pagination/domain/entities/task_entity.dart';
import 'package:solid_and_pagination/domain/usecases/update_task.dart';

import '../../bloc/task_bloc.dart';
import '../../bloc/task_event.dart';
import '../../bloc/task_state.dart';

class TaskListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Task List')),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded || state is TaskLoadingMore) {
            final tasks = (state as dynamic).tasks;
            final hasMore = (state as dynamic).hasMore;
            return ListView.builder(
              itemCount: tasks.length + (hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == tasks.length) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListTile(
                  title: Text(tasks[index].title),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          context.read<TaskBloc>().add(UpdateExistingTask(TaskEntity(id: tasks[index].id, title: 'Updated ${tasks[index].title}')));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          context.read<TaskBloc>().add(DeleteExistingTask(tasks[index].id));
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final newTask = TaskModel(id: DateTime.now().millisecondsSinceEpoch.toString(), title: 'New Task');
          context.read<TaskBloc>().add(AddNewTask(newTask));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
