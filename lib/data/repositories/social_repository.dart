import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/dio_provider.dart';

final socialRepositoryProvider = Provider<SocialRepository>((ref) {
  return SocialRepository(ref.watch(dioProvider));
});

class SocialRepository {
  final Dio _dio;

  SocialRepository(this._dio);

  Future<List<Map<String, dynamic>>> getFeed({int page = 1}) async {
    try {
      final response = await _dio.get('/feed', queryParameters: {'page': page});

      final data = response.data['data'] as List<dynamic>? ?? [];
      return data.map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      // ignore: avoid_print
      print('Social Feed API Error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createPost({
    required String content,
    String? type,
  }) async {
    try {
      final response = await _dio.post(
        '/posts',
        data: {'content': content, 'type': type ?? 'progress'},
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      // ignore: avoid_print
      print('Create Post API Error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> toggleLike(int postId) async {
    try {
      final response = await _dio.post('/posts/$postId/like');
      return response.data as Map<String, dynamic>;
    } catch (e) {
      // ignore: avoid_print
      print('Toggle Like API Error: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getComments(int postId) async {
    try {
      final response = await _dio.get('/posts/$postId/comments');
      // Comments endpoint returns a direct list, not wrapped in data for get()
      final data = response.data as List<dynamic>? ?? [];
      return data.map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      // ignore: avoid_print
      print('Get Comments API Error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> addComment(int postId, String content) async {
    try {
      final response = await _dio.post(
        '/posts/$postId/comments',
        data: {'content': content},
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      // ignore: avoid_print
      print('Add Comment API Error: $e');
      rethrow;
    }
  }
}
