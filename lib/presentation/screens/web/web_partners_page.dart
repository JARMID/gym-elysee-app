import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gyelyseedz/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/web/web_nav_bar.dart';
import '../../widgets/web/web_footer.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/theme_provider.dart';

class WebPartnersPage extends ConsumerWidget {
  const WebPartnersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRamadanMode = ref.watch(ramadanModeProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    final partners = [
      _Partner(
        name: 'Optimum Nutrition',
        category: l10n.partnerCategoryNutrition,
        description: l10n.partnerDescOptimum,
        icon: FontAwesomeIcons.dumbbell,
        color: Colors.red,
      ),
      _Partner(
        name: 'Nike Training',
        category: l10n.partnerCategoryEquipment,
        description: l10n.partnerDescNike,
        icon: FontAwesomeIcons.shoePrints,
        color: Colors.orange,
      ),
      _Partner(
        name: 'Muscle Tech',
        category: l10n.partnerCategoryNutrition,
        description: l10n.partnerDescMuscleTech,
        icon: FontAwesomeIcons.flask,
        color: Colors.purple,
      ),
      _Partner(
        name: 'Under Armour',
        category: l10n.partnerCategoryEquipment,
        description: l10n.partnerDescUnderArmour,
        icon: FontAwesomeIcons.shirt,
        color: Colors.blue,
      ),
      _Partner(
        name: 'MyProtein',
        category: l10n.partnerCategoryNutrition,
        description: l10n.partnerDescMyProtein,
        icon: FontAwesomeIcons.blender,
        color: Colors.teal,
      ),
      _Partner(
        name: 'Technogym',
        category: l10n.partnerCategoryMachines,
        description: l10n.partnerDescTechnogym,
        icon: FontAwesomeIcons.personRunning,
        color: Colors.green,
      ),
      _Partner(
        name: 'Life Fitness',
        category: l10n.partnerCategoryMachines,
        description: l10n.partnerDescLifeFitness,
        icon: FontAwesomeIcons.heartPulse,
        color: Colors.pink,
      ),
      _Partner(
        name: 'Hammer Strength',
        category: l10n.partnerCategoryMachines,
        description: l10n.partnerDescHammer,
        icon: FontAwesomeIcons.bolt,
        color: Colors.amber,
      ),
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: WebNavBar.getHeight(isRamadanMode) + 20),
                // Hero Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 80),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black,
                        isDark ? AppColors.darkBackground : Colors.grey[100]!,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    children: [
                      FadeInDown(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.brandOrange.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const FaIcon(
                            FontAwesomeIcons.handshake,
                            size: 50,
                            color: AppColors.brandOrange,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      FadeInDown(
                        delay: const Duration(milliseconds: 200),
                        child: Text(
                          l10n.partnersTitleFirst,
                          style: GoogleFonts.oswald(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.0,
                          ),
                        ),
                      ),
                      FadeInDown(
                        delay: const Duration(milliseconds: 300),
                        child: ShaderMask(
                          blendMode: BlendMode.srcIn,
                          shaderCallback: (bounds) =>
                              AppColors.fieryGradient.createShader(bounds),
                          child: Text(
                            l10n.partnersTitleSecond,
                            style: GoogleFonts.oswald(
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                              height: 1.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      FadeInDown(
                        delay: const Duration(milliseconds: 400),
                        child: Text(
                          l10n.partnersSubtitle,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Partners Grid
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 80,
                    vertical: 60,
                  ),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 24,
                          mainAxisSpacing: 24,
                          childAspectRatio: 1.0,
                        ),
                    itemCount: partners.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final partner = partners[index];
                      return FadeInUp(
                        delay: Duration(milliseconds: index * 100),
                        child: _PartnerCard(partner: partner, isDark: isDark),
                      );
                    },
                  ),
                ),

                // CTA Section
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 80,
                    vertical: 40,
                  ),
                  padding: const EdgeInsets.all(60),
                  decoration: BoxDecoration(
                    gradient: AppColors.fieryGradient,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.partnersCtaTitle,
                              style: GoogleFonts.oswald(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              l10n.partnersCtaText,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 40),
                      ElevatedButton(
                        onPressed: () => context.go(AppRoutes.webContact),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              l10n.partnersCtaButton,
                              style: GoogleFonts.oswald(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward, size: 18),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
                const WebFooter(),
              ],
            ),
          ),
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: WebNavBar(isScrolled: true),
          ),
        ],
      ),
    );
  }
}

class _Partner {
  final String name;
  final String category;
  final String description;
  final IconData icon;
  final Color color;

  _Partner({
    required this.name,
    required this.category,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class _PartnerCard extends StatefulWidget {
  final _Partner partner;
  final bool isDark;

  const _PartnerCard({required this.partner, required this.isDark});

  @override
  State<_PartnerCard> createState() => _PartnerCardState();
}

class _PartnerCardState extends State<_PartnerCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()
          // ignore: deprecated_member_use
          ..scale(_isHovered ? 1.02 : 1.0, _isHovered ? 1.02 : 1.0),
        decoration: BoxDecoration(
          color: widget.isDark ? AppColors.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered
                ? widget.partner.color.withValues(alpha: 0.5)
                : (widget.isDark
                      ? Colors.white10
                      : Colors.grey.withValues(alpha: 0.2)),
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: widget.partner.color.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ]
              : (widget.isDark
                    ? null
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: widget.partner.color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: FaIcon(
                  widget.partner.icon,
                  size: 32,
                  color: widget.partner.color,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.partner.category,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: widget.partner.color,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.partner.name,
                textAlign: TextAlign.center,
                style: GoogleFonts.oswald(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: widget.isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.partner.description,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: widget.isDark ? Colors.grey[500] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
