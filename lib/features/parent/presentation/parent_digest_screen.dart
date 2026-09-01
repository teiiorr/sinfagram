import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/gradients.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/parent/application/parent_controllers.dart';
import 'package:sinfagram/shared/widgets/app_card.dart';
import 'package:sinfagram/shared/widgets/avatar.dart';
import 'package:sinfagram/shared/widgets/icon_tile.dart';

/// P01 — weekly digest (docs/07 §7.10). Aggregates only; no live feed, no
/// "online" indicator. Links out to the child's published content and any cases.
class ParentDigestScreen extends ConsumerWidget {
  const ParentDigestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final colors = context.colors;
    final d = ref.watch(parentDigestProvider);

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(title: Text(l.pDigestTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
              Space.gutter, Space.md, Space.gutter, Space.xxl),
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Avatar(name: d.childName, size: 44),
                    const SizedBox(width: Space.md),
                    Expanded(
                        child: Text(d.childName,
                            style: AppText.h2
                                .copyWith(color: colors.textPrimary))),
                  ]),
                  const SizedBox(height: Space.md),
                  _stat(context, LucideIcons.calendarCheck,
                      l.pActiveDays(d.activeDays), AppAccents.blue),
                  _stat(context, LucideIcons.clock, l.pMinutes(d.minutes),
                      AppAccents.teal),
                  _stat(context, LucideIcons.messageSquare,
                      l.pPublishedCount(d.published), AppAccents.violet),
                  _stat(context, LucideIcons.heart, l.pThanksReceived(d.thanks),
                      AppAccents.pink),
                ],
              ),
            ),
            const SizedBox(height: Space.md),
            _link(context, LucideIcons.images, l.pChildContent,
                AppAccents.orange, () => context.push('/parent/content')),
            const SizedBox(height: Space.sm),
            _link(context, LucideIcons.flag, l.pCases, AppAccents.red,
                () => context.push('/parent/cases')),
            const SizedBox(height: Space.lg),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(LucideIcons.eyeOff, size: 15, color: colors.textTertiary),
                const SizedBox(width: Space.sm),
                Expanded(
                    child: Text(l.pNoLiveFeed,
                        style: AppText.caption
                            .copyWith(color: colors.textSecondary))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(BuildContext context, IconData icon, String text, Color accent) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Space.xs),
      child: Row(children: [
        IconTile(icon, color: accent, size: 44),
        const SizedBox(width: Space.md),
        Text(text, style: AppText.body.copyWith(color: colors.textPrimary)),
      ]),
    );
  }

  Widget _link(BuildContext context, IconData icon, String label, Color accent,
      VoidCallback onTap) {
    final colors = context.colors;
    return AppCard(
      onTap: onTap,
      child: Row(children: [
        IconTile(icon, color: accent, size: 44),
        const SizedBox(width: Space.md),
        Expanded(
            child: Text(label,
                style: AppText.body.copyWith(color: colors.textPrimary))),
        Icon(LucideIcons.chevronRight, size: 20, color: colors.textTertiary),
      ]),
    );
  }
}
