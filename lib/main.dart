import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'l10n/app_localizations.dart';
import 'presentation/providers/language_provider.dart';

import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';
import 'data/services/api_service.dart';
import 'data/services/storage_service.dart';
import 'data/repositories/auth_repository.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/branch_provider.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/widgets/web/web_layout_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Initialize services
  final secureStorage = const FlutterSecureStorage();
  final prefs = await SharedPreferences.getInstance();
  final storageService = StorageService(secureStorage, prefs);
  final apiService = ApiService(storageService);
  final authRepository = AuthRepository(apiService, storageService);

  // Check initial theme preference
  final isDark = await storageService.isDarkModeEnabled();
  final initialThemeMode = isDark ? ThemeMode.dark : ThemeMode.light;

  runApp(
    ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
        authNotifierProvider.overrideWith(
          (ref) => AuthNotifier(authRepository),
        ),
        storageServiceProvider.overrideWithValue(storageService),
        apiServiceProvider.overrideWithValue(apiService),
        themeNotifierProvider.overrideWith(
          (ref) => ThemeNotifier(storageService, initialThemeMode),
        ),
      ],
      child: const GymElyseeApp(),
    ),
  );
}

class GymElyseeApp extends ConsumerWidget {
  const GymElyseeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeNotifierProvider);

    return MaterialApp.router(
      title: 'GYM ÉLYSÉE DZ',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      // TODO: Add Ramadan theme toggle
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: ref.watch(languageProvider),
      builder: (context, child) =>
          WebLayoutWrapper(child: child ?? const SizedBox()),
      routerConfig: router,
    );
  }
}
