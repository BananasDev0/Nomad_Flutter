import 'package:flutter/foundation.dart';
import '../../data/models/itinerary_models.dart';

class ItineraryViewModel extends ChangeNotifier {
  // Datos del viaje
  final String tripTitle;
  final String destination;
  final String dateRange;
  
  // Datos del itinerario
  List<DayItinerary> _itinerary = [];

  ItineraryViewModel({
    this.tripTitle = 'Parisian Adventure',
    this.destination = 'Paris, France',
    this.dateRange = 'June 10 - June 15, 2024',
  }) {
    _loadItinerary();
  }

  List<DayItinerary> get itinerary => _itinerary;

  void _loadItinerary() {
    // Datos de ejemplo - en producción vendrían del backend
    _itinerary = [
      DayItinerary(
        day: 'Monday, June 10',
        activities: [
          Activity(
            icon: 'account_balance',
            title: 'Eiffel Tower Visit',
            start: '9:00 AM',
            end: '11:00 AM',
          ),
          Activity(
            icon: 'restaurant',
            title: 'Le Bistrot d\'Henri',
            start: '12:30 PM',
            end: '2:00 PM',
          ),
          Activity(
            icon: 'museum',
            title: 'Louvre Museum Tour',
            start: '2:30 PM',
            end: '5:00 PM',
          ),
          Activity(
            icon: 'directions_boat',
            title: 'Seine River Cruise',
            start: '7:00 PM',
            end: '',
          ),
        ],
      ),
      DayItinerary(
        day: 'Tuesday, June 11',
        activities: [
          Activity(
            icon: 'church',
            title: 'Explore Montmartre',
            start: '10:00 AM',
            end: '1:00 PM',
          ),
          Activity(
            icon: 'park',
            title: 'Picnic at Sacré-Cœur',
            start: '1:00 PM',
            end: '2:00 PM',
          ),
          Activity(
            icon: 'shopping_bag',
            title: 'Shopping on Champs-Élysées',
            start: '3:00 PM',
            end: '6:00 PM',
          ),
        ],
      ),
      DayItinerary(
        day: 'Wednesday, June 12',
        activities: [
          Activity(
            icon: 'local_cafe',
            title: 'Breakfast at Café de Flore',
            start: '8:00 AM',
            end: '9:30 AM',
          ),
          Activity(
            icon: 'museum',
            title: 'Musée d\'Orsay Visit',
            start: '10:00 AM',
            end: '1:00 PM',
          ),
          Activity(
            icon: 'park',
            title: 'Walk in Luxembourg Gardens',
            start: '2:00 PM',
            end: '4:00 PM',
          ),
        ],
      ),
      DayItinerary(
        day: 'Thursday, June 13',
        activities: [
          Activity(
            icon: 'local_library',
            title: 'Shakespeare and Company Bookstore',
            start: '9:00 AM',
            end: '10:30 AM',
          ),
          Activity(
            icon: 'restaurant',
            title: 'Lunch at Le Comptoir',
            start: '11:00 AM',
            end: '12:30 PM',
          ),
          Activity(
            icon: 'landscape',
            title: 'Notre Dame & Île de la Cité',
            start: '1:00 PM',
            end: '3:30 PM',
          ),
        ],
      ),
      DayItinerary(
        day: 'Friday, June 14',
        activities: [
          Activity(
            icon: 'shopping_bag',
            title: 'Le Marais Shopping',
            start: '10:00 AM',
            end: '1:00 PM',
          ),
          Activity(
            icon: 'local_cafe',
            title: 'Coffee Break at Café Charlot',
            start: '1:00 PM',
            end: '2:00 PM',
          ),
          Activity(
            icon: 'directions_walk',
            title: 'Walk along the Seine',
            start: '2:30 PM',
            end: '5:00 PM',
          ),
        ],
      ),
    ];
    notifyListeners();
  }

  Future<void> shareItinerary() async {
    // Aquí iría la lógica para compartir el itinerario
    await Future.delayed(const Duration(milliseconds: 500));
    // Ejemplo: Share.share('Check out my trip itinerary!');
  }

  @override
  void dispose() {
    super.dispose();
  }
}