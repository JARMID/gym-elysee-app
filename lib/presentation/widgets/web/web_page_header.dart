import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_colors.dart';

/// Standardized page header for all web pages
/// Provides consistent gradient title, subtitle, and animations
class WebPageHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool useGradientTitle;
  final double? fontSize;

  const WebPageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.useGradientTitle = true,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final effectiveFontSize = fontSize ?? (isMobile ? 40 : 60);

    return FadeInDown(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: isMobile ? 40 : 80,
          horizontal: isMobile ? 20 : 100,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              isDark ? AppColors.darkBackground : Colors.grey[100]!,
            ],
          ),
        ),
        child: Column(
          children: [
            // Title
            if (useGradientTitle)
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) =>
                    AppColors.fieryGradient.createShader(bounds),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.oswald(
                    fontSize: effectiveFontSize,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: AppColors.brandOrange.withValues(alpha: 0.5),
                        blurRadius: 30,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                ),
              )
            else
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.oswald(
                  fontSize: effectiveFontSize,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),

            // Subtitle
            if (subtitle != null) ...[
              const SizedBox(height: 16),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 14 : 18,
                  color: Colors.grey[400],
                  height: 1.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
