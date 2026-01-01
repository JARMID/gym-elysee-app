import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animate_do/animate_do.dart';
import 'package:gyelyseedz/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';

import '../../widgets/web/web_page_shell.dart';
import '../../widgets/mobile/mobile_page_wrapper.dart';

class WebWorkoutsPage extends ConsumerWidget {
  final bool useMobileWrapper;
  const WebWorkoutsPage({super.key, this.useMobileWrapper = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final isMobile = MediaQuery.of(context).size.width < 600;

    final programs = [
      _Program(
        title: "HYROX COMP",
        icon: FontAwesomeIcons.personRunning,
        description: l10n.programHyroxDesc,
        duration: "60 min",
        level: l10n.levelAdvanced,
        color: AppColors.brandOrange,
      ),
      _Program(
        title: "POWERLIFTING",
        icon: FontAwesomeIcons.dumbbell,
        description: l10n.programPowerliftingDesc,
        duration: "90 min",
        level: l10n.levelIntermediate,
        color: AppColors.goldDark,
      ),
      _Program(
        title: "BOXING",
        icon: FontAwesomeIcons.handFist,
        description: l10n.programBoxingDesc,
        duration: "60 min",
        level: l10n.levelAllLevels,
        color: const Color(0xFFFF5722), // Deep Orange
      ),
      _Program(
        title: "YOGA FLOW",
        icon: FontAwesomeIcons.yinYang,
        description: l10n.programYogaDesc,
        duration: "45 min",
        level: l10n.levelBeginner,
        color: AppColors.brandYellow,
      ),
      _Program(
        title: "CROSSFIT",
        icon: FontAwesomeIcons.stopwatch,
        description: l10n.programCrossfitDesc,
        duration: "60 min",
        level: l10n.levelAdvanced,
        color: AppColors.brandOrange,
      ),
      _Program(
        title: "RECOVERY",
        icon: FontAwesomeIcons.heartPulse,
        description: l10n.programRecoveryDesc,
        duration: "30 min",
        level: l10n.levelAllLevels,
        color: AppColors.gold,
      ),
    ];

    final content = Column(
      children: [
        // Hero Section
        FadeInDown(
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
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.brandOrange.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const FaIcon(
                    FontAwesomeIcons.fire,
                    size: 50,
                    color: AppColors.brandOrange,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  l10n.workoutsTitleFirst,
                  style: GoogleFonts.oswald(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.0,
                  ),
                ),
                ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) =>
                      AppColors.fieryGradient.createShader(bounds),
                  child: Text(
                    l10n.workoutsTitleSecond,
                    style: GoogleFonts.oswald(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.workoutsSubtitle,
                  style: GoogleFonts.oswald(
                    fontSize: 24,
                    letterSpacing: 5,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Programs Grid
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 80,
            vertical: isMobile ? 40 : 60,
          ),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 1 : 3,
              crossAxisSpacing: 32,
              mainAxisSpacing: 32,
              childAspectRatio: isMobile ? 1.4 : 1.1,
            ),
            itemCount: programs.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return FadeInUp(
                delay: Duration(milliseconds: index * 100),
                child: _WorkoutCard(
                  program: programs[index],
                  isDark: isDark,
                  l10n: l10n,
                ),
              );
            },
          ),
        ),

        // CTA Section
        // CTA Section
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 80,
            vertical: 40,
          ),
          padding: EdgeInsets.all(isMobile ? 30 : 60),
          decoration: BoxDecoration(
            color: const Color(0xFF151515),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white10),
          ),
          child: isMobile
              ? Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: AppColors.fieryGradient,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.calendarCheck,
                        color: Colors.black,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.workoutsCtaTitle,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.oswald(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.workoutsCtaText,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: AppColors.fieryGradient,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l10n.workoutsCtaButton,
                              style: GoogleFonts.oswald(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: AppColors.fieryGradient,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.calendarCheck,
                        color: Colors.black,
                        size: 40,
                      ),
                    ),
                    const SizedBox(width: 40),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.workoutsCtaTitle,
                            style: GoogleFonts.oswald(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.workoutsCtaText,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: isDark
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 32),
                    Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.fieryGradient,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 20,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              l10n.workoutsCtaButton,
                              style: GoogleFonts.oswald(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
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
        ),

        const SizedBox(height: 40),
      ],
    );

    if (useMobileWrapper) {
      return MobilePageWrapper(
        title: l10n.navWorkouts.toUpperCase(),
        showBackButton: true,
        child: SingleChildScrollView(child: content),
      );
    }

    return WebPageShell(activeRoute: AppRoutes.webWorkouts, child: content);
  }
}

class _Program {
  final String title;
  final IconData icon;
  final String description;
  final String duration;
  final String level;
  final Color color;

  _Program({
    required this.title,
    required this.icon,
    required this.description,
    required this.duration,
    required this.level,
    required this.color,
  });
}

class _WorkoutCard extends StatefulWidget {
  final _Program program;
  final bool isDark;
  final AppLocalizations l10n;

  const _WorkoutCard({
    required this.program,
    required this.isDark,
    required this.l10n,
  });

  @override
  State<_WorkoutCard> createState() => _WorkoutCardState();
}

class _WorkoutCardState extends State<_WorkoutCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          _showProgramDetails(context);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()
            // ignore: deprecated_member_use
            ..scale(_isHovered ? 1.03 : 1.0, _isHovered ? 1.03 : 1.0),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: widget.isDark ? const Color(0xFF151515) : Colors.white,
            border: Border.all(
              color: _isHovered
                  ? widget.program.color.withValues(alpha: 0.5)
                  : (widget.isDark
                        ? Colors.white10
                        : Colors.grey.withValues(alpha: 0.2)),
              width: _isHovered ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: widget.program.color.withValues(alpha: 0.2),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: widget.program.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: FaIcon(
                      widget.program.icon,
                      color: widget.program.color,
                      size: 28,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: widget.program.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.program.level,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: widget.program.color,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                widget.program.title,
                style: GoogleFonts.oswald(
                  fontSize: 24,
                  color: widget.isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.program.description,
                style: GoogleFonts.inter(
                  color: widget.isDark ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: widget.isDark
                            ? Colors.grey[500]
                            : Colors.grey[400],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.program.duration,
                        style: GoogleFonts.inter(
                          color: widget.isDark
                              ? Colors.grey[500]
                              : Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _isHovered
                          ? widget.program.color
                          : widget.program.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Text(
                          widget.l10n.workoutsDetailsButton,
                          style: GoogleFonts.oswald(
                            color: _isHovered
                                ? Colors.white
                                : widget.program.color,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward,
                          size: 14,
                          color: _isHovered
                              ? Colors.white
                              : widget.program.color,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showProgramDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: widget.isDark ? AppColors.cardDark : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: widget.program.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: FaIcon(
                      widget.program.icon,
                      color: widget.program.color,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.program.title,
                          style: GoogleFonts.oswald(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: widget.isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: widget.program.color.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                widget.program.level,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: widget.program.color,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.program.duration,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: widget.isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      color: widget.isDark ? Colors.white54 : Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                widget.program.description,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: widget.isDark ? Colors.grey[400] : Colors.grey[600],
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.program.color,
                      widget.program.color.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Redirect to login since booking requires authentication
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Please login to book a session for ${widget.program.title}',
                        ),
                        action: SnackBarAction(
                          label: 'LOGIN',
                          textColor: Colors.white,
                          onPressed: () => context.go(AppRoutes.login),
                        ),
                        backgroundColor: widget.program.color,
                        duration: const Duration(seconds: 5),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.l10n.workoutsBookSessionButton,
                        style: GoogleFonts.oswald(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.calendar_today, size: 18),
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
