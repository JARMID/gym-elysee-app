import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gyelyseedz/l10n/app_localizations.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';

class WebFooter extends StatelessWidget {
  const WebFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isSmallScreen = MediaQuery.of(context).size.width < 900;

    return Container(
      color: isDark ? const Color(0xFF0A0A0A) : Colors.white,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background Watermark (GYM ELYSEE DZ)
          Positioned(
            bottom: -50,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.03,
              child: Text(
                'GYM ELYSEE DZ',
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.clip,
                style: GoogleFonts.oswald(
                  fontSize: 250,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.grey[100],
                  letterSpacing: 20,
                ),
              ),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 24 : 80,
              vertical: 80,
            ),
            child: Column(
              children: [
                // Back to Top Button
                _BackToTopButton(),
                const SizedBox(height: 60),

                if (isSmallScreen)
                  _buildMobileLayout(context)
                else
                  _buildDesktopLayout(context),

                const SizedBox(height: 80),

                //Copyright Line (Responsive)
                Container(
                  padding: const EdgeInsets.only(top: 32),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.1)
                            : Colors.black.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  child: isSmallScreen
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              l10n.footerCopyright,
                              style: GoogleFonts.inter(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _FooterMiniLink(l10n.footerPrivacy),
                                const SizedBox(width: 24),
                                _FooterMiniLink(l10n.footerTerms),
                              ],
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              l10n.footerCopyright,
                              style: GoogleFonts.inter(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            Row(
                              children: [
                                _FooterMiniLink(l10n.footerPrivacy),
                                const SizedBox(width: 24),
                                _FooterMiniLink(l10n.footerTerms),
                              ],
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Column 1: Logo & About (Flex 3)
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLogo(),
              const SizedBox(height: 32),
              Text(
                l10n.footerTagline,
                style: GoogleFonts.inter(
                  color: Colors.grey[500],
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  _AnimatedSocialIcon(
                    FontAwesomeIcons.facebookF,
                    url: 'https://facebook.com',
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 12),
                  _AnimatedSocialIcon(
                    FontAwesomeIcons.instagram,
                    url: 'https://instagram.com',
                    color: Colors.pink,
                  ),
                  const SizedBox(width: 12),
                  _AnimatedSocialIcon(
                    FontAwesomeIcons.youtube,
                    url: 'https://youtube.com',
                    color: Colors.red,
                  ),
                  const SizedBox(width: 12),
                  _AnimatedSocialIcon(
                    FontAwesomeIcons.tiktok,
                    url: 'https://tiktok.com',
                    color: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 60),

        // Column 2: Navigation (Flex 2)
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, l10n.footerNavigation),
              const SizedBox(height: 32),
              _FooterLink(
                l10n.footerHome,
                onTap: () => context.go(AppRoutes.splash),
              ),
              _FooterLink(
                l10n.footerBranches,
                onTap: () => context.go(AppRoutes.webBranches),
              ),
              _FooterLink(
                l10n.footerPricing,
                onTap: () => context.go(AppRoutes.webPricing),
              ),
              _FooterLink(
                l10n.navBlog,
                onTap: () => context.go(AppRoutes.webBlog),
              ),
              _FooterLink(
                l10n.footerContact,
                onTap: () => context.go(AppRoutes.webContact),
              ),
            ],
          ),
        ),

        // Column 3: Branches (Flex 2)
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, l10n.footerBranches),
              const SizedBox(height: 32),
              _BranchLink(
                'GYM ÉLYSÉE DZ (Hydra)',
                onTap: () => context.go('/branch-details/1'),
              ),
              _BranchLink(
                'GYM ÉLYSÉE BOXE (Oran)',
                onTap: () => context.go('/branch-details/2'),
              ),
              _BranchLink(
                'TIGER SPORT DZ (Bouchaoui)',
                onTap: () => context.go('/branch-details/3'),
              ),
              _BranchLink(
                'GYM ÉLYSÉE GRAPPLING (Constantine)',
                onTap: () => context.go('/branch-details/4'),
              ),
              _BranchLink(
                'GYM ÉLYSÉE FEMMES (Cheraga)',
                onTap: () => context.go('/branch-details/5'),
              ),
              _BranchLink(
                'GYM ÉLYSÉE CROSSFIT (Ben Aknoun)',
                onTap: () => context.go('/branch-details/6'),
              ),
            ],
          ),
        ),

        // Column 4: Contact (Flex 3)
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, l10n.footerContact),
              const SizedBox(height: 32),
              _ContactItem(Icons.email_outlined, 'contact@gymelysee.dz'),
              const SizedBox(height: 16),
              _ContactItem(Icons.phone_outlined, '+213 555 123 456'),
              const SizedBox(height: 16),
              _ContactItem(Icons.access_time, l10n.footerHours),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLogo(),
        const SizedBox(height: 24),
        Text(
          l10n.footerTagline,
          style: GoogleFonts.inter(color: Colors.grey[500], fontSize: 14),
        ),
        const SizedBox(height: 40),
        _buildHeader(context, l10n.footerNavigation),
        const SizedBox(height: 16),
        _FooterLink(l10n.footerHome, onTap: () => context.go(AppRoutes.splash)),
        _FooterLink(
          l10n.footerBranches,
          onTap: () => context.go(AppRoutes.webBranches),
        ),
        _FooterLink(
          l10n.footerPricing,
          onTap: () => context.go(AppRoutes.webPricing),
        ),
        _FooterLink(l10n.navBlog, onTap: () => context.go(AppRoutes.webBlog)),
        _FooterLink(
          l10n.footerContact,
          onTap: () => context.go(AppRoutes.webContact),
        ),
        const SizedBox(height: 40),
        _buildHeader(context, l10n.footerBranches),
        const SizedBox(height: 16),
        _BranchLink(
          'GYM ÉLYSÉE DZ (Hydra)',
          onTap: () => context.go('/branch-details/1'),
        ),
        _BranchLink(
          'GYM ÉLYSÉE BOXE (Oran)',
          onTap: () => context.go('/branch-details/2'),
        ),
        _BranchLink(
          'TIGER SPORT DZ (Bouchaoui)',
          onTap: () => context.go('/branch-details/3'),
        ),
        _BranchLink(
          'GYM ÉLYSÉE GRAPPLING (Constantine)',
          onTap: () => context.go('/branch-details/4'),
        ),
        _BranchLink(
          'GYM ÉLYSÉE FEMMES (Cheraga)',
          onTap: () => context.go('/branch-details/5'),
        ),
        _BranchLink(
          'GYM ÉLYSÉE CROSSFIT (Ben Aknoun)',
          onTap: () => context.go('/branch-details/6'),
        ),
        const SizedBox(height: 40),
        _buildHeader(context, l10n.footerContact),
        const SizedBox(height: 16),
        _ContactItem(Icons.email_outlined, 'contact@gymelysee.dz'),
        const SizedBox(height: 8),
        _ContactItem(Icons.phone_outlined, '+213 555 123 456'),
        const SizedBox(height: 8),
        _ContactItem(Icons.access_time, l10n.footerHours),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _AnimatedSocialIcon(
              FontAwesomeIcons.facebookF,
              url: 'https://facebook.com',
              color: Colors.blue,
            ),
            const SizedBox(width: 12),
            _AnimatedSocialIcon(
              FontAwesomeIcons.instagram,
              url: 'https://instagram.com',
              color: Colors.pink,
            ),
            const SizedBox(width: 12),
            _AnimatedSocialIcon(
              FontAwesomeIcons.youtube,
              url: 'https://youtube.com',
              color: Colors.red,
            ),
            const SizedBox(width: 12),
            _AnimatedSocialIcon(
              FontAwesomeIcons.tiktok,
              url: 'https://tiktok.com',
              color: Colors.white,
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      'assets/images/logo.png',
      height: 150,
      fit: BoxFit.contain,
    );
  }

  Widget _buildHeader(BuildContext context, String text) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            gradient: AppColors.fieryGradient,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: GoogleFonts.oswald(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

class _BackToTopButton extends StatefulWidget {
  @override
  State<_BackToTopButton> createState() => _BackToTopButtonState();
}

class _BackToTopButtonState extends State<_BackToTopButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {
          Scrollable.of(context).position.animateTo(
            0,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: _isHovered ? AppColors.brandOrange : Colors.transparent,
            border: Border.all(
              color: _isHovered ? AppColors.brandOrange : Colors.white24,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedRotation(
                duration: const Duration(milliseconds: 200),
                turns: _isHovered ? -0.25 : 0,
                child: Icon(
                  Icons.arrow_upward,
                  color: _isHovered
                      ? Colors.black
                      : (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white54
                            : Colors.black54),
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                l10n.footerBackToTop,
                style: GoogleFonts.oswald(
                  color: _isHovered
                      ? Colors.black
                      : (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white54
                            : Colors.black54),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterLink extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  const _FooterLink(this.text, {required this.onTap});

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: GoogleFonts.inter(
              color: _isHovered ? AppColors.brandOrange : Colors.grey[500],
              fontSize: 14,
            ),
            child: Text(widget.text),
          ),
        ),
      ),
    );
  }
}

class _BranchLink extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  const _BranchLink(this.text, {required this.onTap});

  @override
  State<_BranchLink> createState() => _BranchLinkState();
}

class _BranchLinkState extends State<_BranchLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  transform: Matrix4.identity()
                    ..rotateZ(0.785398)
                    // ignore: deprecated_member_use
                    ..scale(_isHovered ? 1.2 : 1.0, _isHovered ? 1.2 : 1.0),
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: _isHovered
                          ? AppColors.brandOrange
                          : Colors.transparent,
                      border: Border.all(
                        color: _isHovered
                            ? AppColors.brandOrange
                            : AppColors.brandYellow,
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: GoogleFonts.inter(
                    color: _isHovered
                        ? AppColors.brandOrange
                        : Colors.grey[500],
                    fontSize: 14,
                    height: 1.5,
                  ),
                  child: Text(widget.text),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const _ContactItem(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.brandOrange, size: 16),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              color: Colors.grey[500],
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _FooterMiniLink extends StatefulWidget {
  final String text;
  const _FooterMiniLink(this.text);

  @override
  State<_FooterMiniLink> createState() => _FooterMiniLinkState();
}

class _FooterMiniLinkState extends State<_FooterMiniLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Text(
        widget.text,
        style: GoogleFonts.inter(
          color: _isHovered ? AppColors.brandOrange : Colors.grey[600],
          fontSize: 12,
          decoration: _isHovered ? TextDecoration.underline : null,
        ),
      ),
    );
  }
}

class _AnimatedSocialIcon extends StatefulWidget {
  final IconData icon;
  final String url;
  final Color color;
  const _AnimatedSocialIcon(
    this.icon, {
    required this.url,
    required this.color,
  });

  @override
  State<_AnimatedSocialIcon> createState() => _AnimatedSocialIconState();
}

class _AnimatedSocialIconState extends State<_AnimatedSocialIcon> {
  bool _isHovered = false;

  Future<void> _launchUrl() async {
    final Uri uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: _launchUrl,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 40,
          height: 40,
          transform: Matrix4.identity()
            // ignore: deprecated_member_use
            ..scale(_isHovered ? 1.1 : 1.0, _isHovered ? 1.1 : 1.0),
          decoration: BoxDecoration(
            color: _isHovered
                ? widget.color.withValues(alpha: 0.2)
                : const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _isHovered ? widget.color : Colors.transparent,
            ),
          ),
          child: Center(
            child: FaIcon(
              widget.icon,
              size: 16,
              color: _isHovered ? widget.color : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }
}
