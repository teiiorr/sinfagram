import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/gradients.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/stories/application/stories_controller.dart';
import 'package:sinfagram/features/stories/domain/story.dart';
import 'package:sinfagram/shared/motion/motion_widgets.dart';
import 'package:sinfagram/shared/widgets/app_bottom_sheet.dart';
import 'package:sinfagram/shared/widgets/app_button.dart';
import 'package:sinfagram/shared/widgets/app_text_field.dart';
import 'package:sinfagram/shared/widgets/avatar.dart';

/// Instagram-style story tray for the top of the feed. Unseen rings carry the
/// brand gradient; seen rings go quiet. The first ring is the viewer's own
/// story — tapping it opens a small "add / view" menu.
class StoryTray extends ConsumerWidget {
  const StoryTray({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stories = ref.watch(storiesProvider);
    return SizedBox(
      height: 108,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
            horizontal: Space.gutter, vertical: Space.sm),
        itemCount: stories.length,
        separatorBuilder: (_, __) => const SizedBox(width: Space.md),
        itemBuilder: (context, i) => _ring(context, ref, stories[i], i),
      ),
    );
  }

  Widget _ring(BuildContext context, WidgetRef ref, Story s, int index) {
    final colors = context.colors;
    final l = AppL10n.of(context);
    return TapScale(
      onTap: () => s.isMine
          ? _openMine(context, ref, index, l)
          : context.push('/stories/$index'),
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // Unseen: full-spectrum conic ring (static — no spin, by request).
                // Seen: flat stronger border.
                gradient: s.seen ? null : AppGradients.storyRing,
                color: s.seen ? colors.borderStrong : null,
              ),
              child: Container(
                padding: const EdgeInsets.all(2.5),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: colors.surface),
                child: Stack(
                  children: [
                    Avatar(name: s.author, size: 56),
                    if (s.isMine)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: colors.primary,
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: colors.surface, width: 2),
                          ),
                          child: const Icon(LucideIcons.plus,
                              size: 12, color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: Space.xs),
            Text(
              s.isMine ? l.storyYou : s.author.split(' ').first,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.caption.copyWith(color: colors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  /// The viewer's own ring: add a new slide, or view what's already there.
  Future<void> _openMine(
      BuildContext context, WidgetRef ref, int index, AppL10n l) async {
    await showAppBottomSheet<void>(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppButton(
            l.storyAdd,
            icon: LucideIcons.plus,
            onPressed: () async {
              Navigator.of(context).pop();
              await _addStory(context, ref, l);
            },
          ),
          const SizedBox(height: Space.sm),
          AppButton(
            l.storyYou,
            variant: AppButtonVariant.secondary,
            icon: LucideIcons.eye,
            onPressed: () {
              Navigator.of(context).pop();
              context.push('/stories/$index');
            },
          ),
          const SizedBox(height: Space.sm),
        ],
      ),
    );
  }

  Future<void> _addStory(
      BuildContext context, WidgetRef ref, AppL10n l) async {
    final added = await showAppBottomSheet<bool>(
      context: context,
      child: const _AddStorySheet(),
    );
    if (added == true && context.mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l.storyAdded)));
    }
  }
}

/// Compose one story slide: a short caption over a coloured card (media layer
/// lands later). No real/child imagery — the slide is text on a gradient.
class _AddStorySheet extends ConsumerStatefulWidget {
  const _AddStorySheet();

  @override
  ConsumerState<_AddStorySheet> createState() => _AddStorySheetState();
}

class _AddStorySheetState extends ConsumerState<_AddStorySheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      Navigator.of(context).pop(false);
      return;
    }
    ref.read(storiesProvider.notifier).addMySlide(text);
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final colors = context.colors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l.storyAdd,
            style: AppText.h2.copyWith(color: colors.textPrimary)),
        const SizedBox(height: Space.lg),
        AppTextField(
          controller: _controller,
          label: l.storyAdd,
          maxLines: 3,
          maxLength: 120,
        ),
        const SizedBox(height: Space.lg),
        AppButton(l.storyAdd, icon: LucideIcons.plus, onPressed: _submit),
        const SizedBox(height: Space.sm),
      ],
    );
  }
}
