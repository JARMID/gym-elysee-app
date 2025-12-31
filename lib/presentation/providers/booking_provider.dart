import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/booking_repository.dart';

final sessionsProvider =
    FutureProvider.family<List<Map<String, dynamic>>, DateTime>((
      ref,
      date,
    ) async {
      final repository = ref.watch(bookingRepositoryProvider);
      return repository.getAvailableSessions(date);
    });

final myBookingsProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final repository = ref.watch(bookingRepositoryProvider);
  return repository.getMyBookings();
});
