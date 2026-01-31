import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/trip_form_viewmodel.dart';

class TripFormStepOne extends StatefulWidget {
  const TripFormStepOne({super.key});

  @override
  State<TripFormStepOne> createState() => _TripFormStepOneState();
}

class _TripFormStepOneState extends State<TripFormStepOne> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<TripFormViewModel>();
    _controller = TextEditingController(text: viewModel.destination);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.location_on,
            size: 64,
            color: Colors.blue,
          ),
          const SizedBox(height: 24),
          Text(
            '¿A dónde vas?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Cuéntanos tu destino para comenzar a planear tu viaje',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Destino',
              hintText: 'Ej: Cancún, México',
              prefixIcon: const Icon(Icons.public),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            textCapitalization: TextCapitalization.words,
            onChanged: (value) {
              context.read<TripFormViewModel>().updateDestination(value);
            },
          ),
          const SizedBox(height: 24),
          _buildSuggestions(context),
        ],
      ),
    );
  }

  Widget _buildSuggestions(BuildContext context) {
    final suggestions = [
      {'name': 'Cancún', 'country': 'México', 'icon': '🏖️'},
      {'name': 'París', 'country': 'Francia', 'icon': '🗼'},
      {'name': 'Tokyo', 'country': 'Japón', 'icon': '🗾'},
      {'name': 'Nueva York', 'country': 'USA', 'icon': '🗽'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Destinos populares',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: suggestions.map((suggestion) {
            return InkWell(
              onTap: () {
                _controller.text = suggestion['name']!;
                context
                    .read<TripFormViewModel>()
                    .updateDestination(suggestion['name']!);
              },
              child: Chip(
                avatar: Text(
                  suggestion['icon']!,
                  style: const TextStyle(fontSize: 20),
                ),
                label: Text('${suggestion['name']}, ${suggestion['country']}'),
                backgroundColor: Colors.blue[50],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}