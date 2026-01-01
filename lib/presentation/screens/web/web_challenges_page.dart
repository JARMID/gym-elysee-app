import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gyelyseedz/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/web/web_page_shell.dart';
import '../../widgets/mobile/mobile_page_wrapper.dart';

class WebChallengesPage extends StatelessWidget {
  final bool useMobileWrapper;
  const WebChallengesPage({super.key, this.useMobileWrapper = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final isMobile = MediaQuery.of(context).size.width < 800;

    final leaderboard = [
      _LeaderboardEntry(
        rank: 1,
        name: "Amine Zidane",
        score: 24500,
        avatar: "AZ",
      ),
      _LeaderboardEntry(
        rank: 2,
        name: "Karim Benzema",
        score: 22100,
        avatar: "KB",
      ),
      _LeaderboardEntry(
        rank: 3,
        name: "Sarah Mansouri",
        score: 21800,
        avatar: "SM",
      ),
      _LeaderboardEntry(
        rank: 4,
        name: "Mehdi Kaddour",
        score: 19500,
        avatar: "MK",
      ),
      _LeaderboardEntry(
        rank: 5,
        name: "Leila Hadj",
        score: 18200,
        avatar: "LH",
      ),
    ];

    final content = Column(
      children: [
        // Hero Section
        FadeInUp(
          child: Container(
            height: 450,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black,
                  isDark ? AppColors.darkBackground : Colors.grey[100]!,
                  AppColors.brandOrange.withValues(alpha: 0.1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.brandYellow.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.brandYellow.withValues(alpha: 0.3),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: const FaIcon(
                      FontAwesomeIcons.trophy,
                      size: 60,
                      color: AppColors.brandYellow,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    l10n.challengesTitleMain,
                    style: GoogleFonts.oswald(
                      fontSize: isMobile ? 48 : 72,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) =>
                        AppColors.fieryGradient.createShader(bounds),
                    child: Text(
                      l10n.challengesSlogan,
                      style: GoogleFonts.oswald(
                        fontSize: 24,
                        letterSpacing: 5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Current Challenge Banner
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 100,
            vertical: 40,
          ),
          padding: EdgeInsets.all(isMobile ? 24 : 40),
          decoration: BoxDecoration(
            gradient: AppColors.fieryGradient,
            borderRadius: BorderRadius.circular(20),
          ),
          child: isMobile
              ? Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const FaIcon(
                            FontAwesomeIcons.fire,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.challengeOfTheMonth,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                  letterSpacing: 2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                l10n.challengeTitle,
                                style: GoogleFonts.oswald(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.challengeDesc,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              "15",
                              style: GoogleFonts.oswald(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              l10n.daysRemaining,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () => context.go(AppRoutes.login),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            l10n.joinChallengeButton,
                            style: GoogleFonts.oswald(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.fire,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.challengeOfTheMonth,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.challengeTitle,
                            style: GoogleFonts.oswald(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.challengeDesc,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 32),
                    Column(
                      children: [
                        Text(
                          "15",
                          style: GoogleFonts.oswald(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          l10n.daysRemaining,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 32),
                    ElevatedButton(
                      onPressed: () => context.go(AppRoutes.login),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l10n.joinChallengeButton,
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
                  ],
                ),
        ),

        // Leaderboard
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 100,
            vertical: 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const FaIcon(
                    FontAwesomeIcons.rankingStar,
                    color: AppColors.brandYellow,
                    size: 24,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    l10n.leaderboardTitleSection,
                    style: GoogleFonts.oswald(
                      fontSize: isMobile ? 24 : 32,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ...leaderboard.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return FadeInUp(
                  delay: Duration(milliseconds: index * 100),
                  child: _buildLeaderboardRow(item, isDark, isMobile),
                );
              }),
            ],
          ),
        ),

        // Rules Section
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 100,
            vertical: 40,
          ),
          padding: EdgeInsets.all(isMobile ? 24 : 48),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? Colors.white10 : Colors.grey[200]!,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const FaIcon(
                    FontAwesomeIcons.clipboardList,
                    color: AppColors.brandOrange,
                    size: 24,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    l10n.challengeRulesTitle,
                    style: GoogleFonts.oswald(
                      fontSize: isMobile ? 24 : 28,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _buildRule(
                "1",
                l10n.rule1Title,
                l10n.rule1Desc,
                isDark,
                isMobile,
              ),
              _buildRule(
                "2",
                l10n.rule2Title,
                l10n.rule2Desc,
                isDark,
                isMobile,
              ),
              _buildRule(
                "3",
                l10n.rule3Title,
                l10n.rule3Desc,
                isDark,
                isMobile,
              ),
              _buildRule(
                "4",
                l10n.rule4Title,
                l10n.rule4Desc,
                isDark,
                isMobile,
              ),
            ],
          ),
        ),

        const SizedBox(height: 40),
        const SizedBox(height: 40),
      ],
    );

    if (useMobileWrapper) {
      return MobilePageWrapper(
        title: l10n.navChallenge.toUpperCase(),
        showBackButton: true,
        child: SingleChildScrollView(child: content),
      );
    }

    return WebPageShell(activeRoute: AppRoutes.webChallenges, child: content);
  }

  Widget _buildLeaderboardRow(
    _LeaderboardEntry entry,
    bool isDark,
    bool isMobile,
  ) {
    final isTop3 = entry.rank <= 3;
    final rankColor = entry.rank == 1
        ? AppColors.brandYellow
        : entry.rank == 2
        ? Colors.grey[400]!
        : entry.rank == 3
        ? Colors.orange[700]!
        : Colors.transparent;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 32,
        vertical: 24,
      ),
      decoration: BoxDecoration(
        color: entry.rank == 1
            ? AppColors.brandYellow
            : isDark
            ? AppColors.cardDark
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isTop3 && entry.rank != 1
            ? Border.all(color: rankColor.withValues(alpha: 0.5), width: 2)
            : Border.all(color: isDark ? Colors.white10 : Colors.grey[200]!),
        boxShadow: entry.rank == 1
            ? [
                BoxShadow(
                  color: AppColors.brandYellow.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: isMobile ? 32 : 40,
            height: isMobile ? 32 : 40,
            decoration: BoxDecoration(
              color: isTop3
                  ? rankColor.withValues(alpha: 0.2)
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isTop3
                  ? FaIcon(
                      FontAwesomeIcons.medal,
                      color: entry.rank == 1 ? Colors.black : rankColor,
                      size: isMobile ? 16 : 20,
                    )
                  : Text(
                      entry.rank.toString(),
                      style: GoogleFonts.oswald(
                        fontSize: isMobile ? 16 : 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
            ),
          ),
          SizedBox(width: isMobile ? 12 : 24),
          CircleAvatar(
            radius: isMobile ? 16 : 20,
            backgroundColor: entry.rank == 1
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.grey[800],
            child: Text(
              entry.avatar,
              style: GoogleFonts.inter(
                fontSize: isMobile ? 12 : 14,
                fontWeight: FontWeight.bold,
                color: entry.rank == 1 ? Colors.black : Colors.white,
              ),
            ),
          ),
          SizedBox(width: isMobile ? 12 : 16),
          Expanded(
            child: Text(
              entry.name,
              style: GoogleFonts.inter(
                fontSize: isMobile ? 14 : 18,
                fontWeight: FontWeight.bold,
                color: entry.rank == 1
                    ? Colors.black
                    : isDark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ),
          Text(
            "${entry.score.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} PTS",
            style: GoogleFonts.oswald(
              fontSize: isMobile ? 16 : 24,
              fontWeight: FontWeight.bold,
              color: entry.rank == 1 ? Colors.black : AppColors.brandYellow,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRule(
    String number,
    String title,
    String description,
    bool isDark,
    bool isMobile,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: isMobile ? 32 : 40,
            height: isMobile ? 32 : 40,
            decoration: BoxDecoration(
              gradient: AppColors.fieryGradient,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: GoogleFonts.oswald(
                  fontSize: isMobile ? 14 : 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(width: isMobile ? 12 : 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.oswald(
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: isMobile ? 13 : 14,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LeaderboardEntry {
  final int rank;
  final String name;
  final int score;
  final String avatar;

  _LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.score,
    required this.avatar,
  });
}
