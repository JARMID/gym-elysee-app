import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class WebHoverMenu extends StatefulWidget {
  final String title;
  final String route;
  final bool isActive;
  final List<String> items;
  final Function(String) onItemClick;

  const WebHoverMenu({
    super.key,
    required this.title,
    required this.route,
    this.isActive = false,
    required this.items,
    required this.onItemClick,
  });

  @override
  State<WebHoverMenu> createState() => _WebHoverMenuState();
}

class _WebHoverMenuState extends State<WebHoverMenu> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isButtonHovered = false;
  bool _isOverlayHovered = false;

  bool get _shouldShowHoverEffect => _isButtonHovered || _isOverlayHovered;

  void _checkOverlay() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        if (!_shouldShowHoverEffect) {
          _removeOverlay();
        } else if (_overlayEntry == null) {
          _showOverlay();
        }
        // Force rebuild to update hover styles
        setState(() {});
      }
    });
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Positioned(
        width: 200,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: const Offset(0, 30),
          showWhenUnlinked: false,
          child: MouseRegion(
            onEnter: (_) {
              _isOverlayHovered = true;
              _checkOverlay();
            },
            onExit: (_) {
              _isOverlayHovered = false;
              _checkOverlay();
            },
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(4),
              color: AppColors.cardDark,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.items.map((item) {
                  return InkWell(
                    onTap: () {
                      _isOverlayHovered = false; // Reset immediately on click
                      _removeOverlay();
                      widget.onItemClick(item);
                    },
                    hoverColor: AppColors.gold.withValues(alpha: 0.1),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.white.withValues(alpha: 0.05),
                          ),
                        ),
                      ),
                      child: Text(
                        item.toUpperCase(),
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor = isDark ? Colors.white : Colors.black;
    final defaultColorMuted = isDark ? Colors.white70 : Colors.black54;

    return CompositedTransformTarget(
      link: _layerLink,
      child: MouseRegion(
        onEnter: (_) {
          _isButtonHovered = true;
          _checkOverlay();
        },
        onExit: (_) {
          _isButtonHovered = false;
          _checkOverlay();
        },
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => context.go(widget.route),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: GoogleFonts.oswald(
                        fontSize: 16,
                        fontWeight: widget.isActive || _shouldShowHoverEffect
                            ? FontWeight.w600
                            : FontWeight.w400,
                        letterSpacing: 1.2,
                        color: widget.isActive
                            ? AppColors.brandOrange
                            : (_shouldShowHoverEffect
                                  ? AppColors.brandYellow
                                  : defaultColor),
                      ),
                      child: Text(widget.title.toUpperCase()),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 16,
                      color: widget.isActive
                          ? AppColors.brandOrange
                          : (_shouldShowHoverEffect
                                ? AppColors.brandYellow
                                : defaultColorMuted),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: widget.isActive || _shouldShowHoverEffect ? 20 : 0,
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: AppColors.fieryGradient,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
