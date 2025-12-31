import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/storage_service.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  final StorageService _storageService;

  ThemeNotifier(this._storageService, ThemeMode initialMode)
    : super(initialMode);

  void toggleTheme(bool isDark) {
    final mode = isDark ? ThemeMode.dark : ThemeMode.light;
    state = mode;
    _storageService.setDarkModeEnabled(isDark);
  }

  void setTheme(ThemeMode mode) {
    state = mode;
    _storageService.setDarkModeEnabled(mode == ThemeMode.dark);
  }
}

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((
  ref,
) {
  throw UnimplementedError(
    'themeNotifierProvider must be overridden in main.dart',
  );
});

final ramadanModeProvider = StateProvider<bool>((ref) => false);
