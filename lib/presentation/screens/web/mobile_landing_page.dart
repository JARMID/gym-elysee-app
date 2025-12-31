import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';

/// Enhanced mobile-optimized landing page with navigation and rich content
class MobileLandingPage extends StatefulWidget {
  const MobileLandingPage({super.key});

  @override
  State<MobileLandingPage> createState() => _MobileLandingPageState();
}

class _MobileLandingPageState extends State<MobileLandingPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: isDark ? AppColors.darkBackground : Colors.white,
      drawer: _buildDrawer(context, l10n, isDark),
      body: Stack(
        children: [
          // Main scrollable content
          SingleChildScrollView(
            child: Column(
              children: [
                // Hero Section with Background Image
                _buildHeroSection(context, l10n, isDark),

                // Stats Section
                _buildStatsSection(context, l10n, isDark),

                // Features Section
                _buildFeaturesSection(context, l10n, isDark),

                // CTA Section
                _buildCTASection(context, l10n, isDark),

                // Footer
                _buildFooter(context, l10n, isDark),
              ],
            ),
          ),

          // Floating App Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildAppBar(context, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        bottom: 12,
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.7),
            Colors.black.withValues(alpha: 0.3),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        children: [
          // Menu Button
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 28),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          const Spacer(),
          // Logo
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.brandYellow, width: 2),
            ),
            child: Center(
              child: Text(
                'E',
                style: GoogleFonts.oswald(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.brandYellow,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    return Drawer(
      backgroundColor: isDark ? const Color(0xFF0A0A0A) : Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.brandYellow, AppColors.brandOrange],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'GYM ÉLYSÉE DZ',
                    style: GoogleFonts.oswald(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Premium Fitness',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            // Menu Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildDrawerItem(
                    icon: FontAwesomeIcons.dumbbell,
                    title: 'Accueil',
                    onTap: () {
                      Navigator.pop(context);
                      context.go(AppRoutes.webLanding);
                    },
                    isDark: isDark,
                  ),
                  _buildDrawerItem(
                    icon: FontAwesomeIcons.locationDot,
                    title: 'Nos Branches',
                    onTap: () {
                      Navigator.pop(context);
                      context.go(AppRoutes.webBranches);
                    },
                    isDark: isDark,
                  ),
                  _buildDrawerItem(
                    icon: FontAwesomeIcons.personRunning,
                    title: 'Programmes',
                    onTap: () {
                      Navigator.pop(context);
                      context.go(AppRoutes.webWorkouts);
                    },
                    isDark: isDark,
                  ),
                  _buildDrawerItem(
                    icon: FontAwesomeIcons.users,
                    title: 'Coaches',
                    onTap: () {
                      Navigator.pop(context);
                      context.go(AppRoutes.webCoaches);
                    },
                    isDark: isDark,
                  ),
                  _buildDrawerItem(
                    icon: FontAwesomeIcons.creditCard,
                    title: 'Tarifs',
                    onTap: () {
                      Navigator.pop(context);
                      context.go(AppRoutes.webPricing);
                    },
                    isDark: isDark,
                  ),
                  const Divider(height: 32),
                  _buildDrawerItem(
                    icon: FontAwesomeIcons.rightToBracket,
                    title: 'Se Connecter',
                    onTap: () {
                      Navigator.pop(context);
                      context.go(AppRoutes.login);
                    },
                    isDark: isDark,
                    isAccent: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool isDark,
    bool isAccent = false,
  }) {
    return ListTile(
      leading: FaIcon(
        icon,
        color: isAccent
            ? AppColors.brandYellow
            : (isDark ? Colors.white70 : Colors.black87),
        size: 20,
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          color: isAccent
              ? AppColors.brandYellow
              : (isDark ? Colors.white : Colors.black87),
          fontWeight: isAccent ? FontWeight.bold : FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildHeroSection(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    return Container(
      height: 600,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.network(
            'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=1200&fit=crop',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Container(color: Colors.grey[900]),
          ),

          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.6),
                  Colors.black.withValues(alpha: 0.8),
                ],
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                // Title
                Text(
                  'GYM',
                  style: GoogleFonts.oswald(
                    fontSize: 48,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    height: 1.0,
                  ),
                ),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [AppColors.brandYellow, AppColors.brandOrange],
                  ).createShader(bounds),
                  child: Text(
                    'ÉLYSÉE DZ',
                    style: GoogleFonts.oswald(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.0,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Subtitle
                Text(
                  'La plus grande chaîne de salles de sport premium en Algérie',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.9),
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 40),

                // CTA Buttons
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.go(AppRoutes.register),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brandYellow,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ESSAI GRATUIT',
                          style: GoogleFonts.oswald(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, size: 20),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => context.go(AppRoutes.login),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white, width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'SE CONNECTER',
                      style: GoogleFonts.oswald(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // Scroll Indicator
                Column(
                  children: [
                    Text(
                      'DÉCOUVRIR',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: Colors.white70,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.brandYellow,
                      size: 24,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      color: isDark ? Colors.black : Colors.grey[100],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStat('6', 'Branches', isDark),
          Container(
            width: 1,
            height: 40,
            color: AppColors.brandYellow.withValues(alpha: 0.3),
          ),
          _buildStat('50+', 'Coaches', isDark),
          Container(
            width: 1,
            height: 40,
            color: AppColors.brandYellow.withValues(alpha: 0.3),
          ),
          _buildStat('10K+', 'Membres', isDark),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label, bool isDark) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [AppColors.brandYellow, AppColors.brandOrange],
          ).createShader(bounds),
          child: Text(
            value,
            style: GoogleFonts.oswald(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: isDark ? Colors.grey[400] : Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesSection(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildFeatureCard(
            icon: FontAwesomeIcons.dumbbell,
            title: 'Équipements Premium',
            description: 'Matériel de pointe pour tous vos besoins',
            color: AppColors.brandYellow,
            isDark: isDark,
          ),
          const SizedBox(height: 16),
          _buildFeatureCard(
            icon: FontAwesomeIcons.userGraduate,
            title: 'Coaches Professionnels',
            description: 'Entraîneurs certifiés et expérimentés',
            color: const Color(0xFF4CAF50),
            isDark: isDark,
          ),
          const SizedBox(height: 16),
          _buildFeatureCard(
            icon: FontAwesomeIcons.fire,
            title: 'Programmes Variés',
            description: 'Boxing, MMA, Musculation, CrossFit',
            color: AppColors.brandOrange,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: FaIcon(icon, color: color, size: 24)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.oswald(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: isDark ? Colors.grey[400] : Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCTASection(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.brandYellow, AppColors.brandOrange],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'Prêt à Commencer?',
            style: GoogleFonts.oswald(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Rejoignez la meilleure chaîne de fitness en Algérie',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.go(AppRoutes.webBranches),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'VOIR NOS BRANCHES',
                    style: GoogleFonts.oswald(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      color: isDark ? Colors.black : Colors.grey[200],
      child: Column(
        children: [
          Text(
            '© 2025 GYM ÉLYSÉE DZ',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: isDark ? Colors.grey[600] : Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => context.go(AppRoutes.webContact),
                child: Text(
                  'Contact',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.brandYellow,
                  ),
                ),
              ),
              Text('•', style: TextStyle(color: Colors.grey[600])),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Privacy',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.brandYellow,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
