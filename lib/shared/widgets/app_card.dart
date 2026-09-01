import 'package:flutter/material.dart';

import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/motion.dart';
import 'package:sinfagram/core/theme/spacing.dart';

/// A content container. Surface fill, hairline border, soft ambient depth.
/// When [onTap] is given the card becomes pressable — a 6% primary splash plus a
/// subtle press-scale settle (DECISIONS.md — elevated look). Otherwise inert.
class AppCard extends StatefulWidget {
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
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _pressed = false;

  void _set(bool v) {
    if (v != _pressed) setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final resolvedPadding = widget.padding ?? const EdgeInsets.all(Space.md);

    Widget content = Padding(padding: resolvedPadding, child: widget.child);

    if (widget.onTap != null) {
      content = InkWell(
        onTap: widget.onTap,
        onHighlightChanged: _set,
        borderRadius: BorderRadius.circular(Radii.card),
        splashColor: colors.primary.withValues(alpha: 0.06),
        highlightColor: colors.primary.withValues(alpha: 0.05),
        child: content,
      );
    }

    final card = DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.border, width: Stroke.hairline),
        borderRadius: BorderRadius.circular(Radii.card),
        boxShadow: Shadows.card,
      ),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: BorderRadius.circular(Radii.card),
        clipBehavior: Clip.antiAlias,
        child: content,
      ),
    );

    if (widget.onTap == null) return card;

    return AnimatedScale(
      scale: _pressed ? 0.985 : 1.0,
      duration: motionOf(context, Motion.micro),
      curve: Motion.press,
      child: card,
    );
  }
}
