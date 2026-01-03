import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/supabase_core_repository.dart';
import 'branch_provider.dart';

// Feed Provider (now uses Supabase)
final feedProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((
  ref,
) async {
  final repository = ref.watch(supabaseCoreRepositoryProvider);
  return repository.getFeedPosts();
});

// Real-time feed stream
final feedStreamProvider =
    StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
      final repository = ref.watch(supabaseCoreRepositoryProvider);
      return repository.streamFeedPosts();
    });

// Comments Provider (Family)
final commentsProvider = FutureProvider.family
    .autoDispose<List<Map<String, dynamic>>, int>((ref, postId) async {
      final repository = ref.watch(supabaseCoreRepositoryProvider);
      return repository.getComments(postId);
    });

// Controller for social actions (like, comment, post)
final socialControllerProvider =
    StateNotifierProvider<SocialController, AsyncValue<void>>((ref) {
      return SocialController(ref.watch(supabaseCoreRepositoryProvider), ref);
    });

class SocialController extends StateNotifier<AsyncValue<void>> {
  final SupabaseCoreRepository _repository;
  final Ref _ref;

  SocialController(this._repository, this._ref)
    : super(const AsyncValue.data(null));

  Future<void> toggleLike(int postId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.toggleLike(postId);
      state = const AsyncValue.data(null);
      _ref.invalidate(feedProvider);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addComment(int postId, String content) async {
    state = const AsyncValue.loading();
    try {
      await _repository.addComment(postId, content);
      state = const AsyncValue.data(null);
      _ref.invalidate(commentsProvider(postId));
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> createPost(String content, {String? imageUrl}) async {
    state = const AsyncValue.loading();
    try {
      await _repository.createPost(content: content, imageUrl: imageUrl);
      state = const AsyncValue.data(null);
      _ref.invalidate(feedProvider);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
