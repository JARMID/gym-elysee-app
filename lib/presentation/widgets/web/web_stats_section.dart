import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:gyelyseedz/l10n/app_localizations.dart';

import '../../../core/theme/app_colors.dart';

class WebStatsSection extends StatefulWidget {
  const WebStatsSection({super.key});

  @override
  State<WebStatsSection> createState() => _WebStatsSectionState();
}

class _WebStatsSectionState extends State<WebStatsSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Force black background for this specific section as per design
    // Force black background for this specific section as per design
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? Colors.black : Colors.white;
    final l10n = AppLocalizations.of(context)!;

    return VisibilityDetector(
      key: const Key('stats-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_hasAnimated) {
          _controller.forward();
          _hasAnimated = true;
        }
      },
      child: Container(
        color: backgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 100),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth > 900;
                final isTablet =
                    constraints.maxWidth <= 900 && constraints.maxWidth > 600;

                // Determine columns based on screen width
                int crossAxisCount;
                if (isDesktop) {
                  crossAxisCount = 4;
                } else if (isTablet) {
                  crossAxisCount = 2;
                } else {
                  crossAxisCount = 1;
                }

                // Calculate item width based on available space and spacing
                double spacing = 40;
                double itemWidth =
                    (constraints.maxWidth - (spacing * (crossAxisCount - 1))) /
                    crossAxisCount;

                if (!isDesktop) {
                  // Ensure reasonable width on smaller screens
                  itemWidth =
                      (constraints.maxWidth - spacing) /
                      (crossAxisCount == 1 ? 1 : 2);
                  if (crossAxisCount == 1) itemWidth = constraints.maxWidth;
                }

                return Wrap(
                  spacing: spacing,
                  runSpacing: 60,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildAnimatedStat(
                      icon: Icons.location_on_outlined,
                      label:
                          "BRANCHES", // Used literal to match image exactness
                      targetValue: 6,
                      controller: _controller,
                      width: itemWidth,
                    ),
                    _buildAnimatedStat(
                      icon: Icons.group_outlined,
                      label: "MEMBRES ACTIFS",
                      targetValue: 5000,
                      suffix: '+',
                      controller: _controller,
                      width: itemWidth,
                    ),
                    _buildAnimatedStat(
                      icon: Icons.emoji_events_outlined,
                      label: l10n.statsCoaches.toUpperCase(),
                      targetValue: 50,
                      suffix: '+',
                      controller: _controller,
                      width: itemWidth,
                    ),
                    _buildAnimatedStat(
                      icon: Icons.star_border,
                      label: l10n.statsExperience
                          .toUpperCase(), // "ANNÉES D'EXCELLENCE"
                      targetValue: 10,
                      controller: _controller,
                      width: itemWidth,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedStat({
    required IconData icon,
    required String label,
    required int targetValue,
    required AnimationController controller,
    required double width,
    String suffix = '',
  }) {
    return _InteractiveStatCard(
      icon: icon,
      label: label,
      targetValue: targetValue,
      controller: controller,
      width: width,
      suffix: suffix,
    );
  }
}

class _InteractiveStatCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final int targetValue;
  final AnimationController controller;
  final double width;
  final String suffix;

  const _InteractiveStatCard({
    required this.icon,
    required this.label,
    required this.targetValue,
    required this.controller,
    required this.width,
    this.suffix = '',
  });

  @override
  State<_InteractiveStatCard> createState() => _InteractiveStatCardState();
}

class _InteractiveStatCardState extends State<_InteractiveStatCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        final animationValue = CurvedAnimation(
          parent: widget.controller,
          curve: Curves.easeOutExpo,
        ).value;
        final currentValue = (widget.targetValue * animationValue).toInt();

        // Opacity animation for the whole item
        return Opacity(
          opacity: animationValue,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - animationValue)),
            child: MouseRegion(
              onEnter: (_) => setState(() => _isHovered = true),
              onExit: (_) => setState(() => _isHovered = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: widget.width,
                constraints: const BoxConstraints(
                  minWidth: 200,
                  minHeight: 280,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  // Hover background effect (adaptive card appearance)
                  color: _isHovered
                      ? (isDark ? const Color(0xFF111111) : Colors.grey[100])
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Outlined Icon Box
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _isHovered
                              ? AppColors.brandOrange
                              : AppColors.brandOrange.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        color: _isHovered
                            ? AppColors.brandOrange.withValues(alpha: 0.1)
                            : Colors.transparent,
                      ),
                      child: Center(
                        child: Icon(
                          widget.icon,
                          color: AppColors.brandOrange,
                          size: 30,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Animated Number
                    Text(
                      '$currentValue${widget.suffix}',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.oswald(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        color: AppColors.brandOrange,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Label
                    Text(
                      widget.label,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: _isHovered
                            ? (isDark ? Colors.white : Colors.black)
                            : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
