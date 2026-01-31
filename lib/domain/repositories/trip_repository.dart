import '../../data/models/trip_model.dart';

/// Interface del repositorio de viajes
/// Define el contrato que debe implementar TripRepositoryImpl
abstract class TripRepository {
  /// Obtener todos los viajes del usuario
  Future<List<TripModel>> getTrips();
  
  /// Obtener un viaje por ID
  Future<TripModel> getTripById(String id);
  
  /// Crear un nuevo viaje
  Future<TripModel> createTrip(TripModel trip);
  
  /// Actualizar un viaje existente
  Future<TripModel> updateTrip(String id, TripModel trip);
  
  /// Eliminar un viaje
  Future<void> deleteTrip(String id);
}