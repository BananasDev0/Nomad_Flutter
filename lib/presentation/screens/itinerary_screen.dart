import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/itinerary_viewmodel.dart';
import '../../core/di/injection.dart';

class ItineraryScreen extends StatelessWidget {
  const ItineraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<ItineraryViewModel>(),
      child: const ItineraryView(),
    );
  }
}

class ItineraryView extends StatelessWidget {
  const ItineraryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1F2937)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Consumer<ItineraryViewModel>(
          builder: (context, viewModel, _) {
            return Text(
              viewModel.tripTitle,
              style: const TextStyle(
                color: Color(0xFF1F2937),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: const Color(0xFFD1D5DB),
            height: 1,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Main Content
          Consumer<ItineraryViewModel>(
            builder: (context, viewModel, _) {
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 112),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.only(top: 24, bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            viewModel.destination,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            viewModel.dateRange,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF4B5563),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Days
                    ...viewModel.itinerary.map((dayItem) {
                      return _buildDayCard(context, dayItem);
                    }).toList(),
                  ],
                ),
              );
            },
          ),

          // Floating Action Button
          Positioned(
            bottom: 96,
            right: 16,
            child: _buildShareButton(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDayCard(BuildContext context, dayItem) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dayItem.day,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          ...dayItem.activities.asMap().entries.map((entry) {
            final index = entry.key;
            final activity = entry.value;
            final isLast = index == dayItem.activities.length - 1;
            
            return Column(
              children: [
                _buildActivityItem(context, activity),
                if (!isLast)
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    height: 1,
                    color: const Color(0xFFF3F4F6),
                  ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildActivityItem(BuildContext context, activity) {
    return Row(
      children: [
        // Icon
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF003c49).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getIconData(activity.icon),
            size: 24,
            color: const Color(0xFF003c49),
          ),
        ),
        const SizedBox(width: 16),
        
        // Title and Time
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                activity.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                activity.end.isNotEmpty
                    ? '${activity.start} - ${activity.end}'
                    : activity.start,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF4B5563),
                ),
              ),
            ],
          ),
        ),
        
        // View Details Button
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Detalles de: ${activity.title}'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
          child: const Text(
            'View Details',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF003c49),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShareButton(BuildContext context) {
    return Consumer<ItineraryViewModel>(
      builder: (context, viewModel, _) {
        return Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(32),
          child: InkWell(
            onTap: () async {
              await viewModel.shareItinerary();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('¡Itinerario compartido!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            borderRadius: BorderRadius.circular(32),
            child: Container(
              height: 64,
              width: 192,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF003c49),
                borderRadius: BorderRadius.circular(32),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.share,
                    size: 24,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Share Itinerary',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _getIconData(String iconName) {
    final icons = {
      'account_balance': Icons.account_balance,
      'restaurant': Icons.restaurant,
      'museum': Icons.museum,
      'directions_boat': Icons.directions_boat,
      'church': Icons.church,
      'park': Icons.park,
      'shopping_bag': Icons.shopping_bag,
      'local_cafe': Icons.local_cafe,
      'local_library': Icons.local_library,
      'landscape': Icons.landscape,
      'directions_walk': Icons.directions_walk,
    };
    
    return icons[iconName] ?? Icons.place;
  }
}