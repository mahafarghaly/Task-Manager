import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solid_and_pagination/domain/entities/task_entity.dart';
import '../../bloc/task_bloc.dart';
import '../../bloc/task_event.dart';
import '../../bloc/task_state.dart';
import '../../helper/infinit_scroll.dart';
import '../widgets/task_list_item.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> with InfiniteScrollMixin<TaskListPage> {
  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(LoadTasks());
  }

  @override
  void onScroll() {
    final taskBloc = context.read<TaskBloc>();
    final pagination = taskBloc.pagination;

    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 100 &&
        pagination.hasMore &&
        !pagination.isLoadingMore) {
      taskBloc.add(LoadMoreTasks());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Task List')),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            final tasks = state.tasks;
            final hasMore = state.hasMore;
            return ListView.builder(
              controller: scrollController,
              itemCount: tasks.length + (hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == tasks.length && hasMore) {
                  return Center(child: CircularProgressIndicator());
                }
                return TaskListItem(task: tasks[index]);
              },
            );
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: Icon(Icons.add),
      ),
    );
  }

  void _addTask() {
    final newTask = TaskEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'New Task',
    );
    context.read<TaskBloc>().add(AddNewTask(newTask));
  }
}
