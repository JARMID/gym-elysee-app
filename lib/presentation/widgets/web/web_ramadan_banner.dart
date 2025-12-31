import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gyelyseedz/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

/// Special Ramadan banner displayed at the top of web pages during Ramadan
class WebRamadanBanner extends StatelessWidget {
  final VoidCallback? onDismiss;

  const WebRamadanBanner({super.key, this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.ramadanPurple,
            AppColors.ramadanDarkPurple,
            AppColors.ramadanPurple,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.ramadanGold.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Crescent Moon Icon
          _buildCrescentMoon(),
          const SizedBox(width: 16),

          // Greeting
          Text(
            l10n.ramadanBannerGreeting,
            style: GoogleFonts.oswald(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.ramadanGold,
            ),
          ),
          const SizedBox(width: 24),

          // Divider
          Container(
            width: 1,
            height: 24,
            color: AppColors.ramadanGold.withValues(alpha: 0.3),
          ),
          const SizedBox(width: 24),

          // Info Text
          Text(
            l10n.ramadanBannerTitle,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.ramadanGold.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.ramadanGold.withValues(alpha: 0.5),
              ),
            ),
            child: Text(
              l10n.ramadanBannerHours,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.ramadanGold,
              ),
            ),
          ),
          const SizedBox(width: 24),

          // Stars decoration
          _buildStars(),

          const Spacer(),

          // Dismiss button
          if (onDismiss != null)
            IconButton(
              onPressed: onDismiss,
              icon: Icon(
                Icons.close,
                size: 18,
                color: Colors.white.withValues(alpha: 0.7),
              ),
              splashRadius: 16,
            ),
        ],
      ),
    );
  }

  Widget _buildCrescentMoon() {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [AppColors.ramadanLightGold, AppColors.ramadanGold],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.ramadanGold.withValues(alpha: 0.5),
            blurRadius: 12,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Moon cutout effect
          Positioned(
            right: -4,
            child: Container(
              width: 20,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.ramadanPurple,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStars() {
    return Row(
      children: List.generate(3, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Icon(
            Icons.star,
            size: 10 + (index == 1 ? 4 : 0),
            color: AppColors.ramadanGold.withValues(
              alpha: 0.7 - (index * 0.15),
            ),
          ),
        );
      }),
    );
  }
}
