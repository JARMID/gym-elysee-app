import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_colors.dart';

class WebMapSection extends StatelessWidget {
  const WebMapSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
      child: Column(
        children: [
          // Title
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.oswald(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              children: [
                const TextSpan(text: 'TROUVEZ LA BRANCHE '),
                TextSpan(
                  text: 'PROCHE DE VOUS',
                  style: TextStyle(color: AppColors.brandYellow),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Subtitle
          Text(
            '6 emplacements stratégiques à travers l\'Algérie',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 18, color: Colors.grey[400]),
          ),
          const SizedBox(height: 60),

          // Map Container with hover
          const _InteractiveMapCard(),
        ],
      ),
    );
  }
}

class _InteractiveMapCard extends StatefulWidget {
  const _InteractiveMapCard();

  @override
  State<_InteractiveMapCard> createState() => _InteractiveMapCardState();
}

class _InteractiveMapCardState extends State<_InteractiveMapCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: FadeInUp(
        duration: const Duration(milliseconds: 800),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()
            // ignore: deprecated_member_use
            ..translate(0.0, _isHovered ? -10.0 : 0.0),
          height: 500,
          width: 1200,
          decoration: BoxDecoration(
            color: const Color(0xFF0A0A0A),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _isHovered
                  ? AppColors.brandYellow.withValues(alpha: 0.3)
                  : Colors.white.withValues(alpha: 0.05),
              width: _isHovered ? 2 : 1,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: AppColors.brandYellow.withValues(alpha: 0.1),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ]
                : [],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Central Content
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withValues(
                        alpha: _isHovered ? 0.2 : 0.1,
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.gold,
                        width: _isHovered ? 3 : 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.gold.withValues(
                            alpha: _isHovered ? 0.4 : 0.2,
                          ),
                          blurRadius: _isHovered ? 40 : 30,
                          spreadRadius: _isHovered ? 8 : 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.map_outlined,
                      size: 40,
                      color: AppColors.gold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'CARTE INTERACTIVE',
                    style: GoogleFonts.oswald(
                      color: _isHovered ? AppColors.brandYellow : Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Nos 6 branches sont situées à Alger (Hydra, Bouchaoui, Cheraga, Ben Aknoun), Oran et Constantine',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: Colors.grey[400],
                      height: 1.5,
                    ),
                  ),
                ],
              ),

              // Animated floating dots
              _AnimatedMapDot(
                top: 150,
                left: 300,
                isParentHovered: _isHovered,
                delay: 0,
              ),
              _AnimatedMapDot(
                top: 180,
                right: 350,
                isParentHovered: _isHovered,
                delay: 200,
              ),
              _AnimatedMapDot(
                bottom: 120,
                left: 400,
                isParentHovered: _isHovered,
                delay: 400,
              ),
              _AnimatedMapDot(
                top: 100,
                right: 250,
                isParentHovered: _isHovered,
                delay: 600,
              ),
              _AnimatedMapDot(
                bottom: 180,
                right: 280,
                isParentHovered: _isHovered,
                delay: 300,
              ),
              _AnimatedMapDot(
                bottom: 200,
                left: 250,
                isParentHovered: _isHovered,
                delay: 500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedMapDot extends StatefulWidget {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final bool isParentHovered;
  final int delay;

  const _AnimatedMapDot({
    this.top,
    this.bottom,
    this.left,
    this.right,
    required this.isParentHovered,
    this.delay = 0,
  });

  @override
  State<_AnimatedMapDot> createState() => _AnimatedMapDotState();
}

class _AnimatedMapDotState extends State<_AnimatedMapDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _pulseController.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.top,
      bottom: widget.bottom,
      left: widget.left,
      right: widget.right,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            final scale =
                1.0 +
                (widget.isParentHovered ? 0.3 : 0.15) * _pulseController.value;
            return Transform.scale(
              scale: _isHovered ? 1.8 : scale,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: _isHovered
                      ? AppColors.brandOrange
                      : AppColors.brandYellow,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color:
                          (_isHovered
                                  ? AppColors.brandOrange
                                  : AppColors.brandYellow)
                              .withValues(alpha: _isHovered ? 0.9 : 0.6),
                      blurRadius: _isHovered ? 20 : 10,
                      spreadRadius: _isHovered ? 5 : 2,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
