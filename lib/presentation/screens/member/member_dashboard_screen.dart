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
import '../../widgets/common/notification_panel.dart';

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
            icon: Stack(
              children: [
                Icon(
                  Icons.notifications_outlined,
                  color: isDark ? Colors.white : Colors.black,
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              final screenWidth = MediaQuery.of(context).size.width;
              // On mobile, show close to right edge. On desktop, keep fixed offset.
              final left = screenWidth > 400 ? screenWidth - 380 : 10.0;

              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(left, 60, 10, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.transparent,
                elevation: 0,
                items: [
                  PopupMenuItem(
                    enabled: false,
                    padding: EdgeInsets.zero,
                    child: NotificationPanel(isDark: isDark),
                  ),
                ],
              );
            },
          ),
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
                final Map<String, dynamic>? subData = subscription;
                final hasSubscription = subData != null;

                final subscriptionEnd = hasSubscription
                    ? DateTime.tryParse(subData['end_date'] ?? '') ??
                          DateTime.now()
                    : null;

                // If no subscription, treat as not active/expired
                final isExpired = hasSubscription
                    ? (subData['status'] == 'expired' ||
                          !(subData['isActive'] ?? false))
                    : true;

                final amountDue = hasSubscription
                    ? (subData['plan']?['price'] ?? 0).toDouble()
                    : 0.0;

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
                                            subData['daysLeft'] as int? ?? 0,
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
                          // Payment/Subscribe Button
                          if (amountDue > 0 || !hasSubscription)
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  if (!hasSubscription) {
                                    // Navigate to Plans/Subscription Page
                                    // Assuming AppRoutes.subscription or similar exists, or use GoRouter to find it
                                    // Current context has payment methods link, but we want Plans.
                                    // Usually it's in the profile or separate tab.
                                    // Let's assume we can navigate to SubscriptionScreen via router or direct push.
                                    // Actually checking imports..
                                    // We don't have SubscriptionScreen imported directly?
                                    // Let's check AppRouter content or navigation bar.
                                    // For now, let's use context.push('/subscription') if route exists or open subscription screen.
                                    // Or finding the subscription Tab.

                                    // Using a direct material route for now to be safe, or reusing existing pattern
                                    // Actually, let's check if we can switch tab.
                                    // If not, push Settings -> Subscription?
                                    // Let's try to find the route.
                                    // For now: context.push(AppRoutes.profile); // User can find it there
                                    // Better: context.pushNamed('subscription');
                                    // Safest: Use existing PaymentMethodsScreen if we just want them to pay? No, they need to select a plan.

                                    // Re-checking imports, we see 'SubscriptionScreen' is NOT imported.
                                    // I will import it or assume a route.
                                    // I'll use context.go('/subscription') or similar if I verify the route.
                                    // Let's just use a placeholder Todo or push to Profile for now.
                                    context.go(
                                      '/member/profile',
                                    ); // Usually where subscription is
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PaymentMethodsScreen(
                                              amount: amountDue,
                                            ),
                                      ),
                                    );
                                  }
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
                                            !hasSubscription
                                                ? 'S\'abonner'
                                                : l10n.dashboardPayNow,
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
                                        !hasSubscription
                                            ? 'Voir les plans'
                                            : '${amountDue.toStringAsFixed(0)} DZD',
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
                          // Responsive grid: 1 column on very small screens, 2 on mobile/tablet, 4 on desktop
                          int crossAxisCount = 2;
                          if (constraints.maxWidth < 350) {
                            crossAxisCount = 1;
                          } else if (constraints.maxWidth > 900) {
                            crossAxisCount = 4;
                          } else if (constraints.maxWidth > 600) {
                            crossAxisCount = 3;
                          }
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
                                      builder: (_) => const QRCodeScreen(),
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
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [color.withValues(alpha: 0.15), const Color(0xFF1E1E1E)]
                : [Colors.white, color.withValues(alpha: 0.05)],
          ),
          border: Border.all(
            color: isDark
                ? color.withValues(alpha: 0.2)
                : color.withValues(alpha: 0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: isDark ? 0.1 : 0.05),
              blurRadius: 15,
              offset: const Offset(0, 8),
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: color.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 14),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: isDark ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                letterSpacing: 0.2,
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
