import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/gradients.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/board/application/board_controller.dart';
import 'package:sinfagram/features/board/domain/board.dart';
import 'package:sinfagram/shared/motion/motion_widgets.dart';
import 'package:sinfagram/shared/widgets/app_card.dart';
import 'package:sinfagram/shared/widgets/app_chip.dart';
import 'package:sinfagram/shared/widgets/icon_tile.dart';

/// S15 — school board (docs/07 §7.4). Schedule (current period highlighted),
/// homework, pinned announcements, lost & found — one scroll, fully offline.
class BoardScreen extends ConsumerWidget {
  const BoardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final board = ref.watch(boardProvider);

    return Scaffold(
      backgroundColor: context.colors.bg,
      appBar: AppBar(title: Text(l.boardTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
              Space.gutter, Space.md, Space.gutter, Space.xxl),
          children: [
            // The board's new lead role: a colourful hub into every class
            // activity, so the variety of features is discoverable in one place.
            _section(context, LucideIcons.layoutGrid, l.boardClassHub),
            _classHub(context, l),
            const SizedBox(height: Space.lg),
            _section(context, LucideIcons.calendarDays, l.boardSchedule),
            AppCard(
                padding: EdgeInsets.zero,
                child: Column(children: [
                  for (final it in board.schedule) _lessonRow(context, l, it)
                ])),
            const SizedBox(height: Space.lg),
            _section(context, LucideIcons.clipboardList, l.boardHomework),
            for (final h in board.homework) ...[
              _homeworkCard(context, h),
              const SizedBox(height: Space.sm)
            ],
            const SizedBox(height: Space.md),
            _section(context, LucideIcons.bell, l.boardAnnouncements),
            for (final a in _pinnedFirst(board.announcements)) ...[
              _announcementCard(context, a),
              const SizedBox(height: Space.sm)
            ],
            const SizedBox(height: Space.md),
            _section(context, LucideIcons.search, l.boardLostFound),
            for (final it in board.lostFound) ...[
              _lostCard(context, it),
              const SizedBox(height: Space.sm)
            ],
          ],
        ),
      ),
    );
  }

  List<Announcement> _pinnedFirst(List<Announcement> items) =>
      [...items.where((a) => a.pinned), ...items.where((a) => !a.pinned)];

  /// The class-activities hub: a colourful 2-column grid surfacing every class
  /// feature (roles, shared wall, weekly challenge, time capsule, chronicle,
  /// help) so nothing is orphaned by the Instagram-style navigation.
  Widget _classHub(BuildContext context, AppL10n l) {
    final tiles = <(IconData, Color, String, String)>[
      (LucideIcons.crown, AppAccents.amber, l.rolesTitle, '/roles'),
      (LucideIcons.stickyNote, AppAccents.pink, l.wallTitle, '/wall'),
      (LucideIcons.target, AppAccents.green, l.challengeScreenTitle, '/challenge'),
      (LucideIcons.archive, AppAccents.blue, l.capsuleTitle, '/capsule'),
      (LucideIcons.scrollText, AppAccents.violet, l.chronicleTitle, '/chronicle'),
      (LucideIcons.circleHelp, AppAccents.cyan, l.helpTitle, '/help'),
    ];
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: Space.sm,
      crossAxisSpacing: Space.sm,
      childAspectRatio: 2.6,
      children: [
        for (var i = 0; i < tiles.length; i++)
          Reveal(index: i, child: _hubTile(context, tiles[i])),
      ],
    );
  }

  Widget _hubTile(
      BuildContext context, (IconData, Color, String, String) t) {
    final colors = context.colors;
    return AppCard(
      onTap: () => context.push(t.$4),
      padding: const EdgeInsets.all(Space.sm),
      child: Row(
        children: [
          IconTile(t.$1, color: t.$2, size: 40),
          const SizedBox(width: Space.sm),
          Expanded(
            child: Text(
              t.$3,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppText.bodyStrong.copyWith(color: colors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(BuildContext context, IconData icon, String title) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.sm),
      child: Row(children: [
        Icon(icon, size: 24, color: AppAccents.forSeed(title)),
        const SizedBox(width: Space.sm),
        Text(title, style: AppText.h3.copyWith(color: colors.textPrimary)),
      ]),
    );
  }

  Widget _lessonRow(BuildContext context, AppL10n l, Lesson it) {
    final colors = context.colors;
    return Container(
      color: it.isCurrent ? colors.primarySubtle : null,
      padding: const EdgeInsets.symmetric(
          horizontal: Space.md, vertical: Space.sm + 2),
      child: Row(
        children: [
          SizedBox(
              width: 48,
              child: Text(it.time,
                  style: AppText.numeric.copyWith(
                      color: it.isCurrent
                          ? colors.primary
                          : colors.textSecondary))),
          const SizedBox(width: Space.sm),
          Expanded(
              child: Text(it.subject,
                  style: AppText.body.copyWith(
                      color: colors.textPrimary,
                      fontWeight:
                          it.isCurrent ? FontWeight.w600 : FontWeight.w400))),
          if (it.isCurrent) ...[
            AppChip(l.boardNow, variant: AppChipVariant.primary),
            const SizedBox(width: Space.sm),
          ],
          Text(it.room,
              style: AppText.caption.copyWith(color: colors.textTertiary)),
        ],
      ),
    );
  }

  Widget _homeworkCard(BuildContext context, Homework h) {
    final colors = context.colors;
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppChip(h.subject, variant: AppChipVariant.neutral),
                const SizedBox(height: Space.sm),
                Text(h.title,
                    style: AppText.body.copyWith(color: colors.textPrimary)),
              ],
            ),
          ),
          const SizedBox(width: Space.sm),
          AppChip(h.due,
              variant: AppChipVariant.warning, icon: LucideIcons.clock),
        ],
      ),
    );
  }

  Widget _announcementCard(BuildContext context, Announcement a) {
    final colors = context.colors;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            if (a.pinned) ...[
              Icon(LucideIcons.pin, size: 15, color: colors.primary),
              const SizedBox(width: Space.xs)
            ],
            Expanded(
                child: Text(a.title,
                    style: AppText.bodyStrong
                        .copyWith(color: colors.textPrimary))),
          ]),
          const SizedBox(height: Space.xs),
          Text(a.body,
              style: AppText.bodySm.copyWith(color: colors.textSecondary)),
        ],
      ),
    );
  }

  Widget _lostCard(BuildContext context, LostItem it) {
    final colors = context.colors;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(it.title,
              style: AppText.bodyStrong.copyWith(color: colors.textPrimary)),
          const SizedBox(height: Space.xs),
          Text(it.note,
              style: AppText.bodySm.copyWith(color: colors.textSecondary)),
        ],
      ),
    );
  }
}
