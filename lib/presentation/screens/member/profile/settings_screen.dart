import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../presentation/providers/theme_provider.dart';
import '../../../../presentation/providers/auth_provider.dart';
import '../../../../presentation/providers/member_provider.dart';
import '../../../../presentation/providers/language_provider.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/app_router.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ramadanMode = ref.watch(ramadanModeProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // Custom Gradient Header
          Container(
            padding: const EdgeInsets.only(
              top: 50,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            decoration: BoxDecoration(
              gradient: AppColors.fieryGradient,
              boxShadow: [
                BoxShadow(
                  color: AppColors.brandOrange.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              l10n.settingsTitle.toUpperCase(),
              style: GoogleFonts.oswald(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
          ),

          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Profile section
                    _buildSectionHeader(l10n.profileTitle.toUpperCase()),
                    _buildSettingsTile(
                      icon: Icons.person_outline,
                      title: l10n.settingsEditProfile,
                      onTap: () => _showEditProfileDialog(context),
                    ),
                    _buildSettingsTile(
                      icon: Icons.lock_outline,
                      title: l10n.settingsChangePassword,
                      onTap: () => _showChangePasswordDialog(context),
                    ),
                    // _buildSettingsTile(
                    //   icon: Icons.phone_android,
                    //   title: l10n.settingsPhone,
                    //   subtitle: '+213 555 123 456',
                    //   onTap: () {},
                    // ),
                    const SizedBox(height: 24),

                    // Notifications
                    _buildSectionHeader(l10n.settingsSectionNotifications),
                    _buildSwitchTile(
                      icon: Icons.notifications_outlined,
                      title: l10n.settingsPushNotifications,
                      subtitle: l10n.qrFeatureNotifDesc,
                      value: _notificationsEnabled,
                      onChanged: (value) =>
                          setState(() => _notificationsEnabled = value),
                    ),
                    _buildSettingsTile(
                      icon: Icons.email_outlined,
                      title: l10n.settingsEmailNotifications,
                      subtitle: l10n.settingsEmailNotificationsDesc,
                      onTap: () => _showEmailNotificationsDialog(context),
                    ),
                    const SizedBox(height: 24),

                    // App Settings
                    _buildSectionHeader(l10n.settingsSectionApp),
                    _buildSettingsTile(
                      icon: Icons.language,
                      title: l10n.settingsLanguage,
                      subtitle: ref
                          .watch(languageProvider)
                          .languageCode
                          .toUpperCase(),
                      onTap: () {
                        _showLanguageDialog(context, ref);
                      },
                    ),
                    _buildSwitchTile(
                      icon: Icons.nightlight_round,
                      title: l10n.settingsRamadanMode,
                      subtitle: l10n.settingsRamadanModeDesc,
                      value: ramadanMode,
                      onChanged: (value) {
                        ref.read(ramadanModeProvider.notifier).state = value;
                      },
                    ),
                    _buildSettingsTile(
                      icon: Icons.dark_mode_outlined,
                      title: l10n.settingsTheme,
                      subtitle: l10n.settingsThemeDesc,
                      onTap: () => _showThemeDialog(context, ref),
                    ),
                    const SizedBox(height: 24),

                    // Support
                    _buildSectionHeader(l10n.settingsSectionSupport),
                    _buildSettingsTile(
                      icon: Icons.help_outline,
                      title: l10n.settingsHelpCenter,
                      onTap: () => _showHelpDialog(context),
                    ),
                    _buildSettingsTile(
                      icon: Icons.privacy_tip_outlined,
                      title: l10n.settingsPrivacyPolicy,
                      onTap: () => _showPrivacyDialog(context),
                    ),
                    _buildSettingsTile(
                      icon: Icons.info_outline,
                      title: l10n.settingsAbout,
                      subtitle: 'v1.0.0',
                      onTap: () => _showAboutDialog(context),
                    ),

                    const SizedBox(height: 32),
                    TextButton(
                      onPressed: _showDeleteAccountDialog,
                      child: Text(
                        l10n.settingsDeleteAccount,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.brandOrange,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.brandOrange.withValues(alpha: 0.1),
          child: Icon(icon, color: AppColors.brandOrange),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              )
            : null,
        trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      child: SwitchListTile(
        // ignore: deprecated_member_use
        activeColor: AppColors.brandOrange,
        secondary: CircleAvatar(
          backgroundColor: AppColors.brandOrange.withValues(alpha: 0.1),
          child: Icon(icon, color: AppColors.brandOrange),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  void _showDeleteAccountDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning, color: Colors.red),
            const SizedBox(width: 8),
            Text(l10n.settingsDeleteAccountTitle),
          ],
        ),
        content: Text(l10n.settingsDeleteAccountContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.settingsCancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              // Implement account deletion
              try {
                await ref.read(authRepositoryProvider).deleteAccount();
                if (mounted) {
                  // Navigation to login is handled by auth state change usually,
                  // but we can force it or let the provider listener handle it.
                  // Assuming AuthProvider is watching auth state.
                  // But explicit navigation is safer after logout.
                  context.go(AppRoutes.login);
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
            child: Text(
              l10n.settingsDelete,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Choisir le thème'),
        children: [
          SimpleDialogOption(
            onPressed: () {
              ref
                  .read(themeNotifierProvider.notifier)
                  .setTheme(ThemeMode.system);
              Navigator.pop(context);
            },
            child: const Text('Système'),
          ),
          SimpleDialogOption(
            onPressed: () {
              ref
                  .read(themeNotifierProvider.notifier)
                  .setTheme(ThemeMode.light);
              Navigator.pop(context);
            },
            child: const Text('Clair'),
          ),
          SimpleDialogOption(
            onPressed: () {
              ref.read(themeNotifierProvider.notifier).setTheme(ThemeMode.dark);
              Navigator.pop(context);
            },
            child: const Text('Sombre'),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => _EditProfileDialog());
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => _ChangePasswordDialog());
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choisir la langue'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption(context, ref, 'Français', 'fr'),
            _buildLanguageOption(context, ref, 'English', 'en'),
            _buildLanguageOption(context, ref, 'العربية', 'ar'),
            _buildLanguageOption(context, ref, 'Español', 'es'),
            _buildLanguageOption(context, ref, 'Italiano', 'it'),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    WidgetRef ref,
    String label,
    String code,
  ) {
    final currentLocale = ref.watch(languageProvider);
    final isSelected = currentLocale.languageCode == code;

    return ListTile(
      title: Text(label),
      trailing: isSelected
          ? const Icon(Icons.check, color: AppColors.brandOrange)
          : null,
      onTap: () {
        ref.read(languageProvider.notifier).setLocale(code);
        Navigator.pop(context);
      },
    );
  }

  void _showEmailNotificationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifications Email'),
        content: const Text(
          'Gérer vos préférences de notifications par email.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Centre d\'aide'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            ListTile(
              leading: Icon(Icons.email, color: AppColors.brandOrange),
              title: Text('Support Email'),
              subtitle: Text('support@gym-elysee.dz'),
            ),
            ListTile(
              leading: Icon(Icons.phone, color: AppColors.brandOrange),
              title: Text('Téléphone'),
              subtitle: Text('+213 555 123 456'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Politique de confidentialité'),
        content: const SingleChildScrollView(
          child: Text(
            'Vos données sont sécurisées...\n\n(Contenu de la politique de confidentialité ici)',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AboutDialog(
        applicationName: 'Gym Elysée',
        applicationVersion: '1.0.0',
        applicationIcon: Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            color: AppColors.brandOrange,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.fitness_center, color: Colors.white),
        ),
        children: const [
          SizedBox(height: 20),
          Text('L\'application officielle de Gym Elysée.'),
        ],
      ),
    );
  }
}

class _EditProfileDialog extends ConsumerStatefulWidget {
  @override
  ConsumerState<_EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends ConsumerState<_EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _bioController = TextEditingController();
  XFile? _newPhoto;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authNotifierProvider).user;
    _firstNameController.text = user?.firstName ?? '';
    _lastNameController.text = user?.lastName ?? '';
    _phoneController.text = user?.phone ?? '';
    _cityController.text = user?.city ?? '';
    _bioController.text = user?.bio ?? '';
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _newPhoto = pickedFile;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(memberRepositoryProvider).updateProfile(0, {
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'phone': _phoneController.text,
        'city': _cityController.text,
        'bio': _bioController.text,
      }, _newPhoto);

      if (mounted) {
        await ref.read(authNotifierProvider.notifier).checkAuth();
        if (!mounted) return;
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Profil mis à jour!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(authNotifierProvider).user;

    if (_newPhoto != null) {
      // kIsWeb check is ideal but we can just rely on network for web if we had a blob url,
      // but here we have XFile.
      // On Web, Image.network(path) works if it's a blob url, but XFile.path is barely useful on web.
      // XFile has readAsBytes.
      // Easiest cross platform way without extra deps:
      // If web, use Image.network(_newPhoto!.path) (image_picker 0.8+ returns blob url)
      // OR assume io is safe if not web.
      // Let's use FutureBuilder for bytes if needed, OR just `FileImage` inside a condition.
      // ACTUALLY: flutter/foundation.dart kIsWeb.
      // But we don't want to import logic here if we can avoid it.
      // Let's just use `CrossPlatformImage` approach or simplistic:
      // For this simple dialog, let's use a FutureBuilder to read bytes for preview if generic.
      // OR simpler: `Image.network` works for XFile.path on Web? Yes typically.
      // But `FileImage` throws on Web.
      // So:
    }

    return AlertDialog(
      title: const Text('Modifier le profil'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: _newPhoto == null && user?.photo != null
                          ? NetworkImage(user!.photo!)
                          : null,
                      child: _newPhoto != null
                          ? FutureBuilder<Uint8List>(
                              future: _newPhoto!.readAsBytes(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }
                                if (snapshot.hasData) {
                                  return ClipOval(
                                    child: Image.memory(
                                      snapshot.data!,
                                      fit: BoxFit.cover,
                                      width: 80,
                                      height: 80,
                                    ),
                                  );
                                }
                                return const Icon(Icons.error);
                              },
                            )
                          : (_newPhoto == null && user?.photo == null
                                ? const Icon(Icons.person, size: 40)
                                : null),
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.brandOrange,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'Prénom'),
                validator: (v) => v?.isEmpty == true ? 'Requis' : null,
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Nom'),
                validator: (v) => v?.isEmpty == true ? 'Requis' : null,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Téléphone'),
              ),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'Ville'),
              ),
              TextFormField(
                controller: _bioController,
                decoration: const InputDecoration(labelText: 'Bio'),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _saveProfile,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Enregistrer'),
        ),
      ],
    );
  }
}

class _ChangePasswordDialog extends ConsumerStatefulWidget {
  @override
  ConsumerState<_ChangePasswordDialog> createState() =>
      _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends ConsumerState<_ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  bool _isLoading = false;

  Future<void> _change() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      await ref
          .read(authRepositoryProvider)
          .changePassword(_currentController.text, _newController.text);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Mot de passe changé!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Changer mot de passe'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _currentController,
              decoration: const InputDecoration(labelText: 'Actuel'),
              obscureText: true,
              validator: (v) => v?.isNotEmpty == true ? null : 'Requis',
            ),
            TextFormField(
              controller: _newController,
              decoration: const InputDecoration(labelText: 'Nouveau'),
              obscureText: true,
              validator: (v) => (v?.length ?? 0) >= 8 ? null : 'Min 8 chars',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _change,
          child: const Text('Valider'),
        ),
      ],
    );
  }
}
