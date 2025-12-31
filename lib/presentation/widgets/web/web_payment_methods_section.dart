import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class WebPaymentMethodsSection extends StatelessWidget {
  const WebPaymentMethodsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
      child: Column(
        children: [
          // Tag
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 30, height: 3, color: AppColors.brandOrange),
              const SizedBox(width: 12),
              Icon(Icons.credit_card, color: Colors.grey[500], size: 16),
              const SizedBox(width: 8),
              Text(
                'PAIEMENT',
                style: GoogleFonts.inter(
                  color: Colors.grey[400],
                  letterSpacing: 2,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Header
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.oswald(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.1,
              ),
              children: [
                const TextSpan(text: "MOYENS DE "),
                TextSpan(
                  text: "PAIEMENT",
                  style: GoogleFonts.oswald(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: AppColors.brandOrange,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Plusieurs options pour faciliter votre inscription',
            style: GoogleFonts.inter(fontSize: 16, color: Colors.grey[500]),
          ),
          const SizedBox(height: 60),

          // Cards Grid
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: const [
              _InteractiveMethodCard(
                icon: Icons.credit_card,
                title: 'EDAHABIA',
                subtitle: 'Carte Poste Algérie',
              ),
              _InteractiveMethodCard(
                icon: Icons.payment,
                title: 'CIB',
                subtitle: 'Carte Interbancaire',
              ),
              _InteractiveMethodCard(
                icon: Icons.phone_android,
                title: 'BARIDIMOB',
                subtitle: 'Paiement mobile',
              ),
              _InteractiveMethodCard(
                icon: Icons.money,
                title: 'CASH',
                subtitle: 'Espèces en salle',
              ),
            ],
          ),

          const SizedBox(height: 40),

          // 3x Banner
          const _InteractiveInstallmentBanner(),
        ],
      ),
    );
  }
}

class _InteractiveMethodCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InteractiveMethodCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  State<_InteractiveMethodCard> createState() => _InteractiveMethodCardState();
}

class _InteractiveMethodCardState extends State<_InteractiveMethodCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()
          // ignore: deprecated_member_use
          ..translate(0.0, _isHovered ? -10.0 : 0.0),
        width: 200,
        height: 180,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        decoration: BoxDecoration(
          color: const Color(0xFF0F0F0F),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered
                ? AppColors.brandOrange
                : Colors.white.withValues(alpha: 0.08),
            width: _isHovered ? 2 : 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppColors.brandOrange.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon with glow effect
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _isHovered
                    ? AppColors.brandOrange.withValues(alpha: 0.25)
                    : AppColors.brandOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isHovered
                      ? AppColors.brandOrange
                      : Colors.transparent,
                  width: 1,
                ),
                boxShadow: _isHovered
                    ? [
                        BoxShadow(
                          color: AppColors.brandOrange.withValues(alpha: 0.4),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ]
                    : [],
              ),
              child: Icon(widget.icon, color: AppColors.brandOrange, size: 24),
            ),
            const SizedBox(height: 16),
            Text(
              widget.title,
              style: GoogleFonts.oswald(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _isHovered ? AppColors.brandOrange : Colors.white,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: _isHovered ? Colors.grey[300] : Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InteractiveInstallmentBanner extends StatefulWidget {
  const _InteractiveInstallmentBanner();

  @override
  State<_InteractiveInstallmentBanner> createState() =>
      _InteractiveInstallmentBannerState();
}

class _InteractiveInstallmentBannerState
    extends State<_InteractiveInstallmentBanner> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()
            // ignore: deprecated_member_use
            ..translate(0.0, _isHovered ? -8.0 : 0.0),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          decoration: BoxDecoration(
            border: Border.all(
              color: _isHovered
                  ? AppColors.brandOrange
                  : const Color(0xFF333333),
              width: _isHovered ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xFF111111),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: AppColors.brandOrange.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Glowing icon
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _isHovered
                      ? Colors.red.withValues(alpha: 0.2)
                      : Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: _isHovered
                      ? [
                          BoxShadow(
                            color: Colors.red.withValues(alpha: 0.5),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ]
                      : [],
                ),
                child: const Icon(Icons.flash_on, color: Colors.red, size: 28),
              ),
              const SizedBox(width: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PAIEMENT EN 3X SANS FRAIS',
                    style: GoogleFonts.oswald(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _isHovered ? AppColors.brandOrange : Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    'Disponible pour les abonnements 6 mois et plus',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.grey[400],
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
}
