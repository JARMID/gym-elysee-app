import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:gyelyseedz/l10n/app_localizations.dart';
import '../../providers/member_provider.dart';

class QRCodeScreen extends ConsumerStatefulWidget {
  const QRCodeScreen({super.key});

  @override
  ConsumerState<QRCodeScreen> createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends ConsumerState<QRCodeScreen> {
  late ScreenBrightness _brightness;
  String? _qrCode;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _brightness = ScreenBrightness();
    _setMaxBrightness();
    _fetchQRCode();
  }

  Future<void> _fetchQRCode() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await ref.read(memberRepositoryProvider).getSecureQRCode();
      if (mounted) {
        setState(() {
          _qrCode = data['qr_code'];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Error loading QR Code';
          _isLoading = false;
        });
      }
    }
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
              child: _isLoading
                  ? const SizedBox(
                      width: 280,
                      height: 280,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : _error != null
                  ? SizedBox(
                      width: 280,
                      height: 280,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(_error!, textAlign: TextAlign.center),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: _fetchQRCode,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : QrImageView(
                      data: _qrCode ?? '',
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
