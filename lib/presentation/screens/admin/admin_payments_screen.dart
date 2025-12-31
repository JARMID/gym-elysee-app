import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gyelyseedz/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../providers/admin_provider.dart';

class AdminPaymentsScreen extends ConsumerStatefulWidget {
  const AdminPaymentsScreen({super.key});

  @override
  ConsumerState<AdminPaymentsScreen> createState() =>
      _AdminPaymentsScreenState();
}

class _AdminPaymentsScreenState extends ConsumerState<AdminPaymentsScreen> {
  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(adminPaymentHistoryProvider);
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.adminPaymentsTitle,
                style: GoogleFonts.oswald(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              IconButton(
                onPressed: () {
                  // Refresh logic
                  ref.invalidate(adminPaymentHistoryProvider);
                },
                icon: Icon(
                  Icons.refresh,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Payments Table
          Container(
            constraints: const BoxConstraints(minHeight: 400),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.grey[200]!,
              ),
            ),
            child: historyAsync.when(
              data: (payments) {
                if (payments.isEmpty) {
                  return Center(
                    child: Text(
                      l10n.adminPaymentsEmpty,
                      style: GoogleFonts.inter(color: Colors.grey),
                    ),
                  );
                }

                return SingleChildScrollView(
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(
                      isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : Colors.grey[100],
                    ),
                    dataRowColor: WidgetStateProperty.all(Colors.transparent),
                    columns: [
                      DataColumn(
                        label: Text(
                          l10n.adminPaymentsColumnId,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          l10n.adminPaymentsColumnMember,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          l10n.adminPaymentsColumnAmount,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          l10n.adminPaymentsColumnDate,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          l10n.adminPaymentsColumnMethod,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          l10n.adminPaymentsColumnStatus,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                    rows: payments.map((payment) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Text(
                              '#${payment['id']}',
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                          DataCell(
                            Row(
                              children: [
                                const Icon(
                                  Icons.person,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  payment['member_name'] ??
                                      l10n.adminPaymentsUnknown,
                                  style: TextStyle(
                                    color: isDark ? Colors.white : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DataCell(
                            Text(
                              '\$${payment['amount']}',
                              style: const TextStyle(
                                color: AppColors.brandOrange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              payment['date'] ?? '-',
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              payment['method'] ?? '-',
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    (payment['status'] == 'Approved'
                                            ? Colors.green
                                            : AppColors.error)
                                        .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                payment['status'] ?? '-',
                                style: TextStyle(
                                  color: payment['status'] == 'Approved'
                                      ? Colors.green
                                      : AppColors.error,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Text(
                  l10n.adminPaymentsErrorLoading(err.toString()),
                  style: const TextStyle(color: AppColors.error),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
