import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/chronicle/application/chronicle_controller.dart';
import 'package:sinfagram/features/chronicle/domain/chronicle.dart';
import 'package:sinfagram/shared/widgets/empty_state.dart';

/// S31 — chapter (docs/07 §7.6). A 3-column grid; a tap shows the caption. A
/// sealed chapter says so once, at the top, and is read-only.
class ChapterScreen extends ConsumerWidget {
  const ChapterScreen({super.key, required this.chapterId});

  final String chapterId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final colors = context.colors;
    Chapter? chapter;
    for (final c in ref.watch(chronicleProvider)) {
      if (c.id == chapterId) chapter = c;
    }

    if (chapter == null) {
      return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
            child: EmptyState(
                icon: LucideIcons.bookOpen,
                title: l.emptyTitle,
                message: l.emptyBody)),
      );
    }

    final items = chapter.items;

    return Scaffold(
      appBar: AppBar(title: Text(chapter.monthLabel)),
      body: SafeArea(
        child: items.isEmpty
            ? EmptyState(
                icon: LucideIcons.image, title: l.chapterEmpty, message: '')
            : CustomScrollView(
                slivers: [
                  if (chapter.sealed)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                            Space.gutter, Space.md, Space.gutter, Space.sm),
                        child: Row(
                          children: [
                            Icon(LucideIcons.lock,
                                size: 15, color: colors.textTertiary),
                            const SizedBox(width: Space.sm),
                            Expanded(
                                child: Text(l.chapterSealedNote,
                                    style: AppText.bodySm.copyWith(
                                        color: colors.textSecondary))),
                          ],
                        ),
                      ),
                    ),
                  SliverPadding(
                    padding: const EdgeInsets.all(Space.gutter),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: Space.sm,
                        mainAxisSpacing: Space.sm,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, i) => _tile(context, items[i]),
                        childCount: items.length,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _tile(BuildContext context, ChronicleItem item) {
    final colors = context.colors;
    return GestureDetector(
      onTap: () => ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(item.caption))),
      child: Container(
        decoration: BoxDecoration(
            color: colors.surfaceRaised,
            borderRadius: BorderRadius.circular(Radii.control),
            border: Border.all(color: colors.border, width: Stroke.hairline)),
        alignment: Alignment.center,
        child: Icon(LucideIcons.image, color: colors.textTertiary, size: 26),
      ),
    );
  }
}
