import 'package:flutter/widgets.dart';

import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';

/// A placeholder rectangle for loading states — Instagram flat. A static fill in
/// [AppColors.skeleton]; no shimmer (a moving sheen is a gradient, disallowed
/// everywhere but the story ring), no shadow.
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
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colors.skeleton,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
