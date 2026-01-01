import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gyelyseedz/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import 'web_cta_section.dart';

class WebPricingPageSection extends StatefulWidget {
  const WebPricingPageSection({super.key});

  @override
  State<WebPricingPageSection> createState() => _WebPricingPageSectionState();
}

class _WebPricingPageSectionState extends State<WebPricingPageSection> {
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
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800; // Breakpoint for pricing page

    // Clearing controllers on rebuild is important if strict manual management is needed,
    // but here we just append. To avoid duplicates if rebuilt, we can clear.
    _controllers.clear();

    return VisibilityDetector(
      key: const Key('pricing-page-section'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 80,
          horizontal: isMobile ? 20 : 40,
        ),
        child: Column(
          children: [
            // Header
            FadeInDown(
              manualTrigger: true,
              controller: (c) => _controllers.add(c),
              child: Column(
                children: [
                  Text(
                    l10n.pricingTitleFirst,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.oswald(
                      fontSize: isMobile ? 48 : 72,
                      fontWeight: FontWeight.bold,
                      color: AppColors.gold,
                      height: 1.1,
                    ),
                  ),
                  ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) =>
                        AppColors.fieryGradient.createShader(bounds),
                    child: Text(
                      l10n.pricingTitleSecond,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.oswald(
                        fontSize: isMobile ? 48 : 72,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            FadeInUp(
              manualTrigger: true,
              controller: (c) => _controllers.add(c),
              delay: const Duration(milliseconds: 200),
              child: Text(
                l10n.pricingSubtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 16 : 18,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[400]
                      : Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Calculator Banner
            FadeInUp(
              manualTrigger: true,
              controller: (c) => _controllers.add(c),
              delay: const Duration(milliseconds: 300),
              child: _InteractiveCalculatorBanner(l10n: l10n),
            ),
            const SizedBox(height: 80),

            // Pricing Cards Row
            Wrap(
              spacing: 30,
              runSpacing: 30,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                FadeInUp(
                  manualTrigger: true,
                  controller: (c) => _controllers.add(c),
                  delay: const Duration(milliseconds: 400),
                  child: _InteractivePricingCard(
                    title: l10n.pricingPlanMonthly,
                    subtitle: l10n.pricingSubMonthly,
                    price: '8,000',
                    period: l10n.pricingPerMonth,
                    features: [
                      l10n.pricingFeature1Branch,
                      l10n.pricingFeatureGroupClasses,
                      l10n.pricingFeatureLockers,
                      l10n.pricingFeatureMobileApp,
                    ],
                    isHighlight: false,
                    buttonLabel: l10n.pricingBtnMonthly,
                    delay: 300,
                    width: isMobile ? double.infinity : 380,
                  ),
                ),
                FadeInUp(
                  manualTrigger: true,
                  controller: (c) => _controllers.add(c),
                  delay: const Duration(milliseconds: 500),
                  child: _InteractivePricingCard(
                    title: l10n.pricingPlanQuarterly,
                    subtitle: l10n.pricingSubQuarterly,
                    price: '21,000',
                    period: l10n.pricingPerQuarter,
                    features: [
                      l10n.pricingFeatureAllBranches,
                      l10n.pricingFeatureGroupClasses,
                      l10n.pricingFeature2PrivateSessions,
                      l10n.pricingFeature1GuestMonth,
                      l10n.pricingFeatureLockers,
                      l10n.pricingFeatureMobileApp,
                    ],
                    isHighlight: false,
                    buttonLabel: l10n.pricingBtnQuarterly,
                    delay: 400,
                    savingsBadge: l10n.pricingSave3k,
                    width: isMobile ? double.infinity : 380,
                  ),
                ),
                FadeInUp(
                  manualTrigger: true,
                  controller: (c) => _controllers.add(c),
                  delay: const Duration(milliseconds: 600),
                  child: _InteractivePricingCard(
                    title: l10n.pricingPlanAnnual,
                    subtitle: l10n.pricingSubAnnual,
                    price: '75,000',
                    period: l10n.pricingPerYear,
                    features: [
                      l10n.pricingFeatureUnlimitedBranches,
                      l10n.pricingFeatureGroupClasses,
                      l10n.pricingFeature5PrivateSessions,
                      l10n.pricingFeature3GuestsMonth,
                      l10n.pricingFeatureBodyAssessment,
                      l10n.pricingFeatureNutritionPlan,
                      l10n.pricingFeaturePriorityAccess,
                      l10n.pricingFeature3xPayment,
                    ],
                    isHighlight: true,
                    buttonLabel: l10n.pricingBtnAnnual,
                    delay: 500,
                    savingsBadge: l10n.pricingSave21k,
                    topBadge: l10n.pricingBestValue,
                    width: isMobile ? double.infinity : 380,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 100),

            // COMPARATIF DÉTAILLÉ Section
            FadeInUp(
              manualTrigger: true,
              controller: (c) => _controllers.add(c),
              delay: const Duration(milliseconds: 700),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${l10n.pricingCompTitleFirst} ",
                        style: GoogleFonts.oswald(
                          fontSize: isMobile ? 32 : 42,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            Color(0xFFFFC107),
                            Color(0xFFFF9800),
                            Color(0xFFFF5722),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ).createShader(bounds),
                        child: Text(
                          l10n.pricingCompTitleSecond,
                          style: GoogleFonts.oswald(
                            fontSize: isMobile ? 32 : 42,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),

                  // Comparison Table
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      constraints: BoxConstraints(
                        minWidth: isMobile ? 600 : 0,
                        maxWidth: 900,
                      ),
                      width: isMobile ? 800 : 900,
                      child: Table(
                        columnWidths: const {
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(1),
                          2: FlexColumnWidth(1),
                          3: FlexColumnWidth(1),
                        },
                        children: [
                          // Header Row
                          TableRow(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white.withValues(alpha: 0.1)
                                      : Colors.black.withValues(alpha: 0.1),
                                ),
                              ),
                            ),
                            children: [
                              _buildTableHeader(
                                context,
                                l10n.compTableFeature,
                                isFirst: true,
                              ),
                              _buildTableHeader(
                                context,
                                l10n.pricingPlanMonthly,
                              ),
                              _buildTableHeader(
                                context,
                                l10n.pricingPlanQuarterly,
                              ),
                              _buildTableHeader(
                                context,
                                l10n.pricingPlanAnnual,
                                isHighlight: true,
                              ),
                            ],
                          ),
                          // Data Rows
                          _buildInteractiveTableRow(
                            context,
                            l10n.compMonthlyEquiv,
                            '8,000 DZD',
                            '7,000 DZD',
                            '6,250 DZD',
                            isPrice: true,
                          ),
                          _buildInteractiveTableRow(
                            context,
                            l10n.compBranchAccess,
                            l10n.compValueOneBranch,
                            l10n.compValueAll,
                            l10n.compValueAll,
                          ),
                          _buildInteractiveTableRow(
                            context,
                            l10n.compGroupClasses,
                            l10n.compValueUnlimited,
                            l10n.compValueUnlimited,
                            l10n.compValueUnlimited,
                          ),
                          _buildInteractiveTableRow(
                            context,
                            l10n.compPrivateSessions,
                            '0',
                            '2/trim.',
                            '5/an',
                          ),
                          _buildInteractiveTableRow(
                            context,
                            l10n.compFreeGuests,
                            '0',
                            '1/mois',
                            '3/mois',
                          ),
                          _buildInteractiveTableRow(
                            context,
                            l10n.compBodyAssessment,
                            '—',
                            '—',
                            l10n.compValueQuarterly,
                          ),
                          _buildInteractiveTableRow(
                            context,
                            l10n.compNutritionPlan,
                            '—',
                            '—',
                            '✓',
                          ),
                          _buildInteractiveTableRow(
                            context,
                            l10n.comp3xPayment,
                            '—',
                            '—',
                            '✓',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100),

            // Payment Methods Section
            Column(
              children: [
                // Payment Cards Row
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 24,
                  runSpacing: 24,
                  children: [
                    _InteractivePaymentCard(
                      imagePath: 'assets/images/icone-dahabia.png',
                      title: l10n.paymentMethodEdahabia,
                      subtitle: l10n.paymentMethodEdahabiaDesc,
                    ),
                    _InteractivePaymentCard(
                      imagePath: 'assets/images/icone-cib.png',
                      title: l10n.paymentMethodCib,
                      subtitle: l10n.paymentMethodCibDesc,
                    ),
                    _InteractivePaymentCard(
                      icon: Icons.money,
                      title: l10n.paymentMethodCash,
                      subtitle: l10n.paymentMethodCashDesc,
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                // 3x Banner
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white24),
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).brightness == Brightness.dark
                        ? null
                        : Colors.black.withValues(alpha: 0.8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.bolt, color: Color(0xFFE60000)),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.pricingPaymentTitle,
                            style: GoogleFonts.oswald(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            l10n.pricingPaymentSubtitle,
                            style: GoogleFonts.inter(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 120),

            // PRÊT À COMMENCER ? CTA Section
            const WebCTASection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader(
    BuildContext context,
    String text, {
    bool isFirst = false,
    bool isHighlight = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Text(
        text,
        textAlign: isFirst ? TextAlign.left : TextAlign.center,
        style: GoogleFonts.oswald(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: isHighlight
              ? AppColors.brandYellow
              : (Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black),
          letterSpacing: 1,
        ),
      ),
    );
  }

  TableRow _buildInteractiveTableRow(
    BuildContext context,
    String feature,
    String mensuel,
    String trimestriel,
    String annuel, {
    bool isPrice = false,
  }) {
    // We can't really make the whole row interactive easily within Table
    // But update cell content to look consistent
    return TableRow(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.05),
          ),
        ),
      ),
      children: [
        _buildTableCell(context, feature, isFirst: true),
        _buildTableCell(context, mensuel, isPrice: isPrice),
        _buildTableCell(context, trimestriel, isPrice: isPrice),
        _buildTableCell(context, annuel, isHighlight: true, isPrice: isPrice),
      ],
    );
  }

  Widget _buildTableCell(
    BuildContext context,
    String text, {
    bool isFirst = false,
    bool isHighlight = false,
    bool isPrice = false,
  }) {
    final isCheckmark = text == '✓';
    final isDash = text == '—';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      color: isHighlight ? AppColors.brandYellow.withValues(alpha: 0.03) : null,
      child: isCheckmark
          ? Center(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isHighlight
                      ? AppColors.brandYellow.withValues(alpha: 0.2)
                      : Colors.green.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  size: 14,
                  color: isHighlight ? AppColors.brandYellow : Colors.green,
                ),
              ),
            )
          : Text(
              text,
              textAlign: isFirst ? TextAlign.left : TextAlign.center,
              style: isPrice
                  ? GoogleFonts.oswald(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isHighlight
                          ? AppColors.brandYellow
                          : (isDark ? Colors.white : Colors.black),
                    )
                  : GoogleFonts.inter(
                      fontSize: 14,
                      color: isDash
                          ? (isDark ? Colors.grey[600] : Colors.grey[400])
                          : (isHighlight
                                ? AppColors.brandYellow
                                : (isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[700])),
                      fontWeight: isHighlight
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
            ),
    );
  }
}

class _InteractiveCalculatorBanner extends StatefulWidget {
  final AppLocalizations l10n;
  const _InteractiveCalculatorBanner({required this.l10n});

  @override
  State<_InteractiveCalculatorBanner> createState() =>
      _InteractiveCalculatorBannerState();
}

class _InteractiveCalculatorBannerState
    extends State<_InteractiveCalculatorBanner> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isHovered
                ? Colors.redAccent.withValues(alpha: 0.5)
                : (isDark
                      ? Colors.white10
                      : Colors.grey.withValues(alpha: 0.2)),
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: Colors.redAccent.withValues(alpha: 0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: 0.2,
                    ), // Force Dark Shadow
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE60000).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.calculate_outlined,
                color: Color(0xFFE60000),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.l10n.pricingAnnualSavingsPrefix,
                  style: GoogleFonts.inter(
                    color: Colors.grey[400], // Force Grey
                    fontSize: 12,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "21,000 DZD",
                        style: GoogleFonts.oswald(
                          color: const Color(0xFFE60000),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: widget.l10n.pricingPerYear,
                        style: GoogleFonts.inter(
                          color: isDark ? Colors.white : Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InteractivePricingCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String price;
  final String period;
  final List<String> features;
  final bool isHighlight;
  final String buttonLabel;
  final int delay;
  final String? savingsBadge;
  final String? topBadge;
  final double? width;

  const _InteractivePricingCard({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.period,
    required this.features,
    required this.isHighlight,
    required this.buttonLabel,
    required this.delay,
    this.savingsBadge,
    this.topBadge,
    this.width,
  });

  @override
  State<_InteractivePricingCard> createState() =>
      _InteractivePricingCardState();
}

class _InteractivePricingCardState extends State<_InteractivePricingCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            transform: Matrix4.identity()
              // ignore: deprecated_member_use
              ..translate(0.0, _isHovered ? -12.0 : 0.0),
            width: widget.width ?? 380,
            constraints: const BoxConstraints(minHeight: 650),
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 32),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: widget.isHighlight
                  ? Border.all(color: AppColors.brandYellow, width: 2)
                  : Border.all(
                      color: _isHovered
                          ? AppColors.brandYellow.withValues(alpha: 0.5)
                          : (isDark
                                ? Colors.white10
                                : Colors.grey.withValues(alpha: 0.2)),
                    ),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: widget.isHighlight
                            ? AppColors.brandYellow.withValues(alpha: 0.3)
                            : Colors.black.withValues(alpha: 0.3),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ]
                  : [
                      if (widget.isHighlight)
                        BoxShadow(
                          color: AppColors.brandYellow.withValues(alpha: 0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        )
                      else
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                    ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.topBadge == null) const SizedBox(height: 20),
                Text(
                  widget.title,
                  style: GoogleFonts.oswald(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.subtitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.grey[500], // Force Grey
                  ),
                ),
                const SizedBox(height: 32),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: widget.price,
                        style: GoogleFonts.oswald(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: ' DZD',
                        style: GoogleFonts.oswald(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[500], // Force Grey
                        ),
                      ),
                      TextSpan(
                        text: '\n${widget.period}',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.grey[500], // Force Grey
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Red Savings Badge
                if (widget.savingsBadge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF330505),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF880000)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.local_offer_outlined,
                          size: 14,
                          color: Colors.redAccent,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.savingsBadge!,
                          style: GoogleFonts.inter(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  const SizedBox(height: 40), // Spacer balancing
                // Features
                Column(
                  children: widget.features.map((feature) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.brandYellow.withValues(
                                alpha: 0.2,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              size: 10,
                              color: AppColors.brandYellow,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              feature,
                              style: GoogleFonts.inter(
                                color: Colors.grey[400], // Force Grey
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 32),

                // CTA Button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () => context.go(AppRoutes.register),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.isHighlight || _isHovered
                          ? AppColors.brandOrange
                          : Colors.transparent,
                      foregroundColor: widget.isHighlight || _isHovered
                          ? Colors.black
                          : AppColors.brandOrange,
                      side: widget.isHighlight || _isHovered
                          ? null
                          : const BorderSide(color: AppColors.brandOrange),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.buttonLabel,
                          style: GoogleFonts.oswald(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, size: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Absolute Top Badge for Annual
          if (widget.topBadge != null)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              top: _isHovered ? -28 : -16, // Moves up with the card
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFFC107), Color(0xFFFF9800)],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orangeAccent,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.black),
                      const SizedBox(width: 8),
                      Text(
                        widget.topBadge!,
                        style: GoogleFonts.oswald(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _InteractivePaymentCard extends StatefulWidget {
  final IconData? icon;
  final String? imagePath;
  final String title;
  final String subtitle;

  const _InteractivePaymentCard({
    this.icon,
    this.imagePath,
    required this.title,
    required this.subtitle,
  });

  @override
  State<_InteractivePaymentCard> createState() =>
      _InteractivePaymentCardState();
}

class _InteractivePaymentCardState extends State<_InteractivePaymentCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 250,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered
                ? AppColors.brandOrange.withValues(alpha: 0.5)
                : isDark
                ? Colors.white10
                : Colors.grey.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? AppColors.brandOrange.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.brandOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.brandOrange.withValues(alpha: 0.2),
                ),
              ),
              child: widget.imagePath != null
                  ? Image.asset(widget.imagePath!, fit: BoxFit.contain)
                  : Icon(widget.icon, color: AppColors.brandOrange, size: 24),
            ),
            const SizedBox(height: 16),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: GoogleFonts.oswald(
                fontSize: 18,
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
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
