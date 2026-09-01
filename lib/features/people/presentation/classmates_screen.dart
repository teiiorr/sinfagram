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
import 'package:sinfagram/shared/motion/motion_widgets.dart';
import 'package:sinfagram/shared/widgets/app_card.dart';
import 'package:sinfagram/shared/widgets/avatar.dart';
import 'package:sinfagram/shared/widgets/empty_state.dart';

/// The classmates grid — the whole class as a wall of faces. Opening it plays
/// the "pop-in" the product owner asked for: each cell rides a staggered
/// [Reveal] (fade + rise + scale) so the class cascades into view on entry.
/// Tapping a face opens that person's profile.
class ClassmatesScreen extends ConsumerWidget {
  const ClassmatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final colors = context.colors;
    final people = ref.watch(classmatesProvider);

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
                  crossAxisCount: 2,
                  mainAxisSpacing: Space.md,
                  crossAxisSpacing: Space.md,
                  // Roomy, near-square cards: the ringed avatar sits centred with
                  // the name below, with slack for a 1.6x text scale.
                  childAspectRatio: 0.85,
                ),
                itemCount: people.length,
                itemBuilder: (context, i) => Reveal(
                  index: i,
                  child: _ClassmateCell(person: people[i]),
                ),
              ),
      ),
    );
  }
}

/// One face in the grid: a gradient-ringed avatar over the centred name, on a
/// soft card. The whole cell springs on press (bouncy [TapScale]) before routing
/// to the profile.
class _ClassmateCell extends StatelessWidget {
  const _ClassmateCell({required this.person});

  final Person person;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return TapScale(
      onTap: () => context.push('/person/${person.id}'),
      child: AppCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Brand ring → surface inset → initials avatar.
            Container(
              padding: const EdgeInsets.all(2.5),
              decoration: const BoxDecoration(
                gradient: AppGradients.avatarRing,
                shape: BoxShape.circle,
              ),
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: colors.surface,
                  shape: BoxShape.circle,
                ),
                child: Avatar(name: person.name, size: 60),
              ),
            ),
            const SizedBox(height: Space.sm),
            Text(
              person.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppText.bodyStrong
                  .copyWith(color: colors.textPrimary, fontSize: 13.5),
            ),
          ],
        ),
      ),
    );
  }
}
