import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gyelyseedz/l10n/app_localizations.dart';

import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/landing_providers.dart';
import '../../../data/models/branch_model.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/web/web_footer.dart';
import '../../widgets/web/web_map_section.dart';
import '../../widgets/web/web_nav_bar.dart';

class WebBranchesPage extends ConsumerStatefulWidget {
  const WebBranchesPage({super.key});

  @override
  ConsumerState<WebBranchesPage> createState() => _WebBranchesPageState();
}

class _WebBranchesPageState extends ConsumerState<WebBranchesPage> {
  @override
  Widget build(BuildContext context) {
    final branchesAsync = ref.watch(branchesProvider);
    final isRamadanMode = ref.watch(ramadanModeProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: isRamadanMode ? 130 : 80),

                FadeInDown(
                  duration: const Duration(milliseconds: 800),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 80),
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
                        // Tag
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 40,
                              height: 1.5,
                              color: AppColors.gold,
                            ),
                            const SizedBox(width: 16),
                            const FaIcon(
                              FontAwesomeIcons.dumbbell,
                              color: AppColors.gold,
                              size: 14,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n.branchesTitleTag,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.gold,
                                letterSpacing: 3,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Title
                        Text(
                          l10n.branchesTitleFirst,
                          style: GoogleFonts.oswald(
                            fontSize: 72,
                            fontWeight: FontWeight.bold,
                            color: AppColors.gold,
                            height: 1.0,
                          ),
                        ),
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.brandOrange,
                              AppColors.brandYellow,
                            ],
                          ).createShader(bounds),
                          child: Text(
                            l10n.branchesTitleSecond,
                            style: GoogleFonts.oswald(
                              fontSize: 72,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          l10n.branchesSubtitle,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            color: Colors.grey[400],
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Branches Grid
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 40,
                  ),
                  child: branchesAsync.when(
                    data: (branches) {
                      final displayBranches = branches.isNotEmpty
                          ? branches.take(6).toList()
                          : [
                              {
                                'name': 'GYM ÉLYSÉE DZ',
                                'id': 1,
                                'loc': 'Hydra, Alger',
                                'tags': [
                                  'Flagship',
                                  'Musculation',
                                  'Boxing',
                                  'MMA',
                                ],
                                'type': 'flagship',
                                'desc':
                                    'Notre salle flagship offre une expérience fitness complète avec équipements de dernière génération...',
                              },
                              {
                                'name': 'GYM ÉLYSÉE BOXE',
                                'id': 2,
                                'loc': 'Bab El Oued, Alger',
                                'tags': [
                                  'Boxe Anglaise',
                                  'Préparation Physique',
                                ],
                                'type': 'boxing',
                                'desc':
                                    'Temple de la boxe anglaise en Algérie, notre centre de Bab El Oued a formé plusieurs champions...',
                              },
                              {
                                'name': 'TIGER SPORT DZ',
                                'id': 3,
                                'loc': 'Bouchaoui, Alger',
                                'tags': [
                                  'MMA',
                                  'Striking',
                                  'Lutte',
                                  'Jiu-Jitsu',
                                ],
                                'type': 'mma',
                                'desc':
                                    'Tiger Sport DZ est le centre de référence pour les arts martiaux mixtes en Algérie...',
                              },
                              {
                                'name': 'GYM ÉLYSÉE GRAPPLING',
                                'id': 4,
                                'loc': 'Constantine',
                                'tags': [
                                  'Jiu-Jitsu Brésilien',
                                  'Wrestling',
                                  'No-Gi',
                                ],
                                'type': 'grappling',
                                'desc':
                                    'Spécialisé dans le grappling, notre centre de Constantine offre un enseignement de classe mondiale...',
                              },
                              {
                                'name': 'GYM ÉLYSÉE FEMMES',
                                'id': 5,
                                'loc': 'Cheraga, Alger',
                                'tags': [
                                  'Femmes Only',
                                  'Fitness',
                                  'Cardio',
                                  'Self-Défense',
                                ],
                                'type': 'women',
                                'desc':
                                    'Un espace exclusivement féminin où les femmes peuvent s\'entraîner en toute sérénité...',
                              },
                              {
                                'name': 'GYM ÉLYSÉE CROSSFIT',
                                'id': 6,
                                'loc': 'Ben Aknoun, Alger',
                                'tags': ['CrossFit', 'WOD', 'Haltérophilie'],
                                'type': 'crossfit',
                                'desc':
                                    'Le centre CrossFit offre des WODs quotidiens, une communauté dynamique et des équipements officiels...',
                              },
                            ];

                      return LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth > 1000;
                          final cardWidth = isWide
                              ? (constraints.maxWidth - 40) / 2 - 20
                              : constraints.maxWidth;

                          return Wrap(
                            spacing: 40,
                            runSpacing: 40,
                            alignment: WrapAlignment.center,
                            children: displayBranches.map<Widget>((b) {
                              return SizedBox(
                                width: cardWidth,
                                child: _InteractiveHorizontalBranchCard(
                                  branch: b,
                                  l10n: l10n,
                                ),
                              );
                            }).toList(),
                          );
                        },
                      );
                    },
                    loading: () => const Center(
                      child: CircularProgressIndicator(color: AppColors.gold),
                    ),
                    error: (err, stack) => Center(
                      child: Text(
                        'Erreur: $err',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 60),
                const WebMapSection(),

                // CTA Section
                FadeInUp(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 100),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.black,
                          AppColors.darkBackground,
                          Colors.brown.withValues(alpha: 0.2),
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: l10n.branchesCtaTitle1,
                                style: GoogleFonts.oswald(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              TextSpan(
                                text: l10n.branchesCtaTitle2,
                                style: GoogleFonts.oswald(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  foreground: Paint()
                                    ..shader =
                                        LinearGradient(
                                          colors: [
                                            AppColors.brandOrange,
                                            AppColors.brandYellow,
                                          ],
                                        ).createShader(
                                          const Rect.fromLTWH(0, 0, 200, 50),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          l10n.branchesCtaSubtitle,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            color: Colors.grey[400],
                          ),
                        ),
                        const SizedBox(height: 40),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.brandYellow,
                                AppColors.brandOrange,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () => context.go(AppRoutes.webContact),
                            icon: const FaIcon(
                              FontAwesomeIcons.dumbbell,
                              size: 16,
                              color: Colors.black,
                            ),
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  l10n.branchesCtaButton,
                                  style: GoogleFonts.oswald(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    letterSpacing: 1,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.arrow_forward,
                                  size: 16,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const WebFooter(),
              ],
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: WebNavBar(
              isScrolled: true,
              activeRoute: AppRoutes.webBranches,
            ),
          ),
        ],
      ),
    );
  }
}

class _InteractiveHorizontalBranchCard extends StatefulWidget {
  final dynamic branch;
  final AppLocalizations l10n;

  const _InteractiveHorizontalBranchCard({
    required this.branch,
    required this.l10n,
  });

  @override
  State<_InteractiveHorizontalBranchCard> createState() =>
      _InteractiveHorizontalBranchCardState();
}

class _InteractiveHorizontalBranchCardState
    extends State<_InteractiveHorizontalBranchCard> {
  bool _isHovered = false;

  IconData _getBranchIcon(String type) {
    switch (type) {
      case 'flagship':
        return Icons.fitness_center;
      case 'boxing':
        return Icons.sports_mma;
      case 'mma':
        return Icons.sports_martial_arts;
      case 'grappling':
        return Icons.sports;
      case 'women':
        return Icons.woman;
      case 'crossfit':
        return Icons.fitness_center;
      default:
        return Icons.location_on;
    }
  }

  String _getBranchCoverImage(String type) {
    switch (type) {
      case 'flagship':
        return 'https://images.unsplash.com/photo-1540497077202-7c8a3999166f?w=1200&fit=crop';
      case 'boxing':
        return 'https://images.unsplash.com/photo-1599058945522-28d584b6f0ff?w=1200&fit=crop';
      case 'mma':
        return 'https://images.unsplash.com/photo-1595078475328-1ab05d0a6a0e?w=1200&fit=crop';
      case 'grappling':
        return 'https://images.unsplash.com/photo-1615117968536-bb1d8820c4aa?w=1200&fit=crop';
      case 'women':
        return 'https://images.unsplash.com/photo-1518310383802-640c2de311b2?w=1200&fit=crop';
      case 'crossfit':
        return 'https://images.unsplash.com/photo-1517963879466-8025ikde4383?w=1200&fit=crop';
      default:
        return 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=1200&fit=crop';
    }
  }

  @override
  Widget build(BuildContext context) {
    String type;
    String name;
    String desc;
    List<String> tags;
    int id;
    String loc;

    if (widget.branch is BranchModel) {
      type = widget.branch.type;
      name = widget.branch.name;
      desc = widget.branch.description;
      tags = (widget.branch.tags != null && widget.branch.tags!.isNotEmpty)
          ? widget.branch.tags!
          : ['Sport'];
      id = widget.branch.id;
      loc = '${widget.branch.city}, ${widget.branch.wilaya}';
    } else {
      type = widget.branch['type'] ?? 'flagship';
      name = widget.branch['name'] ?? 'Branch';
      desc = widget.branch['desc'] ?? '';
      tags = List<String>.from(widget.branch['tags'] ?? []);
      id = widget.branch['id'] ?? 1;
      loc = widget.branch['loc'] ?? 'Algeria';
    }

    final isWomen = type == 'women';
    final accentColor = isWomen ? const Color(0xFFFF4081) : AppColors.gold;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go('/branch-details/$id'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          height: 260,
          transform: Matrix4.identity()
            // ignore: deprecated_member_use
            ..translate(0.0, _isHovered ? -8.0 : 0.0),
          decoration: BoxDecoration(
            color: const Color(0xFF151515),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered ? accentColor : Colors.white10,
              width: _isHovered ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? accentColor.withValues(alpha: 0.2)
                    : Colors.black.withValues(alpha: 0.6),
                blurRadius: _isHovered ? 30 : 20,
                offset: _isHovered ? const Offset(0, 15) : const Offset(0, 8),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(
            children: [
              // Left Image
              Expanded(
                flex: 4,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      _getBranchCoverImage(type),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[900],
                        child: Icon(
                          _getBranchIcon(type),
                          size: 48,
                          color: accentColor.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                    Container(color: Colors.black.withValues(alpha: 0.3)),

                    // Hover overlay on image
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: _isHovered ? 0.2 : 0.0,
                      child: Container(color: accentColor),
                    ),

                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: accentColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(color: Colors.black26, blurRadius: 4),
                          ],
                        ),
                        child: Text(
                          tags.isNotEmpty
                              ? tags.first
                              : widget.l10n.branchesTagPremium,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Right Content
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.oswald(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 14,
                                    color: accentColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    loc,
                                    style: GoogleFonts.inter(
                                      color: Colors.grey[400],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            desc,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              color: Colors.grey[400],
                              height: 1.5,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),

                      // Hours & Ramadan
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 14,
                                color: Colors.white70,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                widget.l10n.branchesHoursWeek,
                                style: GoogleFonts.inter(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF330000),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: Colors.red.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  FontAwesomeIcons.moon,
                                  size: 10,
                                  color: Colors.red,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  widget.l10n.branchesHoursRamadan,
                                  style: GoogleFonts.inter(
                                    color: Colors.red,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Tags and Button
                      Row(
                        children: [
                          Expanded(
                            child: Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: tags.skip(1).take(2).map((tag) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white12),
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.white.withValues(alpha: 0.05),
                                  ),
                                  child: Text(
                                    tag,
                                    style: GoogleFonts.inter(
                                      color: Colors.grey[400],
                                      fontSize: 10,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: 38,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: _isHovered
                                    ? [
                                        accentColor,
                                        accentColor.withValues(alpha: 0.8),
                                      ]
                                    : [
                                        AppColors.brandYellow,
                                        AppColors.brandOrange,
                                      ],
                              ),
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: _isHovered
                                  ? [
                                      BoxShadow(
                                        color: accentColor.withValues(
                                          alpha: 0.4,
                                        ),
                                        blurRadius: 10,
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Row(
                              children: [
                                Text(
                                  widget.l10n.branchesViewDetails,
                                  style: GoogleFonts.oswald(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                                if (_isHovered) ...[
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.arrow_forward,
                                    size: 14,
                                    color: Colors.black,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
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
