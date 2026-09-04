import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/social/application/social_controller.dart';
import 'package:sinfagram/shared/motion/motion_widgets.dart';
import 'package:sinfagram/shared/widgets/app_button.dart';
import 'package:sinfagram/shared/widgets/avatar.dart';
import 'package:sinfagram/shared/widgets/empty_state.dart';

/// The Instagram "heart" tab — a flat, chronological wall of who touched your
/// content: likes, new followers, comments. No cards, no shadows: each row is a
/// round avatar, one rich line (actor in bold + the plain-language action + a
/// grey timestamp) and a trailing affordance — a Follow button for a follow, a
/// flat placeholder thumbnail for a like/comment. Rows breathe on whitespace and
/// give the gentle TapScale press. §Activity.
class ActivityScreen extends ConsumerWidget {
  const ActivityScreen({super.key});

  /// Notification kinds. `follow` carries a Follow button; `like`/`comment`
  /// carry a placeholder media thumbnail.
  static const _items = <_Activity>[
    _Activity(
        type: _ActivityKind.like,
        actor: 'Malika Yusupova',
        action: 'sizning suratingizni yoqtirdi',
        time: '2 daqiqa'),
    _Activity(
        type: _ActivityKind.follow,
        actor: 'Jasur Toshmatov',
        action: 'sizni kuzatishni boshladi',
        time: '15 daqiqa'),
    _Activity(
        type: _ActivityKind.comment,
        actor: 'Dilnoza Rahimova',
        action: 'izoh qoldirdi: Juda zoʻr!',
        time: '1 soat'),
    _Activity(
        type: _ActivityKind.like,
        actor: 'Bekzod Aliyev',
        action: 'sizning suratingizni yoqtirdi',
        time: '3 soat'),
    _Activity(
        type: _ActivityKind.follow,
        actor: 'Sevara Qodirova',
        action: 'sizni kuzatishni boshladi',
        time: '5 soat'),
    _Activity(
        type: _ActivityKind.comment,
        actor: 'Nodir Sobirov',
        action: 'izoh qoldirdi: Ajoyib ish',
        time: '8 soat'),
    _Activity(
        type: _ActivityKind.like,
        actor: 'Aziza Karimova',
        action: 'sizning suratingizni yoqtirdi',
        time: '1 kun'),
    _Activity(
        type: _ActivityKind.follow,
        actor: 'Kamola Yodgorova',
        action: 'sizni kuzatishni boshladi',
        time: '2 kun'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(title: Text(l.activityTitle)),
      body: SafeArea(
        child: _items.isEmpty
            ? EmptyState(
                icon: LucideIcons.heart,
                title: l.activityEmpty,
                message: '',
              )
            : ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: Space.gutter,
                  vertical: Space.lg,
                ),
                itemCount: _items.length,
                separatorBuilder: (_, __) => const SizedBox(height: Space.lg),
                itemBuilder: (context, i) => _ActivityRow(item: _items[i]),
              ),
      ),
    );
  }
}

/// One notification. All fields are plain demo strings (Uzbek), the same
/// convention as the app's other seed data.
enum _ActivityKind { like, follow, comment }

@immutable
class _Activity {
  const _Activity({
    required this.type,
    required this.actor,
    required this.action,
    required this.time,
  });

  final _ActivityKind type;
  final String actor;

  /// Plain-language tail of the line, e.g. "sizning suratingizni yoqtirdi".
  final String action;

  /// Relative timestamp label, e.g. "2 daqiqa".
  final String time;
}

/// A single flat row: avatar · rich line · trailing affordance. The whole row
/// carries the relaxing TapScale press; the trailing Follow button (a deeper
/// gesture surface) wins its own taps for the toggle.
class _ActivityRow extends ConsumerWidget {
  const _ActivityRow({required this.item});

  final _Activity item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final colors = context.colors;

    return TapScale(
      onTap: () {},
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Avatar(name: item.actor, size: 44),
          const SizedBox(width: Space.md),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: item.actor,
                    style: AppText.bodyStrong.copyWith(color: colors.textPrimary),
                  ),
                  TextSpan(
                    text: ' ${item.action}  ',
                    style: AppText.body.copyWith(color: colors.textPrimary),
                  ),
                  TextSpan(
                    text: item.time,
                    style: AppText.caption.copyWith(color: colors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: Space.md),
          if (item.type == _ActivityKind.follow)
            _FollowAction(actor: item.actor, l: l)
          else
            const _ThumbPlaceholder(),
        ],
      ),
    );
  }
}

/// The trailing Follow / Following button, driven by [followsProvider]. Blue
/// primary while not followed, quiet grey secondary once followed — Instagram's
/// two-state pill.
class _FollowAction extends ConsumerWidget {
  const _FollowAction({required this.actor, required this.l});

  final String actor;
  final AppL10n l;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final following = ref.watch(followsProvider).contains(actor);

    return AppButton(
      following ? l.following : l.follow,
      variant:
          following ? AppButtonVariant.secondary : AppButtonVariant.primary,
      onPressed: () => ref.read(followsProvider.notifier).toggle(actor),
    );
  }
}

/// A 44x44 flat grey stand-in for the post the like/comment refers to — the
/// [Radii.hero] rounding of a grid preview, with a faint image glyph and no real
/// media.
class _ThumbPlaceholder extends StatelessWidget {
  const _ThumbPlaceholder();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.skeleton,
        borderRadius: BorderRadius.circular(Radii.hero),
      ),
      child: Icon(LucideIcons.image, size: 20, color: colors.textTertiary),
    );
  }
}
