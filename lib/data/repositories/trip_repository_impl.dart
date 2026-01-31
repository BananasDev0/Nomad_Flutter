import '../../domain/repositories/trip_repository.dart';
import '../models/trip_model.dart';
import '../../core/network/api_client.dart';

/// Implementación del repositorio de viajes
/// Conecta con el backend a través de ApiClient
class TripRepositoryImpl implements TripRepository {
  final ApiClient _apiClient;
  
  TripRepositoryImpl(this._apiClient);
  
  @override
  Future<List<TripModel>> getTrips() async {
    try {
      final response = await _apiClient.get('/trips');
      
      if (response.data is List) {
        return (response.data as List)
            .map((json) => TripModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      
      return [];
    } catch (e) {
      throw Exception('Error al obtener viajes: $e');
    }
  }
  
  @override
  Future<TripModel> getTripById(String id) async {
    try {
      final response = await _apiClient.get('/trips/$id');
      return TripModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al obtener viaje: $e');
    }
  }
  
  @override
  Future<TripModel> createTrip(TripModel trip) async {
    try {
      final response = await _apiClient.post(
        '/trips',
        data: trip.toJson(),
      );
      
      return TripModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al crear viaje: $e');
    }
  }
  
  @override
  Future<TripModel> updateTrip(String id, TripModel trip) async {
    try {
      final response = await _apiClient.put(
        '/trips/$id',
        data: trip.toJson(),
      );
      
      return TripModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al actualizar viaje: $e');
    }
  }
  
  @override
  Future<void> deleteTrip(String id) async {
    try {
      await _apiClient.delete('/trips/$id');
    } catch (e) {
      throw Exception('Error al eliminar viaje: $e');
    }
  }
}