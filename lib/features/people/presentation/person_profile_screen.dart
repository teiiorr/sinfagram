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
import 'package:sinfagram/shared/widgets/app_chip.dart';
import 'package:sinfagram/shared/widgets/avatar.dart';
import 'package:sinfagram/shared/widgets/empty_state.dart';
import 'package:sinfagram/shared/widgets/icon_tile.dart';

/// A single person's profile — a classmate's read-only page (or the viewer's own
/// when [personId] is `me`). A colourful gradient header with a ringed avatar
/// sits above cards for bio, "now reading", "now listening", interests and a
/// decorative photo wall. Sections cascade in with a staggered [Reveal].
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
        appBar: _backBar(context, colors),
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
      appBar: _backBar(context, colors),
      // A transparent AppBar over a coloured band, so extend the body up behind it.
      extendBodyBehindAppBar: true,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Reveal(index: 0, child: _Header(person: person)),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Space.gutter,
              Space.lg,
              Space.gutter,
              Space.xl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (person.bio.isNotEmpty) ...[
                  Reveal(
                    index: 1,
                    child: _BioCard(label: l.personBio, bio: person.bio),
                  ),
                  const SizedBox(height: Space.md),
                ],
                Reveal(
                  index: 2,
                  child: _InfoCard(
                    icon: LucideIcons.bookOpen,
                    color: AppAccents.amber,
                    label: l.personReading,
                    value: person.reading,
                    emptyText: l.personNoInfo,
                  ),
                ),
                const SizedBox(height: Space.md),
                Reveal(
                  index: 3,
                  child: _InfoCard(
                    icon: LucideIcons.music,
                    color: AppAccents.pink,
                    label: l.personListening,
                    value: person.listening,
                    emptyText: l.personNoInfo,
                  ),
                ),
                const SizedBox(height: Space.lg),
                Reveal(
                  index: 4,
                  child: _Interests(
                    label: l.personInterests,
                    interests: person.interests,
                    emptyText: l.personNoInfo,
                  ),
                ),
                const SizedBox(height: Space.lg),
                Reveal(
                  index: 5,
                  child: _Photos(label: l.personPhotos, seed: person.name),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// A see-through app bar carrying only the back affordance.
  AppBar _backBar(BuildContext context, AppColors colors) => AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          color: colors.textPrimary,
          onPressed: () => context.pop(),
        ),
      );
}

/// Gradient band with the ringed avatar overlapping its lower edge, then the
/// name and class label. The band hue is seeded from the name so a person keeps
/// a consistent colour across the app.
class _Header extends StatelessWidget {
  const _Header({required this.person});

  final Person person;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              height: 168,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: AppGradients.of(AppAccents.forSeed(person.name)),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(Radii.hero),
                ),
              ),
            ),
            // A white (surface) ring lifts the avatar off the band.
            Positioned(
              bottom: -48,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: colors.surface,
                  shape: BoxShape.circle,
                  boxShadow: Shadows.card,
                ),
                child: Avatar(name: person.name, size: 96),
              ),
            ),
          ],
        ),
        // Clear the avatar's overhang before the name.
        const SizedBox(height: 48 + Space.md),
        Text(
          person.name,
          textAlign: TextAlign.center,
          style: AppText.h1.copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: Space.xs),
        Text(
          person.className,
          textAlign: TextAlign.center,
          style: AppText.bodySm.copyWith(color: colors.textSecondary),
        ),
      ],
    );
  }
}

/// The free-text "about me" card.
class _BioCard extends StatelessWidget {
  const _BioCard({required this.label, required this.bio});

  final String label;
  final String bio;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppText.caption.copyWith(color: colors.textSecondary)),
          const SizedBox(height: Space.xs),
          Text(bio, style: AppText.body.copyWith(color: colors.textPrimary)),
        ],
      ),
    );
  }
}

/// A labelled fact row (reading / listening): a big colourful icon tile, the
/// caption label, and the value — falling back to a muted "no info" line when
/// the person hasn't shared one.
class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
    required this.emptyText,
  });

  final IconData icon;
  final Color color;
  final String label;
  final String value;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final hasValue = value.isNotEmpty;

    return AppCard(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 28),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconTile(icon, color: color, size: 48),
            const SizedBox(width: Space.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: AppText.caption
                        .copyWith(color: colors.textSecondary),
                  ),
                  const SizedBox(height: Space.xs),
                  Text(
                    hasValue ? value : emptyText,
                    style: AppText.body.copyWith(
                      color:
                          hasValue ? colors.textPrimary : colors.textTertiary,
                    ),
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

/// A header plus a wrapped set of interest chips (one per interest), or a muted
/// "no info" line when the person listed none.
class _Interests extends StatelessWidget {
  const _Interests({
    required this.label,
    required this.interests,
    required this.emptyText,
  });

  final String label;
  final List<String> interests;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppText.h3.copyWith(color: colors.textPrimary)),
        const SizedBox(height: Space.sm),
        if (interests.isEmpty)
          Text(
            emptyText,
            style: AppText.body.copyWith(color: colors.textTertiary),
          )
        else
          Wrap(
            spacing: Space.sm,
            runSpacing: Space.sm,
            children: [
              for (final tag in interests)
                AppChip(tag, variant: AppChipVariant.primary),
            ],
          ),
      ],
    );
  }
}

/// A decorative photo wall: six gradient placeholder tiles with a faint image
/// glyph. These are purely ornamental — no real or photorealistic imagery is
/// used or implied (the app collects no child media in this phase).
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
                    AppAccents.all[(seed.hashCode.abs() + i) %
                        AppAccents.all.length],
                  ),
                  borderRadius: BorderRadius.circular(Radii.card),
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
