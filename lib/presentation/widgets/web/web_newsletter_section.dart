import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gyelyseedz/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

class WebNewsletterSection extends StatefulWidget {
  const WebNewsletterSection({super.key});

  @override
  State<WebNewsletterSection> createState() => _WebNewsletterSectionState();
}

class _WebNewsletterSectionState extends State<WebNewsletterSection> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  String? _errorText;
  bool _subscribed = false;
  bool _isCardHovered = false;
  bool _isButtonHovered = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> _subscribe() async {
    final l10n = AppLocalizations.of(context)!;
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      setState(() => _errorText = l10n.newsletterErrorEmpty);
      return;
    }

    if (!_isValidEmail(email)) {
      setState(() => _errorText = l10n.newsletterErrorInvalid);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLoading = false;
        _subscribed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return MouseRegion(
      onEnter: (_) => setState(() => _isCardHovered = true),
      onExit: (_) => setState(() => _isCardHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()
          // ignore: deprecated_member_use
          ..translate(0.0, _isCardHovered ? -8.0 : 0.0),
        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
        padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF111111) : Colors.grey[100],
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _isCardHovered
                ? AppColors.brandOrange.withValues(alpha: 0.5)
                : (isDark ? Colors.white10 : Colors.grey[300]!),
            width: _isCardHovered ? 2 : 1,
          ),
          boxShadow: _isCardHovered
              ? [
                  BoxShadow(
                    color: AppColors.brandOrange.withValues(alpha: 0.1),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            // Icon with glow
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.brandOrange.withValues(
                  alpha: _isCardHovered ? 0.2 : 0.1,
                ),
                shape: BoxShape.circle,
                boxShadow: _isCardHovered
                    ? [
                        BoxShadow(
                          color: AppColors.brandOrange.withValues(alpha: 0.3),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ]
                    : [],
              ),
              child: Icon(
                _subscribed
                    ? Icons.check_circle_outline
                    : Icons.mark_email_unread_outlined,
                color: _subscribed ? Colors.green : AppColors.brandOrange,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) =>
                  AppColors.fieryGradient.createShader(bounds),
              child: Text(
                _subscribed ? l10n.newsletterTitleThanks : l10n.newsletterTitle,
                style: GoogleFonts.oswald(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 600,
              child: Text(
                _subscribed
                    ? l10n.newsletterSubtitleSuccess
                    : l10n.newsletterSubtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  height: 1.5,
                ),
              ),
            ),
            if (!_subscribed) ...[
              const SizedBox(height: 40),
              SizedBox(
                width: 500,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _emailController,
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (_) {
                              if (_errorText != null) {
                                setState(() => _errorText = null);
                              }
                            },
                            decoration: InputDecoration(
                              hintText: l10n.newsletterPlaceholder,
                              hintStyle: TextStyle(
                                color: isDark
                                    ? Colors.grey[600]
                                    : Colors.grey[400],
                              ),
                              filled: true,
                              fillColor: isDark ? Colors.black : Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: _errorText != null
                                      ? Colors.red
                                      : isDark
                                      ? Colors.white10
                                      : Colors.grey[300]!,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: _errorText != null
                                      ? Colors.red
                                      : isDark
                                      ? Colors.white10
                                      : Colors.grey[300]!,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: AppColors.brandOrange,
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 20,
                              ),
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: isDark
                                    ? Colors.grey[600]
                                    : Colors.grey[400],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Animated Subscribe Button
                        MouseRegion(
                          onEnter: (_) =>
                              setState(() => _isButtonHovered = true),
                          onExit: (_) =>
                              setState(() => _isButtonHovered = false),
                          child: GestureDetector(
                            onTap: _isLoading ? null : _subscribe,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOutCubic,
                              transform: Matrix4.identity()
                                // ignore: deprecated_member_use
                                ..translate(_isButtonHovered ? 5.0 : 0.0, 0.0),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 22,
                              ),
                              decoration: BoxDecoration(
                                gradient: AppColors.fieryGradient,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: _isButtonHovered
                                    ? [
                                        BoxShadow(
                                          color: AppColors.brandOrange
                                              .withValues(alpha: 0.4),
                                          blurRadius: 15,
                                          offset: const Offset(0, 8),
                                        ),
                                      ]
                                    : [],
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.black,
                                      ),
                                    )
                                  : Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          l10n.newsletterButton,
                                          style: GoogleFonts.oswald(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          transform: Matrix4.identity()
                                            // ignore: deprecated_member_use
                                            ..translate(
                                              _isButtonHovered ? 5.0 : 0.0,
                                              0.0,
                                            ),
                                          child: const Icon(
                                            Icons.arrow_forward,
                                            size: 18,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_errorText != null) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _errorText!,
                            style: GoogleFonts.inter(
                              color: Colors.red,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
