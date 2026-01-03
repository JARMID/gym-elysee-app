import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/dio_provider.dart';
import '../../data/repositories/landing_repository.dart';
import '../../data/models/branch_model.dart';
import 'branch_provider.dart'; // For supabaseCoreRepositoryProvider

final landingRepositoryProvider = Provider<LandingRepository>((ref) {
  final dio = ref.read(dioProvider);
  return LandingRepository(dio);
});

final branchesProvider = FutureProvider<List<BranchModel>>((ref) async {
  // Switched to Supabase
  final repo = ref.watch(supabaseCoreRepositoryProvider);
  return repo.getBranches();
});

// State provider for Ramadan mode
// export 'theme_provider.dart' show ramadanModeProvider; // Moved to top

final featuredCoachesProvider = FutureProvider<List<dynamic>>((ref) async {
  return ref.read(landingRepositoryProvider).getFeaturedCoaches();
});

final membershipPlansProvider = FutureProvider<List<dynamic>>((ref) async {
  // Switched to Supabase
  final repo = ref.watch(supabaseCoreRepositoryProvider);
  return repo.getMembershipPlans();
});
