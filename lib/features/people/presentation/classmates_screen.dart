import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/gradients.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/people/application/people_controllers.dart';
import 'package:sinfagram/features/people/domain/person.dart';
import 'package:sinfagram/features/stories/application/stories_controller.dart';
import 'package:sinfagram/shared/motion/motion_widgets.dart';
import 'package:sinfagram/shared/widgets/avatar.dart';
import 'package:sinfagram/shared/widgets/empty_state.dart';

/// The classmates grid — the whole class as a flat wall of faces. Each cell is a
/// round avatar (hairline border, or the story ring when that classmate has an
/// unseen story) with the name centred beneath. No cards, no shadows, no
/// gradients except the one allowed story ring. Tapping a face opens that
/// person's profile.
class ClassmatesScreen extends ConsumerWidget {
  const ClassmatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final colors = context.colors;
    final people = ref.watch(classmatesProvider);

    // Classmates who currently have a story get the ring (the one allowed
    // gradient). Matched by author name against the class stories.
    final storyAuthors = ref
        .watch(storiesProvider)
        .where((s) => !s.isMine && s.hasSlides)
        .map((s) => s.author)
        .toSet();

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(title: Text(l.classmatesTitle)),
      body: SafeArea(
        child: people.isEmpty
            ? EmptyState(
                icon: LucideIcons.users,
                title: l.classmatesTitle,
                message: l.personNoInfo,
              )
            : GridView.builder(
                padding: const EdgeInsets.fromLTRB(
                  Space.gutter,
                  Space.lg,
                  Space.gutter,
                  Space.xl,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: Space.lg,
                  crossAxisSpacing: Space.md,
                  // Room for a 72 px avatar, the gap and a two-line name with
                  // slack for a 1.6x text scale.
                  childAspectRatio: 0.72,
                ),
                itemCount: people.length,
                itemBuilder: (context, i) => _ClassmateCell(
                  person: people[i],
                  hasStory: storyAuthors.contains(people[i].name),
                ),
              ),
      ),
    );
  }
}

/// One face in the grid: a round avatar over the centred name. Flat — no card,
/// no shadow. The whole cell dims on press (opacity) before routing to the
/// profile.
class _ClassmateCell extends StatelessWidget {
  const _ClassmateCell({required this.person, required this.hasStory});

  final Person person;
  final bool hasStory;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return TapScale(
      onTap: () => context.push('/person/${person.id}'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _ClassmateAvatar(name: person.name, hasStory: hasStory),
          const SizedBox(height: Space.sm),
          Text(
            person.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppText.bodyStrong.copyWith(color: colors.textPrimary),
          ),
        ],
      ),
    );
  }
}

/// A 72 px round avatar. Flat hairline border by default; the story ring (the
/// only gradient in the product) when the classmate has a story.
class _ClassmateAvatar extends StatelessWidget {
  const _ClassmateAvatar({required this.name, required this.hasStory});

  final String name;
  final bool hasStory;

  static const double _size = 72;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    if (!hasStory) {
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: colors.border, width: Stroke.hairline),
        ),
        child: Avatar(name: name, size: _size),
      );
    }

    return Container(
      padding: const EdgeInsets.all(2.5),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppGradients.storyRing,
      ),
      child: Container(
        padding: const EdgeInsets.all(2.5),
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: colors.surface),
        child: Avatar(name: name, size: _size),
      ),
    );
  }
}
