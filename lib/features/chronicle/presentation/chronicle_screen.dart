import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/gradients.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/chronicle/application/chronicle_controller.dart';
import 'package:sinfagram/features/chronicle/domain/chronicle.dart';
import 'package:sinfagram/shared/widgets/app_card.dart';
import 'package:sinfagram/shared/widgets/app_chip.dart';
import 'package:sinfagram/shared/widgets/empty_state.dart';
import 'package:sinfagram/shared/widgets/icon_tile.dart';

/// S30 — chronicle (docs/07 §7.6). Month chapters, newest first. The current
/// month shows how long until it seals; sealed chapters are marked.
class ChronicleScreen extends ConsumerWidget {
  const ChronicleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final chapters = ref.watch(chronicleProvider);

    return Scaffold(
      backgroundColor: context.colors.bg,
      appBar: AppBar(title: Text(l.chronicleTitle)),
      body: SafeArea(
        child: Column(
          children: [
            _classLinks(context, l),
            Expanded(
              child: chapters.isEmpty
                  ? EmptyState(
                      icon: LucideIcons.bookOpen,
                      title: l.chronicleEmpty,
                      message: '')
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                          Space.gutter, Space.md, Space.gutter, Space.xxl),
                      itemCount: chapters.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: Space.sm),
                      itemBuilder: (context, i) =>
                          _chapterCard(context, l, chapters[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// Quick links to the class-community surfaces (roles, shared wall, capsule)
  /// grouped with the chronicle — the class's shared memory.
  Widget _classLinks(BuildContext context, AppL10n l) {
    Widget chip(IconData icon, String label, String route) => Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Space.xs),
            child: AppCard(
              padding: const EdgeInsets.symmetric(
                  vertical: Space.md, horizontal: Space.sm),
              onTap: () => context.push(route),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconTile(icon, color: AppAccents.forSeed(label), size: 44),
                  const SizedBox(height: Space.xs),
                  Text(label,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.caption
                          .copyWith(color: context.colors.textSecondary)),
                ],
              ),
            ),
          ),
        );
    return Padding(
      padding: const EdgeInsets.fromLTRB(Space.sm, Space.md, Space.sm, 0),
      child: Row(children: [
        chip(LucideIcons.userCheck, l.rolesTitle, '/roles'),
        chip(LucideIcons.layoutGrid, l.wallTitle, '/wall'),
        chip(LucideIcons.mailbox, l.capsuleTitle, '/capsule'),
      ]),
    );
  }

  Widget _chapterCard(BuildContext context, AppL10n l, Chapter c) {
    final colors = context.colors;
    return AppCard(
      onTap: () => context.push('/chapter/${c.id}'),
      child: Row(
        children: [
          // Cover placeholder — a real cover thumbnail lands with the media layer.
          IconTile(LucideIcons.bookOpen,
              color: AppAccents.forSeed(c.monthLabel), size: 56),
          const SizedBox(width: Space.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(c.monthLabel,
                        style: AppText.h3.copyWith(color: colors.textPrimary)),
                    const SizedBox(width: Space.sm),
                    if (c.sealed)
                      AppChip(l.chronicleSealed,
                          variant: AppChipVariant.neutral,
                          icon: LucideIcons.lock),
                  ],
                ),
                const SizedBox(height: Space.xs),
                Text(l.chronicleItems(c.itemCount),
                    style:
                        AppText.bodySm.copyWith(color: colors.textSecondary)),
                if (!c.sealed && c.daysToSeal != null) ...[
                  const SizedBox(height: Space.sm),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Radii.chip),
                    child: LinearProgressIndicator(
                      value: 1 - (c.daysToSeal! / 30).clamp(0.0, 1.0),
                      minHeight: 4,
                      backgroundColor: colors.border,
                      valueColor: AlwaysStoppedAnimation(colors.primary),
                    ),
                  ),
                  const SizedBox(height: Space.xs),
                  Text(l.chronicleDaysToSeal(c.daysToSeal!),
                      style:
                          AppText.caption.copyWith(color: colors.textTertiary)),
                ],
              ],
            ),
          ),
          Icon(LucideIcons.chevronRight, size: 18, color: colors.textTertiary),
        ],
      ),
    );
  }
}
