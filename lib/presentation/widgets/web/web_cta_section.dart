import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:gyelyseedz/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routing/app_router.dart';

class WebCTASection extends StatelessWidget {
  const WebCTASection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 100),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black,
            const Color(0xFF1A0A00).withValues(alpha: 0.6),
            Colors.black,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          // Title - Multi-line layout
          Text(
            l10n.ctaReadyTo,
            style: GoogleFonts.oswald(
              fontSize: 56,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.1,
            ),
          ),
          ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) => const LinearGradient(
              colors: [AppColors.brandOrange, AppColors.brandYellow],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ).createShader(bounds),
            child: Text(
              l10n.ctaTransform,
              style: GoogleFonts.oswald(
                fontSize: 56,
                fontWeight: FontWeight.bold,
                height: 1.1,
              ),
            ),
          ),
          Text(
            l10n.ctaYourLife,
            style: GoogleFonts.oswald(
              fontSize: 56,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 24),
          // Subtitle
          Text(
            l10n.ctaSubtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: Colors.grey[500],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),
          // Animated CTA Button
          _AnimatedCTAButton(label: l10n.ctaButton),
        ],
      ),
    );
  }
}

class _AnimatedCTAButton extends StatefulWidget {
  final String label;

  const _AnimatedCTAButton({required this.label});

  @override
  State<_AnimatedCTAButton> createState() => _AnimatedCTAButtonState();
}

class _AnimatedCTAButtonState extends State<_AnimatedCTAButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => context.go(AppRoutes.register),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()
            // ignore: deprecated_member_use
            ..translate(0.0, _isHovered ? -8.0 : 0.0),
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 18),
          decoration: BoxDecoration(
            color: AppColors.brandYellow,
            borderRadius: BorderRadius.circular(4),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: AppColors.brandYellow.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: EdgeInsets.only(right: _isHovered ? 4.0 : 0.0),
                child: Icon(
                  Icons.fitness_center,
                  color: Colors.black,
                  size: _isHovered ? 20 : 18,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                widget.label,
                style: GoogleFonts.oswald(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(width: 12),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                transform: Matrix4.identity()
                  // ignore: deprecated_member_use
                  ..translate(_isHovered ? 5.0 : 0.0, 0.0),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.black,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
