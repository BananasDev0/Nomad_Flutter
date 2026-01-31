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
      // MODO MOCK - Datos de prueba sin backend///// Comentar cuando se conecte ala bd
      _loadMockTrips();
      
      /* MODO REAL - Descomentar cuando tengas backend
      _loadTripsFromRepository();
      */
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
    final images = {
      'Cancún': 'https://images.unsplash.com/photo-1602002418082-a4443e081dd1?w=800',
      'París': 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=800',
      'Tokyo': 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=800',
      'Nueva York': 'https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=800',
    };
    
    return images[destination] ?? 'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=800';
  }

  Future<void> _loadMockTrips() async {
    _isLoading = true;
    notifyListeners();

    // Simula llamada a backend
    await Future.delayed(const Duration(milliseconds: 500));

    _upcomingTrips = [
      TripCard(
        id: '1',
        title: 'Parisian Adventure',
        date: 'Jun 10 - Jun 15, 2024',
        imageUrl:
            'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=800',
        avatars: const [
          'https://i.pravatar.cc/150?img=1',
          'https://i.pravatar.cc/150?img=2',
        ],
      ),
      TripCard(
        id: '2',
        title: 'Tokyo Exploration',
        date: 'Jul 20 - Jul 28, 2024',
        imageUrl:
            'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=800',
        avatars: const [
          'https://i.pravatar.cc/150?img=3',
          'https://i.pravatar.cc/150?img=4',
          'https://i.pravatar.cc/150?img=5',
        ],
      ),
      TripCard(
        id: '3',
        title: 'Beach Getaway Cancún',
        date: 'Aug 5 - Aug 12, 2024',
        imageUrl:
            'https://images.unsplash.com/photo-1602002418082-a4443e081dd1?w=800',
        avatars: const [
          'https://i.pravatar.cc/150?img=6',
        ],
      ),
    ];

    _pastTrips = [
      TripCard(
        id: '4',
        title: 'New York City Trip',
        date: 'Mar 10 - Mar 17, 2024',
        imageUrl:
            'https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=800',
        avatars: const [
          'https://i.pravatar.cc/150?img=7',
          'https://i.pravatar.cc/150?img=8',
        ],
      ),
      TripCard(
        id: '5',
        title: 'London Adventure',
        date: 'Jan 15 - Jan 22, 2024',
        imageUrl:
            'https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?w=800',
        avatars: const [
          'https://i.pravatar.cc/150?img=9',
        ],
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadTripsFromRepository() async {
    _isLoading = true;
    notifyListeners();

    final trips = await _repository.getTrips();
    final now = DateTime.now();

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
}


  @override
  void dispose() {
    super.dispose();
  }
}