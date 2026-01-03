import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../core/theme/app_colors.dart';

class NotificationPanel extends ConsumerWidget {
  final bool isDark;

  const NotificationPanel({super.key, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mock notifications (TODO: Replace with real provider)
    final notifications = _getMockNotifications();

    return Container(
      width: MediaQuery.of(context).size.width > 380
          ? 360
          : MediaQuery.of(context).size.width - 32,
      constraints: const BoxConstraints(maxHeight: 500),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notifications',
                  style: GoogleFonts.oswald(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                if (notifications.isNotEmpty)
                  Flexible(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        // TODO: Mark all as read
                      },
                      child: Text(
                        'Tout marquer comme lu',
                        style: TextStyle(
                          color: AppColors.brandOrange,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Notifications List
          Flexible(
            child: notifications.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: notifications.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final notif = notifications[index];
                      return _buildNotificationTile(notif, isDark);
                    },
                  ),
          ),

          // Footer
          const Divider(height: 1),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to notifications page
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'Voir toutes les notifications',
                style: TextStyle(
                  color: AppColors.brandOrange,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.notifications_none,
              size: 64,
              color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'Aucune notification',
              style: TextStyle(
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationTile(Map<String, dynamic> notif, bool isDark) {
    final isUnread = notif['unread'] as bool;

    return Container(
      color: isUnread
          ? (isDark
                ? AppColors.brandOrange.withValues(alpha: 0.1)
                : AppColors.brandOrange.withValues(alpha: 0.05))
          : null,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: _getIconColor(notif['type'] as String),
          child: Icon(
            _getIconData(notif['type'] as String),
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          notif['title'] as String,
          style: TextStyle(
            fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
            color: isDark ? Colors.white : Colors.black,
            fontSize: 14,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notif['body'] as String,
              style: TextStyle(
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                fontSize: 13,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              timeago.format(notif['time'] as DateTime, locale: 'fr'),
              style: TextStyle(
                color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                fontSize: 11,
              ),
            ),
          ],
        ),
        trailing: isUnread
            ? Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.brandOrange,
                  shape: BoxShape.circle,
                ),
              )
            : null,
        onTap: () {
          // TODO: Navigate to notification detail or mark as read
        },
      ),
    );
  }

  IconData _getIconData(String type) {
    switch (type) {
      case 'payment':
        return Icons.payment;
      case 'checkin':
        return Icons.check_circle;
      case 'booking':
        return Icons.calendar_today;
      case 'system':
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'payment':
        return Colors.green;
      case 'checkin':
        return Colors.blue;
      case 'booking':
        return AppColors.brandOrange;
      case 'system':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  List<Map<String, dynamic>> _getMockNotifications() {
    return [
      {
        'type': 'payment',
        'title': 'Paiement validé',
        'body': 'Votre paiement de 5000 DZD a été validé avec succès.',
        'time': DateTime.now().subtract(const Duration(minutes: 15)),
        'unread': true,
      },
      {
        'type': 'checkin',
        'title': 'Check-in réussi',
        'body': 'Bienvenue au Gym Elysée! Bon entraînement.',
        'time': DateTime.now().subtract(const Duration(hours: 2)),
        'unread': true,
      },
      {
        'type': 'booking',
        'title': 'Réservation confirmée',
        'body':
            'Votre cours de Boxe avec Coach Ahmed est confirmé pour demain.',
        'time': DateTime.now().subtract(const Duration(days: 1)),
        'unread': false,
      },
    ];
  }
}
