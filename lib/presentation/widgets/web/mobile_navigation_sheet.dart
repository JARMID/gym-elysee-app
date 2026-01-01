import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routing/app_router.dart';
import '../../../l10n/app_localizations.dart';

class MobileNavigationSheet extends StatelessWidget {
  final String? activeRoute;
  final VoidCallback onDismiss;

  const MobileNavigationSheet({
    super.key,
    this.activeRoute,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final menuItems = [
      (l10n.navHome, AppRoutes.splash, FontAwesomeIcons.house),
      (l10n.navWorkouts, AppRoutes.webWorkouts, FontAwesomeIcons.dumbbell),
      (l10n.navChallenge, AppRoutes.webChallenges, FontAwesomeIcons.fire),
      (l10n.navBranches, AppRoutes.webBranches, FontAwesomeIcons.locationDot),
      (l10n.navPricing, AppRoutes.webPricing, FontAwesomeIcons.creditCard),
      (l10n.navPartners, AppRoutes.webPartners, FontAwesomeIcons.handshake),
      (l10n.navBlog, AppRoutes.webBlog, FontAwesomeIcons.newspaper),
      (l10n.navContact, AppRoutes.webContact, FontAwesomeIcons.envelope),
    ];

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0A0A) : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo
                  Image.asset(
                    'assets/images/logo.png',
                    height: 40,
                    errorBuilder: (_, __, ___) => const SizedBox(width: 40),
                  ),
                  // Close Button
                  IconButton(
                    onPressed: onDismiss,
                    icon: Icon(
                      Icons.close,
                      color: isDark ? Colors.white : Colors.black,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Colors.white10),

            // Menu Items
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...menuItems.map(
                      (item) => _buildMenuItem(
                        context,
                        item.$1,
                        item.$2,
                        item.$3,
                        isActive: activeRoute == item.$2,
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Divider(color: Colors.white10),
                    const SizedBox(height: 24),
                    _buildMenuItem(
                      context,
                      l10n.navLogin,
                      AppRoutes.login,
                      FontAwesomeIcons.rightToBracket,
                      isActive: false,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 16),
                    _buildCTAButton(context, l10n.navJoin),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String label,
    String route,
    IconData icon, {
    required bool isActive,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: InkWell(
        onTap: () {
          context.push(route); // Using push to keep nav logic simple, or go
          onDismiss();
        },
        child: Row(
          children: [
            Icon(
              icon,
              color: isActive
                  ? AppColors.brandOrange
                  : (isDark ? Colors.white54 : Colors.black54),
              size: 20,
            ),
            const SizedBox(width: 20),
            Text(
              label.toUpperCase(),
              style: GoogleFonts.oswald(
                fontSize: 24,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive
                    ? AppColors.brandOrange
                    : (isDark ? Colors.white : Colors.black),
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCTAButton(BuildContext context, String label) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          context.go(AppRoutes.register);
          onDismiss();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brandOrange,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: Text(
          label.toUpperCase(),
          style: GoogleFonts.oswald(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }
}
