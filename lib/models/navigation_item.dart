import 'package:flutter/material.dart';

class NavigationItem {
  final String label;
  final IconData iconData;
  final Widget page;

  NavigationItem({
    required this.label,
    required this.iconData,
    required this.page,
  });
}
