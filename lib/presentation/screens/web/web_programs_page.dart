import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routing/app_router.dart';
import '../../widgets/web/web_nav_bar.dart';
import '../../widgets/web/web_footer.dart';

class WebProgramsPage extends StatelessWidget {
  const WebProgramsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const WebNavBar(),
            _buildHeader(context, isDark),
            _buildProgramsGrid(context, isDark),
            const WebFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Column(
        children: [
          Text(
            "NOS PROGRAMMES",
            style: GoogleFonts.inter(
              color: AppColors.brandOrange,
              letterSpacing: 3,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.oswald(
                fontSize: 56,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
                height: 1.1,
              ),
              children: [
                const TextSpan(text: "TROUVEZ VOTRE\n"),
                WidgetSpan(
                  child: Text(
                    "DISCIPLINE",
                    style: GoogleFonts.oswald(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      color: AppColors.brandOrange,
                      height: 1.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgramsGrid(BuildContext context, bool isDark) {
    final programs = _getPrograms();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 900;
              final width = isDesktop
                  ? (constraints.maxWidth - 40) / 2
                  : constraints.maxWidth;

              return Wrap(
                spacing: 40,
                runSpacing: 40,
                children: programs
                    .map(
                      (p) => SizedBox(
                        width: width,
                        child: _ProgramCard(program: p, isDark: isDark),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getPrograms() {
    return [
      {
        'icon': FontAwesomeIcons.dumbbell,
        'iconColor': const Color(0xFFFFC107), // Yellow/Amber
        'title': 'MUSCULATION',
        'subtitle': 'FORCE & HYPERTROPHIE',
        'duration': '60-90 min',
        'level': 'Tous niveaux',
        'description':
            'Programme complet de développement musculaire avec suivi personnalisé et nutrition adaptée.',
        'features': [
          'Programme personnalisé',
          'Suivi progression mensuel',
          'Plan nutritionnel inclus',
          'Accès zone premium',
        ],
      },
      {
        'icon': FontAwesomeIcons.handFist,
        'iconColor': const Color(0xFFFF5722), // Deep Orange
        'title': 'BOXING',
        'subtitle': 'NOBLE ART',
        'duration': '60-75 min',
        'level': 'Débutant à Pro',
        'description':
            'Apprenez la boxe anglaise avec nos champions. Technique, cardio et mental d\'acier.',
        'features': [
          'Technique de frappe',
          'Footwork & déplacements',
          'Sparring contrôlé',
          'Préparation compétition',
        ],
      },
      {
        'icon': FontAwesomeIcons.shieldHalved,
        'iconColor': const Color(0xFFF44336), // Red
        'title': 'MMA',
        'subtitle': 'MIXED MARTIAL ARTS',
        'duration': '90-120 min',
        'level': 'Intermédiaire+',
        'description':
            'L\'art du combat complet. Striking, grappling et soumission dans un seul programme.',
        'features': [
          'Striking complet',
          'Takedowns & contrôle',
          'Ground game',
          'Cage training',
        ],
      },
      {
        'icon': FontAwesomeIcons.bullseye,
        'iconColor': const Color(0xFF4CAF50), // Green
        'title': 'GRAPPLING',
        'subtitle': 'BJJ & WRESTLING',
        'duration': '60-90 min',
        'level': 'Tous niveaux',
        'description':
            'Maîtrisez l\'art du combat au sol. Soumissions, contrôles et escapes.',
        'features': [
          'Positions fondamentales',
          'Soumissions avancées',
          'Wrestling takedowns',
          'Compétition IBJJF',
        ],
      },
      {
        'icon': FontAwesomeIcons.heart,
        'iconColor': const Color(0xFFE040FB), // PurpleAccent
        'title': 'FITNESS FÉMININ',
        'subtitle': '100% WOMEN ONLY',
        'duration': '45-60 min',
        'level': 'Tous niveaux',
        'description':
            'Espace exclusif pour les femmes. Fitness, tonification et self-défense.',
        'features': [
          'Cours collectifs variés',
          'Zone cardio dédiée',
          'Self-défense féminine',
          'Spa & bien-être',
        ],
      },
      {
        'icon': FontAwesomeIcons.trophy,
        'iconColor': const Color(0xFFFFAB00), // AmberAccent
        'title': 'CROSSFIT',
        'subtitle': 'CONSTAMMENT VARIÉ',
        'duration': '60 min',
        'level': 'Tous niveaux',
        'description':
            'Mouvements fonctionnels exécutés à haute intensité. Communauté, défi et résultats.',
        'features': [
          'WOD quotidien',
          'Coaching certifié',
          'Communauté active',
          'Progression mesurable',
        ],
      },
    ];
  }
}

class _ProgramCard extends StatefulWidget {
  final Map<String, dynamic> program;
  final bool isDark;

  const _ProgramCard({required this.program, required this.isDark});

  @override
  State<_ProgramCard> createState() => _ProgramCardState();
}

class _ProgramCardState extends State<_ProgramCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final program = widget.program;
    final Color iconColor = program['iconColor'];

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()
          // ignore: deprecated_member_use
          ..translate(0.0, _isHovered ? -8.0 : 0.0),
        decoration: BoxDecoration(
          color: widget.isDark ? const Color(0xFF0F0F0F) : Colors.white,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: iconColor.withValues(alpha: 0.1),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Color Bar
            Container(
              height: 4,
              width: double.infinity,
              decoration: BoxDecoration(
                color: iconColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: iconColor.withValues(alpha: 0.6),
                    blurRadius: 8,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row: Icon + Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon with Gradient Background
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              iconColor,
                              iconColor.withValues(alpha: 0.6),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: iconColor.withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: FaIcon(
                            program['icon'],
                            color: Colors.black.withValues(alpha: 0.8),
                            size: 28,
                          ),
                        ),
                      ),
                      // Stats (Duration & Level)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildStatBadge(
                            Icons.access_time,
                            program['duration'],
                          ),
                          const SizedBox(height: 8),
                          _buildStatBadge(
                            Icons.people_outline,
                            program['level'],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Title & Subtitle
                  Text(
                    program['title'].toString().toUpperCase(),
                    style: GoogleFonts.oswald(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: widget.isDark ? Colors.white : Colors.black,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    program['subtitle'].toString().toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: iconColor,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Description
                  Text(
                    program['description'],
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: Colors.grey[400],
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Features Grid
                  Wrap(
                    spacing: 24,
                    runSpacing: 16,
                    children: (program['features'] as List<String>).map((
                      feature,
                    ) {
                      return SizedBox(
                        width: 200, // Fixed width for alignment
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: iconColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.black,
                                size: 12,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                feature,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: Colors.grey[300],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 40),

                  // CTA Button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () => context.go(AppRoutes.register),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brandOrange,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'COMMENCER',
                            style: GoogleFonts.oswald(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.arrow_forward, size: 18),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBadge(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.grey[500], size: 14),
        const SizedBox(width: 6),
        Text(
          text,
          style: GoogleFonts.inter(
            color: Colors.grey[400],
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
