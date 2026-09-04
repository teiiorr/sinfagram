import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/people/application/people_controllers.dart';
import 'package:sinfagram/features/people/domain/person.dart';
import 'package:sinfagram/features/social/application/social_controller.dart';
import 'package:sinfagram/shared/widgets/app_button.dart';
import 'package:sinfagram/shared/widgets/app_chip.dart';
import 'package:sinfagram/shared/widgets/avatar.dart';
import 'package:sinfagram/shared/widgets/empty_state.dart';

/// A single person's profile — a classmate's read-only page (or the viewer's own
/// when [personId] is `me`). A flat, count-less mirror of the "Me" profile: an
/// avatar with a hairline border beside the name and class, the free-text bio,
/// the "now reading / now listening" personality lines, interest chips and a
/// flat photo grid. No counters, no gradients, by design.
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
            _Header(person: person),
            const SizedBox(height: Space.lg),
            // Instagram stats row + follow CTA for this classmate.
            _StatsRow(name: person.name),
            const SizedBox(height: Space.md),
            _FollowButton(name: person.name),
            const SizedBox(height: Space.lg),
            if (person.bio.isNotEmpty) ...[
              Text(
                person.bio,
                style: AppText.body.copyWith(color: colors.textPrimary),
              ),
              const SizedBox(height: Space.md),
            ],
            _BioLine(
              icon: LucideIcons.bookOpen,
              label: l.personReading,
              value: person.reading,
              empty: l.personNoInfo,
            ),
            const SizedBox(height: Space.sm),
            _BioLine(
              icon: LucideIcons.music,
              label: l.personListening,
              value: person.listening,
              empty: l.personNoInfo,
            ),
            if (person.interests.isNotEmpty) ...[
              const SizedBox(height: Space.md),
              Wrap(
                spacing: Space.sm,
                runSpacing: Space.sm,
                children: [
                  for (final tag in person.interests)
                    AppChip(tag, variant: AppChipVariant.neutral),
                ],
              ),
            ],
            const SizedBox(height: Space.lg),
            _Photos(label: l.personPhotos),
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
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          icon: const Icon(LucideIcons.arrowLeft),
          color: colors.textPrimary,
          onPressed: () => context.pop(),
        ),
      );
}

/// Identity block: an 80 px avatar with a hairline border beside the name and
/// the "<class> · school" line. Flat — no ring, no shadow.
class _Header extends StatelessWidget {
  const _Header({required this.person});

  final Person person;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: colors.border, width: Stroke.hairline),
          ),
          child: Avatar(name: person.name, size: 80),
        ),
        const SizedBox(width: Space.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                person.name,
                style: AppText.h2.copyWith(color: colors.textPrimary),
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

/// The Instagram stats triplet — posts / followers / following — for [name],
/// read live from the social layer. Three evenly weighted columns: a tabular
/// number (numeric 16) over a small secondary label. Flat, no dividers.
class _StatsRow extends ConsumerWidget {
  const _StatsRow({required this.name});

  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final posts = ref.watch(postsCountProvider(name));
    final followers = ref.watch(followerCountProvider(name));
    final following = ref.watch(followingCountProvider(name));

    return Row(
      children: [
        Expanded(child: _Stat(value: posts, label: l.statPosts)),
        Expanded(child: _Stat(value: followers, label: l.statFollowers)),
        Expanded(child: _Stat(value: following, label: l.statFollowing)),
      ],
    );
  }
}

/// One stat column: number above, label below, centred.
class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$value',
          style: AppText.numeric
              .copyWith(fontSize: 16, color: colors.textPrimary),
        ),
        const SizedBox(height: Space.xs),
        Text(
          label,
          style: AppText.bodySm.copyWith(color: colors.textSecondary),
        ),
      ],
    );
  }
}

/// Full-width follow toggle for [name]. Primary "Kuzatish" when not followed,
/// secondary "Kuzatilmoqda" once followed — wired to [followsProvider].
class _FollowButton extends ConsumerWidget {
  const _FollowButton({required this.name});

  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final isFollowing = ref.watch(followsProvider).contains(name);

    return SizedBox(
      width: double.infinity,
      child: AppButton(
        isFollowing ? l.following : l.follow,
        variant:
            isFollowing ? AppButtonVariant.secondary : AppButtonVariant.primary,
        onPressed: () => ref.read(followsProvider.notifier).toggle(name),
      ),
    );
  }
}

/// One "icon + label + value" personality line (reading / listening). The icon
/// is neutral grey. Shows [empty] softly when [value] is blank, so the line
/// never reads as broken.
class _BioLine extends StatelessWidget {
  const _BioLine({
    required this.icon,
    required this.label,
    required this.value,
    required this.empty,
  });

  final IconData icon;
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
          child: Icon(icon, size: 16, color: colors.textSecondary),
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

/// A flat photo wall: six grey placeholder tiles with a faint image glyph.
/// Purely ornamental — no real or photorealistic imagery is used or implied
/// (the app collects no child media in this phase). No gradient.
class _Photos extends StatelessWidget {
  const _Photos({required this.label});

  final String label;

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
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
          children: [
            for (var i = 0; i < _count; i++)
              ColoredBox(
                color: colors.skeleton,
                child: Center(
                  child: Icon(
                    LucideIcons.image,
                    color: colors.textTertiary,
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
