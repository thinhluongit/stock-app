import 'package:flutter/material.dart';

import 'custom_bottom_nav_item.dart';

/// A customizable bottom navigation bar.
///
/// Everything visual is exposed as a constructor argument so the host app can
/// re-skin it without forking the widget: colors, sizes, the top indicator,
/// the divider, etc. Selection state is fully controlled by the parent via
/// [currentIndex] + [onTap].
class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.selectedColor = const Color(0xFF00A651),
    this.unselectedColor = const Color(0xFF9AA0A6),
    this.backgroundColor = Colors.white,
    this.badgeColor = const Color(0xFFE53935),
    this.height = 62,
    this.iconSize = 24,
    this.selectedFontSize = 11,
    this.unselectedFontSize = 11,
    this.showTopIndicator = true,
    this.showTopDivider = true,
    this.elevation = 8,
  }) : assert(items.length >= 2, 'Need at least 2 items');

  final List<CustomBottomNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  final Color selectedColor;
  final Color unselectedColor;
  final Color backgroundColor;
  final Color badgeColor;

  final double height;
  final double iconSize;
  final double selectedFontSize;
  final double unselectedFontSize;

  /// Small colored bar drawn above the selected item.
  final bool showTopIndicator;

  /// Hairline divider at the top edge of the bar.
  final bool showTopDivider;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Material(
      color: backgroundColor,
      elevation: elevation,
      child: SafeArea(
        top: false,
        child: Container(
          height: height + bottomInset * 0,
          decoration: BoxDecoration(
            border: showTopDivider
                ? const Border(
                    top: BorderSide(color: Color(0x11000000), width: 0.5),
                  )
                : null,
          ),
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: _NavCell(
                    item: items[i],
                    selected: i == currentIndex,
                    onTap: () => onTap(i),
                    selectedColor: selectedColor,
                    unselectedColor: unselectedColor,
                    badgeColor: badgeColor,
                    iconSize: iconSize,
                    selectedFontSize: selectedFontSize,
                    unselectedFontSize: unselectedFontSize,
                    showTopIndicator: showTopIndicator,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavCell extends StatelessWidget {
  const _NavCell({
    required this.item,
    required this.selected,
    required this.onTap,
    required this.selectedColor,
    required this.unselectedColor,
    required this.badgeColor,
    required this.iconSize,
    required this.selectedFontSize,
    required this.unselectedFontSize,
    required this.showTopIndicator,
  });

  final CustomBottomNavItem item;
  final bool selected;
  final VoidCallback onTap;
  final Color selectedColor;
  final Color unselectedColor;
  final Color badgeColor;
  final double iconSize;
  final double selectedFontSize;
  final double unselectedFontSize;
  final bool showTopIndicator;

  @override
  Widget build(BuildContext context) {
    final color = selected ? selectedColor : unselectedColor;
    final icon = selected ? (item.activeIcon ?? item.icon) : item.icon;

    return InkResponse(
      onTap: onTap,
      highlightShape: BoxShape.rectangle,
      radius: 56,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 3,
            width: selected && showTopIndicator ? 24 : 0,
            decoration: BoxDecoration(
              color: selectedColor,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(3),
              ),
            ),
          ),
          const SizedBox(height: 6),
          _IconWithBadge(
            icon: icon,
            color: color,
            iconSize: iconSize,
            badgeCount: item.badgeCount,
            badgeColor: badgeColor,
          ),
          const SizedBox(height: 3),
          Text(
            item.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: selected ? selectedFontSize : unselectedFontSize,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _IconWithBadge extends StatelessWidget {
  const _IconWithBadge({
    required this.icon,
    required this.color,
    required this.iconSize,
    required this.badgeCount,
    required this.badgeColor,
  });

  final IconData icon;
  final Color color;
  final double iconSize;
  final int badgeCount;
  final Color badgeColor;

  @override
  Widget build(BuildContext context) {
    if (badgeCount <= 0) {
      return Icon(icon, size: iconSize, color: color);
    }
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon, size: iconSize, color: color),
        Positioned(
          right: -8,
          top: -6,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            constraints: const BoxConstraints(minWidth: 16),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white, width: 1.2),
            ),
            child: Text(
              badgeCount > 99 ? '99+' : '$badgeCount',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
