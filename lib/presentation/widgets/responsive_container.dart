import 'package:flutter/material.dart';
import '../../core/utils/breakpoint_builder.dart';

/// A container that constrains content width based on screen size
/// and centers content on larger screens
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;
  final bool applyPadding;

  const ResponsiveContainer({
    required this.child,
    this.maxWidth,
    this.padding,
    this.applyPadding = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final effectivePadding = padding ??
        (applyPadding ? BreakpointBuilder.getResponsivePadding(context) : EdgeInsets.zero);

    final effectiveMaxWidth = maxWidth ?? BreakpointBuilder.getContentMaxWidth(context);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: effectiveMaxWidth),
        child: Padding(
          padding: effectivePadding,
          child: child,
        ),
      ),
    );
  }
}

/// A grid that adapts column count based on screen size
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final int? mobileColumns;
  final int? tabletColumns;
  final int? desktopColumns;

  const ResponsiveGrid({
    required this.children,
    this.spacing = 16,
    this.runSpacing = 16,
    this.mobileColumns,
    this.tabletColumns,
    this.desktopColumns,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    int columns;
    
    if (BreakpointBuilder.isDesktop(context)) {
      columns = desktopColumns ?? 4;
    } else if (BreakpointBuilder.isTablet(context)) {
      columns = tabletColumns ?? 2;
    } else {
      columns = mobileColumns ?? 1;
    }

    return GridView.count(
      crossAxisCount: columns,
      crossAxisSpacing: spacing,
      mainAxisSpacing: runSpacing,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: children,
    );
  }
}

/// A row/column that switches based on screen size
class ResponsiveRowColumn extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final double spacing;

  const ResponsiveRowColumn({
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.spacing = 16,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = BreakpointBuilder.isMobile(context);

    if (isMobile) {
      return Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: _addSpacing(children, spacing, true),
      );
    } else {
      return Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: _addSpacing(children, spacing, false),
      );
    }
  }

  List<Widget> _addSpacing(List<Widget> children, double spacing, bool isColumn) {
    if (children.isEmpty) return children;

    final spacedChildren = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);
      if (i < children.length - 1) {
        spacedChildren.add(
          isColumn ? SizedBox(height: spacing) : SizedBox(width: spacing),
        );
      }
    }
    return spacedChildren;
  }
}

/// A text widget that scales based on screen size
class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const ResponsiveText(
    this.text, {
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final multiplier = BreakpointBuilder.getFontSizeMultiplier(context);
    final effectiveStyle = style?.copyWith(
      fontSize: (style?.fontSize ?? 14) * multiplier,
    );

    return Text(
      text,
      style: effectiveStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
