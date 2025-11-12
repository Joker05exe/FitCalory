import 'package:flutter/material.dart';
import '../../core/utils/breakpoint_builder.dart';

/// A responsive scaffold that adapts navigation based on screen size
/// - Mobile: Bottom navigation bar
/// - Tablet/Desktop: Side navigation rail
class ResponsiveScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final int currentIndex;
  final Function(int) onNavigationChanged;
  final List<NavigationItem> navigationItems;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  const ResponsiveScaffold({
    required this.body,
    required this.title,
    required this.currentIndex,
    required this.onNavigationChanged,
    required this.navigationItems,
    this.actions,
    this.floatingActionButton,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BreakpointBuilder(
      mobile: (context) => _buildMobileLayout(context),
      tablet: (context) => _buildTabletDesktopLayout(context, false),
      desktop: (context) => _buildTabletDesktopLayout(context, true),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: actions,
      ),
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onNavigationChanged,
        destinations: navigationItems
            .map((item) => NavigationDestination(
                  icon: Icon(item.icon),
                  selectedIcon: Icon(item.selectedIcon ?? item.icon),
                  label: item.label,
                ))
            .toList(),
      ),
      floatingActionButton: floatingActionButton,
    );
  }

  Widget _buildTabletDesktopLayout(BuildContext context, bool isDesktop) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: isDesktop,
            selectedIndex: currentIndex,
            onDestinationSelected: onNavigationChanged,
            labelType: isDesktop
                ? NavigationRailLabelType.none
                : NavigationRailLabelType.all,
            destinations: navigationItems
                .map((item) => NavigationRailDestination(
                      icon: Icon(item.icon),
                      selectedIcon: Icon(item.selectedIcon ?? item.icon),
                      label: Text(item.label),
                    ))
                .toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Column(
              children: [
                AppBar(
                  title: Text(title),
                  actions: actions,
                ),
                Expanded(child: body),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}

class NavigationItem {
  final String label;
  final IconData icon;
  final IconData? selectedIcon;

  const NavigationItem({
    required this.label,
    required this.icon,
    this.selectedIcon,
  });
}
