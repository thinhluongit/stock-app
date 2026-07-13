import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_app/core/utils/formatters.dart';
import 'package:stock_app/providers/noti_provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/models.dart';
import '../widgets/common_widgets.dart';
import '../widgets/sub_tab_view.dart';

/// Tab lớn: Thông báo
class NotificationsTab extends StatelessWidget {
  const NotificationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final notiProvider = context.watch<NotificationProvider>();

    List<NotificationItem> by(NotiType type) =>
        notiProvider.notifications.where((n) => n.type == type).toList();

    return SubTabView(
      tabs: [
        'common.all'.tr(),
        'common.system'.tr(),
        'common.transaction'.tr(),
        'common.priceAlert'.tr(),
        'common.news'.tr(),
      ],
      views: [
        _NotiList(items: notiProvider.notifications),
        _NotiList(items: by(NotiType.system)),
        _NotiList(items: by(NotiType.transaction)),
        _NotiList(items: by(NotiType.priceAlert)),
        _NotiList(items: by(NotiType.news)),
      ],
    );
  }
}

class _NotiList extends StatelessWidget {
  const _NotiList({required this.items});
  final List<NotificationItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return PlaceholderView(
          title: 'notifications.empty'.tr(), icon: Icons.notifications_none);
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: items.length,
      separatorBuilder: (_, i) =>
          const Divider(height: 1, color: AppColors.divider),
      itemBuilder: (_, i) => _NotiTile(item: items[i]),
    );
  }
}

class _NotiTile extends StatelessWidget {
  const _NotiTile({required this.item});
  final NotificationItem item;

  (IconData, Color) get _icon => switch (item.type) {
        NotiType.system => (Icons.settings, AppColors.textSecondary),
        NotiType.transaction => (Icons.swap_horiz, AppColors.primary),
        NotiType.priceAlert => (
            Icons.notifications_active,
            AppColors.reference
          ),
        NotiType.news => (Icons.article_outlined, AppColors.floor),
      };

  @override
  Widget build(BuildContext context) {
    final (icon, color) = _icon;
    return Container(
      color: item.unread ? AppColors.primaryLight.withValues(alpha: 0.4) : null,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(item.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 14)),
                    ),
                    if (item.unread)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.down,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(item.message,
                    style: const TextStyle(
                        color: AppColors.textPrimary, fontSize: 13)),
                const SizedBox(height: 6),
                Text(item.createdAt.toRelativeTime(),
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
