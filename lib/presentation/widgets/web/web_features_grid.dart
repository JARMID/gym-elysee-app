import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:gyelyseedz/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

class WebFeaturesGrid extends StatefulWidget {
  const WebFeaturesGrid({super.key});

  @override
  State<WebFeaturesGrid> createState() => _WebFeaturesGridState();
}

class _WebFeaturesGridState extends State<WebFeaturesGrid>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _hasAnimate = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Force black/dark background to match the "EXCELLENCE" design
    // Force black/dark background to match the "EXCELLENCE" design
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? Colors.black : Colors.white;
    final l10n = AppLocalizations.of(context)!;

    final features = [
      {
        'icon': FontAwesomeIcons.dumbbell,
        'title': l10n.featureEquipTitle.toUpperCase(),
        'description': l10n.featureEquipDesc,
      },
      {
        'icon': FontAwesomeIcons.trophy,
        'title': l10n.featureCoachTitle.toUpperCase(),
        'description': l10n.featureCoachDesc,
      },
      {
        'icon': FontAwesomeIcons.creditCard,
        'title': l10n.featurePaymentTitle.toUpperCase(),
        'description': l10n.featurePaymentDesc,
      },
      {
        'icon': FontAwesomeIcons.moon,
        'title': l10n.featureRamadanTitle.toUpperCase(),
        'description': l10n.featureRamadanDesc,
      },
      {
        'icon': FontAwesomeIcons.bullseye,
        'title': l10n.featureProgramTitle.toUpperCase(),
        'description': l10n.featureProgramDesc,
      },
      {
        'icon': FontAwesomeIcons.heartPulse,
        'title': l10n.featureCommunityTitle.toUpperCase(),
        'description': l10n.featureCommunityDesc,
      },
    ];

    return VisibilityDetector(
      key: const Key('features-grid'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_hasAnimate) {
          _controller.forward();
          _hasAnimate = true;
        }
      },
      child: Container(
        color: backgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
        child: Column(
          children: [
            // Header matching the design
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: GoogleFonts.oswald(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                  height: 1.1,
                  letterSpacing: 1,
                ),
                children: [
                  const TextSpan(text: "L'EXCELLENCE\n"),
                  WidgetSpan(
                    child: Text(
                      "DANS CHAQUE DÉTAIL",
                      style: GoogleFonts.oswald(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        color: AppColors.brandOrange,
                        letterSpacing: 1,
                        height: 1.1,
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
                child: Wrap(
                  spacing: 30,
                  runSpacing: 30,
                  alignment: WrapAlignment.center,
                  children: List.generate(features.length, (index) {
                    return _buildAnimatedCard(index, features);
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedCard(int index, List<Map<String, dynamic>> features) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double delay = index * 0.1;
        final double start = delay;
        final double end = (delay + 0.4).clamp(0.0, 1.0);

        final curve = CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeOut),
        );

        return Opacity(
          opacity: curve.value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - curve.value)),
            child: _FeatureCard(feature: features[index]),
          ),
        );
      },
    );
  }
}

class _FeatureCard extends StatefulWidget {
  final Map<String, dynamic> feature;

  const _FeatureCard({required this.feature});

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
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
        constraints: const BoxConstraints(maxWidth: 350),
        height: 240,
        transform: Matrix4.identity()
          // ignore: deprecated_member_use
          ..translate(0.0, _isHovered ? -10.0 : 0.0),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F0F0F) : Colors.white,
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.grey.withValues(alpha: 0.2),
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
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: FaIcon(
                      widget.feature['icon'],
                      size: 32,
                      color: AppColors.brandOrange,
                    ),
                  ),

                  Text(
                    widget.feature['title'],
                    style: GoogleFonts.oswald(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _isHovered
                          ? AppColors.brandOrange
                          : (isDark ? Colors.white : Colors.black),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.feature['description'],
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.grey[500],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                height: _isHovered ? 4 : 0,
                color: AppColors.brandOrange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
