import 'package:flutter/foundation.dart';

class UserViewModel extends ChangeNotifier {
  // Estados
  String _username = '';
  String _email = '';
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  String get username => _username;
  String get email => _email;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Validación
  bool get isValid {
    return _username.isNotEmpty && _email.isNotEmpty;
  }

  // Métodos
  void updateUsername(String value) {
    _username = value;
    _errorMessage = null;
    notifyListeners();
  }

  void updateEmail(String value) {
    _email = value;
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> handleUpdate() async {
    if (!isValid) {
      _errorMessage = 'Por favor completa todos los campos';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // Simular llamada al API
      await Future.delayed(const Duration(seconds: 1));

      // Aquí iría tu lógica real de actualización
      // await userRepository.updateUser(username, email);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Error al actualizar: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}