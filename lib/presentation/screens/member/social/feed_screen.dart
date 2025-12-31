import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:gyelyseedz/presentation/providers/auth_provider.dart';
import '../../../../presentation/providers/social_provider.dart';
import '../../../../data/repositories/social_repository.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  final TextEditingController _postController = TextEditingController();
  String _selectedType = 'achievement';

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  Future<void> _refreshFeed() async {
    // Invalidate provider to trigger refresh
    ref.invalidate(feedProvider);
  }

  Future<void> _createPost() async {
    if (_postController.text.trim().isEmpty) return;

    try {
      final repository = ref.read(socialRepositoryProvider);
      await repository.createPost(
        content: _postController.text,
        type: _selectedType,
      );

      if (!mounted) return;
      Navigator.pop(context); // Close sheet

      _postController.clear();
      _refreshFeed(); // Refresh feed

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Post publié avec succès!')));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('fr', timeago.FrMessages());
    final feedAsync = ref.watch(feedProvider);
    final user = ref.watch(authNotifierProvider).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Communauté'),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshFeed,
        child: CustomScrollView(
          slivers: [
            // Create post section
            SliverToBoxAdapter(
              child: Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        backgroundImage: user?.photo != null
                            ? NetworkImage(user!.photo!)
                            : null,
                        child: user?.photo == null
                            ? const Icon(Icons.person, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _showCreatePostSheet(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: const Text(
                              'Partager une victoire...',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Filters (Visual only for now, could be connected to API)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChip(
                        label: const Text('Tous'),
                        selected: true,
                        onSelected: (_) {},
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('Victoires'),
                        selected: false,
                        onSelected: (_) {},
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('Progrès'),
                        selected: false,
                        onSelected: (_) {},
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Feed Content
            feedAsync.when(
              data: (posts) {
                if (posts.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: Text('Aucun post pour le moment')),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final post = posts[index];
                    return _buildPostCard(post, user?.id ?? 0);
                  }, childCount: posts.length),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) => SliverFillRemaining(
                child: Center(child: Text('Erreur de chargement de flux')),
              ),
            ),

            // Bottom padding
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> apiPost, int currentUserId) {
    // Map API data to UI
    final userObj = apiPost['user'] ?? {};
    final userName =
        '${userObj['first_name'] ?? ''} ${userObj['last_name'] ?? ''}'.trim();
    final userPhoto = userObj['photo'];
    final content = apiPost['content'] ?? '';
    final type = apiPost['type'] ?? 'post';
    final createdAt =
        DateTime.tryParse(apiPost['created_at'] ?? '') ?? DateTime.now();
    var likesCount = apiPost['likes_count'] ?? 0;
    final commentsCount = apiPost['comments_count'] ?? 0;

    // Check if liked by current user
    final List<dynamic> likes = apiPost['likes'] ?? [];
    bool isLiked = likes.any((l) => l['user_id'] == currentUserId);

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  backgroundImage: userPhoto != null
                      ? CachedNetworkImageProvider(userPhoto)
                      : null,
                  child: userPhoto == null
                      ? Text(userName.isNotEmpty ? userName[0] : '?')
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        timeago.format(createdAt, locale: 'fr'),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildTypeBadge(type),
              ],
            ),
            const SizedBox(height: 12),

            // Content
            Text(content, style: const TextStyle(height: 1.5)),
            const SizedBox(height: 16),

            // Actions
            Row(
              children: [
                // Like button
                StatefulBuilder(
                  builder: (context, setState) {
                    return InkWell(
                      onTap: () async {
                        // Optimistic UI update
                        setState(() {
                          isLiked = !isLiked;
                          likesCount += isLiked ? 1 : -1;
                        });
                        try {
                          final repo = ref.read(socialRepositoryProvider);
                          await repo.toggleLike(apiPost['id']);
                        } catch (e) {
                          // Revert on error
                          setState(() {
                            isLiked = !isLiked;
                            likesCount += isLiked ? 1 : -1;
                          });
                        }
                      },
                      child: Row(
                        children: [
                          Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? Colors.red : Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$likesCount',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(width: 24),
                // Comment button
                InkWell(
                  onTap: () => _showCommentsSheet(apiPost['id'], commentsCount),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.comment_outlined,
                        color: Colors.grey,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$commentsCount',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                    Icons.share_outlined,
                    color: Colors.grey,
                    size: 20,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeBadge(String type) {
    IconData icon;
    Color color;
    String label;

    switch (type) {
      case 'achievement':
        icon = Icons.emoji_events;
        color = Colors.amber;
        label = 'Victoire';
        break;
      case 'progress':
        icon = Icons.trending_up;
        color = Colors.green;
        label = 'Progrès';
        break;
      case 'motivation':
        icon = Icons.lightbulb;
        color = Colors.blue;
        label = 'Conseil';
        break;
      default:
        icon = Icons.article;
        color = Colors.grey;
        label = 'Post';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }

  void _showCreatePostSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Nouveau post',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _postController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Partage ta victoire, ton progrès ou un conseil...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Type de post',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('🏆 Victoire'),
                    selected: _selectedType == 'achievement',
                    onSelected: (selected) {
                      if (selected) {
                        setSheetState(() => _selectedType = 'achievement');
                      }
                    },
                  ),
                  ChoiceChip(
                    label: const Text('📈 Progrès'),
                    selected: _selectedType == 'progress',
                    onSelected: (selected) {
                      if (selected) {
                        setSheetState(() => _selectedType = 'progress');
                      }
                    },
                  ),
                  ChoiceChip(
                    label: const Text('💡 Conseil'),
                    selected: _selectedType == 'motivation',
                    onSelected: (selected) {
                      if (selected) {
                        setSheetState(() => _selectedType = 'motivation');
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _createPost,
                    child: const Text('Publier'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showCommentsSheet(int postId, int commentCount) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) =>
          _CommentsSheet(postId: postId, initialCount: commentCount),
    );
  }
}

class _CommentsSheet extends ConsumerStatefulWidget {
  final int postId;
  final int initialCount;

  const _CommentsSheet({required this.postId, required this.initialCount});

  @override
  ConsumerState<_CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends ConsumerState<_CommentsSheet> {
  final TextEditingController _commentController = TextEditingController();

  Future<void> _submitComment() async {
    if (_commentController.text.trim().isEmpty) return;
    try {
      final repo = ref.read(socialRepositoryProvider);
      await repo.addComment(widget.postId, _commentController.text);
      _commentController.clear();
      ref.invalidate(commentsProvider(widget.postId)); // Refresh comments
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    final commentsAsync = ref.watch(commentsProvider(widget.postId));

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Commentaires',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Expanded(
            child: commentsAsync.when(
              data: (comments) {
                if (comments.isEmpty) {
                  return const Center(
                    child: Text('Soyez le premier à commenter!'),
                  );
                }
                return ListView.builder(
                  controller: scrollController,
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    final user = comment['user'] ?? {};
                    final userName =
                        '${user['first_name'] ?? ''} ${user['last_name'] ?? ''}';
                    return ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(userName),
                      subtitle: Text(comment['content'] ?? ''),
                      trailing: Text(
                        timeago.format(
                          DateTime.tryParse(comment['created_at'] ?? '') ??
                              DateTime.now(),
                          locale: 'fr',
                        ),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Erreur: $e')),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              left: 16,
              right: 16,
            ),
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Ajouter un commentaire...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _submitComment,
                ),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
