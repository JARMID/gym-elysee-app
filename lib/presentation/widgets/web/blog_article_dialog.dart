import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../domain/models/blog_article.dart';
import '../../../core/theme/app_colors.dart';

class BlogArticleDialog extends StatelessWidget {
  final BlogArticle article;

  const BlogArticleDialog({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: FadeInUp(
        duration: const Duration(milliseconds: 500),
        child: Container(
          width: 900,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF151515) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark ? Colors.white10 : Colors.grey[200]!,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Column(
            children: [
              // Sticky Header / Close Button
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isDark ? Colors.white10 : Colors.grey[200]!,
                    ),
                  ),
                  color: isDark ? const Color(0xFF151515) : Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppColors.fieryGradient,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            article.category.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${article.readTime} de lecture',
                          style: TextStyle(
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Hero Image
                      SizedBox(
                        height: 300,
                        width: double.infinity,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              article.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    color: isDark
                                        ? Colors.grey[900]
                                        : Colors.grey[200],
                                    child: Icon(
                                      Icons.image,
                                      size: 60,
                                      color: isDark
                                          ? Colors.grey[700]
                                          : Colors.grey[400],
                                    ),
                                  ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      isDark
                                          ? const Color(0xFF151515)
                                          : Colors.white,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Article Header
                            Text(
                              article.title,
                              style: GoogleFonts.oswald(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: AppColors.brandOrange
                                      .withValues(alpha: 0.2),
                                  child: Text(
                                    article.author
                                        .substring(0, 1)
                                        .toUpperCase(),
                                    style: GoogleFonts.oswald(
                                      color: AppColors.brandOrange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      article.author,
                                      style: GoogleFonts.inter(
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      article.date,
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.grey[400]
                                            : Colors.grey[600],
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),

                            // Content Blocks
                            ...article.content.map(
                              (block) => _buildBlock(block, isDark),
                            ),

                            const SizedBox(height: 40),
                            Divider(
                              color: isDark ? Colors.white10 : Colors.grey[200],
                            ),
                            const SizedBox(height: 24),

                            // Footer / Share
                            _ShareSection(
                              articleTitle: article.title,
                              isDark: isDark,
                            ),
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
    );
  }

  Widget _buildBlock(BlogContentBlock block, bool isDark) {
    switch (block.type) {
      case BlogBlockType.heading:
        return Padding(
          padding: const EdgeInsets.only(top: 32, bottom: 16),
          child: Text(
            block.text,
            style: GoogleFonts.oswald(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        );
      case BlogBlockType.paragraph:
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            block.text,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: isDark ? Colors.grey[300] : Colors.grey[700],
              height: 1.7,
            ),
          ),
        );
      case BlogBlockType.quoteWithAuthor:
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 24),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : AppColors.brandOrange.withValues(alpha: 0.05),
            border: Border(
              left: BorderSide(color: AppColors.brandOrange, width: 4),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '"${block.text}"',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: isDark ? Colors.white : Colors.black87,
                  height: 1.5,
                ),
              ),
              if (block.secondaryText != null) ...[
                const SizedBox(height: 16),
                Text(
                  block.secondaryText!,
                  style: GoogleFonts.oswald(
                    color: AppColors.brandOrange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        );
      case BlogBlockType.list:
        if (block.structuredListItems != null) {
          return Column(
            children: block.structuredListItems!.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.brandOrange,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.inter(fontSize: 16, height: 1.5),
                          children: [
                            TextSpan(
                              text: '${item['title']} - ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: item['desc'],
                              style: TextStyle(
                                color: isDark
                                    ? Colors.grey[300]
                                    : Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        } else {
          return Column(
            children: block.listItems!.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.brandOrange,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: isDark ? Colors.grey[300] : Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        }
    }
  }
}

class _ShareSection extends StatelessWidget {
  final String articleTitle;
  final bool isDark;

  const _ShareSection({required this.articleTitle, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.share,
              color: isDark ? Colors.white : Colors.black,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Partager cet article',
              style: GoogleFonts.inter(
                color: isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Row(
          children: [
            _ShareIconButton(
              icon: FontAwesomeIcons.facebookF,
              color: const Color(0xFF1877F2),
              onTap: () => _shareToFacebook(),
              isDark: isDark,
            ),
            const SizedBox(width: 8),
            _ShareIconButton(
              icon: FontAwesomeIcons.xTwitter,
              color: isDark ? Colors.white : Colors.black,
              onTap: () => _shareToTwitter(articleTitle),
              isDark: isDark,
            ),
            const SizedBox(width: 8),
            _ShareIconButton(
              icon: FontAwesomeIcons.linkedinIn,
              color: const Color(0xFF0A66C2),
              onTap: () => _shareToLinkedIn(),
              isDark: isDark,
            ),
            const SizedBox(width: 8),
            _ShareIconButton(
              icon: Icons.copy,
              color: AppColors.brandOrange,
              onTap: () => _copyLink(context),
              isDark: isDark,
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _shareToFacebook() async {
    final url = Uri.parse(
      'https://www.facebook.com/sharer/sharer.php?u=https://gymelysee.dz',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _shareToTwitter(String title) async {
    final url = Uri.parse(
      'https://twitter.com/intent/tweet?text=${Uri.encodeComponent(title)}&url=https://gymelysee.dz',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _shareToLinkedIn() async {
    final url = Uri.parse(
      'https://www.linkedin.com/sharing/share-offsite/?url=https://gymelysee.dz',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _copyLink(BuildContext context) {
    Clipboard.setData(const ClipboardData(text: 'https://gymelysee.dz/blog'));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Lien copié!'),
        backgroundColor: AppColors.brandOrange,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _ShareIconButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isDark;

  const _ShareIconButton({
    required this.icon,
    required this.color,
    required this.onTap,
    required this.isDark,
  });

  @override
  State<_ShareIconButton> createState() => _ShareIconButtonState();
}

class _ShareIconButtonState extends State<_ShareIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _isHovered
                ? widget.color.withValues(alpha: 0.2)
                : widget.isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _isHovered ? widget.color : Colors.transparent,
            ),
          ),
          child: Center(
            child: widget.icon == Icons.copy
                ? Icon(
                    widget.icon,
                    size: 18,
                    color: _isHovered
                        ? widget.color
                        : (widget.isDark ? Colors.grey[400] : Colors.grey[600]),
                  )
                : FaIcon(
                    widget.icon,
                    size: 16,
                    color: _isHovered
                        ? widget.color
                        : (widget.isDark ? Colors.grey[400] : Colors.grey[600]),
                  ),
          ),
        ),
      ),
    );
  }
}
