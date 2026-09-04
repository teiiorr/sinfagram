import 'package:flutter/material.dart';

import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';

/// A rounded leading icon tile — Instagram flat. The glyph renders in
/// [AppColors.textPrimary] on a quiet [AppColors.primarySubtle] tile with radius
/// [Radii.hero] (8). The [color] argument is kept for API stability but is
/// deliberately ignored: this system has no per-tile accent colour.
class IconTile extends StatelessWidget {
  const IconTile(this.icon, {super.key, required this.color, this.size = 48});

  final IconData icon;

  /// Kept for API stability; ignored — every tile is neutral.
  final Color color;

  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.primarySubtle,
        borderRadius: BorderRadius.circular(Radii.hero),
      ),
      child: Icon(icon, color: colors.textPrimary, size: size * 0.5),
    );
  }
}
