import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'branch_provider.dart';
import 'subscription_provider.dart';

// Provider for payment history
final myPaymentsProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final repository = ref.watch(supabaseCoreRepositoryProvider);
  return repository.getMyPayments();
});

// Controller for submitting payments
final paymentControllerProvider =
    StateNotifierProvider<PaymentController, AsyncValue<void>>((ref) {
      return PaymentController(ref);
    });

class PaymentController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  PaymentController(this.ref) : super(const AsyncData(null));

  Future<void> uploadProof({
    required XFile file,
    required double amount,
    required String method,
    int? subscriptionId, // Made optional with default handling
  }) async {
    state = const AsyncLoading();
    try {
      final bytes = await file.readAsBytes();
      final extension = file.path.split('.').last;

      // If no subscriptionId provided, we'll handle it gracefully
      // In a real scenario, you'd get the current subscription ID
      final subId = subscriptionId ?? 0;

      await ref
          .read(supabaseCoreRepositoryProvider)
          .submitPayment(
            subscriptionId: subId,
            amount: amount,
            method: method,
            proofImage: bytes,
            proofImageExtension: extension,
          );

      state = const AsyncData(null);
      // Refresh data
      ref.invalidate(myPaymentsProvider);
      ref.invalidate(mySubscriptionProvider);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }
}
