import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/async/loadable.dart';
import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/auth/application/session_controller.dart';
import 'package:sinfagram/features/feed/application/day_page_controller.dart';
import 'package:sinfagram/features/feed/domain/post.dart';
import 'package:sinfagram/features/feed/presentation/friends_carousel.dart';
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
/// Every one of the four [Loadable] states is drawn. A refresh that already has
/// a previous day keeps that day on screen, dimmed — never a spinner over
/// content — so the page never blinks to empty between reads.
class DayPageScreen extends ConsumerWidget {
  const DayPageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final state = ref.watch(dayPageProvider);
    final session = ref.watch(sessionProvider);

    // The day backing the app-bar title: the ready value, or whatever stale day
    // is being held through a load/failure. Class label falls back to the
    // session so the header still names the class before the first read lands.
    final titleDay = switch (state) {
      Ready(:final value) => value,
      Loading(:final previous) => previous,
      Failed(:final previous) => previous,
    };
    final titleClass = titleDay?.classLabel ?? session?.classLabel ?? '';
    final titleDate = titleDay?.dateLabel;

    final Widget body = switch (state) {
      // First load with nothing cached: placeholder cards, never a bare spinner.
      Loading(:final previous) => previous == null
          ? _skeletonList()
          : Opacity(
              opacity: 0.6,
              child: _dayList(context, ref, l, previous, isStale: false),
            ),
      Ready(:final value, :final isStale) =>
        _dayList(context, ref, l, value, isStale: isStale),
      Failed() => _errorRetry(context, ref, l),
    };

    return Scaffold(
      appBar: AppBar(
        title: _appBarTitle(context, titleClass, titleDate),
        actions: [
          IconButton(
            tooltip: l.classmatesTitle,
            icon: const Icon(LucideIcons.users),
            onPressed: () => context.push('/classmates'),
          ),
          IconButton(
            tooltip: l.boardTitle,
            icon: const Icon(LucideIcons.clipboardList),
            onPressed: () => context.push('/board'),
          ),
          IconButton(
            tooltip: l.helpTitle,
            icon: const Icon(LucideIcons.circleHelp),
            onPressed: () => context.push('/help'),
          ),
        ],
      ),
      body: SafeArea(child: body),
    );
  }

  // --- App bar ---------------------------------------------------------------

  /// Class label over the date, stacked. The toolbar height is fixed by the
  /// theme, so the title's own scaling is capped to keep two lines from
  /// overflowing the bar at large system text sizes; body content below is
  /// never clamped.
  Widget _appBarTitle(BuildContext context, String classLabel, String? date) {
    final colors = context.colors;
    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: 1.3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            classLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.h3.copyWith(color: colors.textPrimary),
          ),
          if (date != null && date.isNotEmpty)
            Text(
              date,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.caption.copyWith(color: colors.textSecondary),
            ),
        ],
      ),
    );
  }

  // --- Ready / stale list ----------------------------------------------------

  Widget _dayList(
    BuildContext context,
    WidgetRef ref,
    AppL10n l,
    DayPage day, {
    required bool isStale,
  }) {
    // Instagram-style: the Lenta feed is photos/videos only. Text-only posts
    // are surfaced elsewhere (Munozara), so they never enter this list.
    final photos = day.posts.where((p) => p.hasMedia).toList();
    return ListView(
      // Vertical padding only: the banner is full-bleed by design, so the
      // horizontal gutter is applied per item instead of on the whole list.
      padding: const EdgeInsets.only(top: Space.sm, bottom: Space.xxl),
      children: [
        if (isStale) ...[
          AppBanner(l.bannerOffline),
          const SizedBox(height: Space.md),
        ],
        const StoryTray(),
        const FriendsCarousel(),
        const SizedBox(height: Space.md),
        const SchoolBoardCarousel(),
        const SizedBox(height: Space.md),
        if (photos.isEmpty)
          _hpad(EmptyState(
            icon: LucideIcons.image,
            title: l.feedPhotosEmpty,
            message: '',
          ))
        else
          ..._postWidgets(context, ref, l, photos),
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

  Widget _skeletonList() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        Space.gutter,
        Space.md,
        Space.gutter,
        Space.xxl,
      ),
      children: const [
        _SkeletonPostCard(),
        SizedBox(height: Space.sm),
        _SkeletonPostCard(),
        SizedBox(height: Space.sm),
        _SkeletonPostCard(),
      ],
    );
  }

  Widget _errorRetry(BuildContext context, WidgetRef ref, AppL10n l) {
    final colors = context.colors;
    // Centred, but still scrollable so it survives a short viewport or large
    // system text without overflowing.
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(Space.gutter),
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
                      style:
                          AppText.bodySm.copyWith(color: colors.textSecondary),
                    ),
                    const SizedBox(height: Space.md),
                    AppButton(
                      l.actionRetry,
                      onPressed: () => ref.invalidate(dayPageProvider),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- Shared ----------------------------------------------------------------

  /// Applies the page gutter to a single list item, leaving full-bleed items
  /// (the banner) untouched.
  Widget _hpad(Widget child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: Space.gutter),
        child: child,
      );
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
