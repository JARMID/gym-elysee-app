import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/theme_provider.dart';
import 'web_nav_bar.dart';
import 'web_footer.dart';
import 'web_back_to_top_fab.dart';

/// Unified page shell for all web pages
/// Provides consistent NavBar, Footer, FAB, and mobile handling
class WebPageShell extends ConsumerStatefulWidget {
  final Widget child;
  final String activeRoute;
  final bool showFooter;
  final bool showFAB;

  const WebPageShell({
    super.key,
    required this.child,
    required this.activeRoute,
    this.showFooter = true,
    this.showFAB = true,
  });

  @override
  ConsumerState<WebPageShell> createState() => _WebPageShellState();
}

class _WebPageShellState extends ConsumerState<WebPageShell> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRamadanMode = ref.watch(ramadanModeProvider);
    final theme = Theme.of(context);

    // Mobile detection: show mobile experience for small screens
    // For internal pages, we want to show the responsive content, not the landing page
    // The content itself handles responsivity via LayoutBuilder/MediaQuery

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Main scrollable content
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // Spacing for fixed NavBar
                SizedBox(height: WebNavBar.getHeight(isRamadanMode)),

                // Page content
                widget.child,

                // Footer
                if (widget.showFooter) const WebFooter(),
              ],
            ),
          ),

          // Fixed NavBar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: WebNavBar(isScrolled: true, activeRoute: widget.activeRoute),
          ),
        ],
      ),
      floatingActionButton: widget.showFAB
          ? WebBackToTopFAB(scrollController: _scrollController)
          : null,
    );
  }
}
