import 'package:flutter/widgets.dart';

import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';

/// Semantic tone of an [AppChip]. Drives the background/foreground colour pair.
enum AppChipVariant { neutral, primary, success, warning, accent }

/// A small, static status/label pill. docs/05 §5.5.
///
/// The chip is a label, not a control — its background is the *subtle* tint of
/// the variant and its text/icon the *strong* tone, so it reads as a quiet
/// marker rather than a tappable button.
class AppChip extends StatelessWidget {
  const AppChip(this.label,
      {super.key, this.variant = AppChipVariant.neutral, this.icon});

  final String label;
  final AppChipVariant variant;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (Color background, Color foreground) = switch (variant) {
      // Neutral has no dedicated "subtle" role, so the border colour doubles as a
      // faint fill and textSecondary keeps it visually recessive.
      AppChipVariant.neutral => (colors.border, colors.textSecondary),
      AppChipVariant.primary => (colors.primarySubtle, colors.primary),
      AppChipVariant.success => (colors.successSubtle, colors.success),
      AppChipVariant.warning => (colors.warningSubtle, colors.warning),
      AppChipVariant.accent => (colors.accentSubtle, colors.accent),
    };

    return ConstrainedBox(
      // Min-height floor rather than a fixed height so the label still fits when
      // the user scales text up to 1.6x.
      constraints: const BoxConstraints(minHeight: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: Space.sm, vertical: Space.xs),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(Radii.chip),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: foreground),
              const SizedBox(width: Space.xs),
            ],
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: AppText.caption.copyWith(color: foreground),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
