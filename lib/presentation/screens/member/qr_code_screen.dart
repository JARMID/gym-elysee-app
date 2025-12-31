import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:gyelyseedz/l10n/app_localizations.dart';

class QRCodeScreen extends StatefulWidget {
  final String qrCode;

  const QRCodeScreen({super.key, required this.qrCode});

  @override
  State<QRCodeScreen> createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  late ScreenBrightness _brightness;

  @override
  void initState() {
    super.initState();
    _brightness = ScreenBrightness();
    _setMaxBrightness();
  }

  Future<void> _setMaxBrightness() async {
    try {
      await _brightness.setScreenBrightness(1.0);
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _resetBrightness() async {
    try {
      await _brightness.resetScreenBrightness();
    } catch (e) {
      // Handle error silently
    }
  }

  @override
  void dispose() {
    _resetBrightness();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
        title: Text(
          l10n.qrTitle,
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // QR Code
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: QrImageView(
                data: widget.qrCode,
                size: 280,
                backgroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 32),

            // Instructions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                l10n.qrInstructions,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isDark ? Colors.white : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.qrValid,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.grey : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
