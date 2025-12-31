import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gyelyseedz/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

class WebTestimonialsSection extends StatelessWidget {
  const WebTestimonialsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Force black background for consistency
    // Force black background for consistency
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? Colors.black : Colors.white;
    final l10n = AppLocalizations.of(context)!;
    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
      child: Column(
        children: [
          Text(
            l10n.testimonialsTitleTag,
            style: GoogleFonts.inter(
              color: AppColors.brandYellow,
              letterSpacing: 3,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.oswald(
                fontSize: 56,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
                height: 1.1,
              ),
              children: [
                TextSpan(text: "${l10n.testimonialsTitle1}\n"),
                WidgetSpan(
                  child: ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        Color(0xFFFFC107), // Amber
                        Color(0xFFFF9800), // Orange
                        Color(0xFFFF5722), // Deep Orange
                      ],
                      stops: [0.0, 0.5, 1.0],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ).createShader(bounds),
                    child: Text(
                      l10n.testimonialsTitle2,
                      style: GoogleFonts.oswald(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 80),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isMobile = constraints.maxWidth < 800;
                  return isMobile
                      ? Column(
                          children: _getTestimonials(l10n)
                              .map(
                                (t) => Padding(
                                  padding: const EdgeInsets.only(bottom: 24),
                                  child: _TestimonialCard(testimonial: t),
                                ),
                              )
                              .toList(),
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _getTestimonials(l10n)
                              .map(
                                (t) => Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: _TestimonialCard(testimonial: t),
                                  ),
                                ),
                              )
                              .toList(),
                        );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getTestimonials(AppLocalizations l10n) {
    return [
      {
        'quote': l10n.testimonials1Quote,
        'name': l10n.testimonials1Name,
        'role': l10n.testimonials1Role,
        'initial': 'KB',
      },
      {
        'quote': l10n.testimonials2Quote,
        'name': l10n.testimonials2Name,
        'role': l10n.testimonials2Role,
        'initial': 'SH',
      },
      {
        'quote': l10n.testimonials3Quote,
        'name': l10n.testimonials3Name,
        'role': l10n.testimonials3Role,
        'initial': 'OZ',
      },
    ];
  }
}

class _TestimonialCard extends StatefulWidget {
  final Map<String, dynamic> testimonial;

  const _TestimonialCard({required this.testimonial});

  @override
  State<_TestimonialCard> createState() => _TestimonialCardState();
}

class _TestimonialCardState extends State<_TestimonialCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()
          // ignore: deprecated_member_use
          ..translate(0.0, _isHovered ? -10.0 : 0.0),
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF111111) : Colors.white,
          border: Border.all(
            // Border turns orange on hover
            color: _isHovered
                ? AppColors.brandOrange
                : (isDark
                      ? Colors.white10
                      : Colors.grey.withValues(alpha: 0.2)),
            width: 1,
          ),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FaIcon(
              FontAwesomeIcons.quoteLeft,
              // Quote icon turns orange on hover if you like, or stays dark?
              // Design shows outline usually, but let's keep it subtle or match brand.
              // Let's make it orange when hovered for pop.
              color: _isHovered
                  ? AppColors.brandOrange
                  : const Color(0xFF333333),
              size: 40,
            ),
            const SizedBox(height: 24),
            Row(
              children: List.generate(
                5,
                (index) => const Icon(
                  Icons.star,
                  color: AppColors.brandYellow,
                  size: 16,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '"${widget.testimonial['quote']}"',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: isDark ? Colors.white : Colors.black87,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: AppColors.brandYellow,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      widget.testimonial['initial'],
                      style: GoogleFonts.oswald(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.testimonial['name'],
                      style: GoogleFonts.oswald(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      widget.testimonial['role'],
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: _isHovered
                            ? AppColors.brandOrange
                            : Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
