import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../viewmodels/trip_form_viewmodel.dart';

class TripFormStepThree extends StatefulWidget {
  const TripFormStepThree({super.key});

  @override
  State<TripFormStepThree> createState() => _TripFormStepThreeState();
}

class _TripFormStepThreeState extends State<TripFormStepThree> {
  late TextEditingController _descriptionController;
  late TextEditingController _budgetController;
  final TextEditingController _activityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<TripFormViewModel>();
    _descriptionController = TextEditingController(text: viewModel.description);
    _budgetController = TextEditingController(
      text: viewModel.budget != null ? viewModel.budget.toString() : '',
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _budgetController.dispose();
    _activityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TripFormViewModel>(
      builder: (context, viewModel, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.edit_note,
                size: 64,
                color: Colors.purple,
              ),
              const SizedBox(height: 24),
              Text(
                'Detalles del viaje',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Agrega información adicional sobre tu viaje',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  hintText: 'Describe brevemente tu viaje...',
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                onChanged: viewModel.updateDescription,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _budgetController,
                decoration: InputDecoration(
                  labelText: 'Presupuesto (opcional)',
                  hintText: '0.00',
                  prefixIcon: const Icon(Icons.attach_money),
                  suffixText: 'USD',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    final budget = double.tryParse(value);
                    viewModel.updateBudget(budget);
                  } else {
                    viewModel.updateBudget(null);
                  }
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Actividades planeadas',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _activityController,
                      decoration: InputDecoration(
                        hintText: 'Ej: Visitar museo',
                        prefixIcon: const Icon(Icons.add_task),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      onSubmitted: (value) => _addActivity(viewModel, value),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: () => _addActivity(viewModel, _activityController.text),
                    icon: const Icon(Icons.add),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (viewModel.activities.isEmpty)
                _buildEmptyActivities()
              else
                _buildActivitiesList(viewModel),
              const SizedBox(height: 24),
              _buildActivitySuggestions(viewModel),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyActivities() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Icon(
            Icons.event_busy,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 8),
          Text(
            'No hay actividades agregadas',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivitiesList(TripFormViewModel viewModel) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: viewModel.activities.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final activity = viewModel.activities[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.purple[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.purple[100]!),
          ),
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            title: Text(
              activity,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              color: Colors.red[400],
              onPressed: () => viewModel.removeActivity(activity),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActivitySuggestions(TripFormViewModel viewModel) {
    final suggestions = [
      '🏖️ Ir a la playa',
      '🍽️ Probar comida local',
      '🏛️ Visitar museos',
      '🏔️ Hacer senderismo',
      '🛍️ Shopping',
      '📸 Tour fotográfico',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sugerencias',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: suggestions.map((suggestion) {
            return ActionChip(
              label: Text(suggestion),
              onPressed: () {
                _activityController.text = suggestion.substring(3);
                _addActivity(viewModel, _activityController.text);
              },
              backgroundColor: Colors.purple[50],
              labelStyle: TextStyle(color: Colors.purple[700]),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _addActivity(TripFormViewModel viewModel, String activity) {
    if (activity.trim().isEmpty) return;
    viewModel.addActivity(activity.trim());
    _activityController.clear();
  }
}