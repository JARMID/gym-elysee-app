import 'package:dio/dio.dart';
import '../../core/network/dio_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  return BookingRepository(ref.watch(dioProvider));
});

class BookingRepository {
  final Dio _dio;

  BookingRepository(this._dio);

  Future<List<Map<String, dynamic>>> getAvailableSessions(DateTime date) async {
    try {
      final formattedDate = date.toIso8601String().split('T')[0];
      final response = await _dio.get(
        '/bookings/available',
        queryParameters: {
          'date': formattedDate,
          'branch_id': 1, // TODO: Get actual branch ID
        },
      );

      // API returns List<dynamic> directly
      final List<dynamic> data = response.data ?? [];
      return data.map((json) => json as Map<String, dynamic>).toList();
    } catch (e) {
      // ignore: avoid_print
      print('Booking API Error: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getMyBookings() async {
    try {
      final response = await _dio.get('/member/bookings');
      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => json as Map<String, dynamic>).toList();
    } catch (e) {
      // ignore: avoid_print
      print('My Bookings API Error: $e');
      rethrow;
    }
  }

  Future<void> bookSession(int sessionId) async {
    try {
      await _dio.post('/bookings', data: {'session_id': sessionId});
    } catch (e) {
      // ignore: avoid_print
      print('Book Session API Error: $e');
      rethrow;
    }
  }
}
