import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/supabase_core_repository.dart';
import 'branch_provider.dart'; // Pour utiliser supabaseCoreRepositoryProvider

// Provider for current user's subscription (now uses Supabase)
final mySubscriptionProvider = FutureProvider<Map<String, dynamic>?>((
  ref,
) async {
  final repository = ref.watch(supabaseCoreRepositoryProvider);
  return repository.getMySubscription();
});

// Controller for subscribing to a plan
final subscribeControllerProvider =
    StateNotifierProvider<SubscribeController, AsyncValue<void>>((ref) {
      return SubscribeController(
        ref.watch(supabaseCoreRepositoryProvider),
        ref,
      );
    });

class SubscribeController extends StateNotifier<AsyncValue<void>> {
  final SupabaseCoreRepository _repository;
  final Ref _ref;

  SubscribeController(this._repository, this._ref)
    : super(const AsyncValue.data(null));

  Future<void> subscribe(int planId, {String paymentMethod = 'cash'}) async {
    state = const AsyncValue.loading();
    try {
      await _repository.subscribe(planId, paymentMethod: paymentMethod);
      state = const AsyncValue.data(null);
      // Refresh subscription data
      _ref.invalidate(mySubscriptionProvider);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
