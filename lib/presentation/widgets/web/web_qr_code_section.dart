import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gyelyseedz/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

/// Section showcasing the mobile app QR code check-in feature
class WebQRCodeSection extends StatelessWidget {
  const WebQRCodeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 60),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.webGradientStart, AppColors.webGradientMid],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: Phone Mockup with QR
          Expanded(
            child: Center(child: _PhoneMockup(l10n: l10n)),
          ),
          const SizedBox(width: 80),
          // Right: Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.premiumBlue.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.premiumBlue.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.phone_android,
                        size: 14,
                        color: AppColors.premiumBlue,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l10n.qrMobileApp,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.premiumBlueLight,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Title
                Text(
                  l10n.qrQuickAccess,
                  style: GoogleFonts.outfit(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [AppColors.premiumBlue, Colors.cyanAccent],
                  ).createShader(bounds),
                  child: Text(
                    l10n.qrWithQrCode,
                    style: GoogleFonts.outfit(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Description
                Text(
                  l10n.qrSectionDesc,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    color: Colors.grey[400],
                    height: 1.7,
                  ),
                ),
                const SizedBox(height: 40),
                // Features with hover
                _InteractiveFeatureItem(
                  icon: Icons.qr_code_scanner,
                  title: l10n.qrFeatureCheckin,
                  subtitle: l10n.qrFeatureCheckinDesc,
                ),
                const SizedBox(height: 16),
                _InteractiveFeatureItem(
                  icon: Icons.calendar_today,
                  title: l10n.qrFeatureBooking,
                  subtitle: l10n.qrFeatureBookingDesc,
                ),
                const SizedBox(height: 16),
                _InteractiveFeatureItem(
                  icon: Icons.notifications_active,
                  title: l10n.qrFeatureNotif,
                  subtitle: l10n.qrFeatureNotifDesc,
                ),
                const SizedBox(height: 40),
                // Download buttons with hover
                Row(
                  children: [
                    _AnimatedAppStoreButton(isApple: true, l10n: l10n),
                    const SizedBox(width: 16),
                    _AnimatedAppStoreButton(isApple: false, l10n: l10n),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PhoneMockup extends StatefulWidget {
  final AppLocalizations l10n;

  const _PhoneMockup({required this.l10n});

  @override
  State<_PhoneMockup> createState() => _PhoneMockupState();
}

class _PhoneMockupState extends State<_PhoneMockup> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()
          // ignore: deprecated_member_use
          ..translate(0.0, _isHovered ? -10.0 : 0.0)
          ..rotateZ(_isHovered ? -0.02 : 0.0),
        width: 300,
        height: 600,
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: Colors.grey[800]!, width: 8),
          boxShadow: [
            BoxShadow(
              color: AppColors.premiumBlue.withValues(
                alpha: _isHovered ? 0.5 : 0.3,
              ),
              blurRadius: _isHovered ? 100 : 80,
              offset: Offset(0, _isHovered ? 40 : 30),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Container(
            color: AppColors.darkBackground,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Status bar mockup
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '9:41',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.signal_cellular_4_bar,
                          size: 14,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.wifi, size: 14, color: Colors.white),
                        const SizedBox(width: 4),
                        Icon(Icons.battery_full, size: 14, color: Colors.white),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                // Title
                Text(
                  widget.l10n.appStoreMemberCard,
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                // QR Code with glow
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  width: 180,
                  height: 180,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.premiumBlue.withValues(
                          alpha: _isHovered ? 0.5 : 0.3,
                        ),
                        blurRadius: _isHovered ? 30 : 20,
                      ),
                    ],
                  ),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 8,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                        ),
                    itemCount: 64,
                    itemBuilder: (context, index) {
                      final isBlack =
                          (index % 3 == 0) ||
                          (index < 16 && index % 2 == 0) ||
                          (index > 48);
                      return Container(
                        decoration: BoxDecoration(
                          color: isBlack ? Colors.black : Colors.white,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'John Doe',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.l10n.appStorePremiumMember,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.premiumBlueLight,
                  ),
                ),
                const Spacer(),
                Container(
                  width: 120,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[700],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InteractiveFeatureItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InteractiveFeatureItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  State<_InteractiveFeatureItem> createState() =>
      _InteractiveFeatureItemState();
}

class _InteractiveFeatureItemState extends State<_InteractiveFeatureItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()
          // ignore: deprecated_member_use
          ..translate(_isHovered ? 10.0 : 0.0, 0.0),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _isHovered
              ? AppColors.premiumBlue.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.premiumBlue.withValues(
                  alpha: _isHovered ? 0.25 : 0.1,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: _isHovered
                    ? [
                        BoxShadow(
                          color: AppColors.premiumBlue.withValues(alpha: 0.4),
                          blurRadius: 12,
                          spreadRadius: 1,
                        ),
                      ]
                    : [],
              ),
              child: Icon(widget.icon, color: AppColors.premiumBlue, size: 24),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _isHovered
                        ? AppColors.premiumBlueLight
                        : Colors.white,
                  ),
                  child: Text(widget.title),
                ),
                Text(
                  widget.subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.grey[500],
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

class _AnimatedAppStoreButton extends StatefulWidget {
  final bool isApple;
  final AppLocalizations l10n;

  const _AnimatedAppStoreButton({required this.isApple, required this.l10n});

  @override
  State<_AnimatedAppStoreButton> createState() =>
      _AnimatedAppStoreButtonState();
}

class _AnimatedAppStoreButtonState extends State<_AnimatedAppStoreButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()
          // ignore: deprecated_member_use
          ..translate(0.0, _isHovered ? -6.0 : 0.0),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              widget.isApple
                  ? FontAwesomeIcons.apple
                  : FontAwesomeIcons.googlePlay,
              size: 24,
              color: Colors.black,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isApple
                      ? widget.l10n.appStoreDownloadOn
                      : widget.l10n.appStoreAvailableOn,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  widget.isApple ? 'App Store' : 'Google Play',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
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
