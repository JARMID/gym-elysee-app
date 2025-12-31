import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/sparring_repository.dart';
import '../../data/models/member_model.dart';

import 'branch_provider.dart';

// Repository Provider
final sparringRepositoryProvider = Provider<SparringRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return SparringRepository(apiService);
});

// Partner Filters Provider
class PartnerFilters {
  final int? branchId;
  final String? discipline;
  final String? level;

  PartnerFilters({this.branchId, this.discipline, this.level});
}

final partnerFiltersProvider = StateProvider<PartnerFilters>(
  (ref) => PartnerFilters(),
);

// Partners List Provider
final sparringPartnersProvider = FutureProvider.autoDispose<List<MemberModel>>((
  ref,
) async {
  final repository = ref.watch(sparringRepositoryProvider);
  final filters = ref.watch(partnerFiltersProvider);

  return repository.findPartners(
    branchId: filters.branchId,
    discipline: filters.discipline,
    level: filters.level,
  );
});

// Sparring Controller (for actions)
final sparringControllerProvider =
    StateNotifierProvider<SparringController, AsyncValue<void>>((ref) {
      return SparringController(ref);
    });

class SparringController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  SparringController(this.ref) : super(const AsyncData(null));

  Future<void> createRequest({
    required int requestedId,
    required int branchId,
    String? discipline,
    DateTime? proposedTime,
    String? message,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(sparringRepositoryProvider)
          .createRequest(
            requestedId: requestedId,
            branchId: branchId,
            discipline: discipline,
            proposedTime: proposedTime,
            message: message,
          );
    });
  }

  Future<void> respondToRequest(int requestId, String action) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(sparringRepositoryProvider)
          .respondToRequest(requestId, action);
    });
  }
}
