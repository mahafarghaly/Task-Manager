import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/task_entity.dart';
import '../../bloc/task_bloc.dart';
import '../../bloc/task_event.dart';

class TaskListItem extends StatelessWidget {
  final TaskEntity task;

  const TaskListItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(task.title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              final updatedTask = TaskEntity(
                id: task.id,
                title: 'Updated ${task.title}',
              );
              context.read<TaskBloc>().add(UpdateExistingTask(updatedTask));
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              context.read<TaskBloc>().add(DeleteExistingTask(task.id));
            },
          ),
        ],
      ),
    );
  }
}
