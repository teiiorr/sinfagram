import 'package:flutter/material.dart';

import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';

/// A content container — Instagram flat. Surface fill, a single hairline border,
/// radius [Radii.card] (0), and no shadow. When [onTap] is given the card is
/// pressable with a quiet primary splash; there is no press-scale.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final resolvedPadding = padding ?? const EdgeInsets.all(Space.md);

    Widget content = Padding(padding: resolvedPadding, child: child);

    if (onTap != null) {
      content = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Radii.card),
        splashColor: colors.primary.withValues(alpha: 0.06),
        highlightColor: colors.primary.withValues(alpha: 0.05),
        child: content,
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.border, width: Stroke.hairline),
        borderRadius: BorderRadius.circular(Radii.card),
      ),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: BorderRadius.circular(Radii.card),
        clipBehavior: Clip.antiAlias,
        child: content,
      ),
    );
  }
}
