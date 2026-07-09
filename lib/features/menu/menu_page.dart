import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../core/localization/language_switcher.dart';
import '../../core/theme/app_colors.dart';
import '../login/login_page.dart';

/// Account menu screen pushed from the Home AppBar.
///
/// All labels are localized; the AppBar carries the language switcher so the
/// user can change language here too (content re-translates in place).
class MenuPage extends StatelessWidget {
  const MenuPage({super.key, required this.username});

  final String username;

  @override
  Widget build(BuildContext context) {
    // Build fresh (non-const) so labels re-translate on locale change.
    final items = <({IconData icon, String labelKey})>[
      (icon: Icons.payments_outlined, labelKey: 'menu.cashTransaction'),
      (icon: Icons.candlestick_chart, labelKey: 'menu.securitiesTransaction'),
      (
        icon: Icons.manage_accounts_outlined,
        labelKey: 'menu.accountManagement'
      ),
      (icon: Icons.widgets_outlined, labelKey: 'menu.utilities'),
      (icon: Icons.settings_outlined, labelKey: 'menu.settings'),
      (icon: Icons.verified_user_outlined, labelKey: 'menu.security'),
      (icon: Icons.support_agent, labelKey: 'menu.support'),
    ];

    return Scaffold(
        appBar: AppBar(
          title: Text('menu.title'.tr()),
          actions: const [LanguageSwitcher(), SizedBox(width: 4)],
          elevation: 8,
          shadowColor: Colors.black.withOpacity(0.15),
          surfaceTintColor: Colors.transparent,
        ),
        body: ListView(
          
          children: [
            _AccountHeader(
              username: username,
              onLogout: () => _confirmLogout(context),
            ),
            const SizedBox(height: 8),
            for (final it in items) ...[
              Container(
                color: Colors.white,
                child: _MenuExpansionTile(
                  icon: it.icon,
                  label: it.labelKey.tr(),
                  children: _buildMenuChildren(it.labelKey),
                ),
              ),
              _buildDivider(72),
            ],
          ],
        ));
  }

  Widget _buildDivider(double left) {
    return Padding(
        padding: EdgeInsets.only(left: left),
        child: Divider(
          height: 1,
        ));
  }

  List<Widget> _buildMenuChildren(String parentLabelKey) {
    final Map<String, List<String>> menus = {
      'menu.cashTransaction': [
        'menu.internalTransfer',
        'menu.externalTransfer',
        'menu.advanceOnSaleProceeds',
      ],
      'menu.securitiesTransaction': [
        'menu.securitiesTransfer',
        'menu.rightsSubscription',
        'menu.corporateActionInquiry',
      ],
      'menu.accountManagement': [
        'menu.marginDebt',
        'menu.cashStatement',
        'menu.securitiesStatement',
        'menu.orderHistory',
        'menu.matchedOrdersSummary',
        'menu.realizedProfitLoss',
      ],
      'menu.utilities': [
        'menu.digitalIdentityCertificate',
        'menu.updateInformationServices',
        'menu.marginEligibleList',
        'menu.alertSettings',
      ],
      'menu.settings': [
        'menu.personalInformation',
        'menu.fontSize',
        'menu.theme',
      ],
      'menu.security': [
        'menu.changePassword',
        'menu.biometricSettings',
      ],
      'menu.support': [
        'menu.contact',
        'menu.tradingHandbook',
        'menu.address',
      ],
    };

    final children = menus[parentLabelKey] ?? [];

    return [
      for (int i = 0; i < children.length; i++) ...[
        _buildDivider(18),
        ListTile(
          title: Text(children[i].tr()),
          onTap: () {},
        ),
      ],
    ];
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text('menu.logout'.tr()),
        content: Text('menu.logoutConfirmMessage'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: Text('menu.cancel'.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, true),
            child: Text('menu.logout'.tr(),
                style: const TextStyle(color: AppColors.down)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }
}

/// Top card: avatar + name + customer code, with a logout button on the right.
class _AccountHeader extends StatelessWidget {
  const _AccountHeader({required this.username, required this.onLogout});

  final String username;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final initial = username.isNotEmpty ? username[0].toUpperCase() : '?';
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.primaryLight,
            child: Text(initial,
                style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 22)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(username,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 17)),
                const SizedBox(height: 4),
                Text('${'menu.userCode'.tr()}: $username',
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 13)),
              ],
            ),
          ),
          IconButton(
            tooltip: 'menu.logout'.tr(),
            icon: const Icon(Icons.logout, color: AppColors.down),
            onPressed: onLogout,
          ),
        ],
      ),
    );
  }
}

/// A single menu row: icon chip + label + chevron.
class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          tileColor: AppColors.surface,
          leading: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              // color: AppColors.primaryLight,
              color: Colors.white,

              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          title: Text(label,
              style:
                  const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
          trailing:
              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        ),
        const Divider(height: 1, indent: 72, color: AppColors.divider),
      ],
    );
  }
}

class _MenuExpansionTile extends StatefulWidget {
  const _MenuExpansionTile({
    required this.icon,
    required this.label,
    required this.children,
  });

  final IconData icon;
  final String label;
  final List<Widget> children;

  @override
  State<_MenuExpansionTile> createState() => _MenuExpansionTileState();
}

class _MenuExpansionTileState extends State<_MenuExpansionTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      shape: const Border(),
      collapsedShape: const Border(),
      tilePadding: const EdgeInsets.symmetric(horizontal: 16),
      childrenPadding: const EdgeInsets.only(left: 54),
      onExpansionChanged: (expanded) {
        setState(() {
          _isExpanded = expanded;
        });
      },
      leading: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          widget.icon,
          color: AppColors.primary,
        ),
      ),
      title: Text(
        widget.label,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
      ),
      trailing: AnimatedRotation(
        turns: _isExpanded ? 0.25 : 0.0, // 90°
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: const Icon(
          Icons.chevron_right,
          color: AppColors.textSecondary,
        ),
      ),
      children: widget.children,
    );
  }
}
