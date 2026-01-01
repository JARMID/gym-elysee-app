import 'package:flutter/material.dart';
import '../../../core/routing/app_router.dart';
import '../../widgets/web/web_page_shell.dart';
import '../../widgets/web/web_pricing_page_section.dart';
import '../../widgets/mobile/mobile_page_wrapper.dart';
import 'package:gyelyseedz/l10n/app_localizations.dart';

class WebPricingPage extends StatelessWidget {
  final bool useMobileWrapper;
  const WebPricingPage({super.key, this.useMobileWrapper = false});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final content = const Column(
      children: [
        // Pricing Section (Header, Banner, Cards, Comparison, Payment, CTA)
        WebPricingPageSection(),
        SizedBox(height: 80),
      ],
    );

    if (useMobileWrapper) {
      return MobilePageWrapper(
        title: l10n.navPricing.toUpperCase(),
        showBackButton: true,
        child: SingleChildScrollView(child: content),
      );
    }

    return WebPageShell(activeRoute: AppRoutes.webPricing, child: content);
  }
}
