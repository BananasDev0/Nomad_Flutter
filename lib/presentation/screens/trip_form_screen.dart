import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/trip_form_viewmodel.dart';
import '../widgets/trip_form_step_one.dart';
import '../widgets/trip_form_step_two.dart';
import '../widgets/trip_form_step_three.dart';
import '../../core/di/injection.dart';

class TripFormScreen extends StatelessWidget {
  const TripFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<TripFormViewModel>(),
      child: const TripFormView(),
    );
  }
}

class TripFormView extends StatelessWidget {
  const TripFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planea tu Viaje'),
        elevation: 0,
      ),
      body: Consumer<TripFormViewModel>(
        builder: (context, viewModel, child) {
          // Mostrar loading cuando está guardando
          if (viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Column(
            children: [
              _buildStepper(context, viewModel),
              Expanded(
                child: _buildCurrentStep(context, viewModel),
              ),
              _buildNavigationButtons(context, viewModel),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStepper(BuildContext context, TripFormViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surface,
      child: Row(
        children: [
          _buildStepIndicator(
            context,
            stepNumber: 1,
            label: 'Destino',
            isActive: viewModel.currentStep == 0,
            isCompleted: viewModel.currentStep > 0,
          ),
          Expanded(child: _buildStepLine(viewModel.currentStep > 0)),
          _buildStepIndicator(
            context,
            stepNumber: 2,
            label: 'Fechas',
            isActive: viewModel.currentStep == 1,
            isCompleted: viewModel.currentStep > 1,
          ),
          Expanded(child: _buildStepLine(viewModel.currentStep > 1)),
          _buildStepIndicator(
            context,
            stepNumber: 3,
            label: 'Detalles',
            isActive: viewModel.currentStep == 2,
            isCompleted: viewModel.currentStep > 2,
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(
    BuildContext context, {
    required int stepNumber,
    required String label,
    required bool isActive,
    required bool isCompleted,
  }) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted
                ? Colors.green
                : isActive
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[300],
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 20)
                : Text(
                    '$stepNumber',
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive
                ? Theme.of(context).colorScheme.primary
                : Colors.grey[600],
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(bool isCompleted) {
    return Container(
      height: 2,
      margin: const EdgeInsets.only(bottom: 30),
      color: isCompleted ? Colors.green : Colors.grey[300],
    );
  }

  Widget _buildCurrentStep(BuildContext context, TripFormViewModel viewModel) {
    switch (viewModel.currentStep) {
      case 0:
        return const TripFormStepOne();
      case 1:
        return const TripFormStepTwo();
      case 2:
        return const TripFormStepThree();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildNavigationButtons(BuildContext context, TripFormViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (viewModel.currentStep > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: viewModel.previousStep,
                  child: const Text('Anterior'),
                ),
              ),
            if (viewModel.currentStep > 0) const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: viewModel.canGoNext
                    ? () async {
                        if (viewModel.currentStep < 2) {
                          viewModel.nextStep();
                        } else {
                          // Submit
                          final success = await viewModel.submitTrip();
                          
                          if (success && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('¡Viaje creado exitosamente!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.of(context).pop();
                          } else if (viewModel.errorMessage != null && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(viewModel.errorMessage!),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      }
                    : null,
                child: Text(
                  viewModel.currentStep < 2 ? 'Siguiente' : 'Crear Viaje',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}