import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class WebLayoutWrapper extends StatefulWidget {
  final Widget child;

  const WebLayoutWrapper({super.key, required this.child});

  @override
  State<WebLayoutWrapper> createState() => _WebLayoutWrapperState();
}

class _WebLayoutWrapperState extends State<WebLayoutWrapper> {
  final ValueNotifier<Offset> _mousePosition = ValueNotifier(Offset.zero);
  final ValueNotifier<bool> _isHovering = ValueNotifier(false);

  @override
  void dispose() {
    _mousePosition.dispose();
    _isHovering.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Only apply custom cursor on desktop web if possible,
    // but for now we apply generally as it's a web target.
    return MouseRegion(
      onHover: (event) {
        _mousePosition.value = event.position;
        if (!_isHovering.value) _isHovering.value = true;
      },
      onExit: (_) => _isHovering.value = false,
      // Hide system cursor generally, but clickable widgets will override this
      // with SystemMouseCursors.click which will show the pointer.
      // To strictly force custom cursor everywhere, we'd need to wrap all buttons.
      // A better approach: Show our custom ring cursor *in addition* to system cursor
      // strictly for aesthetic, or hide system cursor if we are confident.
      // Let's try keeping system cursor but adding the ring as a "follower".
      cursor: SystemMouseCursors.basic,
      child: Stack(
        children: [
          // 1. The Main Content
          widget.child,

          // 2. Noise Overlay
          Positioned.fill(
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.03, // Subtle grain
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://t3.ftcdn.net/jpg/02/98/94/30/360_F_298943009_8r2r3Xf5G7o0f3X5.jpg', // Generic noise texture
                      ),
                      repeat: ImageRepeat.repeat,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 3. Custom Cursor Follower (Gold Ring)
          ValueListenableBuilder<Offset>(
            valueListenable: _mousePosition,
            builder: (context, position, child) {
              return ValueListenableBuilder<bool>(
                valueListenable: _isHovering,
                builder: (context, isHovering, _) {
                  if (!isHovering) return const SizedBox();

                  return Positioned(
                    left: position.dx - 15,
                    top: position.dy - 15,
                    child: IgnorePointer(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.gold.withValues(alpha: 0.5),
                            width: 1.5,
                          ),
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),

          // 4. Custom Dot (Inner)
          ValueListenableBuilder<Offset>(
            valueListenable: _mousePosition,
            builder: (context, position, child) {
              return ValueListenableBuilder<bool>(
                valueListenable: _isHovering,
                builder: (context, isHovering, _) {
                  if (!isHovering) return const SizedBox();

                  return Positioned(
                    left: position.dx - 3,
                    top: position.dy - 3,
                    child: IgnorePointer(
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.brandOrange.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

