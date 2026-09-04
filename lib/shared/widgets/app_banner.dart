import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';

/// Inline stale/offline notice. docs/05 §5.5.
///
/// The caller places it directly below the app bar; it is a normal child in the
/// layout, never an overlay — so it pushes content down rather than covering it.
class AppBanner extends StatelessWidget {
  const AppBanner(this.message, {super.key, this.onDismiss});

  final String message;
  final VoidCallback? onDismiss;

  // Min height and touch target come from the design system, not the widget.
  static const double _minHeight = 32;
  static const double _dismissHit = 44; // accessible tap target for the X

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: _minHeight),
      decoration: BoxDecoration(
        color: colors.warningSubtle,
        border: Border(
          bottom: BorderSide(color: colors.border, width: Stroke.hairline),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: Space.gutter),
      child: Row(
        children: [
          Expanded(
            child: Text(
              message,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.caption.copyWith(color: colors.warning),
            ),
          ),
          if (onDismiss != null) ...[
            const SizedBox(width: Space.sm),
            // The visible glyph stays 16px; the tappable area is padded out to 44px
            // so the small icon still meets the minimum touch target.
            Semantics(
              button: true,
              label: 'dismiss',
              child: InkResponse(
                onTap: onDismiss,
                radius: _dismissHit / 2,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: _dismissHit,
                    minHeight: _dismissHit,
                  ),
                  child: Icon(
                    LucideIcons.x,
                    size: 16,
                    color: colors.warning,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
