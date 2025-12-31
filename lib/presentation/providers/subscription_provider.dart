import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/subscription_repository.dart';

final mySubscriptionProvider = FutureProvider<Map<String, dynamic>>((
  ref,
) async {
  final repository = ref.watch(subscriptionRepositoryProvider);
  return repository.getMySubscription();
});
