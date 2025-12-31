import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/dio_provider.dart';

final messageRepositoryProvider = Provider<MessageRepository>((ref) {
  return MessageRepository(ref.watch(dioProvider));
});

class MessageRepository {
  final Dio _dio;

  MessageRepository(this._dio);

  Future<List<Map<String, dynamic>>> getConversations() async {
    try {
      final response = await _dio.get('/messages');
      // Returns list of { partner: ..., last_message_at: ..., unread_count: ... }
      final data = response.data as List<dynamic>? ?? [];
      return data.map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      // ignore: avoid_print
      print('Message Conversations API Error: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getThread(int userId) async {
    try {
      final response = await _dio.get('/messages/$userId');
      // Returns paginated response: { data: [...], ... }
      final data = response.data['data'] as List<dynamic>? ?? [];
      return data.map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      // ignore: avoid_print
      print('Message Thread API Error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> sendMessage(int userId, String content) async {
    try {
      final response = await _dio.post(
        '/messages',
        data: {'receiver_id': userId, 'content': content},
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      // ignore: avoid_print
      print('Send Message API Error: $e');
      rethrow;
    }
  }
}
