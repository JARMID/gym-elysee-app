import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/member_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/language_provider.dart';

class CoachSettingsScreen extends ConsumerStatefulWidget {
  const CoachSettingsScreen({super.key});

  @override
  ConsumerState<CoachSettingsScreen> createState() =>
      _CoachSettingsScreenState();
}

class _CoachSettingsScreenState extends ConsumerState<CoachSettingsScreen> {
  bool _isUploading = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickAndUploadPhoto() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      setState(() => _isUploading = true);

      await ref.read(memberRepositoryProvider).updateProfile(0, {}, image);

      await ref.read(authNotifierProvider.notifier).checkAuth();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Photo de profil mise à jour!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authNotifierProvider).user;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeMode = ref.watch(themeNotifierProvider);
    final locale = ref.watch(languageProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'PARAMÈTRES',
          style: GoogleFonts.oswald(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            _buildSectionHeader('PROFILE', isDark),
            const SizedBox(height: 16),
            _buildSettingsCard(
              context,
              isDark: isDark,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: AppColors.brandOrange,
                          backgroundImage: user?.photo != null
                              ? CachedNetworkImageProvider(user!.photo!)
                              : null,
                          child: _isUploading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : (user?.photo == null
                                    ? Text(
                                        user?.firstName
                                                .substring(0, 1)
                                                .toUpperCase() ??
                                            'C',
                                        style: const TextStyle(
                                          fontSize: 32,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : null),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _isUploading ? null : _pickAndUploadPhoto,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.brandOrange,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isDark ? Colors.black : Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.fullName ?? 'Coach',
                            style: GoogleFonts.oswald(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.email ?? '',
                            style: GoogleFonts.inter(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'COACH',
                              style: GoogleFonts.oswald(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Appearance Section
            _buildSectionHeader('APPARENCE', isDark),
            const SizedBox(height: 16),
            _buildSettingsCard(
              context,
              isDark: isDark,
              child: Column(
                children: [
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.brightness_6,
                        color: isDark ? Colors.white : Colors.grey[700],
                        size: 20,
                      ),
                    ),
                    title: Text(
                      'Thème',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      themeMode == ThemeMode.system
                          ? 'Système'
                          : (themeMode == ThemeMode.dark ? 'Sombre' : 'Clair'),
                      style: GoogleFonts.inter(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    trailing: DropdownButton<ThemeMode>(
                      value: themeMode,
                      dropdownColor: isDark
                          ? const Color(0xFF1E1E1E)
                          : Colors.white,
                      style: GoogleFonts.inter(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(
                          value: ThemeMode.system,
                          child: Text('Système'),
                        ),
                        DropdownMenuItem(
                          value: ThemeMode.light,
                          child: Text('Clair'),
                        ),
                        DropdownMenuItem(
                          value: ThemeMode.dark,
                          child: Text('Sombre'),
                        ),
                      ],
                      onChanged: (mode) {
                        if (mode != null) {
                          ref
                              .read(themeNotifierProvider.notifier)
                              .setTheme(mode);
                        }
                      },
                    ),
                  ),
                  Divider(color: isDark ? Colors.white12 : Colors.grey[200]),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.language,
                        color: isDark ? Colors.white : Colors.grey[700],
                        size: 20,
                      ),
                    ),
                    title: Text(
                      'Langue',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      locale.languageCode == 'fr'
                          ? 'Français'
                          : (locale.languageCode == 'ar'
                                ? 'العربية'
                                : 'English'),
                      style: GoogleFonts.inter(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    trailing: DropdownButton<Locale>(
                      value: locale,
                      dropdownColor: isDark
                          ? const Color(0xFF1E1E1E)
                          : Colors.white,
                      style: GoogleFonts.inter(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(
                          value: Locale('fr'),
                          child: Text('Français'),
                        ),
                        DropdownMenuItem(
                          value: Locale('en'),
                          child: Text('English'),
                        ),
                        DropdownMenuItem(
                          value: Locale('ar'),
                          child: Text('العربية'),
                        ),
                      ],
                      onChanged: (newLocale) {
                        if (newLocale != null) {
                          ref
                              .read(languageProvider.notifier)
                              .setLanguage(newLocale);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Account Section
            _buildSectionHeader('COMPTE', isDark),
            const SizedBox(height: 16),
            _buildSettingsCard(
              context,
              isDark: isDark,
              child: Column(
                children: [
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.brandOrange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.lock_outline,
                        color: AppColors.brandOrange,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      'Changer le mot de passe',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      // TODO: Show change password dialog
                    },
                  ),
                  Divider(color: isDark ? Colors.white12 : Colors.grey[200]),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.logout,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      'Se déconnecter',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                    onTap: () {
                      ref.read(authNotifierProvider.notifier).logout();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.grey[400] : Colors.grey[600],
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context, {
    required bool isDark,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.grey[200]!,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: child,
    );
  }
}
