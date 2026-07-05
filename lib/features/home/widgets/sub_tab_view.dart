import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// A reusable scaffold for a large tab that owns a set of horizontally
/// scrollable sub-tabs. The sub-tab bar sits directly under the shared AppBar.
class SubTabView extends StatelessWidget {
  const SubTabView({
    super.key,
    required this.tabs,
    required this.views,
  }) : assert(tabs.length == views.length);

  final List<String> tabs;
  final List<Widget> views;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Column(
        children: [
          Material(
            color: AppColors.surface,
            elevation: 1,
            child: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle:
                  const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              tabs: [for (final t in tabs) Tab(text: t)],
            ),
          ),
          Expanded(child: TabBarView(children: views)),
        ],
      ),
    );
  }
}
