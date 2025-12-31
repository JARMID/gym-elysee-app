import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/repositories/payment_repository.dart';
import 'branch_provider.dart';

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return PaymentRepository(apiService);
});

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
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(paymentRepositoryProvider)
          .uploadPaymentProof(proofFile: file, amount: amount, method: method),
    );
  }
}
