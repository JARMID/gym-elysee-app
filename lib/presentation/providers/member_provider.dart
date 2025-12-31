import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/member_repository.dart';
import 'branch_provider.dart'; // Contains apiServiceProvider and storageServiceProvider

// Let's assume there is a way to get ApiService.
// Step 4066 suggests `main.dart` handles it.
// Ideally, `memberRepositoryProvider` should just depend on `ref`.

final memberRepositoryProvider = Provider<MemberRepository>((ref) {
  // Use the global apiServiceProvider if available, or create one.
  // Assuming apiServiceProvider and storageServiceProvider are available via import
  final apiService = ref.watch(apiServiceProvider);
  return MemberRepository(apiService);
});

final memberDashboardProvider = FutureProvider<Map<String, dynamic>>((
  ref,
) async {
  return ref.read(memberRepositoryProvider).getDashboard();
});
