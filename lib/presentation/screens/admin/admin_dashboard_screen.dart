import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gyelyseedz/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/admin_provider.dart';
import '../../widgets/admin/add_member_dialog.dart';
import '../../widgets/admin/pending_payments_dialog.dart';
import '../../widgets/admin/create_post_dialog.dart';
import 'admin_members_screen.dart';
import 'admin_coaches_screen.dart';
import 'admin_programs_screen.dart';
import 'admin_branches_screen.dart';
import 'admin_payments_screen.dart';
import 'admin_settings_screen.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getMenuItems(AppLocalizations l10n) => [
    {'icon': FontAwesomeIcons.chartLine, 'label': l10n.adminNavDashboard},
    {'icon': FontAwesomeIcons.users, 'label': l10n.adminNavMembers},
    {'icon': FontAwesomeIcons.userTie, 'label': l10n.adminNavCoaches},
    {'icon': FontAwesomeIcons.dumbbell, 'label': l10n.adminNavPrograms},
    {'icon': FontAwesomeIcons.shop, 'label': l10n.adminNavBranches},
    {'icon': FontAwesomeIcons.moneyBill, 'label': l10n.adminNavPayments},
    {'icon': FontAwesomeIcons.gear, 'label': l10n.adminNavSettings},
  ];

  String _getMenuTitle(int index) {
    // Helper to get title based on index, defaulting to Dashboard
    // In a real app, this could match the _getMenuItems list
    switch (index) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Members';
      case 2:
        return 'Coaches';
      case 3:
        return 'Programs';
      case 4:
        return 'Branches';
      case 5:
        return 'Payments';
      case 6:
        return 'Settings';
      default:
        return 'Admin';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Desktop breakpoint: 900px
        final isDesktop = constraints.maxWidth >= 900;

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: isDark
              ? const Color(0xFF0A0A0A)
              : const Color(0xFFF5F5F7),
          // Drawer for Mobile/Tablet
          drawer: !isDesktop
              ? Drawer(
                  backgroundColor: isDark
                      ? const Color(0xFF111111)
                      : Colors.white,
                  child: _buildSidebarContent(isDark, l10n),
                )
              : null,
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Persistent Sidebar for Desktop
              if (isDesktop)
                Container(
                  width: 260,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF111111) : Colors.white,
                    border: Border(
                      right: BorderSide(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.1)
                            : Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                  ),
                  child: _buildSidebarContent(isDark, l10n),
                ),

              // Main Content Area
              Expanded(
                child: Column(
                  children: [
                    // Adaptive Header
                    _buildHeader(isDark, !isDesktop),

                    // Content Body
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(isDesktop ? 24 : 16),
                        child: _buildContent(
                          l10n,
                          isDark,
                          constraints.maxWidth,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSidebarContent(bool isDark, AppLocalizations l10n) {
    final menuItems = _getMenuItems(l10n);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo Area
        Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: AppColors.fieryGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: FaIcon(
                    FontAwesomeIcons.dumbbell,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'GYM ÉLYSÉE',
                style: GoogleFonts.oswald(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.grey.shade200,
          height: 1,
        ),

        // Menu Items
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              final item = menuItems[index];
              final isSelected = _selectedIndex == index;
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 2,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() => _selectedIndex = index);
                      // Close drawer on mobile selection
                      if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
                        Navigator.pop(context);
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark
                                  ? AppColors.brandOrange.withValues(
                                      alpha: 0.15,
                                    )
                                  : AppColors.brandOrange.withValues(
                                      alpha: 0.1,
                                    ))
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected
                            ? Border.all(
                                color: AppColors.brandOrange.withValues(
                                  alpha: 0.3,
                                ),
                                width: 1,
                              )
                            : null,
                      ),
                      child: Row(
                        children: [
                          FaIcon(
                            item['icon'],
                            size: 18,
                            color: isSelected
                                ? AppColors.brandOrange
                                : (isDark
                                      ? Colors.grey.shade400
                                      : Colors.grey.shade600),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              item['label'],
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isSelected
                                    ? (isDark ? Colors.white : Colors.black87)
                                    : (isDark
                                          ? Colors.grey.shade400
                                          : Colors.grey.shade600),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Logout
        Padding(
          padding: const EdgeInsets.all(12),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                ref.read(authNotifierProvider.notifier).logout();
                context.go('/');
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.red.withValues(alpha: 0.1)
                      : Colors.red.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.red.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.rightFromBracket,
                      size: 18,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 14),
                    Text(
                      'Logout',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(bool isDark, bool showHamburger) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111111) : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          if (showHamburger) ...[
            IconButton(
              icon: Icon(
                Icons.menu,
                color: isDark ? Colors.white : Colors.black87,
              ),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            const SizedBox(width: 8),
          ],

          // Title
          Expanded(
            child: Text(
              _getMenuTitle(_selectedIndex),
              style: GoogleFonts.oswald(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Search (Hidden on small mobile if needed, or collapsed)
          if (!showHamburger) // Hide search bar directly on mobile to save space
            Container(
              width: 300,
              height: 44,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.grey.shade300,
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 14),
                  Icon(Icons.search, size: 20, color: Colors.grey.shade500),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                ],
              ),
            ),
          const SizedBox(width: 16),

          // Notifications
          Stack(
            children: [
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.bell, size: 20),
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 8,
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
        ],
      ),
    );
  }

  Widget _buildContent(AppLocalizations l10n, bool isDark, double maxWidth) {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardOverview(l10n, isDark, maxWidth);
      case 1:
        return const AdminMembersScreen();
      case 2:
        return const AdminCoachesScreen();
      case 3:
        return const AdminProgramsScreen();
      case 4:
        return const AdminBranchesScreen();
      case 5:
        return const AdminPaymentsScreen();
      case 6:
        return const AdminSettingsScreen();
      default:
        return const SizedBox();
    }
  }

  Widget _buildDashboardOverview(
    AppLocalizations l10n,
    bool isDark,
    double maxWidth,
  ) {
    // Responsive Grid logic
    int crossAxisCount = 4;
    double childAspectRatio = 1.8;

    if (maxWidth < 600) {
      crossAxisCount = 1;
      childAspectRatio = 2.5; // Wider cards for mobile
    } else if (maxWidth < 1100) {
      crossAxisCount = 2;
      childAspectRatio = 2.0;
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Stats Cards
          Consumer(
            builder: (context, ref, child) {
              final statsAsync = ref.watch(adminStatsProvider);
              return statsAsync.when(
                data: (stats) => GridView.count(
                  crossAxisCount: crossAxisCount,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: childAspectRatio,
                  children: [
                    _buildStatCard(
                      'Total Members',
                      '${stats['total_members']}',
                      FontAwesomeIcons.users,
                      Colors.blue,
                      isDark,
                    ),
                    _buildStatCard(
                      'Active Today',
                      '${stats['today_bookings']}',
                      FontAwesomeIcons.calendarCheck,
                      Colors.green,
                      isDark,
                    ),
                    _buildStatCard(
                      'Pending Payments',
                      '${stats['pending_payments']}',
                      FontAwesomeIcons.moneyBill,
                      Colors.orange,
                      isDark,
                    ),
                    _buildStatCard(
                      'Active Subscriptions',
                      '${stats['active_subscriptions']}',
                      FontAwesomeIcons.trophy,
                      Colors.purple,
                      isDark,
                    ),
                  ],
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) =>
                    const Center(child: Text('Error loading stats')),
              );
            },
          ),
          const SizedBox(height: 32),

          // Quick Actions
          Text(
            'Quick Actions',
            style: GoogleFonts.oswald(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildQuickActionButton(
                'Add Member',
                FontAwesomeIcons.userPlus,
                Colors.blue,
                isDark,
                () => showDialog(
                  context: context,
                  builder: (_) => const AddMemberDialog(),
                ),
              ),
              _buildQuickActionButton(
                'Record Payment',
                FontAwesomeIcons.moneyBillWave,
                Colors.green,
                isDark,
                () => showDialog(
                  context: context,
                  builder: (_) => const PendingPaymentsDialog(),
                ),
              ),
              _buildQuickActionButton(
                'Create Post',
                FontAwesomeIcons.penToSquare,
                Colors.orange,
                isDark,
                () => showDialog(
                  context: context,
                  builder: (_) => const CreatePostDialog(),
                ),
              ),
              _buildQuickActionButton(
                'View Reports',
                FontAwesomeIcons.chartLine,
                Colors.purple,
                isDark,
                () {},
              ),
            ],
          ),
          const SizedBox(height: 32),

          //Recent Activity
          Text(
            'Recent Activity',
            style: GoogleFonts.oswald(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Consumer(
            builder: (context, ref, child) {
              final membersAsync = ref.watch(adminMembersProvider);
              return membersAsync.when(
                data: (members) {
                  final recentMembers = members.take(5).toList();
                  return Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF111111) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.1)
                            : Colors.grey.shade200,
                      ),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: recentMembers.length,
                      separatorBuilder: (context, index) => Divider(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : Colors.grey.shade200,
                        height: 1,
                      ),
                      itemBuilder: (context, index) {
                        final member = recentMembers[index];
                        final user = member['user'];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.brandOrange.withValues(
                              alpha: 0.2,
                            ),
                            child: Text(
                              '${user['first_name'][0]}${user['last_name'][0]}',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                color: AppColors.brandOrange,
                              ),
                            ),
                          ),
                          title: Text(
                            '${user['first_name']} ${user['last_name']}',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          subtitle: Text(
                            'New registration',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          trailing: Text(
                            'Recently',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => const SizedBox(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111111) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FaIcon(icon, size: 20, color: color),
              ),
            ],
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    value,
                    style: GoogleFonts.oswald(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.grey.shade500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    String label,
    IconData icon,
    Color color,
    bool isDark,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(icon, size: 16, color: color),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
