import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class WebDownloadAppSection extends StatelessWidget {
  const WebDownloadAppSection({super.key});

  Future<void> _downloadApk() async {
    // This URL assumes the APK is placed in build/web/downloads/app-release.apk
    final Uri url = Uri.parse('/downloads/app-release.apk');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Responsive break point
    final isMobile = MediaQuery.of(context).size.width < 900;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      color: isDark ? AppColors.darkBackground : Colors.grey[100],
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          decoration: BoxDecoration(
            gradient: AppColors.fieryGradient, // Using brand gradient
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppColors.brandOrange.withValues(alpha: 0.3),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: isMobile
              ? _buildMobileLayout(context)
              : _buildDesktopLayout(context),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(60),
      child: Row(
        children: [
          Expanded(flex: 5, child: _buildTextContent(context)),
          const SizedBox(width: 40),
          Expanded(flex: 4, child: _buildPhoneMockup(context)),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          _buildPhoneMockup(context),
          const SizedBox(height: 40),
          _buildTextContent(context, centered: true),
        ],
      ),
    );
  }

  Widget _buildTextContent(BuildContext context, {bool centered = false}) {
    return Column(
      crossAxisAlignment: centered
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'EMPORTEZ GYM ÉLYSÉE\nPARTOUT AVEC VOUS',
          textAlign: centered ? TextAlign.center : TextAlign.start,
          style: GoogleFonts.oswald(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Planifiez vos séances, suivez vos progrès et accédez à du contenu exclusif directement depuis votre poche. L\'expérience ultime, maintenant mobile.',
          textAlign: centered ? TextAlign.center : TextAlign.start,
          style: GoogleFonts.inter(
            fontSize: 18,
            color: Colors.white.withValues(alpha: 0.9),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: _downloadApk,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.brandOrange,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 25),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            elevation: 10,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(FontAwesomeIcons.circleArrowDown),
              const SizedBox(width: 12),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TÉLÉCHARGER L\'APPLICATION',
                    style: GoogleFonts.oswald(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    'Version Android (APK DIRECT)',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: AppColors.brandOrange.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneMockup(BuildContext context) {
    return Transform.rotate(
      angle: 0.1,
      child: Container(
        height: 400,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: Colors.grey[800]!, width: 8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 20,
              offset: const Offset(10, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Stack(
            children: [
              // Screen content placeholder
              Container(
                width: double.infinity,
                height: double.infinity,
                color: const Color(0xFF1E1E1E),
                child: Column(
                  children: [
                    // Status bar
                    Container(
                      height: 30,
                      color: Colors.black,
                      child: const Center(
                        child: Icon(Icons.lens, size: 8, color: Colors.white),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.fitness_center,
                              color: AppColors.brandOrange,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'GYM ÉLYSÉE',
                              style: GoogleFonts.oswald(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'App Coming Soon',
                              style: GoogleFonts.inter(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Navigation bar
                    Container(
                      height: 60,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2C2C2C),
                        border: Border(top: BorderSide(color: Colors.white10)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(Icons.home, color: AppColors.brandOrange),
                          const Icon(Icons.calendar_today, color: Colors.grey),
                          const Icon(Icons.person, color: Colors.grey),
                        ],
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
