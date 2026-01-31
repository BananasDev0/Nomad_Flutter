import 'package:flutter/foundation.dart';
import '../../data/models/trip_card.dart';
import '../../domain/repositories/trip_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final TripRepository _repository;

  HomeViewModel(this._repository);

  // Estado
  List<TripCard> _upcomingTrips = [];
  List<TripCard> _pastTrips = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _showUpcoming = true; // true = Upcoming, false = Past
  String _searchQuery = '';

  // Getters
  List<TripCard> get upcomingTrips => _upcomingTrips;
  List<TripCard> get pastTrips => _pastTrips;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get showUpcoming => _showUpcoming;
  String get searchQuery => _searchQuery;

  // Trips filtrados por búsqueda y tab actual
  List<TripCard> get displayedTrips {
    final trips = _showUpcoming ? _upcomingTrips : _pastTrips;
    
    if (_searchQuery.isEmpty) {
      return trips;
    }
    
    return trips.where((trip) {
      return trip.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             trip.date.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  // Métodos
  void toggleTab(bool upcoming) {
    _showUpcoming = upcoming;
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> loadTrips() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Obtener viajes del repositorio
      final trips = await _repository.getTrips();
      
      final now = DateTime.now();
      
      // Separar en upcoming y past
      _upcomingTrips = trips
          .where((trip) => trip.endDate.isAfter(now))
          .map((trip) => TripCard(
                id: trip.id ?? '',
                title: trip.destination,
                date: _formatDateRange(trip.startDate, trip.endDate),
                imageUrl: _getDestinationImage(trip.destination),
                avatars: const [
                  'https://i.pravatar.cc/150?img=1',
                  'https://i.pravatar.cc/150?img=2',
                ],
              ))
          .toList();

      _pastTrips = trips
          .where((trip) => trip.endDate.isBefore(now))
          .map((trip) => TripCard(
                id: trip.id ?? '',
                title: trip.destination,
                date: _formatDateRange(trip.startDate, trip.endDate),
                imageUrl: _getDestinationImage(trip.destination),
                avatars: const [
                  'https://i.pravatar.cc/150?img=3',
                  'https://i.pravatar.cc/150?img=4',
                ],
              ))
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error al cargar viajes: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  String _formatDateRange(DateTime start, DateTime end) {
    final months = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
    ];
    
    return '${months[start.month - 1]} ${start.day} - ${months[end.month - 1]} ${end.day}, ${end.year}';
  }

  String _getDestinationImage(String destination) {
    // Mapeo simple de destinos a imágenes
    final images = {
      'Cancún': 'https://images.unsplash.com/photo-1602002418082-a4443e081dd1?w=800',
      'París': 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=800',
      'Tokyo': 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=800',
      'Nueva York': 'https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=800',
    };
    
    return images[destination] ?? 'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=800';
  }

  @override
  void dispose() {
    super.dispose();
  }
}