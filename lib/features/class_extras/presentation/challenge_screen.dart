import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/class_extras/application/class_extras_controllers.dart';
import 'package:sinfagram/shared/widgets/app_button.dart';
import 'package:sinfagram/shared/widgets/app_chip.dart';
import 'package:sinfagram/shared/widgets/avatar.dart';

/// S25 — weekly class challenge (docs/07). A theme, a reference-image slot, the
/// deadline, one submit action, and who has entered so far. Flat: the border and
/// the surfaceRaised fill carry the placeholder, nothing lifts. docs/05 §5.5.
class ChallengeScreen extends ConsumerWidget {
  const ChallengeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final colors = context.colors;
    final c = ref.watch(challengeProvider);

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(title: Text(l.challengeScreenTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(Space.gutter),
          children: [
            Text(c.theme,
                style: AppText.h2.copyWith(color: colors.textPrimary)),
            const SizedBox(height: Space.md),

            // Reference-image slot. No photo in this phase — a quiet framed panel
            // with a placeholder glyph holds the shape.
            AspectRatio(
              aspectRatio: 16 / 9,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.surfaceRaised,
                  borderRadius: BorderRadius.circular(Radii.card),
                ),
                child: Center(
                  child: Icon(LucideIcons.image,
                      size: Space.xl, color: colors.textTertiary),
                ),
              ),
            ),
            const SizedBox(height: Space.md),

            Row(
              children: [
                Icon(LucideIcons.clock, size: 16, color: colors.textSecondary),
                const SizedBox(width: Space.xs),
                Expanded(
                  child: Text(
                    l.challengeDeadline(c.deadline),
                    style: AppText.bodySm.copyWith(color: colors.textSecondary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Space.lg),

            // One action: submit while it is still open, otherwise a settled
            // "you're in" marker.
            if (!c.submitted)
              Align(
                alignment: Alignment.centerLeft,
                child: AppButton(
                  l.challengeSubmit,
                  variant: AppButtonVariant.primary,
                  size: AppButtonSize.lg,
                  icon: LucideIcons.send,
                  onPressed: () =>
                      ref.read(challengeProvider.notifier).submit(),
                ),
              )
            else
              Align(
                alignment: Alignment.centerLeft,
                child: AppChip(
                  l.challengeSubmitted,
                  variant: AppChipVariant.success,
                  icon: LucideIcons.check,
                ),
              ),
            const SizedBox(height: Space.xl),

            Text(l.challengeEntries,
                style: AppText.label.copyWith(color: colors.textTertiary)),
            const SizedBox(height: Space.sm),

            for (final name in c.entries)
              Padding(
                padding: const EdgeInsets.only(top: Space.sm),
                child: Row(
                  children: [
                    Avatar(name: name, size: 28),
                    const SizedBox(width: Space.sm),
                    Expanded(
                      child: Text(name,
                          style:
                              AppText.body.copyWith(color: colors.textPrimary)),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
