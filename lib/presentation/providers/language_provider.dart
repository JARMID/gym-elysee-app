import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/storage_service.dart';
import 'branch_provider.dart';

final languageProvider = StateNotifierProvider<LanguageNotifier, Locale>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return LanguageNotifier(storage);
});

class LanguageNotifier extends StateNotifier<Locale> {
  final StorageService _storage;

  LanguageNotifier(this._storage) : super(const Locale('fr')) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final savedCode = await _storage.getSelectedLanguage();
    if (savedCode != null) {
      state = Locale(savedCode);
    }
  }

  Future<void> setLanguage(Locale locale) async {
    state = locale;
    await _storage.setSelectedLanguage(locale.languageCode);
  }

  Future<void> setLocale(String languageCode) async {
    state = Locale(languageCode);
    await _storage.setSelectedLanguage(languageCode);
  }
}
