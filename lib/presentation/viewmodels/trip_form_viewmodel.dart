import 'package:flutter/foundation.dart';
import '../../data/models/trip_model.dart';
import '../../domain/repositories/trip_repository.dart';

/// ViewModel para el formulario de viaje
/// Maneja todo el estado y lógica del formulario
class TripFormViewModel extends ChangeNotifier {
  final TripRepository _repository;

  TripFormViewModel(this._repository);

  // Estado del formulario
  int _currentStep = 0;
  String _destination = '';
  DateTime? _startDate;
  DateTime? _endDate;
  String _description = '';
  double? _budget;
  List<String> _activities = [];

  // Estado de carga y errores
  bool _isLoading = false;
  String? _errorMessage;
  TripModel? _createdTrip;

  // Getters
  int get currentStep => _currentStep;
  String get destination => _destination;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  String get description => _description;
  double? get budget => _budget;
  List<String> get activities => List.unmodifiable(_activities);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  TripModel? get createdTrip => _createdTrip;

  // Validaciones
  bool get canGoNext {
    switch (_currentStep) {
      case 0:
        return _destination.isNotEmpty;
      case 1:
        return _startDate != null && _endDate != null;
      case 2:
        return true;
      default:
        return false;
    }
  }

  int? get tripDuration {
    if (_startDate != null && _endDate != null) {
      return _endDate!.difference(_startDate!).inDays + 1;
    }
    return null;
  }

  // Métodos para actualizar el estado
  void updateDestination(String value) {
    _destination = value;
    notifyListeners();
  }

  void updateStartDate(DateTime date) {
    _startDate = date;
    
    // Si la fecha de fin es anterior a la nueva fecha de inicio, ajustarla
    if (_endDate != null && _endDate!.isBefore(date)) {
      _endDate = date.add(const Duration(days: 7));
    }
    
    notifyListeners();
  }

  void updateEndDate(DateTime date) {
    _endDate = date;
    notifyListeners();
  }

  void setQuickDateRange(int days) {
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, now.day);
    _endDate = _startDate!.add(Duration(days: days - 1));
    notifyListeners();
  }

  void updateDescription(String value) {
    _description = value;
    notifyListeners();
  }

  void updateBudget(double? value) {
    _budget = value;
    notifyListeners();
  }

  void addActivity(String activity) {
    if (activity.trim().isNotEmpty) {
      _activities.add(activity.trim());
      notifyListeners();
    }
  }

  void removeActivity(String activity) {
    _activities.remove(activity);
    notifyListeners();
  }

  // Navegación entre pasos
  void nextStep() {
    if (canGoNext && _currentStep < 2) {
      _currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  // Submit del formulario
  Future<bool> submitTrip() async {
    if (_startDate == null || _endDate == null) {
      _errorMessage = 'Por favor completa las fechas del viaje';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final trip = TripModel(
        destination: _destination,
        startDate: _startDate!,
        endDate: _endDate!,
        description: _description,
        budget: _budget,
        activities: _activities,
      );

      _createdTrip = await _repository.createTrip(trip);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Error al crear el viaje: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Resetear el formulario
  void reset() {
    _currentStep = 0;
    _destination = '';
    _startDate = null;
    _endDate = null;
    _description = '';
    _budget = null;
    _activities = [];
    _isLoading = false;
    _errorMessage = null;
    _createdTrip = null;
    notifyListeners();
  }

  @override
  void dispose() {
    // Limpiar recursos si es necesario
    super.dispose();
  }
}