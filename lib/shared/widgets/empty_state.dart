import 'package:flutter/widgets.dart';

import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';

/// The blank-slate for any list, feed or search that has nothing to show.
/// Instagram-quiet: a single large outline icon, a title, one line of secondary
/// copy, and an optional action — no halo, no illustration, no mascot, so it
/// reads as a state and not a distraction. Centred. docs/05 §5.5.
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
            // A bare outline glyph — illustrative only, so kept out of the a11y
            // tree.
            Icon(icon, size: 96, color: colors.textPrimary),
            const SizedBox(height: Space.md),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppText.h1.copyWith(color: colors.textPrimary),
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
