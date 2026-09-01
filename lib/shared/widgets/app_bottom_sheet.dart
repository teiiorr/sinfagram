import 'package:flutter/material.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';

/// Standard modal bottom sheet for Sinfagram — docs/05 §5.5.
///
/// The caller supplies [child] as the full content (no title is injected here).
/// For content taller than the sheet, pass a scrollable [child] (a `ListView`
/// or `SingleChildScrollView`): the sheet is capped at 85% of screen height, so
/// the child scrolls inside that bound rather than pushing past the top edge.
///
/// Returns whatever the child pops with (via `Navigator.pop(context, value)`).
Future<T?> showAppBottomSheet<T>({
  required BuildContext context,
  required Widget child,
  bool isScrollControlled = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    // The shell paints surface + radius + shadow itself so we can use the
    // Shadows.overlay token; the framework's own elevation is suppressed.
    backgroundColor: Colors.transparent,
    elevation: 0,
    // Neutral scrim, not a coloured one. docs/05 §5.5: black at 40%.
    barrierColor: Colors.black.withValues(alpha: 0.4),
    constraints: BoxConstraints(
      maxHeight: MediaQuery.sizeOf(context).height * 0.85,
    ),
    builder: (context) => _AppBottomSheetShell(child: child),
  );
}

/// Surface + drag handle wrapper. Private: only [showAppBottomSheet] builds it.
class _AppBottomSheetShell extends StatelessWidget {
  const _AppBottomSheetShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      // clipBehavior keeps a full-width child's corners inside the rounded top.
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(Radii.sheet),
        ),
        boxShadow: Shadows.overlay,
      ),
      child: SafeArea(
        // Sheet sits at the bottom; only the home-indicator inset matters.
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _DragHandle(),
            // Flexible lets a scrollable child fill the remaining bounded space
            // (up to the 85% cap) instead of forcing the sheet to full height.
            Flexible(child: child),
          ],
        ),
      ),
    );
  }
}

/// Purely decorative grab affordance; excluded from the semantics tree since the
/// sheet is dismissed by swipe or by tapping the scrim, not by activating this.
class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Space.sm),
        child: Container(
          width: Space.xl, // 32
          height: Space.xs, // 4
          decoration: BoxDecoration(
            color: context.colors.border,
            borderRadius: BorderRadius.circular(Radii.chip),
          ),
        ),
      ),
    );
  }
}
