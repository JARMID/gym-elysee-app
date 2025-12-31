import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:gyelyseedz/l10n/app_localizations.dart';
import '../../../../presentation/providers/booking_provider.dart';

class MyBookingsScreen extends ConsumerWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final myBookingsAsync = ref.watch(myBookingsProvider);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.bookingMyBookings),
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.bookingTabUpcoming),
              Tab(text: l10n.bookingTabPast),
              Tab(text: l10n.bookingTabCancelled),
            ],
          ),
        ),
        body: myBookingsAsync.when(
          data: (bookings) {
            final upcoming = bookings; // TODO: Filter by date/status
            // For now just show all in upcoming for demo

            return TabBarView(
              children: [
                // Upcoming
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: upcoming.length,
                  itemBuilder: (context, index) =>
                      _buildBookingCard(context, upcoming[index]),
                ),
                // Past
                Center(child: Text(l10n.bookingEmptyPast)),
                // Cancelled
                Center(child: Text(l10n.bookingEmptyCancelled)),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context, Map<String, dynamic> booking) {
    final l10n = AppLocalizations.of(context)!;
    final date = booking['date'] as DateTime;
    final isPending = booking['status'] == 'pending';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    booking['title'],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isPending
                        ? Colors.orange.withValues(alpha: 0.2)
                        : Colors.green.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isPending
                        ? l10n.bookingStatusPending
                        : l10n.bookingStatusConfirmed,
                    style: TextStyle(
                      fontSize: 12,
                      color: isPending ? Colors.orange : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(DateFormat('EEEE d MMMM', 'fr_FR').format(date)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(booking['time']),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(booking['coach']),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    // Cancel booking
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(l10n.bookingCancelTitle),
                        content: Text(l10n.bookingCancelContent),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(l10n.dashboardCancel),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l10n.bookingCancelled)),
                              );
                            },
                            child: Text(
                              l10n.dashboardCancel,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text(
                    l10n.bookingCancelTitle,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
