import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/routing/app_router.dart';
import '../../providers/landing_providers.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/web/web_nav_bar.dart';
import '../../widgets/web/web_hero_section.dart';
import '../../widgets/web/web_stats_section.dart';
import '../../widgets/web/web_features_grid.dart';
import '../../widgets/web/web_testimonials_section.dart';
import '../../widgets/web/web_footer.dart';
import '../../widgets/web/web_newsletter_section.dart';
import '../../widgets/web/web_pricing_section_new.dart';

import '../../widgets/web/web_cta_section.dart';
import '../../widgets/web/web_blog_preview_section.dart';
import '../../widgets/web/web_branches_section.dart';
import '../../widgets/web/web_transformations_section.dart';
import '../../widgets/web/web_download_app_section.dart';
import 'mobile_landing_page.dart';

/// Platform-aware landing page wrapper
/// Shows desktop-optimized web version on browsers
/// Shows mobile-optimized simple version on mobile apps
class WebLandingPage extends StatelessWidget {
  const WebLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Platform detection:
    // 1. Show Web/Desktop version ONLY if screen is wide enough (> 900px) AND we are on web/desktop
    // 2. Otherwise show Mobile App version (works for phones, tabletsMain, and small browser windows)
    final isLargeScreen = MediaQuery.of(context).size.width > 900;

    if (kIsWeb && isLargeScreen) {
      return const _DesktopWebLandingPage();
    } else {
      return const MobileLandingPage();
    }
  }
}

class _DesktopWebLandingPage extends ConsumerStatefulWidget {
  const _DesktopWebLandingPage();

  @override
  ConsumerState<_DesktopWebLandingPage> createState() =>
      _DesktopWebLandingPageState();
}

class _DesktopWebLandingPageState
    extends ConsumerState<_DesktopWebLandingPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 50 && !_isScrolled) {
        setState(() => _isScrolled = true);
      } else if (_scrollController.offset <= 50 && _isScrolled) {
        setState(() => _isScrolled = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final plansAsync = ref.watch(membershipPlansProvider);
    final isRamadanMode = ref.watch(ramadanModeProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Main Content
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // 1. Hero Section
                WebHeroSection(topPadding: WebNavBar.getHeight(isRamadanMode)),

                // 2. Stats Section (New)
                _FadeInUp(delay: 200, child: const WebStatsSection()),

                // 3. Features Grid (New)
                _FadeInUp(delay: 300, child: const WebFeaturesGrid()),

                // 4. Branches Section
                _FadeInUp(delay: 400, child: const WebBranchesSection()),

                // 5. Testimonials (New)
                _FadeInUp(delay: 500, child: const WebTestimonialsSection()),

                // 5b. Transformations Section
                _FadeInUp(delay: 550, child: const WebTransformationsSection()),

                // 6. Pricing (New Reusable Widget)
                if (plansAsync.hasValue) const WebPricingSectionNew(),

                // 7. Blog Preview Section
                _FadeInUp(delay: 600, child: const WebBlogPreviewSection()),

                // 9. Final CTA (Start Today)
                _FadeInUp(delay: 700, child: const WebCTASection()),

                // 9b. Download App Section (New)
                _FadeInUp(delay: 750, child: const WebDownloadAppSection()),

                // 10. Newsletter
                _FadeInUp(delay: 800, child: const WebNewsletterSection()),

                // 11. Footer
                const WebFooter(),
              ],
            ),
          ),

          // Fixed Navbar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: WebNavBar(
              isScrolled: _isScrolled,
              activeRoute: AppRoutes.splash,
            ),
          ),
        ],
      ),
    );
  }
}

class _FadeInUp extends StatefulWidget {
  final Widget child;
  final int delay;
  const _FadeInUp({required this.child, required this.delay});
  @override
  State<_FadeInUp> createState() => _FadeInUpState();
}

class _FadeInUpState extends State<_FadeInUp>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _translate;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _opacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _translate = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _translate, child: widget.child),
    );
  }
}
