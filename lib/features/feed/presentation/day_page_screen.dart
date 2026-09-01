import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/app/ui_prefs.dart';
import 'package:sinfagram/core/async/loadable.dart';
import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/gradients.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/auth/application/session_controller.dart';
import 'package:sinfagram/features/feed/application/day_page_controller.dart';
import 'package:sinfagram/features/feed/domain/post.dart';
import 'package:sinfagram/features/board/presentation/school_board_carousel.dart';
import 'package:sinfagram/features/moderation/presentation/report_sheet.dart';
import 'package:sinfagram/features/stories/presentation/story_tray.dart';
import 'package:sinfagram/shared/motion/motion_widgets.dart';
import 'package:sinfagram/shared/widgets/app_banner.dart';
import 'package:sinfagram/shared/widgets/app_button.dart';
import 'package:sinfagram/shared/widgets/app_card.dart';
import 'package:sinfagram/shared/widgets/empty_state.dart';
import 'package:sinfagram/shared/widgets/post_card.dart';
import 'package:sinfagram/shared/widgets/skeleton_block.dart';

/// S10 — the day page (docs/08). The one screen the pupil opens most: a finite,
/// chronological feed of one class-day, rendered straight in the order it comes
/// with no ranking of its own.
///
/// The plain toolbar is gone: the feed now opens with the signature gradient
/// hero header (design handoff) — wordmark, greeting, class + date, glass
/// controls and the story tray, all on the violet→pink sweep. The school board
/// carousel rises to overlap the header's curve, then the photo feed follows.
///
/// Every one of the four [Loadable] states is still drawn beneath that header. A
/// refresh that already has a previous day keeps that day on screen, dimmed —
/// never a spinner over content — so the page never blinks to empty between
/// reads.
class DayPageScreen extends ConsumerWidget {
  const DayPageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final state = ref.watch(dayPageProvider);
    final session = ref.watch(sessionProvider);

    // The day backing the header subtitle: the ready value, or whatever stale
    // day is held through a load/failure. Class label falls back to the session
    // so the header still names the class before the first read lands.
    final titleDay = switch (state) {
      Ready(:final value) => value,
      Loading(:final previous) => previous,
      Failed(:final previous) => previous,
    };
    final classLabel = titleDay?.classLabel ?? session?.classLabel ?? '';
    final dateLabel = titleDay?.dateLabel;

    // Everything under the header, per state. Kept in one block so the whole
    // thing can rise to overlap the header curve (and dim as one during a
    // stale reload) while the header itself stays put and fully opaque.
    final Widget below = switch (state) {
      // First load with nothing cached: placeholder cards, never a bare spinner.
      Loading(:final previous) => previous == null
          ? _skeletonBelow()
          : Opacity(
              opacity: 0.6,
              child: _dayBelow(context, ref, l, previous, isStale: false),
            ),
      Ready(:final value, :final isStale) =>
        _dayBelow(context, ref, l, value, isStale: isStale),
      Failed() => _errorBelow(context, ref, l),
    };

    return Scaffold(
      body: SafeArea(
        top: false,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _FeedHero(classLabel: classLabel, dateLabel: dateLabel),
            // The board carousel (and the content under it) rises over the
            // header's rounded bottom, like the design's floating carousel.
            Transform.translate(
              offset: const Offset(0, -_overlap),
              child: below,
            ),
          ],
        ),
      ),
    );
  }

  /// How far the content below the header rises to overlap the header curve.
  static const double _overlap = 32;

  // --- Ready / stale list ----------------------------------------------------

  Widget _dayBelow(
    BuildContext context,
    WidgetRef ref,
    AppL10n l,
    DayPage day, {
    required bool isStale,
  }) {
    // Instagram-style: the Lenta feed is photos/videos only. Text-only posts
    // are surfaced elsewhere (Munozara), so they never enter this list.
    final photos = day.posts.where((p) => p.hasMedia).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Overlaps the header curve — its own accent gradient reads as a card
        // floating on the violet.
        const SchoolBoardCarousel(),
        const SizedBox(height: Space.md),
        if (isStale) ...[
          AppBanner(l.bannerOffline),
          const SizedBox(height: Space.md),
        ],
        if (photos.isEmpty)
          _hpad(EmptyState(
            icon: LucideIcons.image,
            title: l.feedPhotosEmpty,
            message: '',
          ))
        else
          ..._postWidgets(context, ref, l, photos),
        const SizedBox(height: Space.xxl + _overlap),
      ],
    );
  }

  List<Widget> _postWidgets(
    BuildContext context,
    WidgetRef ref,
    AppL10n l,
    List<Post> posts,
  ) {
    final widgets = <Widget>[];
    for (var i = 0; i < posts.length; i++) {
      final p = posts[i];
      widgets.add(_hpad(Reveal(
        index: i,
        child: PostCard(
          key: ValueKey(p.id),
          authorName: p.authorName,
          timeLabel: p.timeLabel,
          body: p.body,
          hasPhoto: p.hasPhoto,
          photoPath: p.photoPath,
          videoPath: p.videoPath,
          thanksLabel: l.thanks,
          thankedByMe: p.thankedByMe,
          onThanks: () => ref.read(dayPageProvider.notifier).toggleThanks(p.id),
          commentLabel: l.comments(p.commentCount),
          onComment: () => context.push('/post/${p.id}'),
          onReport: () =>
              showReportSheet(context, targetKind: 'post', targetId: p.id),
          onMore: () {},
          onRepost: () {
            final now = ref.read(dayPageProvider.notifier).toggleRepost(p.id);
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text(now ? l.repostDone : l.repostRemoved),
              ));
          },
          repostedByMe: p.repostedByMe,
          repostLabel: l.repost,
          heldForReview: p.heldForReview,
          waitingLabel: l.composeReview,
        ),
      )));
      if (i != posts.length - 1) {
        widgets.add(const SizedBox(height: Space.sm));
      }
    }
    return widgets;
  }

  // --- Loading & failure -----------------------------------------------------

  Widget _skeletonBelow() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(
        Space.gutter,
        Space.md,
        Space.gutter,
        Space.xxl + _overlap,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SkeletonPostCard(),
          SizedBox(height: Space.sm),
          _SkeletonPostCard(),
          SizedBox(height: Space.sm),
          _SkeletonPostCard(),
        ],
      ),
    );
  }

  Widget _errorBelow(BuildContext context, WidgetRef ref, AppL10n l) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Space.gutter,
        Space.md,
        Space.gutter,
        Space.xxl + _overlap,
      ),
      child: AppCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              l.errorTitle,
              textAlign: TextAlign.center,
              style: AppText.h3.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: Space.xs),
            Text(
              l.errorBody,
              textAlign: TextAlign.center,
              style: AppText.bodySm.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: Space.md),
            AppButton(
              l.actionRetry,
              onPressed: () => ref.invalidate(dayPageProvider),
            ),
          ],
        ),
      ),
    );
  }

  // --- Shared ----------------------------------------------------------------

  /// Applies the page gutter to a single item, leaving full-bleed items
  /// (the banner) untouched.
  Widget _hpad(Widget child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: Space.gutter),
        child: child,
      );
}

/// The signature gradient hero at the top of the feed (design handoff): the
/// violet→pink sweep with rounded bottom corners, carrying the wordmark, a
/// personal greeting, the class + date, two "glass" controls, and the story
/// tray. It replaces the plain toolbar entirely.
class _FeedHero extends ConsumerWidget {
  const _FeedHero({required this.classLabel, this.dateLabel});

  final String classLabel;
  final String? dateLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final topInset = MediaQuery.of(context).padding.top;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final session = ref.watch(sessionProvider);
    final first = (session?.displayName ?? '').split(' ').first.trim();
    // TODO(l10n): add feedGreeting(name) once l10n can be regenerated; for now
    // this is a name interpolation, not translatable copy.
    final greeting = first.isEmpty ? 'Salom!' : 'Salom, $first!';

    final subtitle = [
      classLabel,
      if (dateLabel != null && dateLabel!.isNotEmpty) dateLabel!,
    ].where((s) => s.isNotEmpty).join(' · ');

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        gradient: AppGradients.hero,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(Radii.header),
        ),
      ),
      // Horizontal gutter is applied per-row so the story tray can bleed to the
      // header edges; the generous bottom leaves room for the carousel overlap.
      padding: EdgeInsets.fromLTRB(0, 12 + topInset, 0, 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        // Brand wordmark (proper noun — not localised copy).
                        'Sinfagram',
                        style: AppText.wordmark.copyWith(
                          color: Colors.white.withValues(alpha: 0.82),
                        ),
                      ),
                      const SizedBox(height: Space.xs),
                      Text(
                        greeting,
                        style: AppText.display.copyWith(color: Colors.white),
                      ),
                      if (subtitle.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.bodySm.copyWith(
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: Space.sm),
                _glassButton(
                  icon: isDark ? LucideIcons.sun : LucideIcons.moon,
                  tooltip: l.settingsDarkMode,
                  onTap: () => ref.read(themeModeProvider.notifier).state =
                      isDark ? ThemeMode.light : ThemeMode.dark,
                ),
                const SizedBox(width: Space.sm),
                _glassButton(
                  icon: LucideIcons.users,
                  tooltip: l.classmatesTitle,
                  onTap: () => context.push('/classmates'),
                ),
              ],
            ),
          ),
          const SizedBox(height: Space.sm),
          // Rings already carry the conic gradient and pop on the violet.
          const StoryTray(),
        ],
      ),
    );
  }

  /// A 42×42 translucent "glass" control that sits on the gradient.
  Widget _glassButton({
    required IconData icon,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: TapScale(
        onTap: onTap,
        child: Container(
          width: 42,
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(Radii.media),
          ),
          child: Icon(icon, size: 20, color: Colors.white),
        ),
      ),
    );
  }
}

/// A resting placeholder shaped like a [PostCard]: an avatar dot, two header
/// lines, and a couple of body lines. Quiet by design (see [SkeletonBlock]).
class _SkeletonPostCard extends StatelessWidget {
  const _SkeletonPostCard();

  @override
  Widget build(BuildContext context) {
    return const AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              SkeletonBlock(width: 36, height: 36, radius: Radii.avatar),
              SizedBox(width: Space.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SkeletonBlock(width: 128, height: 12),
                    SizedBox(height: Space.xs),
                    SkeletonBlock(width: 72, height: 10),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: Space.md),
          SkeletonBlock(height: 12),
          SizedBox(height: Space.sm),
          SkeletonBlock(width: 220, height: 12),
        ],
      ),
    );
  }
}
