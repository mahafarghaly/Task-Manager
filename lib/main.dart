import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solid_and_pagination/presentation/views/pages/task_list_page.dart';
import 'core/service/service_locator.dart';
import 'presentation/bloc/task_bloc.dart';
import 'presentation/bloc/task_event.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ServicesLocator().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => sl<TaskBloc>()..add(LoadTasks()),
        child: TaskListPage(),
      ),
    );
  }
}
