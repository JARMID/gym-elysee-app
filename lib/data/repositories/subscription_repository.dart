import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/dio_provider.dart';

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  return SubscriptionRepository(ref.watch(dioProvider));
});

class SubscriptionRepository {
  final Dio _dio;

  SubscriptionRepository(this._dio);

  Future<Map<String, dynamic>> getMySubscription() async {
    try {
      final response = await _dio.get('/member/subscription');

      // Backend returns { subscription: {...}, subscription_status: ... }
      final data = response.data;
      final subscription = data['subscription'] as Map<String, dynamic>?;
      final status = data['subscription_status'] as String?;

      if (subscription == null) {
        return {
          'status': status ?? 'inactive',
          'endDate': DateTime.now().toIso8601String(), // Fallback
          'amountDue': 0,
          'daysLeft': 0,
        };
      }

      // Calculate derived fields if missing
      final endDateStr = subscription['end_date'];
      final endDate = DateTime.tryParse(endDateStr) ?? DateTime.now();
      final daysLeft = endDate.difference(DateTime.now()).inDays;

      // Map to UI model
      return {
        'status': status,
        'endDate': endDateStr,
        'amountDue':
            subscription['remaining_amount'] ??
            0, // specific field check needed
        'daysLeft': daysLeft > 0 ? daysLeft : 0,
        ...subscription,
      };
    } catch (e) {
      // ignore: avoid_print
      print('Subscription API Error: $e');
      rethrow;
    }
  }
}
