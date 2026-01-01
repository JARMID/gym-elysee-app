import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/web/web_footer.dart';
import '../../providers/theme_provider.dart';
import '../../providers/language_provider.dart';

/// Mobile-native landing page optimized for app experience
class MobileLandingPage extends ConsumerStatefulWidget {
  const MobileLandingPage({super.key});

  @override
  ConsumerState<MobileLandingPage> createState() => _MobileLandingPageState();
}

class _MobileLandingPageState extends ConsumerState<MobileLandingPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showBackToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 300 && !_showBackToTop) {
        setState(() => _showBackToTop = true);
      } else if (_scrollController.offset <= 300 && _showBackToTop) {
        setState(() => _showBackToTop = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0A0A) : Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // Hero
                _buildHero(context, l10n, isDark, screenHeight),

                // Quick Stats
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: _buildQuickStats(isDark),
                ),

                // Features
                FadeInUp(
                  delay: const Duration(milliseconds: 300),
                  child: _buildFeatures(context, isDark),
                ),

                // Branches Preview
                FadeInUp(
                  delay: const Duration(milliseconds: 400),
                  child: _buildBranchesPreview(context, isDark),
                ),

                // Testimonials
                FadeInUp(
                  delay: const Duration(milliseconds: 500),
                  child: _buildTestimonials(isDark),
                ),

                // CTA
                FadeInUp(
                  delay: const Duration(milliseconds: 600),
                  child: _buildCTA(context, isDark),
                ),

                // Footer
                const WebFooter(),
              ],
            ),
          ),

          // Back to Top Button
          if (_showBackToTop)
            Positioned(
              bottom: 20,
              right: 20,
              child: FadeIn(
                child: FloatingActionButton(
                  mini: true,
                  backgroundColor: AppColors.brandYellow,
                  onPressed: () {
                    _scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                    );
                  },
                  child: const Icon(
                    Icons.arrow_upward,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHero(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
    double screenHeight,
  ) {
    return SizedBox(
      height: screenHeight * 0.85,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.network(
            'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800&fit=crop',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Container(color: const Color(0xFF0A0A0A)),
          ),

          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.4),
                  Colors.black.withValues(alpha: 0.9),
                ],
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // Nav Bar
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        // Logo (premium positioning like desktop)
                        FadeInLeft(
                          child: GestureDetector(
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
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Center(
                                                child: ShaderMask(
                                                  blendMode: BlendMode.srcIn,
                                                  shaderCallback: (bounds) =>
                                                      AppColors.fieryGradient
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
                        ),
                        const Spacer(),

                        // Language Toggle
                        FadeInRight(child: _buildLanguageButton(context, ref)),

                        // Theme Toggle
                        FadeInRight(
                          child: GestureDetector(
                            onTap: () {
                              ref
                                  .read(themeNotifierProvider.notifier)
                                  .toggleTheme(
                                    Theme.of(context).brightness !=
                                        Brightness.dark,
                                  );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 12),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.08),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.15),
                                ),
                              ),
                              child: Icon(
                                Theme.of(context).brightness == Brightness.dark
                                    ? Icons.wb_sunny_rounded
                                    : Icons.nightlight_round,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),

                        // Menu
                        FadeInRight(child: _buildMenuButton(context, l10n)),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Title Section
                  FadeInUp(
                    delay: const Duration(milliseconds: 300),
                    child: Column(
                      children: [
                        // Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.brandYellow.withValues(
                              alpha: 0.15,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.brandYellow.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                          child: Text(
                            "🏆 #1 EN ALGÉRIE",
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.brandYellow,
                              letterSpacing: 1,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Title
                        Text(
                          "GYM",
                          style: GoogleFonts.oswald(
                            fontSize: 48,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            height: 1.1,
                          ),
                        ),
                        ShaderMask(
                          shaderCallback: (bounds) =>
                              AppColors.fieryGradient.createShader(bounds),
                          child: Text(
                            "ÉLYSÉE DZ",
                            style: GoogleFonts.oswald(
                              fontSize: 48,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              height: 1.1,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Subtitle
                        Text(
                          l10n.heroPivotSubtitle,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            color: Colors.grey[400],
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // CTA Buttons
                  FadeInUp(
                    delay: const Duration(milliseconds: 500),
                    child: Column(
                      children: [
                        _PrimaryButton(
                          label: "COMMENCER",
                          onTap: () => context.go(AppRoutes.register),
                        ),
                        const SizedBox(height: 12),
                        _SecondaryButton(
                          label: "SE CONNECTER",
                          onTap: () => context.go(AppRoutes.login),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Scroll hint
                  FadeInUp(
                    delay: const Duration(milliseconds: 700),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey[600],
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageButton(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(languageProvider);

    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: PopupMenuButton<String>(
        icon: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
          ),
          child: Text(
            currentLocale.languageCode.toUpperCase(),
            style: GoogleFonts.oswald(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
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

  Widget _buildMenuButton(BuildContext context, AppLocalizations l10n) {
    return PopupMenuButton<String>(
      icon: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        ),
        child: const Icon(Icons.menu, color: Colors.white, size: 22),
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

  Widget _buildQuickStats(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      color: isDark ? const Color(0xFF111111) : Colors.grey[50],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _statItem("6", "Branches", isDark),
          _divider(),
          _statItem("50+", "Coaches", isDark),
          _divider(),
          _statItem("10K+", "Membres", isDark),
        ],
      ),
    );
  }

  Widget _statItem(String value, String label, bool isDark) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) =>
              AppColors.fieryGradient.createShader(bounds),
          child: Text(
            value,
            style: GoogleFonts.oswald(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: isDark ? Colors.grey[500] : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 32,
      color: AppColors.brandYellow.withValues(alpha: 0.2),
    );
  }

  Widget _buildFeatures(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Pourquoi Nous?",
            style: GoogleFonts.oswald(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          _featureCard(
            FontAwesomeIcons.dumbbell,
            "Équipement Premium",
            "Matériel de dernière génération",
            isDark,
          ),
          const SizedBox(height: 12),
          _featureCard(
            FontAwesomeIcons.userTie,
            "Coaches Certifiés",
            "Entraîneurs professionnels",
            isDark,
          ),
          const SizedBox(height: 12),
          _featureCard(
            FontAwesomeIcons.clock,
            "Accès 24/7",
            "Ouverts tous les jours",
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _featureCard(
    IconData icon,
    String title,
    String subtitle,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: AppColors.fieryGradient.scale(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) =>
                    AppColors.fieryGradient.createShader(bounds),
                child: FaIcon(icon, size: 20),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.oswald(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBranchesPreview(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Nos Branches",
                style: GoogleFonts.oswald(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              TextButton(
                onPressed: () => context.go(AppRoutes.webBranches),
                child: Text(
                  "Voir tout",
                  style: GoogleFonts.inter(
                    color: AppColors.brandOrange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 140,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _branchCard("Alger Centre", "Flagship", isDark),
                const SizedBox(width: 12),
                _branchCard("Oran", "Premium", isDark),
                const SizedBox(width: 12),
                _branchCard("Constantine", "Standard", isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _branchCard(String name, String type, bool isDark) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.brandYellow.withValues(alpha: 0.2),
            AppColors.brandOrange.withValues(alpha: 0.1),
          ],
        ),
        border: Border.all(color: AppColors.brandYellow.withValues(alpha: 0.3)),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.brandYellow,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              type.toUpperCase(),
              style: GoogleFonts.oswald(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: GoogleFonts.oswald(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonials(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      color: isDark ? const Color(0xFF0A0A0A) : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Témoignages",
            style: GoogleFonts.oswald(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: PageView(
              children: [
                _testimonialCard(
                  "Meilleure salle de sport où j'ai jamais été! Les équipements sont de qualité et les coaches sont très professionnels.",
                  "Karim B.",
                  "Membre depuis 2 ans",
                  isDark,
                ),
                _testimonialCard(
                  "Ambiance exceptionnelle et résultats garantis. Je recommande vivement!",
                  "Sarah M.",
                  "Membre depuis 1 an",
                  isDark,
                ),
                _testimonialCard(
                  "Programme de CrossFit incroyable. J'ai atteint tous mes objectifs en 6 mois.",
                  "Ahmed K.",
                  "Membre depuis 6 mois",
                  isDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _testimonialCard(
    String text,
    String name,
    String duration,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(
              5,
              (index) =>
                  Icon(Icons.star, color: AppColors.brandYellow, size: 16),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: isDark ? Colors.grey[400] : Colors.grey[700],
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: GoogleFonts.oswald(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          Text(
            duration,
            style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildCTA(BuildContext context, bool isDark) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.fieryGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            "Prêt à Commencer?",
            style: GoogleFonts.oswald(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Essai gratuit de 7 jours",
            style: GoogleFonts.inter(fontSize: 13, color: Colors.black87),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.go(AppRoutes.register),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "S'INSCRIRE MAINTENANT",
                style: GoogleFonts.oswald(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Footer implementation moved to WebFooter widget
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _PrimaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brandYellow,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: GoogleFonts.oswald(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward, size: 18),
          ],
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _SecondaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.white.withValues(alpha: 0.4)),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          label,
          style: GoogleFonts.oswald(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
