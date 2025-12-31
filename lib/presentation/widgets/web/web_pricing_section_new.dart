import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:gyelyseedz/l10n/app_localizations.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';

class WebPricingSectionNew extends StatefulWidget {
  const WebPricingSectionNew({super.key});

  @override
  State<WebPricingSectionNew> createState() => _WebPricingSectionNewState();
}

class _WebPricingSectionNewState extends State<WebPricingSectionNew> {
  final List<AnimationController> _controllers = [];
  bool _isVisible = false;

  void _onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction > 0.1 && !_isVisible) {
      setState(() => _isVisible = true);
      for (final controller in _controllers) {
        controller.forward();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Force black background for consistency but adapt if needed by theme logic (though historically black)
    // User requested "Light Mode" consistency, so we use adaptive background
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? Colors.black : Colors.grey[100];
    final l10n = AppLocalizations.of(context)!;

    // Reset controllers list on rebuild to avoid duplicates/stale references
    _controllers.clear();

    return VisibilityDetector(
      key: const Key('pricing-section-new'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 40),
        color: backgroundColor,
        child: Column(
          children: [
            // Small Top Label
            FadeInDown(
              manualTrigger: true,
              controller: (c) => _controllers.add(c),
              child: Text(
                l10n.landingPricingTag,
                style: GoogleFonts.inter(
                  color: AppColors.brandYellow,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Main Header
            FadeInDown(
              delay: const Duration(milliseconds: 100),
              manualTrigger: true,
              controller: (c) => _controllers.add(c),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.oswald(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  children: [
                    TextSpan(text: "${l10n.landingPricingTitle1}\n"),
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
                          l10n.landingPricingTitle2,
                          style: GoogleFonts.oswald(
                            fontSize: 72,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Subtitle (Restored)
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              manualTrigger: true,
              controller: (c) => _controllers.add(c),
              child: Text(
                l10n.pricingSubtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 18, color: Colors.grey[500]),
              ),
            ),
            const SizedBox(height: 80),
            // Cards Row
            Wrap(
              spacing: 30,
              runSpacing: 30,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _PricingCard(
                  title: l10n.pricingPlanMonthly,
                  subtitle: l10n.landingPricingSubtitleMonthly,
                  price: '8,000',
                  period: l10n.pricingPerMonth,
                  features: l10n.landingPricingFeaturesMonthly.split(','),
                  isHighlight: false,
                  buttonLabel: l10n.landingPricingBtnDetails,
                  delay: 200,
                  onControllerCreated: (c) => _controllers.add(c),
                ),
                _PricingCard(
                  title: l10n.pricingPlanQuarterly,
                  subtitle: l10n.landingPricingSubtitleQuarterly,
                  price: '21,000',
                  period: l10n.pricingPerQuarter,
                  features: l10n.landingPricingFeaturesQuarterly.split(','),
                  isHighlight: false,
                  buttonLabel: l10n.landingPricingBtnDetails,
                  delay: 300,
                  onControllerCreated: (c) => _controllers.add(c),
                ),
                _PricingCard(
                  title: l10n.pricingPlanAnnual,
                  subtitle: l10n.landingPricingSubtitleAnnual,
                  price: '75,000',
                  period: l10n.pricingPerYear,
                  features: l10n.landingPricingFeaturesAnnual.split(','),
                  isHighlight: true,
                  badge: l10n.landingPricingBadge,
                  buttonLabel: l10n.landingPricingBtnDetails,
                  delay: 400,
                  onControllerCreated: (c) => _controllers.add(c),
                ),
              ],
            ),
            const SizedBox(height: 60),
            // "Voir tous les tarifs" Button
            FadeInUp(
              delay: const Duration(milliseconds: 500),
              manualTrigger: true,
              controller: (c) => _controllers.add(c),
              child: OutlinedButton(
                onPressed: () => context.go(
                  AppRoutes.webPricing,
                ), // Navigates to full pricing
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: AppColors.brandYellow.withValues(alpha: 0.5),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.landingPricingBtnAll,
                      style: GoogleFonts.oswald(
                        color: AppColors.brandYellow,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward,
                      color: AppColors.brandYellow,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PricingCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String price;
  final String period;
  final List<String> features;
  final bool isHighlight;
  final String? badge;
  final String? buttonLabel;
  final int delay;
  final Function(AnimationController)? onControllerCreated;

  const _PricingCard({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.period,
    required this.features,
    required this.isHighlight,
    this.badge,
    this.buttonLabel,
    required this.delay,
    this.onControllerCreated,
  });

  @override
  State<_PricingCard> createState() => _PricingCardState();
}

class _PricingCardState extends State<_PricingCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // If it's highlighted by default (Annual plan), it might always have a style,
    // but hover should still do something (e.g. pop/lift).
    final isHighlighted = widget.isHighlight || _isHovered;

    return FadeInUp(
      delay: Duration(milliseconds: widget.delay),
      manualTrigger: true,
      controller: widget.onControllerCreated,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          constraints: const BoxConstraints(maxWidth: 380),
          // Pop animation translation
          transform: Matrix4.identity()
            // ignore: deprecated_member_use
            ..translate(0.0, _isHovered ? -15.0 : 0.0),
          height: widget.isHighlight ? 620 : 580,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F0F0F) : Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: isHighlighted
                ? Border.all(color: AppColors.brandYellow, width: 2)
                : Border.all(
                    color: isDark
                        ? Colors.transparent
                        : Colors.grey.withValues(alpha: 0.2),
                  ),
            boxShadow: isHighlighted
                ? [
                    BoxShadow(
                      color: AppColors.brandYellow.withValues(alpha: 0.1),
                      blurRadius: 40,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : (isDark
                      ? []
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 40,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        if (widget.isHighlight && widget.badge != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.brandYellow,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              widget.badge!,
                              style: GoogleFonts.oswald(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                        Text(
                          widget.title,
                          style: GoogleFonts.oswald(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.subtitle,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              widget.price,
                              style: GoogleFonts.oswald(
                                fontSize: 56,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.period,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        // Features
                        Column(
                          children: widget.features.map((feature) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: AppColors.brandYellow.withValues(
                                        alpha: 0.2,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.bolt,
                                      size: 12,
                                      color: AppColors.brandYellow,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    feature,
                                    style: GoogleFonts.inter(
                                      color: Colors.grey[400],
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    // Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: isHighlighted
                          ? ElevatedButton(
                              onPressed: () => context.go(AppRoutes.register),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.brandYellow,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.buttonLabel ?? 'VOIR DÉTAILS',
                                    style: GoogleFonts.oswald(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.arrow_forward, size: 16),
                                ],
                              ),
                            )
                          : OutlinedButton(
                              onPressed: () => context.go(AppRoutes.register),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: AppColors.brandYellow.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.buttonLabel ?? 'VOIR DÉTAILS',
                                    style: GoogleFonts.oswald(
                                      color: AppColors.brandYellow,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.arrow_forward,
                                    color: AppColors.brandYellow,
                                    size: 16,
                                  ),
                                ],
                              ),
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
