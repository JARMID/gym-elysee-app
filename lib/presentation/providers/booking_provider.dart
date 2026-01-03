import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/supabase_core_repository.dart';
import 'branch_provider.dart'; // Pour utiliser supabaseCoreRepositoryProvider

// Provider for available sessions on a given date
// Note: This may need a different implementation if session scheduling is complex
final sessionsProvider =
    FutureProvider.family<List<Map<String, dynamic>>, DateTime>((
      ref,
      date,
    ) async {
      // For now, return empty list - sessions feature needs program schedule data
      // TODO: Implement session scheduling based on program data
      return [];
    });

// Provider for user's bookings (now uses Supabase)
final myBookingsProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final repository = ref.watch(supabaseCoreRepositoryProvider);
  return repository.getMyBookings();
});

// Controller for canceling bookings
final cancelBookingControllerProvider =
    StateNotifierProvider<CancelBookingController, AsyncValue<void>>((ref) {
      return CancelBookingController(
        ref.watch(supabaseCoreRepositoryProvider),
        ref,
      );
    });

class CancelBookingController extends StateNotifier<AsyncValue<void>> {
  final SupabaseCoreRepository _repository;
  final Ref _ref;

  CancelBookingController(this._repository, this._ref)
    : super(const AsyncValue.data(null));

  Future<void> cancel(int bookingId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.cancelBooking(bookingId);
      state = const AsyncValue.data(null);
      // Refresh bookings
      _ref.invalidate(myBookingsProvider);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
