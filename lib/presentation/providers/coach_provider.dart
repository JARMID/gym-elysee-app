import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/coach_repository.dart';
import '../../data/models/member_model.dart';
import '../../data/models/program_model.dart';
import 'branch_provider.dart'; // For apiServiceProvider

// Repository provider
final coachRepositoryProvider = Provider<CoachRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return CoachRepository(apiService);
});

// Dashboard provider
final coachDashboardProvider = FutureProvider.autoDispose<Map<String, dynamic>>(
  (ref) async {
    final repo = ref.watch(coachRepositoryProvider);
    return repo.getDashboard();
  },
);

// Squad provider
final coachSquadProvider = FutureProvider.autoDispose<List<MemberModel>>((
  ref,
) async {
  final repo = ref.watch(coachRepositoryProvider);
  return repo.getSquad();
});

// Programs provider
final coachProgramsProvider = FutureProvider.autoDispose<List<ProgramModel>>((
  ref,
) async {
  final repo = ref.watch(coachRepositoryProvider);
  return repo.getPrograms();
});

// Bookings provider
final coachBookingsProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>, String?>((ref, status) async {
      final repo = ref.watch(coachRepositoryProvider);
      return repo.getBookings(status: status);
    });

// Schedule provider
final coachScheduleProvider = FutureProvider.autoDispose<Map<String, dynamic>>((
  ref,
) async {
  final repo = ref.watch(coachRepositoryProvider);
  return repo.getSchedule();
});

// Controller for actions
final coachControllerProvider =
    StateNotifierProvider<CoachController, AsyncValue<void>>((ref) {
      return CoachController(ref);
    });

class CoachController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  CoachController(this.ref) : super(const AsyncData(null));

  Future<void> createProgram(Map<String, dynamic> data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(coachRepositoryProvider).createProgram(data);
      ref.invalidate(coachProgramsProvider);
    });
  }

  Future<void> updateProgram(int programId, Map<String, dynamic> data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(coachRepositoryProvider).updateProgram(programId, data);
      ref.invalidate(coachProgramsProvider);
    });
  }

  Future<void> deleteProgram(int programId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(coachRepositoryProvider).deleteProgram(programId);
      ref.invalidate(coachProgramsProvider);
    });
  }

  Future<void> updateBooking(
    int bookingId,
    String status, {
    String? notes,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(coachRepositoryProvider)
          .updateBooking(bookingId, status: status, notes: notes);
      ref.invalidate(coachBookingsProvider);
      ref.invalidate(coachScheduleProvider);
      ref.invalidate(coachDashboardProvider);
    });
  }
}
