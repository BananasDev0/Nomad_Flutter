# nomad_flutter

A new Flutter project.
lib/
├── main.dart
│
├── core/
│   ├── di/
│   │   └── injection.dart              # GetIt - Inyección de dependencias
│   └── network/
│       └── api_client.dart             # Dio - Cliente HTTP
│
├── data/
│   ├── models/
│   │   └── trip_model.dart             # Modelos de datos (con Freezed)
│   └── repositories/
│       └── trip_repository_impl.dart   # Implementación del repositorio
│
├── domain/
│   └── repositories/
│       └── trip_repository.dart        # Interface del repositorio
│
└── presentation/
    ├── viewmodels/
    │   └── trip_form_viewmodel.dart    # ViewModel (ChangeNotifier)
    ├── screens/
    │   └── trip_form_screen.dart       # Pantalla principal
    └── widgets/
        ├── trip_form_step_one.dart     # Widget paso 1
        ├── trip_form_step_two.dart     # Widget paso 2 (DatePickers)
        └── trip_form_step_three.dart   # Widget paso 3