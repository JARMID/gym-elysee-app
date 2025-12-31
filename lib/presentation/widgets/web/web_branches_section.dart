import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/branch_model.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/landing_providers.dart';

class WebBranchesSection extends ConsumerWidget {
  const WebBranchesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branchesAsync = ref.watch(branchesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 60),
      color: isDark ? Colors.black : Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Left side - Title
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 2,
                          color: AppColors.brandYellow,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'NOS BRANCHES',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.brandYellow,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '3 GYMS',
                          style: GoogleFonts.oswald(
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                            height: 1.1,
                          ),
                        ),
                        ShaderMask(
                          blendMode: BlendMode.srcIn,
                          shaderCallback: (bounds) =>
                              AppColors.fieryGradient.createShader(bounds),
                          child: Text(
                            'PREMIUM',
                            style: GoogleFonts.oswald(
                              fontSize: 64,
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Right side - Animated Button
              _AnimatedExploreButton(isDark: isDark),
            ],
          ),
          const SizedBox(height: 60),

          // Branch Cards Grid
          branchesAsync.when(
            data: (branches) {
              final displayBranches = branches.take(3).toList();
              if (displayBranches.isEmpty) {
                return const Center(
                  child: Text(
                    'Aucune branche disponible',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              return Row(
                children: displayBranches.map((branch) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: _InteractiveBranchCard(branch: branch),
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.brandYellow),
            ),
            error: (err, stack) => const Center(
              child: Text(
                'Erreur branches',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedExploreButton extends StatefulWidget {
  final bool isDark;
  const _AnimatedExploreButton({required this.isDark});

  @override
  State<_AnimatedExploreButton> createState() => _AnimatedExploreButtonState();
}

class _AnimatedExploreButtonState extends State<_AnimatedExploreButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => context.go(AppRoutes.webBranches),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()
            // ignore: deprecated_member_use
            ..translate(0.0, _isHovered ? -5.0 : 0.0),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          decoration: BoxDecoration(
            color: _isHovered ? AppColors.brandYellow : Colors.transparent,
            border: Border.all(color: AppColors.brandYellow, width: 2),
            borderRadius: BorderRadius.circular(4),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: AppColors.brandYellow.withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'EXPLORER TOUT',
                style: GoogleFonts.oswald(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _isHovered
                      ? Colors.black
                      : (widget.isDark ? Colors.white : Colors.black),
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward,
                size: 16,
                color: _isHovered
                    ? Colors.black
                    : (widget.isDark ? Colors.white : Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InteractiveBranchCard extends StatefulWidget {
  final dynamic branch;

  const _InteractiveBranchCard({required this.branch});

  @override
  State<_InteractiveBranchCard> createState() => _InteractiveBranchCardState();
}

class _InteractiveBranchCardState extends State<_InteractiveBranchCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    if (widget.branch is! BranchModel) return const SizedBox.shrink();

    final BranchModel branch = widget.branch;
    final name = branch.name.toUpperCase();
    final loc = '${branch.city}, ${branch.wilaya}';
    final type = branch.type;

    String tag = _getTagLabel(type);
    final isWomen = type == 'women' || name.contains('FEMMES');
    final Color tagColor = isWomen
        ? const Color(0xFFFF4081)
        : AppColors.brandYellow;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go('/branch-details/${branch.id}'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()
            // ignore: deprecated_member_use
            ..translate(0.0, _isHovered ? -12.0 : 0.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _isHovered ? tagColor : Colors.transparent,
              width: 2,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: tagColor.withValues(alpha: 0.25),
                      blurRadius: 25,
                      offset: const Offset(0, 15),
                    ),
                  ]
                : [],
          ),
          child: AspectRatio(
            aspectRatio: 0.8,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFF1A1A1A),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background with zoom effect
                  AnimatedScale(
                    scale: _isHovered ? 1.05 : 1.0,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOut,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            tagColor.withValues(alpha: 0.2),
                            Colors.black,
                          ],
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          _getBranchIcon(type),
                          size: 80,
                          color: tagColor.withValues(
                            alpha: _isHovered ? 0.5 : 0.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Dark gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.9),
                        ],
                        stops: const [0.5, 1.0],
                      ),
                    ),
                  ),
                  // Tag Badge
                  Positioned(
                    bottom: 80,
                    left: 20,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: tagColor,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: _isHovered
                            ? [
                                BoxShadow(
                                  color: tagColor.withValues(alpha: 0.5),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ]
                            : [],
                      ),
                      child: Text(
                        tag,
                        style: GoogleFonts.oswald(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                  // Content
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          style: GoogleFonts.oswald(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: _isHovered ? tagColor : Colors.white,
                          ),
                          child: Text(name),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          loc,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Hover Indicator Arrow
                  Positioned(
                    top: 20,
                    right: 20,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: _isHovered ? 1.0 : 0.0,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: tagColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.black,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getTagLabel(String type) {
    switch (type) {
      case 'flagship':
        return 'FLAGSHIP';
      case 'boxing':
        return 'BOXE ANGLAISE';
      case 'mma':
        return 'MMA COMPLET';
      case 'grappling':
        return 'BJJ & WRESTLING';
      case 'women':
        return '100% FÉMININ';
      case 'crossfit':
        return 'CROSSFIT';
      default:
        return 'GYM PREMIUM';
    }
  }

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
}
