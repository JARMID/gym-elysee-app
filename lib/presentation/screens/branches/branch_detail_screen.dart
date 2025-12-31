import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../presentation/providers/branch_provider.dart';

class BranchDetailScreen extends ConsumerWidget {
  final int branchId;
  
  const BranchDetailScreen({
    super.key,
    required this.branchId,
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branchAsync = ref.watch(branchProvider(branchId));
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de la Branche'),
      ),
      body: branchAsync.when(
        data: (branch) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Photos (si disponibles)
                if (branch.photos.isNotEmpty)
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: branch.photos.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 300,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: NetworkImage(branch.photos[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                
                const SizedBox(height: 16),
                
                // Nom
                Text(
                  branch.name,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Adresse
                Row(
                  children: [
                    Icon(Icons.location_on, size: 20, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        branch.fullAddress,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Description
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  branch.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                
                const SizedBox(height: 24),
                
                // Horaires
                _SectionTitle('Horaires d\'ouverture'),
                const SizedBox(height: 8),
                ...branch.openingHours.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDay(entry.key),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          entry.value,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                
                const SizedBox(height: 24),
                
                // Équipements
                _SectionTitle('Équipements'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: branch.equipment.map((equipment) {
                    return Chip(
                      label: Text(equipment),
                      backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    );
                  }).toList(),
                ),
                
                const SizedBox(height: 24),
                
                // Capacité
                _SectionTitle('Informations'),
                const SizedBox(height: 8),
                _InfoRow(
                  icon: Icons.people,
                  label: 'Capacité',
                  value: '${branch.capacity} membres',
                ),
                _InfoRow(
                  icon: Icons.phone,
                  label: 'Téléphone',
                  value: branch.phone,
                ),
                if (branch.latitude != null && branch.longitude != null)
                  _InfoRow(
                    icon: Icons.map,
                    label: 'Coordonnées',
                    value: '${branch.latitude}, ${branch.longitude}',
                  ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Erreur: ${error.toString()}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(branchProvider(branchId)),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  String _formatDay(String day) {
    final days = {
      'monday': 'Lundi',
      'tuesday': 'Mardi',
      'wednesday': 'Mercredi',
      'thursday': 'Jeudi',
      'friday': 'Vendredi',
      'saturday': 'Samedi',
      'sunday': 'Dimanche',
    };
    return days[day.toLowerCase()] ?? day;
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  
  const _SectionTitle(this.title);
  
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}


