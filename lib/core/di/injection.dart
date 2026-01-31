import 'package:get_it/get_it.dart';
import 'package:trip_planner/presentation/viewmodels/home_viewmodel.dart';
import '../network/api_client.dart';
import '../../data/repositories/trip_repository_impl.dart';
import '../../domain/repositories/trip_repository.dart';
import '../../presentation/viewmodels/trip_form_viewmodel.dart';

final getIt = GetIt.instance;

/// Configura todas las dependencias de la aplicación
/// Llama esto en main.dart antes de runApp()
void setupDependencies() {
  // Network
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(
      // Cambia esto por la URL de tu backend
      baseUrl: 'https://tu-api.com/api',
    ),
  );
  
  // Repositories
  getIt.registerLazySingleton<TripRepository>(
    () => TripRepositoryImpl(getIt<ApiClient>()),
  );
  
  // ViewModels - Factory porque se crean nuevos cada vez
  getIt.registerFactory<TripFormViewModel>(
    () => TripFormViewModel(getIt<TripRepository>()),
  );

  getIt.registerFactory<HomeViewModel>(
    () => HomeViewModel(getIt<TripRepository>())
  );
}

/// Limpia todas las dependencias
/// Útil para tests
void resetDependencies() {
  getIt.reset();
}