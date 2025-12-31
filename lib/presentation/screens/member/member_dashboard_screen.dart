import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../presentation/providers/auth_provider.dart';
import '../../../presentation/widgets/member/member_card_widget.dart';
import '../payment/payment_methods_screen.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import 'package:gyelyseedz/l10n/app_localizations.dart';
import '../../widgets/member/member_calendar_widget.dart';
import 'qr_code_screen.dart';
import '../../../presentation/providers/subscription_provider.dart';

// Provider to manage user photos
final userPhotosProvider =
    StateNotifierProvider<UserPhotosNotifier, List<String>>((ref) {
      return UserPhotosNotifier();
    });

class UserPhotosNotifier extends StateNotifier<List<String>> {
  UserPhotosNotifier() : super([]);

  void addPhoto(String path) {
    state = [...state, path];
  }

  void removePhoto(String path) {
    state = state.where((p) => p != path).toList();
  }
}

class MemberDashboardScreen extends ConsumerWidget {
  const MemberDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;
    final photos = ref.watch(userPhotosProvider);
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Watch subscription data
    final subscriptionAsync = ref.watch(mySubscriptionProvider);

    if (user == null) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.brandOrange),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          l10n.dashboardTitle,
          style: GoogleFonts.oswald(
            letterSpacing: 1.5,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings_outlined,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () {
              context.push(AppRoutes.settings);
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background Gradient decoration
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.brandOrange.withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: subscriptionAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.brandOrange),
              ),
              error: (err, stack) => Center(
                child: Text(
                  'Error loading dashboard: $err',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              data: (subscription) {
                final subscriptionEnd = DateTime.parse(subscription['endDate']);
                final isExpired = subscription['status'] == 'expired';
                final amountDue = subscription['amountDue'];

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with Greeting
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: user.photo != null
                                ? NetworkImage(user.photo!)
                                : null,
                            child: user.photo == null
                                ? Text(
                                    user.firstName.isNotEmpty
                                        ? user.firstName[0].toUpperCase()
                                        : 'M',
                                    style: GoogleFonts.oswald(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: isDark
                                          ? AppColors.darkBackground
                                          : Colors.white,
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${l10n.dashboardHello}, ${user.firstName} 👋',
                                style: GoogleFonts.oswald(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                              Text(
                                l10n.dashboardSubtitle,
                                style: GoogleFonts.inter(
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // Member Card
                      MemberCardWidget(
                        user: user,
                        subscriptionEnd: subscriptionEnd,
                        isExpired: isExpired,
                      ),
                      const SizedBox(height: 30),

                      // Subscription Status & Quick Pay
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isExpired
                                    ? Colors.red.withValues(alpha: 0.1)
                                    : Colors.green.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isExpired
                                      ? Colors.red.withValues(alpha: 0.3)
                                      : Colors.green.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isExpired
                                        ? l10n.dashboardExpired
                                        : l10n.dashboardActive,
                                    style: GoogleFonts.oswald(
                                      color: isExpired
                                          ? Colors.red
                                          : Colors.green,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    isExpired
                                        ? l10n.dashboardRenew
                                        : l10n.dashboardDaysLeft(
                                            subscription['daysLeft'] ?? 0,
                                          ),
                                    style: GoogleFonts.inter(
                                      color: isDark
                                          ? Colors.white70
                                          : Colors.black54,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Payment Button (if due)
                          if (amountDue > 0)
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PaymentMethodsScreen(
                                            amount: amountDue
                                                .toDouble(), // From API
                                          ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    gradient: AppColors.fieryGradient,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.brandOrange.withValues(
                                          alpha: 0.3,
                                        ),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            l10n.dashboardPayNow,
                                            style: GoogleFonts.oswald(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.black,
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        // TODO: Format currency properly later
                                        '${amountDue.toStringAsFixed(0)} DZD',
                                        style: GoogleFonts.inter(
                                          color: Colors.black.withValues(
                                            alpha: 0.9,
                                          ),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),

                      // Progress Photos Section
                      const SizedBox(height: 32),
                      _PhotoGallerySection(photos: photos, ref: ref),

                      const SizedBox(height: 30),
                      Text(
                        l10n.dashboardThisWeek,
                        style: GoogleFonts.oswald(
                          fontSize: 20,
                          color: isDark ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Calendar Widget (Mock data inside widget but that's ok for now)
                      const MemberCalendarWidget(),

                      const SizedBox(height: 30),

                      // Quick Actions Grid (Keep existing)
                      Text(
                        l10n.dashboardQuickActions,
                        style: GoogleFonts.oswald(
                          fontSize: 20,
                          color: isDark ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          // Responsive grid: 1 column on very small screens, 2 on larger
                          final crossAxisCount = constraints.maxWidth < 350
                              ? 1
                              : 2;
                          return GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: crossAxisCount,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 1.5,
                            children: [
                              _buildQuickActionCard(
                                context,
                                icon: Icons.qr_code,
                                label: l10n.dashboardQRCode,
                                color: Colors.blue,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => QRCodeScreen(
                                        qrCode:
                                            user.qrCode ?? 'MEMBER:${user.id}',
                                      ),
                                    ),
                                  );
                                },
                              ),
                              _buildQuickActionCard(
                                context,
                                icon: FontAwesomeIcons.dumbbell,
                                label: l10n.dashboardBookClass,
                                color: Colors.orange,
                                onTap: () => context.go(AppRoutes.booking),
                              ),
                              _buildQuickActionCard(
                                context,
                                icon: FontAwesomeIcons.chartLine,
                                label: l10n.dashboardMyStats,
                                color: Colors.purple,
                                onTap: () => context.push(AppRoutes.stats),
                              ),
                              _buildQuickActionCard(
                                context,
                                icon: FontAwesomeIcons.users,
                                label: l10n.dashboardCommunity,
                                color: Colors.teal,
                                onTap: () => context.push(AppRoutes.feed),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 100), // Bottom spacing
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.grey.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: GoogleFonts.inter(
                color: isDark ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoGallerySection extends StatelessWidget {
  final List<String> photos;
  final WidgetRef ref;

  const _PhotoGallerySection({required this.photos, required this.ref});

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      ref.read(userPhotosProvider.notifier).addPhoto(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Reusing the same localization for section title (borrowing from dashboard for now)
    // Actually we don't have a key for "Progress Photos", let's use a hardcoded one or add it later.
    // Ideally should be localized.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'PROGRESS PHOTOS', // TODO: Localize
              style: GoogleFonts.oswald(
                fontSize: 20,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_a_photo, color: AppColors.brandOrange),
              onPressed: () => _showImageSourceActionSheet(context),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: photos.isEmpty
              ? Center(
                  child: Text(
                    'No photos yet', // TODO: Localize
                    style: GoogleFonts.inter(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: photos.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 100,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: FileImage(File(photos[index])),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: AppColors.brandOrange,
              ),
              title: Text(
                'Gallery',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_camera,
                color: AppColors.brandOrange,
              ),
              title: Text(
                'Camera',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }
}
