import 'package:flutter/widgets.dart';

/// A single item shown inside [CustomBottomNavBar].
///
/// Kept as a plain data class so it is trivial to extend later (e.g. add a
/// custom widget builder, tooltip, route name, etc.).
class CustomBottomNavItem {
  const CustomBottomNavItem({
    required this.icon,
    required this.label,
    this.activeIcon,
    this.badgeCount = 0,
  });

  /// Icon shown when the item is NOT selected.
  final IconData icon;

  /// Icon shown when the item IS selected. Falls back to [icon] when null.
  final IconData? activeIcon;

  /// Text label under the icon.
  final String label;

  /// Optional badge number (e.g. unread notifications). 0 hides the badge.
  final int badgeCount;
}
