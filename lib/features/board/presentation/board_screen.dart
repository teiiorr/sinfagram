import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/board/application/board_controller.dart';
import 'package:sinfagram/features/board/domain/board.dart';
import 'package:sinfagram/shared/widgets/app_chip.dart';

/// S15 — school board (docs/07 §7.4). Schedule (current period highlighted),
/// homework, pinned announcements, lost & found — one scroll, fully offline.
///
/// Instagram styling: flat grouped blocks — a hairline-bordered container with a
/// radius-8 corner, rows separated by 1px dividers. Neutral 24px glyphs, no
/// colourful tiles, no gradients, no shadows.
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
            // The board's lead role: a hub into every class activity, so the
            // variety of features is discoverable in one place.
            _section(context, LucideIcons.layoutGrid, l.boardClassHub),
            _classHub(context, l),
            const SizedBox(height: Space.lg),
            _section(context, LucideIcons.calendarDays, l.boardSchedule),
            _block(
              context,
              children: [
                for (final it in board.schedule) _lessonRow(context, l, it),
              ],
            ),
            const SizedBox(height: Space.lg),
            _section(context, LucideIcons.clipboardList, l.boardHomework),
            _block(
              context,
              children: [
                for (final h in board.homework) _homeworkRow(context, h),
              ],
            ),
            const SizedBox(height: Space.lg),
            _section(context, LucideIcons.bell, l.boardAnnouncements),
            _block(
              context,
              children: [
                for (final a in _pinnedFirst(board.announcements))
                  _announcementRow(context, a),
              ],
            ),
            const SizedBox(height: Space.lg),
            _section(context, LucideIcons.search, l.boardLostFound),
            _block(
              context,
              children: [
                for (final it in board.lostFound) _lostRow(context, it),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Announcement> _pinnedFirst(List<Announcement> items) =>
      [...items.where((a) => a.pinned), ...items.where((a) => !a.pinned)];

  /// A flat grouped block: surface fill, a hairline border with a radius-8
  /// corner, [children] stacked with 1px dividers between them.
  Widget _block(BuildContext context, {required List<Widget> children}) {
    if (children.isEmpty) return const SizedBox.shrink();
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.border, width: Stroke.hairline),
        borderRadius: BorderRadius.circular(Radii.hero),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Radii.hero),
        child: Column(children: _divided(context, children)),
      ),
    );
  }

  List<Widget> _divided(BuildContext context, List<Widget> rows) {
    final colors = context.colors;
    final out = <Widget>[];
    for (var i = 0; i < rows.length; i++) {
      if (i > 0) {
        out.add(Container(height: Stroke.hairline, color: colors.border));
      }
      out.add(rows[i]);
    }
    return out;
  }

  /// The class-activities hub: a 2-column grid of flat rows surfacing every class
  /// feature (roles, shared wall, weekly challenge, time capsule, chronicle,
  /// help) so nothing is orphaned by the Instagram-style navigation.
  Widget _classHub(BuildContext context, AppL10n l) {
    final tiles = <(IconData, String, String)>[
      (LucideIcons.crown, l.rolesTitle, '/roles'),
      (LucideIcons.stickyNote, l.wallTitle, '/wall'),
      (LucideIcons.target, l.challengeScreenTitle, '/challenge'),
      (LucideIcons.archive, l.capsuleTitle, '/capsule'),
      (LucideIcons.scrollText, l.chronicleTitle, '/chronicle'),
      (LucideIcons.circleHelp, l.helpTitle, '/help'),
    ];
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: Space.sm,
      crossAxisSpacing: Space.sm,
      childAspectRatio: 2.7,
      children: [for (final t in tiles) _hubTile(context, t)],
    );
  }

  Widget _hubTile(BuildContext context, (IconData, String, String) t) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.border, width: Stroke.hairline),
        borderRadius: BorderRadius.circular(Radii.hero),
      ),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: BorderRadius.circular(Radii.hero),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.push(t.$3),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Space.md, vertical: Space.sm),
            child: Row(
              children: [
                Icon(t.$1, size: 24, color: colors.textPrimary),
                const SizedBox(width: Space.sm),
                Expanded(
                  child: Text(
                    t.$2,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:
                        AppText.bodyStrong.copyWith(color: colors.textPrimary),
                  ),
                ),
                const SizedBox(width: Space.xs),
                Icon(LucideIcons.chevronRight,
                    size: 20, color: colors.textTertiary),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _section(BuildContext context, IconData icon, String title) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.sm),
      child: Row(children: [
        Icon(icon, size: 24, color: colors.textPrimary),
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

  Widget _homeworkRow(BuildContext context, Homework h) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.all(Space.md),
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

  Widget _announcementRow(BuildContext context, Announcement a) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.all(Space.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            if (a.pinned) ...[
              Icon(LucideIcons.pin, size: 14, color: colors.textSecondary),
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

  Widget _lostRow(BuildContext context, LostItem it) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.all(Space.md),
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
