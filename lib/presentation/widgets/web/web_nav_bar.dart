import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'mobile_navigation_sheet.dart';

import '../../../l10n/app_localizations.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/theme_provider.dart';
import '../../providers/language_provider.dart';
import 'web_hover_menu.dart';
import 'web_settings_dialog.dart';
import 'web_ramadan_banner.dart';

/// Premium navigation bar with fiery theme consistency
/// Fully adaptive for Light and Dark modes

class WebNavBar extends ConsumerWidget {
  final bool isScrolled;
  final String? activeRoute;

  const WebNavBar({super.key, this.isScrolled = false, this.activeRoute});

  static double getHeight(bool isRamadanMode) => isRamadanMode ? 130.0 : 80.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRamadanMode = ref.watch(ramadanModeProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Increased breakpoint to prevent overflow on medium screens
    final isSmallScreen = screenWidth < 1350;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Ramadan Banner
        if (isRamadanMode)
          WebRamadanBanner(
            onDismiss: () =>
                ref.read(ramadanModeProvider.notifier).state = false,
          ),

        // Navbar Content
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 80,
          decoration: BoxDecoration(
            color: isScrolled
                ? (isDark
                      ? const Color(0xFF0A0A0A).withValues(alpha: 0.98)
                      : Colors.white.withValues(alpha: 0.98))
                : (isRamadanMode
                      ? Colors.black.withValues(alpha: 0.6)
                      : Colors.transparent),
            border: Border(
              bottom: BorderSide(
                color: isScrolled
                    ? (isDark
                          ? AppColors.brandOrange.withValues(alpha: 0.15)
                          : Colors.grey.withValues(alpha: 0.2))
                    : (isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : Colors.black.withValues(alpha: 0.05)),
                width: 1,
              ),
            ),
            boxShadow: isScrolled
                ? [
                    BoxShadow(
                      color: isDark
                          ? AppColors.brandOrange.withValues(alpha: 0.08)
                          : Colors.black.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : null,
          ),
          child: Padding(
            // Responsive padding
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth < 1400 ? 24 : 40,
            ),
            child: Row(
              children: [
                // Logo
                _AnimatedLogo(),
                const Spacer(),

                // Navigation Links (Desktop)
                if (!isSmallScreen) ...[
                  // Workouts Dropdown
                  WebHoverMenu(
                    title: l10n.navWorkouts,
                    route: AppRoutes.webWorkouts,
                    isActive: activeRoute == AppRoutes.webWorkouts,
                    items: [
                      l10n.navCardio,
                      l10n.navStrength,
                      l10n.navHybrid,
                      l10n.navRecover,
                    ],
                    onItemClick: (item) => context.go(AppRoutes.webWorkouts),
                  ),

                  _AnimatedNavLink(
                    title: l10n.navChallenge,
                    route: AppRoutes.webChallenges,
                    isActive: activeRoute == AppRoutes.webChallenges,
                  ),

                  // Branches Dropdown
                  WebHoverMenu(
                    title: l10n.navBranches,
                    route: AppRoutes.webBranches,
                    isActive: activeRoute == AppRoutes.webBranches,
                    items: [l10n.navAlgiers, l10n.navOran, l10n.navConstantine],
                    onItemClick: (item) => context.go(AppRoutes.webBranches),
                  ),

                  _AnimatedNavLink(
                    title: l10n.navPricing,
                    route: AppRoutes.webPricing,
                    isActive: activeRoute == AppRoutes.webPricing,
                  ),

                  // Partners Dropdown
                  WebHoverMenu(
                    title: l10n.navPartners,
                    route: AppRoutes.webPartners,
                    isActive: activeRoute == AppRoutes.webPartners,
                    items: [l10n.navNutrition, l10n.navGear, l10n.navSponsors],
                    onItemClick: (item) => context.go(AppRoutes.webPartners),
                  ),

                  _AnimatedNavLink(
                    title: l10n.navBlog,
                    route: AppRoutes.webBlog,
                    isActive: activeRoute == AppRoutes.webBlog,
                  ),
                  _AnimatedNavLink(
                    title: l10n.navContact,
                    route: AppRoutes.webContact,
                    isActive: activeRoute == AppRoutes.webContact,
                  ),
                  const SizedBox(width: 24),
                ],

                const Spacer(),

                // Action Area
                // Action Area
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Language Selector (Always Desktop Style)
                    _AnimatedLanguageButton(ref: ref),
                    const SizedBox(width: 12),

                    // Settings Button
                    _AnimatedIconButton(
                      icon: Icons.settings_outlined,
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierColor: Colors.black.withValues(alpha: 0.8),
                          builder: (context) => const WebSettingsDialog(),
                        );
                      },
                    ),

                    // Auth Buttons (Hidden on small screen)
                    if (!isSmallScreen) ...[
                      const SizedBox(width: 16),
                      _AnimatedCTAButton(label: l10n.navJoin),
                      const SizedBox(width: 12),
                      _AnimatedIconButton(
                        icon: Icons.person_outline,
                        onPressed: () => context.go(AppRoutes.login),
                        isAccent: true,
                      ),
                    ],

                    // Mobile Menu (Visible on small screen)
                    if (isSmallScreen) ...[
                      const SizedBox(width: 16),
                      _buildMobileMenu(context, l10n, isDark),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileMenu(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => MobileNavigationSheet(
            activeRoute: activeRoute,
            onDismiss: () => Navigator.pop(context),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.05),
          shape: BoxShape.circle,
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.1),
          ),
        ),
        child: Icon(
          Icons.menu,
          color: isDark ? Colors.white : Colors.black,
          size: 24,
        ),
      ),
    );
  }
}

class _AnimatedLogo extends StatefulWidget {
  @override
  State<_AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<_AnimatedLogo> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go(AppRoutes.splash),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          // Scale effect on hover
          transform: Matrix4.diagonal3Values(
            _isHovered ? 1.05 : 1.0,
            _isHovered ? 1.05 : 1.0,
            1.0,
          ),
          // Reserve layout space
          width: 100,
          height: 60,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // The Logo itself, raw and unclipped
              Positioned(
                top: -25, // Perfectly centered vertically (80 - 130) / 2 = -25
                child: SizedBox(
                  height: 130, // Way bigger for maximum visibility
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.broken_image,
                        color: Colors.white,
                        size: 40,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedNavLink extends StatefulWidget {
  final String title;
  final String route;
  final bool isActive;

  const _AnimatedNavLink({
    required this.title,
    required this.route,
    required this.isActive,
  });

  @override
  State<_AnimatedNavLink> createState() => _AnimatedNavLinkState();
}

class _AnimatedNavLinkState extends State<_AnimatedNavLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor = isDark ? Colors.white : Colors.black;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => context.go(widget.route),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: GoogleFonts.oswald(
                  fontSize: 16,
                  fontWeight: widget.isActive || _isHovered
                      ? FontWeight.w600
                      : FontWeight.w400,
                  letterSpacing: 1.2,
                  color: widget.isActive
                      ? AppColors.brandOrange
                      : (_isHovered ? AppColors.brandYellow : defaultColor),
                ),
                child: Text(widget.title.toUpperCase()),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: widget.isActive || _isHovered ? 20 : 0,
                height: 2,
                decoration: BoxDecoration(
                  gradient: AppColors.fieryGradient,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool isAccent;

  const _AnimatedIconButton({
    required this.icon,
    required this.onPressed,
    this.isAccent = false,
  });

  @override
  State<_AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<_AnimatedIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.05);
    final bgColorHover = isDark
        ? Colors.white.withValues(alpha: 0.15)
        : Colors.black.withValues(alpha: 0.1);
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.15)
        : Colors.black.withValues(alpha: 0.1);
    final borderColorHover = isDark
        ? Colors.white.withValues(alpha: 0.3)
        : Colors.black.withValues(alpha: 0.2);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _isHovered
                ? (widget.isAccent
                      ? AppColors.brandOrange.withValues(alpha: 0.2)
                      : bgColorHover)
                : bgColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: _isHovered
                  ? (widget.isAccent ? AppColors.brandOrange : borderColorHover)
                  : borderColor,
            ),
          ),
          child: Icon(
            widget.icon,
            color: _isHovered && widget.isAccent
                ? AppColors.brandOrange
                : iconColor,
            size: 20,
          ),
        ),
      ),
    );
  }
}

class _AnimatedLanguageButton extends StatefulWidget {
  final WidgetRef ref;
  const _AnimatedLanguageButton({required this.ref});

  @override
  State<_AnimatedLanguageButton> createState() =>
      _AnimatedLanguageButtonState();
}

class _AnimatedLanguageButtonState extends State<_AnimatedLanguageButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final currentLocale = widget.ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white70 : Colors.black54;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: PopupMenuButton<String>(
        icon: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _isHovered
                ? (isDark
                      ? Colors.white.withValues(alpha: 0.15)
                      : Colors.black.withValues(alpha: 0.1))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.language,
                color: _isHovered ? AppColors.brandOrange : iconColor,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                currentLocale.languageCode.toUpperCase(),
                style: GoogleFonts.inter(
                  color: _isHovered ? AppColors.brandOrange : iconColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        color: const Color(0xFF151515),
        offset: const Offset(0, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        onSelected: (langCode) {
          widget.ref.read(languageProvider.notifier).setLocale(langCode);
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
}

class _AnimatedCTAButton extends StatefulWidget {
  final String label;

  const _AnimatedCTAButton({required this.label});

  @override
  State<_AnimatedCTAButton> createState() => _AnimatedCTAButtonState();
}

class _AnimatedCTAButtonState extends State<_AnimatedCTAButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go(AppRoutes.register),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()
            // ignore: deprecated_member_use
            ..translate(0.0, _isHovered ? -3.0 : 0.0),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            gradient: AppColors.fieryGradient,
            borderRadius: BorderRadius.circular(4),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: AppColors.brandOrange.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.label.toUpperCase(),
                style: GoogleFonts.oswald(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  letterSpacing: 1,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 8),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                transform: Matrix4.identity()
                  // ignore: deprecated_member_use
                  ..translate(_isHovered ? 4.0 : 0.0, 0.0)
                  // ignore: deprecated_member_use
                  ..scale(_isHovered ? 1.05 : 1.0),
                child: const Icon(
                  Icons.arrow_forward,
                  size: 16,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
