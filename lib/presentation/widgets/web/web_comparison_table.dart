import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class WebComparisonTable extends StatelessWidget {
  const WebComparisonTable({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      {
        'name': 'Prix mensuel équivalent',
        'm': '8,000 DZD',
        't': '7,000 DZD',
        'a': '6,250 DZD',
        'highlight': true,
      },
      {
        'name': 'Accès branches',
        'm': '1 branche',
        't': 'Toutes',
        'a': 'Toutes',
        'highlight': true,
      },
      {
        'name': 'Cours collectifs',
        'm': 'Illimités',
        't': 'Illimités',
        'a': 'Illimités',
        'highlight': true,
      },
      {'name': 'Sessions privées', 'm': '0', 't': '2/trim.', 'a': '5/an'},
      {'name': 'Invitations gratuites', 'm': '0', 't': '1/mois', 'a': '3/mois'},
      {'name': 'Bilan corporel', 'm': '-', 't': '-', 'a': 'Trimestriel'},
      {'name': 'Programme nutrition', 'm': '-', 't': '-', 'a': 'check'},
      {'name': 'Paiement 3x', 'm': '-', 't': '-', 'a': 'check'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
      child: Column(
        children: [
          Text(
            'COMPARATIF DÉTAILLÉ',
            style: GoogleFonts.oswald(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: AppColors.brandYellow,
            ),
          ),
          const SizedBox(height: 60),

          Container(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              children: [
                // Header Row
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 16,
                  ),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.white24)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'CARACTÉRISTIQUE',
                          style: GoogleFonts.oswald(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'MENSUEL',
                            style: GoogleFonts.oswald(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'TRIMESTRIEL',
                            style: GoogleFonts.oswald(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'ANNUEL',
                            style: GoogleFonts.oswald(
                              fontWeight: FontWeight.bold,
                              color: AppColors.brandYellow,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Feature Rows with hover
                ...features.map(
                  (item) => _InteractiveTableRow(
                    featureName: item['name'].toString(),
                    monthly: item['m'].toString(),
                    trimestrial: item['t'].toString(),
                    annual: item['a'].toString(),
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

class _InteractiveTableRow extends StatefulWidget {
  final String featureName;
  final String monthly;
  final String trimestrial;
  final String annual;

  const _InteractiveTableRow({
    required this.featureName,
    required this.monthly,
    required this.trimestrial,
    required this.annual,
  });

  @override
  State<_InteractiveTableRow> createState() => _InteractiveTableRowState();
}

class _InteractiveTableRowState extends State<_InteractiveTableRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: _isHovered
              ? AppColors.brandYellow.withValues(alpha: 0.08)
              : Colors.transparent,
          border: Border(
            bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
            left: BorderSide(
              color: _isHovered ? AppColors.brandYellow : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: _isHovered ? Colors.white : Colors.grey[300],
                  fontWeight: _isHovered ? FontWeight.w600 : FontWeight.normal,
                ),
                child: Text(widget.featureName),
              ),
            ),
            Expanded(child: Center(child: _buildCell(widget.monthly))),
            Expanded(child: Center(child: _buildCell(widget.trimestrial))),
            Expanded(
              child: Center(child: _buildCell(widget.annual, isGold: true)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCell(String content, {bool isGold = false}) {
    if (content == 'check') {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: _isHovered
              ? AppColors.brandYellow.withValues(alpha: 0.2)
              : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, color: AppColors.brandYellow, size: 20),
      );
    }
    if (content == '-') {
      return Text('—', style: TextStyle(color: Colors.grey[700]));
    }
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 200),
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: _isHovered ? FontWeight.bold : FontWeight.w600,
        color: isGold
            ? (_isHovered ? AppColors.brandOrange : AppColors.brandYellow)
            : (_isHovered ? Colors.white : Colors.grey[300]),
      ),
      child: Text(content),
    );
  }
}
