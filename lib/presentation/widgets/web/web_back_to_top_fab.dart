import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/theme/app_colors.dart';

class WebBackToTopFAB extends StatefulWidget {
  final ScrollController scrollController;

  const WebBackToTopFAB({super.key, required this.scrollController});

  @override
  State<WebBackToTopFAB> createState() => _WebBackToTopFABState();
}

class _WebBackToTopFABState extends State<WebBackToTopFAB> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (widget.scrollController.offset > 400 && !_isVisible) {
      setState(() => _isVisible = true);
    } else if (widget.scrollController.offset <= 400 && _isVisible) {
      setState(() => _isVisible = false);
    }
  }

  void _scrollToTop() {
    widget.scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) =>
          ScaleTransition(scale: animation, child: child),
      child: _isVisible
          ? FloatingActionButton(
              key: const ValueKey('backToTop'),
              onPressed: _scrollToTop,
              backgroundColor: AppColors.brandOrange,
              elevation: 4,
              child: const FaIcon(
                FontAwesomeIcons.arrowUp,
                color: Colors.black,
                size: 20,
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
