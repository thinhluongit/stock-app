import 'package:flutter/material.dart';

class MenuItem {
  final String labelKey;
  final IconData? icon;
  final Widget page;
  final bool requiresLogin;

  const MenuItem({
    required this.labelKey,
    required this.page,
    this.icon,
    this.requiresLogin = true,
  });
}