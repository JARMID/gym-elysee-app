import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gyelyseedz/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../providers/theme_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/admin/change_password_dialog.dart';

class AdminSettingsScreen extends ConsumerStatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  ConsumerState<AdminSettingsScreen> createState() =>
      _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends ConsumerState<AdminSettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailAlerts = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeMode = ref.watch(themeNotifierProvider);
    final locale = ref.watch(languageProvider);

    return Column(
      children: [
        // Header
        Row(
          children: [
            Text(
              l10n.adminNavSettings,
              style: GoogleFonts.oswald(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Appearance Section
                _buildSectionHeader(l10n.settingsAppearance, isDark),
                const SizedBox(height: 16),
                _buildSettingsCard(
                  context,
                  isDark: isDark,
                  children: [
                    _buildSwitchTile(
                      title: l10n.settingsTheme,
                      subtitle: themeMode == ThemeMode.system
                          ? l10n.settingsThemeSystem
                          : (themeMode == ThemeMode.dark
                                ? l10n.settingsThemeDark
                                : l10n.settingsThemeLight),
                      icon: Icons.brightness_6,
                      isDark: isDark,
                      trailing: DropdownButton<ThemeMode>(
                        value: themeMode,
                        dropdownColor: isDark
                            ? const Color(0xFF1E1E1E)
                            : Colors.white,
                        style: GoogleFonts.inter(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        underline: const SizedBox(),
                        items: [
                          DropdownMenuItem(
                            value: ThemeMode.system,
                            child: Text(l10n.settingsThemeSystem),
                          ),
                          DropdownMenuItem(
                            value: ThemeMode.light,
                            child: Text(l10n.settingsThemeLight),
                          ),
                          DropdownMenuItem(
                            value: ThemeMode.dark,
                            child: Text(l10n.settingsThemeDark),
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
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(),
                    ),
                    _buildSwitchTile(
                      title: l10n.settingsLanguage,
                      subtitle: locale.languageCode == 'fr'
                          ? 'Français'
                          : (locale.languageCode == 'ar'
                                ? 'العربية'
                                : 'English'),
                      icon: Icons.language,
                      isDark: isDark,
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
                const SizedBox(height: 32),

                // Notifications Section
                _buildSectionHeader(l10n.settingsNotifications, isDark),
                const SizedBox(height: 16),
                _buildSettingsCard(
                  context,
                  isDark: isDark,
                  children: [
                    _buildSwitchTile(
                      title: 'Push Notifications',
                      subtitle: 'Receive alerts when members inquire',
                      icon: Icons.notifications_active,
                      isDark: isDark,
                      trailing: Switch(
                        value: _notificationsEnabled,
                        onChanged: (val) =>
                            setState(() => _notificationsEnabled = val),
                        activeTrackColor: AppColors.brandOrange,
                        activeThumbColor: Colors.white,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(),
                    ),
                    _buildSwitchTile(
                      title: 'Email Alerts',
                      subtitle: 'Receive daily summary via email',
                      icon: Icons.email,
                      isDark: isDark,
                      trailing: Switch(
                        value: _emailAlerts,
                        onChanged: (val) => setState(() => _emailAlerts = val),
                        activeTrackColor: AppColors.brandOrange,
                        activeThumbColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Security Section
                _buildSectionHeader('Security', isDark),
                const SizedBox(height: 16),
                _buildSettingsCard(
                  context,
                  isDark: isDark,
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
                        'Change Password',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        'Last updated 3 months ago',
                        style: GoogleFonts.inter(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => const ChangePasswordDialog(),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
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
    required List<Widget> children,
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
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isDark,
    required Widget trailing,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isDark ? Colors.white : Colors.grey[700],
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.inter(color: Colors.grey, fontSize: 12),
      ),
      trailing: trailing,
    );
  }
}
