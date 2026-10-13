import 'package:get_it/get_it.dart';
import '../bloc/task_bloc.dart';
import '../repositories/task_repository.dart';
import '../services/task_api.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator({String baseUrl = 'http://192.168.1.44:3000'}) {
  // API Service
  getIt.registerLazySingleton<TaskApi>(
    () => TaskApi(baseUrl: baseUrl),
  );

  // Repository
  getIt.registerLazySingleton<TaskRepository>(
    () => TaskRepository(api: getIt<TaskApi>()),
  );

  // BLoC / ViewModel
  getIt.registerFactory<TaskBloc>(
    () => TaskBloc(repository: getIt<TaskRepository>()),
  );
}
