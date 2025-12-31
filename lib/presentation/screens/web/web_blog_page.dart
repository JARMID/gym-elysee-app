import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:gyelyseedz/l10n/app_localizations.dart';

import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/web/web_nav_bar.dart';
import '../../widgets/web/web_footer.dart';

class WebBlogPage extends ConsumerWidget {
  const WebBlogPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRamadanMode = ref.watch(ramadanModeProvider);
    final l10n = AppLocalizations.of(context)!;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: isRamadanMode ? 130 : 80),
                FadeInDown(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 80),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black,
                          isDark ? AppColors.darkBackground : Colors.grey[100]!,
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        ShaderMask(
                          blendMode: BlendMode.srcIn,
                          shaderCallback: (bounds) =>
                              AppColors.fieryGradient.createShader(bounds),
                          child: Text(
                            l10n.blogTitle,
                            style: GoogleFonts.oswald(
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: AppColors.brandOrange.withValues(
                                    alpha: 0.5,
                                  ),
                                  blurRadius: 30,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.blogSubtitle,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 40,
                          mainAxisSpacing: 40,
                          childAspectRatio: 0.8,
                        ),
                    itemCount: 6,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return FadeInUp(
                        delay: Duration(milliseconds: index * 100),
                        child: _buildBlogCard(context, index, l10n),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 100),
                const WebFooter(),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: WebNavBar(isScrolled: true, activeRoute: AppRoutes.webBlog),
          ),
        ],
      ),
    );
  }

  Widget _buildBlogCard(
    BuildContext context,
    int index,
    AppLocalizations l10n,
  ) {
    return _BlogCard(
      index: index,
      l10n: l10n,
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => _ArticleDialog(
            title: l10n.dummyArticleTitle,
            category: l10n.dummyArticleCategory,
            imageIndex: index,
            content: l10n.dummyArticleContent,
          ),
        );
      },
    );
  }
}

class _BlogCard extends StatefulWidget {
  final int index;
  final VoidCallback onTap;
  final AppLocalizations l10n;

  const _BlogCard({
    required this.index,
    required this.onTap,
    required this.l10n,
  });

  @override
  State<_BlogCard> createState() => _BlogCardState();
}

class _BlogCardState extends State<_BlogCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()
            // ignore: deprecated_member_use
            ..scale(_isHovered ? 1.05 : 1.0, _isHovered ? 1.05 : 1.0),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF151515) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHovered
                  ? AppColors.brandOrange.withValues(alpha: 0.5)
                  : (isDark
                        ? Colors.white10
                        : Colors.grey.withValues(alpha: 0.2)),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: _isHovered ? 20 : 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=800',
                    ), // Placeholder
                    fit: BoxFit.cover,
                    opacity: 0.6,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.article,
                    color: Colors.white.withValues(alpha: 0.2),
                    size: 50,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.l10n.blogTagTraining,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.brandOrange, // Updated to Orange
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.l10n.dummyArticleTitle,
                      style: GoogleFonts.oswald(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          widget.l10n.blogReadArticle,
                          style: GoogleFonts.inter(
                            color: _isHovered
                                ? AppColors.brandOrange
                                : (isDark ? Colors.white70 : Colors.black54),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward,
                          size: 16,
                          color: _isHovered
                              ? AppColors.brandOrange
                              : Colors.white70, // Updated to Orange
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArticleDialog extends StatelessWidget {
  final String title;
  final String category;
  final int imageIndex;
  final String content;

  const _ArticleDialog({
    required this.title,
    required this.category,
    required this.imageIndex,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.cardDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/program_1.jpg'),
                    fit: BoxFit.cover,
                    opacity: 0.7,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 16,
                      right: 16,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, color: Colors.white),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category,
                      style: GoogleFonts.inter(
                        color: AppColors.brandOrange,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      title,
                      style: GoogleFonts.oswald(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      content,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        color: Colors.grey[300],
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
