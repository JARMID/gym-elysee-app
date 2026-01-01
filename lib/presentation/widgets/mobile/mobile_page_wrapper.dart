import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../data/models/branch_model.dart';
import '../../providers/landing_providers.dart';
import '../../providers/theme_provider.dart';
import '../../providers/language_provider.dart';

/// Shared mobile page wrapper widget
class MobilePageWrapper extends StatelessWidget {
  final String title;
  final Widget child;
  final bool showBackButton;

  const MobilePageWrapper({
    super.key,
    required this.title,
    required this.child,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final l10n = AppLocalizations.of(context)!;
        return _buildScaffold(context, ref, isDark, l10n);
      },
    );
  }

  Widget _buildScaffold(
    BuildContext context,
    WidgetRef ref,
    bool isDark,
    AppLocalizations l10n,
  ) {
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0A0A) : Colors.white,
      body: Column(
        children: [
          // Mobile App Bar - MATCHING LANDING PAGE
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  // Logo (matching landing page)
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.splash),
                    child: SizedBox(
                      width: 80,
                      height: 50,
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            top: -25,
                            child: SizedBox(
                              height: 140,
                              child: Image.asset(
                                'assets/images/logo.png',
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: ShaderMask(
                                      blendMode: BlendMode.srcIn,
                                      shaderCallback: (bounds) => AppColors
                                          .fieryGradient
                                          .createShader(bounds),
                                      child: const FaIcon(
                                        FontAwesomeIcons.dumbbell,
                                        size: 32,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),

                  // Language Toggle (matching landing page)
                  _buildLanguageButton(context, ref, isDark),

                  // Theme Toggle (matching landing page)
                  GestureDetector(
                    onTap: () {
                      ref
                          .read(themeNotifierProvider.notifier)
                          .toggleTheme(!isDark);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.black.withValues(alpha: 0.05),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.15)
                              : Colors.black.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Icon(
                        isDark
                            ? Icons.wb_sunny_rounded
                            : Icons.nightlight_round,
                        color: isDark ? Colors.white : Colors.black,
                        size: 20,
                      ),
                    ),
                  ),

                  // Menu (matching landing page)
                  _buildMenuButton(context, l10n, isDark),
                ],
              ),
            ),
          ),
          // Content
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildLanguageButton(
    BuildContext context,
    WidgetRef ref,
    bool isDark,
  ) {
    final currentLocale = ref.watch(languageProvider);

    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: PopupMenuButton<String>(
        icon: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.05),
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.15)
                  : Colors.black.withValues(alpha: 0.1),
            ),
          ),
          child: Text(
            currentLocale.languageCode.toUpperCase(),
            style: GoogleFonts.oswald(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
        color: const Color(0xFF151515),
        offset: const Offset(0, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        onSelected: (langCode) {
          ref.read(languageProvider.notifier).setLocale(langCode);
        },
        itemBuilder: (context) => [
          _buildLangItem('fr', 'Français', currentLocale),
          _buildLangItem('en', 'English', currentLocale),
          _buildLangItem('ar', 'العربية', currentLocale),
        ],
      ),
    );
  }

  PopupMenuItem<String> _buildLangItem(
    String code,
    String name,
    Locale current,
  ) {
    final isSelected = current.languageCode == code;
    return PopupMenuItem<String>(
      value: code,
      child: Row(
        children: [
          Text(
            name,
            style: TextStyle(
              color: isSelected ? AppColors.brandOrange : Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (isSelected) ...[
            const Spacer(),
            const Icon(Icons.check, size: 16, color: AppColors.brandOrange),
          ],
        ],
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    return PopupMenuButton<String>(
      icon: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.05),
          shape: BoxShape.circle,
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.15)
                : Colors.black.withValues(alpha: 0.1),
          ),
        ),
        child: Icon(
          Icons.menu,
          color: isDark ? Colors.white : Colors.black,
          size: 22,
        ),
      ),
      color: const Color(0xFF151515),
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      onSelected: (value) {
        switch (value) {
          case 'workouts':
            context.go(AppRoutes.mobileWorkouts);
            break;
          case 'challenges':
            context.go(AppRoutes.mobileChallenges);
            break;
          case 'branches':
            context.go(AppRoutes.mobileBranches);
            break;
          case 'pricing':
            context.go(AppRoutes.mobilePricing);
            break;
          case 'blog':
            context.go(AppRoutes.mobileBlog);
            break;
          case 'contact':
            context.go(AppRoutes.mobileContact);
            break;
          case 'login':
            context.go(AppRoutes.login);
            break;
        }
      },
      itemBuilder: (context) => [
        _menuItem(l10n.navWorkouts, 'workouts', FontAwesomeIcons.dumbbell),
        _menuItem(l10n.navChallenge, 'challenges', FontAwesomeIcons.fire),
        _menuItem(l10n.navBranches, 'branches', FontAwesomeIcons.locationDot),
        _menuItem(l10n.navPricing, 'pricing', FontAwesomeIcons.creditCard),
        _menuItem(l10n.navBlog, 'blog', FontAwesomeIcons.newspaper),
        _menuItem(l10n.navContact, 'contact', FontAwesomeIcons.envelope),
        const PopupMenuDivider(),
        _menuItem(l10n.navLogin, 'login', FontAwesomeIcons.rightToBracket),
      ],
    );
  }

  PopupMenuItem<String> _menuItem(String label, String value, IconData icon) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) =>
                AppColors.fieryGradient.createShader(bounds),
            child: FaIcon(icon, size: 16),
          ),
          const SizedBox(width: 14),
          Text(
            label.toUpperCase(),
            style: GoogleFonts.oswald(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

/// Mobile Branches Page
class MobileBranchesPage extends ConsumerWidget {
  const MobileBranchesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branchesAsync = ref.watch(branchesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MobilePageWrapper(
      title: "Nos Branches",
      child: branchesAsync.when(
        data: (branches) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.8),
                      isDark ? const Color(0xFF0A0A0A) : Colors.white,
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    FadeInDown(
                      child: ShaderMask(
                        shaderCallback: (bounds) =>
                            AppColors.fieryGradient.createShader(bounds),
                        child: Text(
                          "Découvrez",
                          style: GoogleFonts.oswald(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "6 Branches Premium en Algérie",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Branches List
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: branches
                      .map(
                        (branch) => FadeInUp(
                          child: _buildBranchCard(context, branch, isDark),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildBranchCard(
    BuildContext context,
    BranchModel branch,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey[300]!),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.go('/web/branches/${branch.id}'),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    // Type Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: AppColors.fieryGradient,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        branch.type.toUpperCase(),
                        style: GoogleFonts.oswald(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Name
                Text(
                  branch.name,
                  style: GoogleFonts.oswald(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),

                const SizedBox(height: 8),

                // Address
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: AppColors.brandYellow,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        branch.address,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.grey[500],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Features
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _featureChip('Boxing', isDark),
                    _featureChip('Musculation', isDark),
                    if (branch.type == 'crossfit')
                      _featureChip('CrossFit', isDark),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _featureChip(String label, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.brandYellow.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.grey[400] : Colors.grey[700],
        ),
      ),
    );
  }
}
