import 'package:flutter/widgets.dart';

import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/shared/motion/motion_widgets.dart';

/// A placeholder rectangle for loading states with a moving sheen (DECISIONS.md
/// — a more noticeable shimmer was requested; still one cheap animated
/// ShaderMask, and it falls back to a static tint under reduce-motion).
///
/// A null [width] fills the available width, so a stack of these reads as text
/// lines; give an explicit width for chips, avatars, or fixed cells.
class SkeletonBlock extends StatelessWidget {
  const SkeletonBlock(
      {super.key, this.width, this.height = 16, this.radius = Radii.control});

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final base = context.colors.skeleton;
    // A lighter band sweeps across the base fill.
    final highlight = Color.lerp(base, context.colors.surface, 0.6)!;

    final box = SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: base, borderRadius: BorderRadius.circular(radius)),
      ),
    );

    return RepaintBoundary(
      child: Shimmer(base: base, highlight: highlight, child: box),
    );
  }
}
