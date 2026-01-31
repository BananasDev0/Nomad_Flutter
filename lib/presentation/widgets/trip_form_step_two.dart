import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../viewmodels/trip_form_viewmodel.dart';

class TripFormStepTwo extends StatelessWidget {
  const TripFormStepTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TripFormViewModel>(
      builder: (context, viewModel, child) {
        final duration = viewModel.tripDuration;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.calendar_month,
                size: 64,
                color: Colors.orange,
              ),
              const SizedBox(height: 24),
              Text(
                '¿Cuándo viajas?',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Selecciona las fechas de inicio y fin de tu viaje',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 32),
              _buildDateCard(
                context: context,
                title: 'Fecha de inicio',
                icon: Icons.flight_takeoff,
                date: viewModel.startDate,
                onTap: () => _selectStartDate(context, viewModel),
              ),
              const SizedBox(height: 16),
              _buildDateCard(
                context: context,
                title: 'Fecha de salida',
                icon: Icons.flight_land,
                date: viewModel.endDate,
                onTap: () => _selectEndDate(context, viewModel),
              ),
              if (duration != null) ...[
                const SizedBox(height: 24),
                _buildDurationCard(context, duration),
              ],
              const SizedBox(height: 32),
              _buildQuickDateOptions(context, viewModel),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDateCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    final formattedDate = date != null
        ? DateFormat('EEEE, d MMMM yyyy', 'es').format(date)
        : null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: date != null ? Colors.orange[50] : Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: date != null ? Colors.orange : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: date != null ? Colors.orange : Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formattedDate ?? 'Seleccionar fecha',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: date != null ? Colors.black87 : Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationCard(BuildContext context, int days) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[400]!, Colors.blue[600]!],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.event,
            color: Colors.white,
            size: 32,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Duración del viaje',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$days ${days == 1 ? 'día' : 'días'}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickDateOptions(BuildContext context, TripFormViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Opciones rápidas',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildQuickOption(context, viewModel, label: 'Fin de semana', days: 3),
            _buildQuickOption(context, viewModel, label: '1 semana', days: 7),
            _buildQuickOption(context, viewModel, label: '2 semanas', days: 14),
            _buildQuickOption(context, viewModel, label: '1 mes', days: 30),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickOption(
    BuildContext context,
    TripFormViewModel viewModel, {
    required String label,
    required int days,
  }) {
    return ActionChip(
      label: Text(label),
      onPressed: () => viewModel.setQuickDateRange(days),
      backgroundColor: Colors.orange[50],
      labelStyle: TextStyle(color: Colors.orange[700]),
    );
  }

  Future<void> _selectStartDate(BuildContext context, TripFormViewModel viewModel) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: viewModel.startDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 730)),
      locale: const Locale('es', 'ES'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.orange,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      viewModel.updateStartDate(picked);
    }
  }

  Future<void> _selectEndDate(BuildContext context, TripFormViewModel viewModel) async {
    final startDate = viewModel.startDate;
    
    if (startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona primero la fecha de inicio'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: viewModel.endDate ?? startDate.add(const Duration(days: 7)),
      firstDate: startDate,
      lastDate: startDate.add(const Duration(days: 365)),
      locale: const Locale('es', 'ES'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.orange,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      viewModel.updateEndDate(picked);
    }
  }
}