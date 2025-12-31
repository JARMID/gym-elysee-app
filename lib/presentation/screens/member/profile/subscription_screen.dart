import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? null : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;

    return Scaffold(
      appBar: AppBar(title: const Text('Mon Abonnement')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current subscription
            Card(
              elevation: isDark ? 1 : 4,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber),
                        const SizedBox(width: 8),
                        Text(
                          'PREMIUM',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'ACTIF',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Expire le',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '15 Janvier 2025',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildFeatureChip('Toutes branches'),
                        const SizedBox(width: 8),
                        _buildFeatureChip('Sessions illimitées'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Features included
            Text(
              'Avantages inclus',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: textColor),
            ),
            const SizedBox(height: 12),
            _buildFeatureRow(
              context,
              Icons.check_circle,
              'Accès à toutes les branches',
              true,
              textColor,
            ),
            _buildFeatureRow(
              context,
              Icons.check_circle,
              'Cours collectifs illimités',
              true,
              textColor,
            ),
            _buildFeatureRow(
              context,
              Icons.check_circle,
              '2 sessions privées/mois',
              true,
              textColor,
            ),
            _buildFeatureRow(
              context,
              Icons.check_circle,
              'Accès à l\'espace VIP',
              true,
              textColor,
            ),
            _buildFeatureRow(
              context,
              Icons.check_circle,
              'Programmes personnalisés',
              true,
              textColor,
            ),
            _buildFeatureRow(
              context,
              Icons.check_circle,
              '10% sur les suppléments',
              true,
              textColor,
            ),
            const SizedBox(height: 24),

            // Payment history
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Historique paiements',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: textColor),
                ),
                TextButton(onPressed: () {}, child: const Text('Voir tout')),
              ],
            ),
            const SizedBox(height: 8),
            _buildPaymentTile(
              context,
              '15 Oct 2024',
              '15,000 DZD',
              'eDahabia',
              'Validé',
              cardColor,
              textColor,
              subTextColor,
            ),
            _buildPaymentTile(
              context,
              '15 Sep 2024',
              '15,000 DZD',
              'CIB',
              'Validé',
              cardColor,
              textColor,
              subTextColor,
            ),
            _buildPaymentTile(
              context,
              '15 Aoû 2024',
              '15,000 DZD',
              'Cash',
              'Validé',
              cardColor,
              textColor,
              subTextColor,
            ),
            const SizedBox(height: 24),

            // Renew button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  _showRenewDialog(context);
                },
                child: const Text('Renouveler mon abonnement'),
              ),
            ),
            const SizedBox(height: 16),

            // Cancel subscription
            Center(
              child: TextButton(
                onPressed: () {
                  // Show cancel confirmation
                },
                child: Text(
                  'Annuler mon abonnement',
                  style: TextStyle(
                    color: isDark ? Colors.grey : Colors.grey[700],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  Widget _buildFeatureRow(
    BuildContext context,
    IconData icon,
    String text,
    bool included,
    Color textColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: included ? Colors.green : Colors.grey, size: 20),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(color: included ? textColor : Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentTile(
    BuildContext context,
    String date,
    String amount,
    String method,
    String status,
    Color? cardColor,
    Color textColor,
    Color subTextColor,
  ) {
    return Card(
      color: cardColor,
      margin: const EdgeInsets.only(bottom: 8),
      elevation: Theme.of(context).brightness == Brightness.light ? 2 : 1,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.withValues(alpha: 0.1),
          child: const Icon(Icons.check, color: Colors.green),
        ),
        title: Text(
          amount,
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '$date • $method',
          style: TextStyle(color: subTextColor),
        ),
        trailing: Text(
          status,
          style: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showRenewDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choisir la durée',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            _buildPlanOption(context, 'Mensuel', '15,000 DZD/mois', false),
            _buildPlanOption(
              context,
              'Trimestriel',
              '12,500 DZD/mois',
              true,
              savings: '17%',
            ),
            _buildPlanOption(
              context,
              'Annuel',
              '10,000 DZD/mois',
              false,
              savings: '33%',
            ),
            const SizedBox(height: 24),
            Text(
              'Méthode de paiement',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: Image.asset(
                    'assets/images/icone-dahabia.png',
                    height: 20,
                  ),
                  selected: true,
                  onSelected: (_) {},
                  backgroundColor: Colors.white,
                  selectedColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                ),
                ChoiceChip(
                  label: Image.asset('assets/images/icone-cib.png', height: 20),
                  selected: false,
                  onSelected: (_) {},
                  backgroundColor: Colors.white,
                  selectedColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                ),
                ChoiceChip(
                  label: const Text('Cash'),
                  selected: false,
                  onSelected: (_) {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Demande de renouvellement envoyée!'),
                    ),
                  );
                },
                child: const Text('Continuer vers le paiement'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanOption(
    BuildContext context,
    String title,
    String price,
    bool recommended, {
    String? savings,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: recommended
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).brightness == Brightness.dark
              ? Colors.grey.shade800
              : Colors.grey.shade300,
          width: recommended ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: RadioListTile(
        value: title,
        // ignore: deprecated_member_use
        groupValue: recommended ? title : null,
        // ignore: deprecated_member_use
        onChanged: (_) {},
        title: Row(
          children: [
            Text(title),
            if (savings != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '-$savings',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        subtitle: Text(price),
        secondary: recommended
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Recommandé',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              )
            : null,
      ),
    );
  }
}
