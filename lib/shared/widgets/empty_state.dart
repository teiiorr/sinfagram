import 'package:flutter/widgets.dart';

import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';

/// The blank-slate for any list, feed or search that has nothing to show.
/// Deliberately quiet: an icon, two lines, and an optional action — no
/// illustration or mascot, so it reads as a state and not a distraction.
/// docs/05 §5.5.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.all(Space.xl),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // A soft coloured halo behind the glyph — friendlier and less
            // monotone than a bare grey icon. Illustrative only, so kept out of
            // the a11y tree.
            Container(
              width: 88,
              height: 88,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: colors.primarySubtle, shape: BoxShape.circle),
              child: Icon(icon,
                  size: 40, color: colors.primary, semanticLabel: null),
            ),
            const SizedBox(height: Space.md),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppText.h2.copyWith(color: colors.textPrimary),
            ),
            if (message.isNotEmpty) ...[
              const SizedBox(height: Space.xs),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppText.body.copyWith(color: colors.textSecondary),
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: Space.md),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
