import 'package:flutter/scheduler.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';

class WebHeroSection extends ConsumerStatefulWidget {
  final double topPadding;
  const WebHeroSection({super.key, this.topPadding = 0});

  @override
  ConsumerState<WebHeroSection> createState() => _WebHeroSectionState();
}

class _WebHeroSectionState extends ConsumerState<WebHeroSection>
    with TickerProviderStateMixin {
  bool _isPlaying = true;
  late ScrollController _tickerScrollController;
  late Ticker _ticker;
  late AnimationController _bounceController;

  @override
  void initState() {
    super.initState();
    _tickerScrollController = ScrollController();

    // Create a ticker that advances the scroll position every frame
    _ticker = createTicker((elapsed) {
      if (_tickerScrollController.hasClients) {
        // Pixel speed: 1.0 pixels per frame (approx 60px/sec at 60fps)
        // Using a simple increment. Since the list is infinite, we just keep scrolling.
        // Double precision is sufficient for years of scrolling.
        final double newOffset = _tickerScrollController.offset + 1.0;
        _tickerScrollController.jumpTo(newOffset);
      }
    });

    // Start the ticker after a short delay to ensure layout is ready
    Future.delayed(Duration.zero, () {
      if (mounted) _ticker.start();
    });

    // Bounce animation for scroll indicator
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ticker.dispose();
    _tickerScrollController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isSmallScreen = MediaQuery.of(context).size.width < 900;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark ? AppColors.darkBackground : Colors.grey[100],
      child: Column(
        children: [
          // Main Hero Area with Video
          SizedBox(
            height: 750,
            width: double.infinity,
            child: Stack(
              children: [
                // Background
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark
                            ? [const Color(0xFF0A0A0A), const Color(0xFF151515)]
                            : [Colors.white, const Color(0xFFF5F5F5)],
                      ),
                    ),
                  ),
                ),
                // Content
                Padding(
                  padding: EdgeInsets.only(top: widget.topPadding + 40),
                  child: isSmallScreen
                      ? _buildMobileLayout(context, l10n)
                      : _buildDesktopLayout(context, l10n),
                ),
                // Scroll Indicator
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: AnimatedBuilder(
                    animation: _bounceController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, 10 * _bounceController.value),
                        child: child,
                      );
                    },
                    child: Column(
                      children: [
                        Text(
                          'SCROLL',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: Colors.grey[600],
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.gold,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Animated Sport Ticker
          _buildAnimatedTicker(),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, AppLocalizations l10n) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // LEFT: Text Content (55%)
          Expanded(
            flex: 55,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInLeft(
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 2,
                        color: AppColors.brandYellow,
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: AppColors.brandYellow,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "6 BRANCHES PREMIUM EN ALGÉRIE",
                        style: GoogleFonts.inter(
                          color: AppColors.brandYellow,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'GYM',
                        style: GoogleFonts.oswald(
                          fontSize: 96,
                          height: 1.1,
                          fontWeight: FontWeight.w500, // Thinner
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            Color(0xFFFFC107), // Amber/Bright Yellow (Hot Top)
                            Color(0xFFFF9800), // Orange
                            Color(0xFFFF5722), // Deep Orange (Fiery Bottom)
                          ],
                          stops: [0.0, 0.5, 1.0],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ).createShader(bounds),
                        child: Text(
                          'ÉLYSÉE',
                          style: GoogleFonts.oswald(
                            fontSize: 96,
                            height: 1.1,
                            fontWeight: FontWeight.w900,
                            color: Colors.white, // Required for ShaderMask
                          ),
                        ),
                      ),
                      Text(
                        'DZ',
                        style: GoogleFonts.oswald(
                          fontSize: 96,
                          height: 1.1,
                          fontWeight: FontWeight.w900,
                          // Outlined text style
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 2
                            ..color = const Color(
                              0xFFFFC107,
                            ), // Matching Bright Yellow Outline
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                FadeInUp(
                  delay: const Duration(milliseconds: 400),
                  child: Text(
                    l10n.heroPivotSubtitle,
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      color: isDark ? Colors.grey[400] : Colors.grey[800],
                      height: 1.6,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                FadeInUp(
                  delay: const Duration(milliseconds: 600),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _AnimatedHeroButton(
                        label: 'ESSAI GRATUIT',
                        isPrimary: true,
                        onTap: () => context.go(AppRoutes.register),
                      ),
                      _AnimatedHeroButton(
                        label: 'DÉCOUVRIR',
                        isPrimary: false,
                        icon: Icons.play_arrow_outlined,
                        onTap: () => context.go(AppRoutes.webWorkouts),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // RIGHT: Video Experience (45%)
          Expanded(
            flex: 45,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Gold Backing Shape
                Positioned(
                  right: -50,
                  bottom: -50,
                  child: Transform.rotate(
                    angle: -0.1,
                    child: Container(
                      width: 600,
                      height: 700,
                      color: AppColors.gold.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                // Video Container
                FadeInRight(
                  child: Container(
                    height: 550,
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                      right: 60,
                      top: 40,
                      bottom: 40,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.gold.withValues(alpha: 0.2),
                          blurRadius: 40,
                          offset: const Offset(-10, 10),
                        ),
                      ],
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Video Thumbnail Placeholder
                        Image.network(
                          'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800&fit=crop',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.gold.withValues(alpha: 0.1),
                                      const Color(0xFF1A1A1A),
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.dumbbell,
                                    size: 50,
                                    color: Colors.white24,
                                  ),
                                ),
                              ),
                        ),
                        // Dark Overlay
                        Container(color: Colors.black.withValues(alpha: 0.3)),
                        // Play Button
                        Center(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _isPlaying = !_isPlaying),
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                              child: Icon(
                                _isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                        ),
                        // "LIVE" Badge
                        Positioned(
                          top: 20,
                          right: 20,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            color: Colors.red,
                            child: Text(
                              "LIVE",
                              style: GoogleFonts.oswald(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildAnimatedTicker() {
    final sports = [
      'BOXING',
      'MMA',
      'GRAPPLING',
      'FITNESS',
      'CROSSFIT',
      'FORCE',
      'MUSCULATION',
    ];

    return Container(
      height: 60,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFFA000), // Amber 700
            Color(0xFFFF5722), // Deep Orange 500
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        controller: _tickerScrollController,
        itemBuilder: (context, index) {
          final sport = sports[index % sports.length];
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                sport,
                style: GoogleFonts.oswald(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(width: 40),
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 40),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, AppLocalizations l10n) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            'GYM ÉLYSÉE DZ',
            style: GoogleFonts.outfit(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'L\'excellence du sport en Algérie.',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: isDark ? Colors.grey[400] : Colors.grey[800],
            ),
          ),
          const SizedBox(height: 32),
          _AnimatedHeroButton(
            label: 'ESSAI GRATUIT',
            isPrimary: true,
            onTap: () => context.go(AppRoutes.register),
          ),
        ],
      ),
    );
  }
}

class _AnimatedHeroButton extends StatefulWidget {
  final String label;
  final bool isPrimary;
  final IconData? icon;
  final VoidCallback onTap;

  const _AnimatedHeroButton({
    required this.label,
    required this.isPrimary,
    this.icon,
    required this.onTap,
  });

  @override
  State<_AnimatedHeroButton> createState() => _AnimatedHeroButtonState();
}

class _AnimatedHeroButtonState extends State<_AnimatedHeroButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()
            // ignore: deprecated_member_use
            ..translate(0.0, _isHovered ? -6.0 : 0.0),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          decoration: BoxDecoration(
            color: widget.isPrimary
                ? (_isHovered ? AppColors.brandOrange : AppColors.brandYellow)
                : (_isHovered
                      ? AppColors.brandYellow.withValues(alpha: 0.1)
                      : Colors.transparent),
            border: widget.isPrimary
                ? null
                : Border.all(
                    color: _isHovered
                        ? AppColors.brandYellow
                        : (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white.withValues(alpha: 0.2)
                              : Colors.black.withValues(alpha: 0.2)),
                    width: _isHovered ? 2 : 1,
                  ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color:
                          (widget.isPrimary
                                  ? AppColors.brandYellow
                                  : AppColors.brandYellow)
                              .withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null && !widget.isPrimary) ...[
                Icon(
                  widget.icon,
                  size: 20,
                  color: _isHovered
                      ? AppColors.brandYellow
                      : AppColors.brandYellow,
                ),
                const SizedBox(width: 12),
              ],
              Text(
                widget.label,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                  color: widget.isPrimary
                      ? Colors.black
                      : AppColors.brandYellow,
                ),
              ),
              if (widget.isPrimary) ...[
                const SizedBox(width: 12),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  transform: Matrix4.identity()
                    // ignore: deprecated_member_use
                    ..translate(_isHovered ? 5.0 : 0.0, 0.0),
                  child: const Icon(
                    Icons.arrow_forward,
                    size: 20,
                    color: Colors.black,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
