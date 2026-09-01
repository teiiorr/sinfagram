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
import 'package:sinfagram/shared/widgets/app_chip.dart';
import 'package:sinfagram/shared/widgets/avatar.dart';
import 'package:sinfagram/shared/widgets/empty_state.dart';

/// A single person's profile — a classmate's read-only page (or the viewer's own
/// when [personId] is `me`). A read-only mirror of the "Me" profile: a ringed
/// avatar beside the name and class, the free-text bio, the "now reading / now
/// listening" personality lines, interest chips and a decorative photo wall.
/// Sections cascade in with a staggered [Reveal]. No counters, by design.
class PersonProfileScreen extends ConsumerWidget {
  const PersonProfileScreen({super.key, required this.personId});

  final String personId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final colors = context.colors;
    final person = ref.watch(personByIdProvider(personId));

    // Unknown id — nothing to show, but keep a way back.
    if (person == null) {
      return Scaffold(
        backgroundColor: colors.bg,
        appBar: _backBar(context, colors, ''),
        body: SafeArea(
          child: EmptyState(
            icon: LucideIcons.users,
            title: l.personNoInfo,
            message: '',
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: _backBar(context, colors, person.name),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            Space.gutter,
            Space.lg,
            Space.gutter,
            Space.xl,
          ),
          children: [
            Reveal(index: 0, child: _Header(person: person)),
            const SizedBox(height: Space.lg),
            if (person.bio.isNotEmpty) ...[
              Reveal(
                index: 1,
                child: Text(
                  person.bio,
                  style: AppText.body.copyWith(color: colors.textPrimary),
                ),
              ),
              const SizedBox(height: Space.md),
            ],
            Reveal(
              index: 2,
              child: _BioLine(
                icon: LucideIcons.bookOpen,
                color: AppAccents.amber,
                label: l.personReading,
                value: person.reading,
                empty: l.personNoInfo,
              ),
            ),
            const SizedBox(height: Space.sm),
            Reveal(
              index: 3,
              child: _BioLine(
                icon: LucideIcons.music,
                color: AppAccents.pink,
                label: l.personListening,
                value: person.listening,
                empty: l.personNoInfo,
              ),
            ),
            if (person.interests.isNotEmpty) ...[
              const SizedBox(height: Space.md),
              Reveal(
                index: 4,
                child: Wrap(
                  spacing: Space.sm,
                  runSpacing: Space.sm,
                  children: [
                    for (final tag in person.interests)
                      AppChip(tag, variant: AppChipVariant.accent),
                  ],
                ),
              ),
            ],
            const SizedBox(height: Space.lg),
            Reveal(
              index: 5,
              child: _Photos(label: l.personPhotos, seed: person.name),
            ),
          ],
        ),
      ),
    );
  }

  /// A plain app bar carrying the back affordance and the person's name.
  AppBar _backBar(BuildContext context, AppColors colors, String title) =>
      AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          color: colors.textPrimary,
          onPressed: () => context.pop(),
        ),
      );
}

/// Identity block: a large brand-ringed avatar beside the name and the
/// "<class> · school" line. The ring uses the shared avatar gradient so a person
/// keeps a consistent, colourful frame across the app.
class _Header extends StatelessWidget {
  const _Header({required this.person});

  final Person person;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppGradients.avatarRing,
            boxShadow: Shadows.lift,
          ),
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: colors.surface),
            child: Avatar(name: person.name, size: 80),
          ),
        ),
        const SizedBox(width: Space.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                person.name,
                style: AppText.h2.copyWith(color: colors.textPrimary, fontSize: 19),
              ),
              const SizedBox(height: Space.xs),
              Text(
                // Demo roster line: class group within the (single, seeded) school.
                '${person.className} · 12-maktab',
                style: AppText.bodySm.copyWith(color: colors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// One "icon + label + value" personality line (reading / listening). Shows
/// [empty] softly when [value] is blank, so the line never reads as broken.
class _BioLine extends StatelessWidget {
  const _BioLine({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
    required this.empty,
  });

  final IconData icon;
  final Color color;
  final String label;
  final String value;
  final String empty;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isEmpty = value.isEmpty;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: Space.sm),
        Expanded(
          child: isEmpty
              ? Text(empty,
                  style: AppText.body.copyWith(color: colors.textTertiary))
              : Text.rich(
                  TextSpan(children: [
                    TextSpan(
                      text: '$label  ',
                      style: AppText.caption
                          .copyWith(color: colors.textTertiary),
                    ),
                    TextSpan(
                      text: value,
                      style:
                          AppText.body.copyWith(color: colors.textPrimary),
                    ),
                  ]),
                ),
        ),
      ],
    );
  }
}

/// A decorative photo wall: six gradient placeholder tiles with a faint image
/// glyph. Purely ornamental — no real or photorealistic imagery is used or
/// implied (the app collects no child media in this phase).
class _Photos extends StatelessWidget {
  const _Photos({required this.label, required this.seed});

  final String label;
  final String seed;

  static const _count = 6;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppText.h3.copyWith(color: colors.textPrimary)),
        const SizedBox(height: Space.sm),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: Space.sm,
          crossAxisSpacing: Space.sm,
          children: [
            for (var i = 0; i < _count; i++)
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: AppGradients.of(
                    AppAccents.all[
                        (seed.hashCode.abs() + i) % AppAccents.all.length],
                  ),
                  borderRadius: BorderRadius.circular(Radii.media),
                ),
                child: Center(
                  child: Icon(
                    LucideIcons.image,
                    color: Colors.white.withValues(alpha: 0.55),
                    size: 28,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
