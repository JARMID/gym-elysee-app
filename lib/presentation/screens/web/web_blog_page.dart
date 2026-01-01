import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:gyelyseedz/l10n/app_localizations.dart';

import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/web/web_page_shell.dart';
import '../../widgets/web/web_page_header.dart';
import '../../widgets/mobile/mobile_page_wrapper.dart';

class WebBlogPage extends StatelessWidget {
  final bool useMobileWrapper;
  const WebBlogPage({super.key, this.useMobileWrapper = false});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    final content = Column(
      children: [
        // Unified Header
        // Unified Header
        WebPageHeader(title: l10n.blogTitle, subtitle: l10n.blogSubtitle),

        // Blog Grid
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 100),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 1 : 3,
              crossAxisSpacing: isMobile ? 0 : 40,
              mainAxisSpacing: isMobile ? 20 : 40,
              childAspectRatio: isMobile ? 0.85 : 0.8,
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
        SizedBox(height: isMobile ? 40 : 100),
      ],
    );

    if (useMobileWrapper) {
      return MobilePageWrapper(
        title: l10n.navBlog.toUpperCase(),
        showBackButton: true,
        child: SingleChildScrollView(child: content),
      );
    }

    return WebPageShell(activeRoute: AppRoutes.webBlog, child: content);
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
                    ),
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
                padding: const EdgeInsets.all(16), // Reduced padding from 24
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.l10n.blogTagTraining,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.brandOrange,
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
                              : Colors.white70,
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
    final isMobile = MediaQuery.of(context).size.width < 600;

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
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800',
                    ),
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
                padding: EdgeInsets.all(isMobile ? 24 : 40),
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
                        fontSize: isMobile ? 32 : 40,
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
