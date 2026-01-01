import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/analytics_provider.dart';
import '../../widgets/admin/analytics/revenue_chart_card.dart';
import '../../widgets/admin/analytics/membership_growth_card.dart';
import '../../widgets/admin/analytics/attendance_chart_card.dart';

class AdminAnalyticsScreen extends ConsumerStatefulWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  ConsumerState<AdminAnalyticsScreen> createState() =>
      _AdminAnalyticsScreenState();
}

class _AdminAnalyticsScreenState extends ConsumerState<AdminAnalyticsScreen> {
  @override
  Widget build(BuildContext context) {
    // final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Watch providers
    final revenueAsync = ref.watch(revenueDataProvider);
    final membershipAsync = ref.watch(membershipGrowthProvider);
    final attendanceAsync = ref.watch(attendancePatternsProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Analytics Dashboard',
                style: GoogleFonts.oswald(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white10 : Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: isDark ? Colors.grey : Colors.grey[800],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Last 6 Months',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Revenue Chart (Full Width)
          revenueAsync.when(
            data: (data) => RevenueChartCard(data: data, isDark: isDark),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Text('Error: $e'),
          ),
          const SizedBox(height: 24),

          // Two Column Layout for split charts
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 900) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: membershipAsync.when(
                        data: (data) =>
                            MembershipGrowthCard(data: data, isDark: isDark),
                        loading: () => const CircularProgressIndicator(),
                        error: (e, s) => Text('Error: $e'),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: attendanceAsync.when(
                        data: (data) =>
                            AttendanceChartCard(data: data, isDark: isDark),
                        loading: () => const CircularProgressIndicator(),
                        error: (e, s) => Text('Error: $e'),
                      ),
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    membershipAsync.when(
                      data: (data) =>
                          MembershipGrowthCard(data: data, isDark: isDark),
                      loading: () => const CircularProgressIndicator(),
                      error: (e, s) => Text('Error: $e'),
                    ),
                    const SizedBox(height: 24),
                    attendanceAsync.when(
                      data: (data) =>
                          AttendanceChartCard(data: data, isDark: isDark),
                      loading: () => const CircularProgressIndicator(),
                      error: (e, s) => Text('Error: $e'),
                    ),
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
