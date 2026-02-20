import 'package:check_around_me/core/theme/app_theme.dart';
import 'package:check_around_me/data/model/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/router.dart';
import '../../vm/notification_provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _hasLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, vm, child) {
        if (!_hasLoaded) {
          _hasLoaded = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            vm.getNotifications();
          });
        }
        return Scaffold(
          backgroundColor: AppTheme.surface,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: AppTheme.onSurface),
              onPressed: () => router.pop(),
            ),
            title: const Text(
              'Notifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.onSurface,
              ),
            ),
            centerTitle: true,
            actions: [
              if (vm.unreadCount > 0)
                TextButton(
                  onPressed: vm.isLoading
                      ? null
                      : () async {
                          final success = await vm.markAllAsRead();
                          if (context.mounted && !success && vm.error != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(vm.error!.message)),
                            );
                          }
                        },
                  child: Text(
                    'Mark all read',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
            ],
          ),
          body: vm.isLoading && vm.notifications.isEmpty
              ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
              : vm.error != null && vm.notifications.isEmpty
                  ? _buildError(context, vm)
                  : RefreshIndicator(
                      onRefresh: () => vm.getNotifications(),
                      child: vm.notifications.isEmpty
                          ? _buildEmpty(context)
                          : ListView.separated(
                              padding: const EdgeInsets.all(20),
                              itemCount: vm.notifications.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 12),
                              itemBuilder: (context, i) {
                                return _NotificationTile(notification: vm.notifications[i]);
                              },
                            ),
                    ),
        );
      },
    );
  }

  Widget _buildError(BuildContext context, NotificationProvider vm) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppTheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(
              vm.error?.message ?? 'Something went wrong',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => vm.getNotifications(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 80),
        Icon(
          Icons.notifications_none_rounded,
          size: 64,
          color: AppTheme.onSurfaceVariant.withOpacity(0.6),
        ),
        const SizedBox(height: 16),
        Text(
          'No notifications yet',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationModel notification;

  const _NotificationTile({required this.notification});

  @override
  Widget build(BuildContext context) {
    final isRead = notification.isRead == true;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppTheme.borderRadiusLg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isRead
                  ? AppTheme.surfaceVariant
                  : AppTheme.primaryLight,
              borderRadius: AppTheme.borderRadiusSm,
            ),
            child: Icon(
              _iconForType(notification.type),
              size: 22,
              color: isRead ? AppTheme.onSurfaceVariant : AppTheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title ?? '',
                  style: TextStyle(
                    fontWeight: isRead ? FontWeight.w500 : FontWeight.w600,
                    fontSize: 15,
                    color: AppTheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if ((notification.body ?? '').isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    notification.body!,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.onSurfaceVariant,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (notification.createdAt != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    _formatDate(notification.createdAt!),
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.onSurfaceVariant.withOpacity(0.8),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconForType(String? type) {
    switch (type?.toLowerCase()) {
      case 'message':
        return Icons.message_outlined;
      case 'booking':
        return Icons.calendar_today_outlined;
      case 'review':
        return Icons.star_outline;
      default:
        return Icons.notifications_outlined;
    }
  }

  String _formatDate(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inDays > 0) return '${diff.inDays}d ago';
      if (diff.inHours > 0) return '${diff.inHours}h ago';
      if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
      return 'Just now';
    } catch (_) {
      return dateStr;
    }
  }
}
