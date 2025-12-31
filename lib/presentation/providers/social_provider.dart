import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/social_repository.dart';

// Feed Provider
final feedProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((
  ref,
) async {
  final repository = ref.watch(socialRepositoryProvider);
  return repository.getFeed();
});

// Comments Provider (Family)
final commentsProvider = FutureProvider.family
    .autoDispose<List<Map<String, dynamic>>, int>((ref, postId) async {
      final repository = ref.watch(socialRepositoryProvider);
      return repository.getComments(postId);
    });
