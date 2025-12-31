import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gyelyseedz/l10n/app_localizations.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';

class WebBlogPreviewSection extends StatelessWidget {
  const WebBlogPreviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      color: isDark ? const Color(0xFF0A0A0A) : Colors.grey[100],
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 2,
                        decoration: BoxDecoration(
                          gradient: AppColors.fieryGradient,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        l10n.blogPreviewTag,
                        style: GoogleFonts.inter(
                          color: AppColors.brandYellow,
                          letterSpacing: 3,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) =>
                        AppColors.fieryGradient.createShader(bounds),
                    child: Text(
                      l10n.blogPreviewTitle,
                      style: GoogleFonts.oswald(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              OutlinedButton(
                onPressed: () => context.go(AppRoutes.webBlog),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.brandYellow,
                  side: BorderSide(
                    color: AppColors.brandYellow.withValues(alpha: 0.5),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.blogPreviewViewAll,
                      style: GoogleFonts.oswald(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, size: 16),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),
          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 900;
              if (isDesktop) {
                return Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildBlogCard(
                        context,
                        title: l10n.blogDummy1Title,
                        category: l10n.blogDummy1Cat,
                        image:
                            'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=800&fit=crop',
                        readMore: l10n.blogReadMore,
                        isLarge: true,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        children: [
                          _buildBlogCard(
                            context,
                            title: l10n.blogDummy2Title,
                            category: l10n.blogDummy2Cat,
                            image:
                                'https://images.unsplash.com/photo-1605296867304-46d5465a13f1?w=800&fit=crop',
                            readMore: l10n.blogReadMore,
                          ),
                          const SizedBox(height: 24),
                          _buildBlogCard(
                            context,
                            title: l10n.blogDummy3Title,
                            category: l10n.blogDummy3Cat,
                            image:
                                'https://images.unsplash.com/photo-1599901860904-17e6ed7083a0?w=800&fit=crop',
                            readMore: l10n.blogReadMore,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildBlogCard(
                      context,
                      title: l10n.blogDummy1Title,
                      category: l10n.blogDummy1Cat,
                      image:
                          'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=800&fit=crop',
                      readMore: l10n.blogReadMore,
                    ),
                    const SizedBox(height: 24),
                    _buildBlogCard(
                      context,
                      title: l10n.blogDummy2Title,
                      category: l10n.blogDummy2Cat,
                      image:
                          'https://images.unsplash.com/photo-1605296867304-46d5465a13f1?w=800&fit=crop',
                      readMore: l10n.blogReadMore,
                    ),
                    const SizedBox(height: 24),
                    _buildBlogCard(
                      context,
                      title: l10n.blogDummy3Title,
                      category: l10n.blogDummy3Cat,
                      image:
                          'https://images.unsplash.com/photo-1544367563-12123d8965cd?w=800&fit=crop',
                      readMore: l10n.blogReadMore,
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBlogCard(
    BuildContext context, {
    required String title,
    required String category,
    required String image,
    required String readMore,
    bool isLarge = false,
  }) {
    return _AnimatedBlogCard(
      title: title,
      category: category,
      image: image,
      readMore: readMore,
      isLarge: isLarge,
    );
  }
}

class _AnimatedBlogCard extends StatefulWidget {
  final String title;
  final String category;
  final String image;
  final String readMore;
  final bool isLarge;

  const _AnimatedBlogCard({
    required this.title,
    required this.category,
    required this.image,
    required this.readMore,
    required this.isLarge,
  });

  @override
  State<_AnimatedBlogCard> createState() => _AnimatedBlogCardState();
}

class _AnimatedBlogCardState extends State<_AnimatedBlogCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(AppRoutes.webBlog),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            0,
          ), // Sharp edges or slight radius
          child: Container(
            height: widget.isLarge ? 500 : 240,
            color: const Color(0xFF1A1A1A),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Animated Background Image
                AnimatedScale(
                  scale: _isHovered ? 1.05 : 1.0,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                  child: Image.network(
                    widget.image,
                    fit: BoxFit.cover,
                    color: Colors.black.withValues(
                      alpha: 0.2,
                    ), // Base darkening
                    colorBlendMode: BlendMode.darken,
                  ),
                ),

                // Animated Overlay (Darkens on hover)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  color: Colors.black.withValues(alpha: _isHovered ? 0.3 : 0.0),
                ),

                // Content
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.9),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          color: AppColors.brandYellow,
                          child: Text(
                            widget.category,
                            style: GoogleFonts.oswald(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.title,
                          style: GoogleFonts.oswald(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Animated "Read More" Arrow or Color change
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: _isHovered
                                ? AppColors.brandYellow
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          child: Row(
                            children: [
                              Text(widget.readMore),
                              if (_isHovered) ...[
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.arrow_forward,
                                  color: AppColors.brandYellow,
                                  size: 16,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
