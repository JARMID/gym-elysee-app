import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/message_repository.dart';

// Conversations Provider
final conversationsProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
      final repository = ref.watch(messageRepositoryProvider);
      return repository.getConversations();
    });

// Thread Provider (Family)
final threadProvider = FutureProvider.family
    .autoDispose<List<Map<String, dynamic>>, int>((ref, partnerId) async {
      final repository = ref.watch(messageRepositoryProvider);
      return repository.getThread(partnerId);
    });
