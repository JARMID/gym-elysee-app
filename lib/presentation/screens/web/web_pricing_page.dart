import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/theme_provider.dart';
import '../../../core/routing/app_router.dart';

import '../../widgets/web/web_footer.dart';
import '../../widgets/web/web_nav_bar.dart';
import '../../widgets/web/web_pricing_page_section.dart';

class WebPricingPage extends ConsumerStatefulWidget {
  const WebPricingPage({super.key});

  @override
  ConsumerState<WebPricingPage> createState() => _WebPricingPageState();
}

class _WebPricingPageState extends ConsumerState<WebPricingPage> {
  @override
  Widget build(BuildContext context) {
    // Only used for Navbar positioning/padding logic if needed
    final isRamadanMode = ref.watch(ramadanModeProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // Spacing for fixed Navbar
                SizedBox(height: WebNavBar.getHeight(isRamadanMode) + 20),

                // New Pricing Section (Header, Banner, Cards, Comparison, Payment, CTA)
                const WebPricingPageSection(),

                const SizedBox(height: 80),

                // Footer
                const WebFooter(),
              ],
            ),
          ),

          // Positioned Navbar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: WebNavBar(
              isScrolled: true, // Always opaque for internal pages
              activeRoute: AppRoutes.webPricing,
            ),
          ),
        ],
      ),
    );
  }
}
