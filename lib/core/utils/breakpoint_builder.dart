import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// A widget that builds different layouts based on screen breakpoints
/// Supports mobile (< 600px), tablet (600-900px), and desktop (> 900px)
class BreakpointBuilder extends StatelessWidget {
  final Widget Function(BuildContext context)? mobile;
  final Widget Function(BuildContext context)? tablet;
  final Widget Function(BuildContext context)? desktop;
  final Widget Function(BuildContext context)? fallback;

  const BreakpointBuilder({
    this.mobile,
    this.tablet,
    this.desktop,
    this.fallback,
    super.key,
  }) : assert(
          mobile != null || tablet != null || desktop != null || fallback != null,
          'At least one builder must be provided',
        );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // Desktop layout (> 900px)
        if (width >= AppConstants.tabletBreakpoint) {
          return (desktop ?? tablet ?? mobile ?? fallback)!(context);
        }

        // Tablet layout (600-900px)
        if (width >= AppConstants.mobileBreakpoint) {
          return (tablet ?? mobile ?? desktop ?? fallback)!(context);
        }

        // Mobile layout (< 600px)
        return (mobile ?? tablet ?? desktop ?? fallback)!(context);
      },
    );
  }

  /// Get the current breakpoint type
  static BreakpointType getBreakpoint(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= AppConstants.tabletBreakpoint) {
      return BreakpointType.desktop;
    } else if (width >= AppConstants.mobileBreakpoint) {
      return BreakpointType.tablet;
    } else {
      return BreakpointType.mobile;
    }
  }

  /// Check if current screen is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < AppConstants.mobileBreakpoint;
  }

  /// Check if current screen is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= AppConstants.mobileBreakpoint &&
        width < AppConstants.tabletBreakpoint;
  }

  /// Check if current screen is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= AppConstants.tabletBreakpoint;
  }

  /// Get responsive padding based on screen size
  static EdgeInsets getResponsivePadding(BuildContext context) {
    if (isDesktop(context)) {
      return const EdgeInsets.all(32);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(24);
    } else {
      return const EdgeInsets.all(16);
    }
  }

  /// Get responsive horizontal padding
  static EdgeInsets getResponsiveHorizontalPadding(BuildContext context) {
    if (isDesktop(context)) {
      return const EdgeInsets.symmetric(horizontal: 48);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 32);
    } else {
      return const EdgeInsets.symmetric(horizontal: 16);
    }
  }

  /// Get responsive content max width
  static double getContentMaxWidth(BuildContext context) {
    if (isDesktop(context)) {
      return 1200;
    } else if (isTablet(context)) {
      return 800;
    } else {
      return double.infinity;
    }
  }

  /// Get responsive font size multiplier
  static double getFontSizeMultiplier(BuildContext context) {
    if (isDesktop(context)) {
      return 1.2;
    } else if (isTablet(context)) {
      return 1.1;
    } else {
      return 1.0;
    }
  }

  /// Get responsive icon size
  static double getIconSize(BuildContext context, {double baseSize = 24}) {
    if (isDesktop(context)) {
      return baseSize * 1.5;
    } else if (isTablet(context)) {
      return baseSize * 1.25;
    } else {
      return baseSize;
    }
  }

  /// Get number of columns for grid layouts
  static int getGridColumns(BuildContext context) {
    if (isDesktop(context)) {
      return 4;
    } else if (isTablet(context)) {
      return 2;
    } else {
      return 1;
    }
  }
}

enum BreakpointType {
  mobile,
  tablet,
  desktop,
}
