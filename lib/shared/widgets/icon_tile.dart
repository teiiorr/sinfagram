import 'package:flutter/material.dart';

import 'package:sinfagram/core/theme/gradients.dart';

/// A large, colourful rounded icon tile — a white glyph on a vivid accent
/// gradient (DECISIONS.md — bigger, colourful icons). Use as the leading element
/// of list rows and section cards instead of a small monotone icon.
class IconTile extends StatelessWidget {
  const IconTile(this.icon, {super.key, required this.color, this.size = 48});

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: AppGradients.of(color),
        borderRadius: BorderRadius.circular(size * 0.32),
        boxShadow: [
          BoxShadow(
              color: color.withValues(alpha: 0.32),
              blurRadius: 12,
              offset: const Offset(0, 6))
        ],
      ),
      child: Icon(icon, color: Colors.white, size: size * 0.5),
    );
  }
}
