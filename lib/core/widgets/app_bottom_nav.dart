import 'package:flutter/material.dart';

class AppBottomNavItem {
  const AppBottomNavItem({required this.label, required this.icon});
  final String label;
  final IconData icon;
}

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onSelected,
  });

  final List<AppBottomNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onSelected,
      destinations: [
        for (final item in items)
          NavigationDestination(icon: Icon(item.icon), label: item.label),
      ],
    );
  }
}
