import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/task_bloc.dart';
import 'bloc/task_event.dart';
import 'di/service_locator.dart';
import 'repositories/task_repository.dart';
import 'ui/task_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  runApp(const TaskApp());
}

class TaskApp extends StatelessWidget {
  const TaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: getIt<TaskRepository>(),
      child: BlocProvider(
        create: (context) => getIt<TaskBloc>()..add(const LoadTasksEvent()),
        child: MaterialApp(
          title: 'Task Tracker',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
            ),
          ),
          home: const TaskScreen(),
        ),
      ),
    );
  }
}
